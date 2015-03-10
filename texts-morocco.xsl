<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:exsl="http://exslt.org/common"
  xmlns:fcs="http://clarin.eu/fcs/1.0" xmlns:sru="http://www.loc.gov/zing/srw/"
  xmlns:hits="http://clarin.eu/fcs/dataview/hits"
  xmlns:m="http://acdh.oeaw.ac.at/morocco"
  xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xsl exsl xd tei fcs sru hits m">
  <xsl:import href="fcs/result2view_v1.xsl"/>
    <xsl:output method="html" media-type="text/xhtml" indent="yes" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
  <xsl:template name="callback-header">
    <link href="/static/fonts/andika/Andika.css" type="text/css" rel="stylesheet"/>
    <style type="text/css">
      body { font: 13px/1.5 AndikaW, 'Andika', serif; }
    </style>
    <link href="{$scripts_url}style/sampleText.css" type="text/css" rel="stylesheet"/>     
    <link href="{$scripts_url}style/fcs-kwic.css" type="text/css" rel="stylesheet"/>     
    <script type="text/javascript" src="{$scripts_url}js/URI.js"></script>
    <script type="text/javascript" src="{$scripts_url}js/jquery/jquery.selection.js"></script>
    <script type="text/javascript" src="scripts/js/params.js"></script>
    <script type="text/javascript" src="{$scripts_url}js/virtual-keyboard.js"></script>
    <link href="{$scripts_url}style/virtual-keyboard.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript">
      VirtualKeyboard.keys = {
      "morocco":["ʔ", "ā", "ḅ", "ʕ", "ḏ̣", "ḏ", "ē", "ġ", "ǧ", "ḥ", "ī", "ᴵ", "ḷ", "ṃ", "ō", "ṛ", "ṣ", "š", "ṭ", "ṯ", "ū", "ẓ", "ž"], 
      }
      VirtualKeyboard.keys["morocco_conc"] = VirtualKeyboard.keys["morocco"]
      $(document).ready(function(){
      VirtualKeyboard.attachKeyboards()
      });
    </script>
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
      <xsl:when test="starts-with(@target, 'http://') or starts-with(@target, '/') or starts-with(@target, 'https://')">
        <img src="{@target}" alt="{$altText}"/>
      </xsl:when>
      <xsl:otherwise>
        <img src="http://corpus3.aac.ac.at/static/images/vicav/{@target}" alt="{@target}"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>We need three columns for the kwic like results.</xd:desc>
  </xd:doc>
  <xsl:template name="result-rows">
    <xsl:apply-templates mode="result-data-table"/>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>This result view has 4 columns + the result number</xd:desc>
  </xd:doc>
  <xsl:template name="getTotalNumberofResultCols">4</xsl:template>
  
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
      <xsl:when test="./@m:ana">
        <xsl:variable name="linkTargetDict">
          <xsl:call-template name="formURL">
            <xsl:with-param name="action">searchRetrieve</xsl:with-param>
            <xsl:with-param name="q" select="concat('entry==', @lemmaRef)"/>
            <xsl:with-param name="x-context" select="'aeb_eng_001__v001'"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="linkTargetSrc">
          <xsl:call-template name="formURL">
            <xsl:with-param name="action">searchRetrieve</xsl:with-param>
            <xsl:with-param name="q" select="concat('wid=', @xml:id|@copyOf)"/>
            <xsl:with-param name="x-context">
              <xsl:choose>
                <xsl:when test="../../tei:ref/@target|../tei:ref/@target">
                  <xsl:value-of select="../../tei:ref/@target|../tei:ref/@target"/>                  
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$x-context"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="dataview">full</xsl:with-param>
          </xsl:call-template>
        </xsl:variable>
        <span class="{$classes}"><a href="{$linkTargetSrc}"><xsl:apply-templates mode="record-data"/></a><xsl:if
          test="@lemmaRef != ''"><dl 
              class="tei-fs"><dt
              class="dict-ref">Dict.</dt><dd><a class="search-caller" href="{$linkTargetDict}">entry</a></dd></dl></xsl:if></span>
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
  
  <xsl:template match="tei:ref[parent::hits:Result]" mode="record-data"/>
  
</xsl:stylesheet>
