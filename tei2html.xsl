<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:exsl="http://exslt.org/common"
    version="1.0" exclude-result-prefixes="xsl exsl xd tei">
<xsl:import href="commons_v1.xsl"/>
<!--<xsl:import href="fcs/data2view_teiHeader.xsl"/>-->
<xsl:import href="fcs/data2view_tei.xsl"/>
<xsl:output method="html" media-type="text/xhtml" indent="yes" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
    <xsl:template name="continue-root">
        <xsl:apply-templates mode="record-data"/>
    </xsl:template>
    <xsl:template name="inline">
        <span class="tei-{name(.)}"><xsl:apply-templates mode="record-data"/></span>
    </xsl:template>
    <xsl:template name="generateImgHTMLTags">
        <p>Image: <xsl:value-of select="."/></p>
    </xsl:template>
    <!-- Ignore for now -->
    <xsl:template match="tei:teiHeader" mode="record-data"/> 
</xsl:stylesheet>