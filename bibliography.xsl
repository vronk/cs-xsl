<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:sru="http://www.loc.gov/zing/srw/"
  xmlns:fcs="http://clarin.eu/fcs/1.0"
  xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xsl xd tei html">
  <xsl:import href="fcs/result2view_v1.xsl"/>
    <xsl:output method="html" media-type="text/xhtml" indent="yes" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
  <xsl:template name="getTitle">
    <xsl:text>&#xa0;</xsl:text>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>Transforms one fcs:Resource
      <xd:p>This supersedes the generic template because we want a fixed order in which
      the various data views are transformed (metadata last)</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="fcs:Resource" mode="record-data">
    <xsl:apply-templates select=".//fcs:DataView[not(@type='metadata')]" mode="record-data"/>
    <xsl:apply-templates select=".//fcs:DataView[@type='metadata']" mode="record-data"/>
  </xsl:template>
</xsl:stylesheet>