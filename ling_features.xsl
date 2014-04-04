<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:html="http://www.w3.org/1999/xhtml" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
   xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:exsl="http://exslt.org/common"
   xmlns:fcs="http://clarin.eu/fcs/1.0" xmlns:sru="http://www.loc.gov/zing/srw/"
   xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xsl exsl xd tei fcs sru html" version="1.0">
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
      <title>Feature list</title>
   </xsl:template>
   
   <xsl:template match="/">
      <xsl:choose>
         <xsl:when test="contains($format, 'page')">
            <html>
               <head>
                  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
                  <title>Feature list</title>
                  <xsl:call-template name="callback-header"/>
               </head>               
               <body>
                  <div class="searchresults">
                      <xsl:call-template name="content"/>
                  </div>
               </body>
            </html>
         </xsl:when>
         <xsl:otherwise>
            <xsl:call-template name="content"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <xsl:template name="content">
      <div class="lingfeature">
         <div class="result-header" data-numberOfRecords="{//sru:numberOfRecords}"/>
         <xsl:if test="not(//tei:TEI)">
            <xsl:text>No entries found!!</xsl:text>
         </xsl:if>
         <xsl:for-each select="//tei:TEI">
            <h1>Contents</h1>
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
            <xsl:apply-templates mode="record-data"/>
         </xsl:for-each>
      </div>
   </xsl:template>
   
   <xsl:template match="tei:a" mode="record-data"/>
   
   <xsl:template match="tei:cell" mode="record-data">
      <xsl:variable name="class">
         <xsl:choose>
            <xsl:when test="@class!=''">
               <xsl:value-of select="@class"/>
            </xsl:when>
            <xsl:otherwise>tdCorpora</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      <td class="{$class}">
         <xsl:apply-templates mode="record-data"/>
      </td>
   </xsl:template>
   
   <xsl:template match="tei:fs|tei:f" mode="record-data"/>
   
   <xsl:template match="*" mode="tei-body-headings">
      <div id="{@xml:id}" class="feature">
      <xsl:call-template name="div-count-to-html-header">
         <xsl:with-param name="div-count">
            <xsl:call-template name="tei-div-count"/>
         </xsl:with-param>
         <xsl:with-param name="content">
            <xsl:apply-templates mode="record-data"/>
            <a class="aGoTocontents" title="CONTENTS" href="#contents"><span class="aGoTocontents">   (Go to contents)</span></a>
         </xsl:with-param>
      </xsl:call-template>
      </div>
   </xsl:template>
   
   <xsl:template match="tei:quote" mode="record-data"><xsl:apply-templates mode="record-data"/></xsl:template>
   
   <xsl:template match="tei:w" mode="record-data">
      <xsl:choose>
         <xsl:when test="@rend='high'"><span class="spHigh"><xsl:apply-templates mode="record-data"/></span></xsl:when>
         <xsl:otherwise><xsl:apply-templates mode="record-data"/></xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <xsl:template match="tei:cit[@type='example']" mode="record-data">
      <span class="example">
         <xsl:apply-templates mode="record-data"/>
      </span>
      <xsl:text> </xsl:text>
   </xsl:template>
   
   <xd:doc>
      <xd:desc>Ignore pointers needed by web_dict_editor</xd:desc>
   </xd:doc>
   <xsl:template match="tei:ptr[starts-with(@target, '#')]" mode="record-data"/>
   
</xsl:stylesheet>
