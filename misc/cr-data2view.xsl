<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xs xd" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>Generate html view of a cr:response (cr-data sequence)            
        </xd:desc>
    </xd:doc>
    <xd:doc>
        <xd:desc>Note: method="xhtml" is saxon-specific! prevents  collapsing empty &lt;script&gt; tags, that makes browsers choke</xd:desc>
    </xd:doc>
    <xsl:output method="xhtml" media-type="text/html" indent="yes" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"/>
    <xsl:include href="../commons_v2.xsl"/>
    <xsl:include href="../fcs/data2view_v2.xsl"/>
    <xsl:param name="title">
        <xsl:text>Result Set</xsl:text>
    </xsl:param>
    <xsl:variable name="cols">
        <col>all</col>
    </xsl:variable>
    <xsl:template name="continue-root">
        <xsl:apply-templates/>
    </xsl:template>
</xsl:stylesheet>