<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:exsl="http://exslt.org/common"
  xmlns:fcs="http://clarin.eu/fcs/1.0" xmlns:sru="http://www.loc.gov/zing/srw/"
  xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xsl exsl xd tei fcs sru">
  <xsl:import href="fcs/result2view_v1.xsl"/>
    <xsl:output method="html" media-type="text/xhtml" indent="yes" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
  <xsl:template name="callback-header">
    <link href="{$scripts_url}style/sampleText.css" type="text/css" rel="stylesheet"/>
  </xsl:template>

  <xd:doc>
    <xd:desc>Mappings to other transcritption systems for latin diacritics used in VICAV transcription</xd:desc>
  </xd:doc>
  <xsl:template name="get-char-mappings">
    <tei:mapping type="IPA"/>
    <tei:mapping type="arabic"/>
<!--    <tei:mapping type="vicavMSA"/>-->
    <tei:mapping type="DIN"/>
    <tei:mapping type="chat"/>         
  </xsl:template>
  
  <xsl:template name="getTitle">
    <xsl:value-of select="concat(//tei:fileDesc//tei:title, ' ')"/>
    <span class="tei-authors">
      <xsl:apply-templates select="//tei:fileDesc/tei:author" mode="record-data"/>
    </span>
  </xsl:template>

  <xsl:template match="tei:head" mode="tei-body-headings">
    <xsl:if test="normalize-space(./text())">
      <xsl:call-template name="div-count-to-html-header">
        <xsl:with-param name="div-count"><xsl:call-template name="tei-div-count"/></xsl:with-param>
        <xsl:with-param name="content" select="normalize-space(./text())"></xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <xsl:apply-templates mode="tei-body-headings"/>
  </xsl:template>
  
  <xsl:template name="generateImgHTMLTags">
    <xsl:param name="altText" select="@target"/>
    <xsl:choose>
      <xsl:when test="starts-with(@target, 'https://upload.wikimedia.org') or starts-with(@target, 'http://upload.wikimedia.org')">       
        <div class="img-with-text" style="display: inline-block;">
          <img src="{@target}" alt="{$altText}"/>
          <span class="img-caption" style="display: block;">From Wikimedia Commons, <a target="_blank" href="http://creativecommons.org/licenses/by-sa/3.0/" class="cc-license-link">CC BY-SA 3.0</a></span>
        </div>        
      </xsl:when>
      <xsl:when test="starts-with(@target, 'http://') or starts-with(@target, '/') or starts-with(@target, 'https://')">
        <img src="{@target}" alt="{$altText}"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="text() != ''">
            <div class="img-with-text" style='display: inline-block;'>
              <img src="https://minerva.arz.oeaw.ac.at/static/images/vicav/{@target}" alt="{$altText}"/>
              <span class="img-caption" style="display: block;"><xsl:value-of select="."/></span>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <img src="https://minerva.arz.oeaw.ac.at/static/images/vicav/{@target}" alt="{@target}"/>           
          </xsl:otherwise>
        </xsl:choose>           
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="*" mode="tei-body-headings">
    <xsl:if test="normalize-space(./text())">
      <h2>
        <xsl:value-of select="normalize-space(./text())"/>
      </h2>
    </xsl:if>
    <xsl:apply-templates mode="tei-body-headings"/>
  </xsl:template>
  
  <xsl:template match="text()" mode="tei-body-headings"/>  

  <xsl:template match="tei:name[@xml:lang]" mode="tei-body-headings">
    <xsl:if test="@xml:lang='eng'">
      <xsl:call-template name="div-count-to-html-header">
        <xsl:with-param name="div-count"><xsl:call-template name="tei-div-count"/></xsl:with-param>
        <xsl:with-param name="content">
          <xsl:value-of select="."/>
        </xsl:with-param>
      </xsl:call-template>       
      <div class="nyms">
        <div class="official nym-wrapper">
          <span class="official nym-label">Official name </span>
          <xsl:apply-templates select="../tei:name[@xml:lang='ara']" mode="record-data"/>
          <xsl:apply-templates select="../tei:name[@xml:lang = 'ara-x-DMG']" mode="record-data"/>
        </div>
        <xsl:if test="../tei:name[@type='araLoc' or @type='latLoc']">
          <div class="local nym-wrapper">
            <span class="local nym-label">Local name </span>
            <xsl:choose>
              <xsl:when test="../tei:name[@type='araLoc']"><xsl:apply-templates select="../tei:name[@type='araLoc']" mode="record-data"/></xsl:when>
              <xsl:otherwise><span class="tei-type-araLoc"/></xsl:otherwise>
            </xsl:choose>            
            <xsl:choose>
              <xsl:when test="../tei:name[@type='latLoc']"><xsl:apply-templates select="../tei:name[@type='latLoc']" mode="record-data"/></xsl:when>
              <xsl:otherwise><span class="tei-type-latLoc"/></xsl:otherwise>
            </xsl:choose>
          </div>
        </xsl:if>
      </div>
    </xsl:if>
  </xsl:template>
  <xd:doc>
    <xd:desc>Delegate to the default ref logic</xd:desc>
  </xd:doc>
  <xsl:template match="tei:ref" mode="tei-body-headings">
    <xsl:apply-templates select="." mode="record-data"/>
  </xsl:template>
  
  <xsl:template match="tei:ref[contains(@target, 'author')]" mode="tei-body-headings">
    <xsl:call-template name="getAuthor"/>
    <div class="tei-authors"><span class="last-change"><xsl:apply-templates select="//tei:teiHeader/tei:revisionDesc"/></span></div>
  </xsl:template>

  <xsl:template name="getAuthor">
    <div class="tei-authors">
      <xsl:apply-templates select="//tei:fileDesc/tei:author" mode="record-data"/>
    </div>
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
  

  <xd:doc>
    <xd:desc>Suppress rendering the tei:div of type positioning as it only containse a machine
      readable geo tag used by the map function.</xd:desc>
  </xd:doc>
  <xsl:template match="tei:div[@type='positioning']" mode="record-data">
    <xsl:apply-templates select=".//tei:ref" mode="record-data"/>
  </xsl:template>

  <xsl:template match="tei:name[@xml:lang]" mode="record-data">
    <span class="{@xml:lang}">
      <xsl:value-of select="concat(., ' ')"/>
    </span>
  </xsl:template>

  <xsl:template match="tei:name[@type]" mode="record-data" priority="2">
    <span class="{@xml:lang} tei-type-{@type}">
      <xsl:value-of select="concat(., ' ')"/>
    </span>
  </xsl:template>
  
  <xsl:template match="tei:pc" mode="record-data">
    <xsl:value-of select="."/>
    <xsl:choose>
      <xsl:when test="./text() = ',' or ./text() = '.'">
        <xsl:text> </xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:strip-space elements="tei:u tei:w tei:pc"/>
  
  <xsl:template match="tei:w" mode="record-data">
    <xsl:variable name="classes">
      <xsl:choose>
        <xsl:when test="@type = preceding-sibling::*[1]/@type">
          <xsl:value-of select="concat('tei-w tei-type-', @type, ' lang-fr')"/>
        </xsl:when>
        <xsl:when test="@type">
          <xsl:value-of select="concat('tei-w tei-type-', @type, ' lang-fr xsl-first-of-group')"/>                
        </xsl:when>
        <xsl:when test="preceding-sibling::tei:w[1]/@type">
          tei-w lang-aeb xsl-first-of-group
        </xsl:when>
        <xsl:otherwise>tei-w</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="not(./@*|./tei:fs)">
        <xsl:value-of select="."/>
      </xsl:when>
      <xsl:when test="./@ana">
        <xsl:variable name="linkTarget">
          <xsl:call-template name="formURL">
            <xsl:with-param name="action">searchRetrieve</xsl:with-param>
            <xsl:with-param name="q" select="concat('entry==', substring-after(@ana, '#'))"/>
            <xsl:with-param name="x-context" select="'aeb_eng_001__v001'"/>
          </xsl:call-template>
        </xsl:variable>
        <span class="{$classes}"><xsl:apply-templates mode="record-data"/><dl class="tei-fs"><dt class="dict-ref">Dict.</dt><dd><a class="search-caller" href="{$linkTarget}">Go to entry</a></dd></dl></span>
      </xsl:when>
      <xsl:when test="./@type">
        <span class="{$classes}"><xsl:apply-templates mode="record-data"/></span>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-imports/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="not(local-name(following-sibling::*[1]) = 'pc') and
      not(local-name(following-sibling::*[1]) = 'w' and substring(following-sibling::*[1]/text(), 1, 1) = '-')">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="tei:kinesic" mode="record-data">
    <span class="tei-kinesic"><xsl:value-of select="tei:desc"/></span>
  </xsl:template>

</xsl:stylesheet>
