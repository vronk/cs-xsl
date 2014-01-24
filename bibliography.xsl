<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xsl xd tei html">
  <xsl:import href="fcs/result2view_v1.xsl"/>
  <xsl:output method="html" media-type="text/xhtml" indent="yes" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/> 
 
  <xsl:template name="getTitle">
    <span class="tei-authors"><xsl:apply-templates select=".//tei:author" mode="record-data"/></span><span class="xsl-author-title-separator">: </span><span class="tei-title"><xsl:value-of select=".//tei:title"/></span>
  </xsl:template>

</xsl:stylesheet>
