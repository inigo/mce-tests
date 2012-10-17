<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:m="http://schemas.openxmlformats.org/mspec"
      exclude-result-prefixes="#all"
      version="2.0">
        
    <xsl:output method="html"/>
    <xsl:strip-space elements="*"/>

    <!-- Convert the MTest XML content into HTML that provides headings and structure -->
    <xsl:template match="m:description">
        <html>
            <head>
                <title><xsl:value-of select="@title"/> - MCE</title>
                <style type="text/css">
                    body { font-family: Verdana; }
                    
                    table { border-collapse:collapse; }                 
                    th { background: #eee; text-align: left; }
                    tr { border-top: solid 1px black; }
                    td { vertical-align:text-top; width: 50%; }
                    th, td { padding: 4px; }
                    
                    .understanding { font-size: 0.8em; display: block; color: #999; }
                    .understanding:before { content: '('; }
                    .understanding:after { content: ')'; }
                    
                    .context, .expectedContent { font-family: Courier; font-size: 0.9em; white-space: pre-wrap; }
                    .context { color: green; }
                    .expectedContent { color: blue; }
                </style>
            </head>
            <body>
                <h1><xsl:value-of select="@title"/> - MCE</h1>
                <table class="scenario">
                    <xsl:apply-templates/>
                </table>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="m:scenario[not(parent::scenario)]" priority="1">
        <tr><th colspan="2"><xsl:value-of select="@label"/></th></tr>
        <xsl:apply-templates select=".//m:expect | .//m:expectError"/>
    </xsl:template>
    
    <xsl:template match="m:context">
        <div class="context"><xsl:apply-templates mode="escape"/></div>
    </xsl:template>
    
    <xsl:template match="m:expect | m:expectError">
        <tr>
            <td>
                <xsl:apply-templates select="preceding-sibling::m:context"/>
            </td>
            <td>  
                <div class="expectation">
                    <span class="expected"><xsl:value-of select="ancestor::*/@label | @label"/></span>
                    <span class="understanding"><xsl:value-of select="@understands"/></span>
                    <div class="expectedContent"><xsl:apply-templates mode="escape"/></div>
                </div>
            </td>
        </tr>
    </xsl:template>
        
    <!-- Escape the XML context and expected results so they can be displayed in HTML --> 
    <xsl:template match="*" mode="escape">
        <xsl:text/>&lt;<xsl:value-of select="name()"/> <xsl:apply-templates select="@*" mode="#current"/> &gt;<xsl:text>&#10;</xsl:text>
            <xsl:apply-templates select="node()" mode="#current"/>
        <xsl:text>&#10;</xsl:text>&lt;/<xsl:value-of select="name()"/>&gt;<xsl:text/>
    </xsl:template>
    <xsl:template match="*[not(node())]" mode="escape">
        <xsl:text/>&lt;<xsl:value-of select="name()"/> <xsl:apply-templates select="@*" mode="#current"/> /&gt;<xsl:text>&#10;</xsl:text>
    </xsl:template>
    <xsl:template match="@*" mode="escape"><xsl:text> </xsl:text><xsl:value-of select="name()"/>="<xsl:value-of select="."/>"</xsl:template>
    <xsl:template match="text()" mode="escape"><xsl:value-of select="."/></xsl:template>    

</xsl:stylesheet>
