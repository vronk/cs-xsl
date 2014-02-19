<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:html="http://www.w3.org/1999/xhtml" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:exsl="http://exslt.org/common"
  xmlns:fcs="http://clarin.eu/fcs/1.0" xmlns:sru="http://www.loc.gov/zing/srw/"
  xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xsl exsl xd tei fcs sru">
  <xsl:import href="fcs/result2view_v1.xsl"/>
  <xsl:output method="html" media-type="text/xhtml" indent="yes" encoding="UTF-8"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>

  <xd:doc>
    <xd:desc>Special handling of target declarations as used by profiles</xd:desc>
  </xd:doc>
  <xsl:template name="generateTarget">
    <xsl:param name="linkText" select="'Click here'"/>
    <xsl:variable name="linkTarget">
      <xsl:choose>
        <xsl:when test="contains(@target, 'http://')">_blank</xsl:when>
        <xsl:otherwise/>
        <!-- empty string -->
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="target">
      <xsl:choose>
        <xsl:when test="contains(@target, 'http://')">
          <xsl:value-of select="@target"/>
        </xsl:when>
        <xsl:when test="contains(@target, '|')">
          <xsl:call-template name="formURL">
            <xsl:with-param name="action">searchRetrieve</xsl:with-param>
            <xsl:with-param name="q" select="substring-after(@target, '|')"/>
            <xsl:with-param name="x-context" select="substring-before(@target, '|')"/>
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
    <a href="{$target}" target="{$linkTarget}">
      <xsl:value-of select="$linkText"/>
    </a>
  </xsl:template>

  <xd:doc>
    <xd:desc>Handling of ptr, that is links without further text as description</xd:desc>
  </xd:doc>
  <xsl:template match="tei:ptr" mode="record-data">
    <xsl:call-template name="generateTarget"/>
  </xsl:template>

  <xd:doc>
    <xd:desc>Handling of ref, that is links with further text as description</xd:desc>
  </xd:doc>
  <xsl:template match="tei:ref[not(contains(@target, '.JPG') or 
    contains(@target, '.jpg') or
    contains(@target, '.PNG') or
    contains(@target, '.png'))]" mode="record-data" priority="-1">
    <xsl:call-template name="generateTarget">
      <xsl:with-param name="linkText">
        <xsl:apply-templates mode="record-data"/>
      </xsl:with-param>
    </xsl:call-template>
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
      <h2>
        <xsl:value-of select="."/>
      </h2>
      <div class="nyms">
        <div class="official nym-wrapper">
          <span class="official nym-label">Official name </span>
          <xsl:apply-templates select="../tei:name[@xml:lang='ara']" mode="record-data"/>
          <xsl:apply-templates select="../tei:name[@xml:lang = 'ara-x-DMG']" mode="record-data"/>
        </div>
        <xsl:if test="../tei:name[@type='araLoc']">
          <div class="local nym-wrapper">
            <span class="local nym-label">Local name </span>
            <xsl:apply-templates select="../tei:name[@type='araLoc']" mode="record-data"/>
            <xsl:apply-templates select="../tei:name[@type='latLoc']" mode="record-data"/>
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
    <xd:desc>Put TEI text content into a div</xd:desc>
  </xd:doc>
  <xsl:template match="tei:TEI" mode="record-data">
    <div class="tei-TEI">
      <xsl:if test="@xml:id">
        <xsl:attribute name="class">
          <xsl:value-of select="concat('tei-TEI ', @xml:id)"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="tei:text" mode="record-data"/>
    </div>
  </xsl:template>

  <xd:doc>
    <xd:desc>Suppress rendering the tei:div of type positioning as it only containse a machine
      readable geo tag used by the map function.</xd:desc>
  </xd:doc>
  <xsl:template match="tei:div[@type='positioning']" mode="record-data">
    <xsl:apply-templates select=".//tei:ref" mode="record-data"/>
  </xsl:template>

  <!-- unused right now  <xd:doc>
    <xd:desc>Glottonyms need special treatment, they will be searched in the whole document and
    rendered here.
    </xd:desc>
  </xd:doc>
  <xsl:template match="tei:div[@type='glottonyms']" mode="record-data">
    <div class="tei-div glottonyms">
      <xsl:call-template name="typeToHeading"/>
      <div class="nym">
        <div class="official-nyms"><span class="official-nyms-label">Official name:</span><xsl:apply-templates select="//tei:name[@xml:lang='ara']" mode="record-data"/><xsl:apply-templates select="//tei:name[@xml:lang='ara-x-DMG']" mode="record-data"/></div>
        <div class="local-nyms"><span class="local-nyms-label">Local name:</span><xsl:apply-templates select="//tei:name[@type='araLoc']" mode="record-data"/><xsl:apply-templates select="//tei:name[@type='latLoc']" mode="record-data"/></div>
      </div>
    </div>
  </xsl:template> -->

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

  <xd:doc>
    <xd:desc>Return the result if there is exactly one result</xd:desc>
  </xd:doc>
  <xsl:template match="sru:records[count(sru:record) = 1]" mode="table">
    <xsl:variable name="rec_uri">
      <xsl:call-template name="_getRecordURI"/>
    </xsl:variable>
    <xsl:apply-templates select="sru:record/*" mode="record-data"/>
    <div class="title">
      <xsl:choose>
        <xsl:when test="$rec_uri">
          <!-- it was: htmlsimple, htmltable -link-to-> htmldetail; otherwise -> htmlpage -->
          <!--                        <a class="internal" href="{my:formURL('record', $format, my:encodePID(.//recordIdentifier))}">-->
          <a class="value-caller" href="{$rec_uri}&amp;x-format={$format}">
            <xsl:call-template name="getTitle"/>
          </a>                         
          <!--                        <span class="cmd cmd_save"/>-->
        </xsl:when>
        <xsl:otherwise>
          <!-- FIXME: generic link somewhere anyhow! -->
          <xsl:call-template name="getTitle"/>
        </xsl:otherwise>
      </xsl:choose>                        
    </div>
    <xsl:apply-templates select="//tei:teiHeader" mode="record-data"/>
  </xsl:template>
</xsl:stylesheet>
