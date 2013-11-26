<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:exsl="http://exslt.org/common"
  xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xsl exsl xd tei">
  <xsl:import href="fcs/result2view_v1.xsl"/>
  <xsl:output method="html" media-type="text/xhtml" indent="yes" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/> 

  <xsl:template match="tei:ptr" mode="record-data">
    <xsl:variable name="target">
      <xsl:choose>
        <xsl:when test="contains(@target, 'http://')">
           <xsl:value-of select="@target"/>   
        </xsl:when>
        <xsl:when test="ancestor::tei:div[@type = 'sampleText']">
          <xsl:call-template name="formURL">
            <xsl:with-param name="action">searchRetrieve</xsl:with-param>
            <xsl:with-param name="q" select="concat('sampleText=', @target)"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains(@target, '|')">
          <xsl:call-template name="formURL">
            <xsl:with-param name="action">searchRetrieve</xsl:with-param>
            <xsl:with-param name="q" select="substring-after(@target, '|')"/>
            <!-- <xsl:with-param name="x-context" select="substring-before(@target, '|')"/>-->
            <xsl:with-param name="x-context">vicav-bib</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="formURL">
            <xsl:with-param name="action">explain</xsl:with-param>
            <xsl:with-param name="x-context" select="@target"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <a href="{$target}">Click here!</a>
  </xsl:template>

  <xsl:template name="getTitle">
    <xsl:value-of select="//tei:title"/>
  </xsl:template>
  
  <xsl:template name="generateImg">
    <xsl:choose>
      <xsl:when test="starts-with(@target, 'http://') or starts-with(@target, '/')">
        <img src="{@target}" alt="{@target}"/>
      </xsl:when>
      <xsl:otherwise>
        <img src="http://corpus3.aac.ac.at/vicav/images/{@target}" alt="{@target}"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
