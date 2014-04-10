<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
   xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:exsl="http://exslt.org/common"
   xmlns:fcs="http://clarin.eu/fcs/1.0" xmlns:sru="http://www.loc.gov/zing/srw/"
   xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xsl exsl xd tei fcs sru" version="1.0">
   <xsl:import href="fcs/result2view_v1.xsl"/>
   <xsl:output method="html" media-type="text/xhtml" indent="yes" encoding="UTF-8"
      doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
<!--   <xsl:strip-space elements="*"/>
   <xsl:preserve-space elements="quote"/>-->
   
   <xsl:template name="callback-header">
      <link href="{$scripts_url}style/sampleText.css" type="text/css" rel="stylesheet"/>
      <link href="{$scripts_url}style/glossary.css" type="text/css" rel="stylesheet"/>
      <link href="{$scripts_url}style/lingFeature.css" type="text/css" rel="stylesheet"/>
   </xsl:template>
   
   <xsl:template name="getTitle">
      Feature list
   </xsl:template>
   
   <!-- Is this generic enough to be useful in other resources? -->
   <xsl:template name="dataview-full-contents">
      <div class="xsl-dataview-full-contents">
         <h1>
            <xsl:call-template name="dict">
               <xsl:with-param name="key">Contents</xsl:with-param>
            </xsl:call-template>
         </h1>
         <ul class="dvContents" id="contents">
            <xsl:for-each select=".//tei:head">
               <li>
                  <xsl:if test="count(ancestor::tei:div) = 1">
                     <a class="h1_contents" href="#{@xml:id}">
                        <xsl:value-of select="."/>
                     </a>
                  </xsl:if>
                  <xsl:if test="count(ancestor::tei:div) = 2">
                     <a class="h2_contents" href="#{@xml:id}">
                        <xsl:value-of select="."/>
                     </a>
                  </xsl:if>
                  <xsl:if test="count(ancestor::tei:div) = 3">
                     <a class="h3_contents" href="#{@xml:id}">
                        <xsl:value-of select="."/>
                     </a>
                  </xsl:if>
                  <xsl:if test="count(ancestor::tei:div) = 4">
                     <a class="h4_contents" href="#{@xml:id}">
                        <xsl:value-of select="."/>
                     </a>
                  </xsl:if>
                  <xsl:if test="count(ancestor::tei:div) = 5">
                     <a class="h5_contents" href="#{@xml:id}">
                        <xsl:value-of select="."/>
                     </a>
                  </xsl:if>
               </li>
            </xsl:for-each>
         </ul>
      </div>
   </xsl:template>
   
   <xd:doc>
      <xd:desc>Ignore pointers needed by web_dict_editor</xd:desc>
   </xd:doc>
   <xsl:template match="tei:ptr[starts-with(@target, '#')]" mode="record-data"/>
   
   <xd:doc>
      <xd:desc>For internal use</xd:desc>
   </xd:doc>
   <xsl:template match="tei:a" mode="record-data"/>

   <xd:doc>
      <xd:desc>For internal use</xd:desc>
   </xd:doc>
   <xsl:template match="tei:fs|tei:f" mode="record-data"/>
</xsl:stylesheet>
