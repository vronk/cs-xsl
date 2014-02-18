<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:html="http://www.w3.org/1999/xhtml"
   xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
   xmlns:tei="http://www.tei-c.org/ns/1.0"
   xmlns:exsl="http://exslt.org/common"
   xmlns:sru="http://www.loc.gov/zing/srw/"
   xmlns:fcs="http://clarin.eu/fcs/1.0"
   xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xsl exsl xd tei sru fcs html">
   <xsl:import href="fcs/result2view_v1.xsl"/>
   <xsl:output method="html" media-type="text/xhtml" indent="yes" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/> 


   <xsl:template name="getTitle">
   </xsl:template>
   
   <xsl:template name="callback-header">
      <link href="{$scripts_url}style/glossary.css" type="text/css" rel="stylesheet"/>
   </xsl:template>
   
   <xsl:template match="fcs:Resource" mode="record-data">
      <xsl:apply-templates select=".//fcs:DataView[not(@type='metadata')]" mode="record-data"/>
      <xsl:apply-templates select=".//fcs:DataView[@type='metadata']" mode="record-data"/>
   </xsl:template>
   
<!--    <xsl:template name="continue-root">
        <div style="text-align: center; border-top: 1px solid #CCCCCC; border-bottom: 1px solid #CCCCCC; margin: 10px 0px; padding: 5px 0px;">
        <xsl:text>Search results (</xsl:text>
           <xsl:value-of select="//fcs:returnedRecords"/>
        <xsl:text> shown)</xsl:text></div>

        <xsl:if test="not(//tei:entry)">
            <xsl:text>No entries found!!</xsl:text>
        </xsl:if>
       <xsl:call-template name="continue-root-base"/>
    </xsl:template>-->
   
</xsl:stylesheet>
