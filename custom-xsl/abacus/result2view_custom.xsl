<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:diag="http://www.loc.gov/zing/srw/diagnostic/" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:utils="http://aac.ac.at/content_repository/utils" xmlns:sru="http://www.loc.gov/zing/srw/" xmlns:saxon="http://saxon.sf.net/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fcs="http://clarin.eu/fcs/1.0" xmlns:exsl="http://exslt.org/common" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" version="2.0" exclude-result-prefixes="#all">
     <xsl:import href="../../fcs/result2view_v1.xsl"/>
    <xd:doc scope="stylesheet">
        <xd:desc>Customization for abacus project. copied directly from /db/apps/cr-xq-mets/modules/cs-xsl/fcs/result2view.xsl</xd:desc>
    </xd:doc>
    <xsl:output method="xhtml" media-type="text/html" indent="yes" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
    <xsl:include href="../../commons_v2.xsl"/>
    <xsl:include href="../../fcs/data2view_v2.xsl"/>
    
    <!-- wenn eine Seite keinen Textinhalt hat, hat der div in der Anzeige keine Breite, ergo rutscht das Faksimilie nach links; wird durch einen nbsp verhindert.-->
    <!--<xsl:template match="TEI | tei:TEI" mode="record-data">
        <xsl:if test="normalize-space(.)=''"> </xsl:if>
        <xsl:text>***</xsl:text>
        <xsl:next-match/>
    </xsl:template>-->
    
    <xsl:template match="*[parent::fcs:DataView/@type='full'][normalize-space(.)='']" mode="record-data" priority="1">
        <xsl:text>&#160;</xsl:text>
        <xsl:next-match/>
    </xsl:template>
    
    <!--<xsl:template match="tei:lb|lb" mode="record-data" priority="1">
        <br/>
    </xsl:template>-->
     
    <xsl:template match="tei:bibl | bibl" mode="record-data"  priority="1">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:head | head" mode="record-data" priority="1">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <span class="{$class}">
            <xsl:call-template name="inline">
                <xsl:with-param name="insertTrailingBlank" select="not((ancestor::tei:TEI|ancestor::TEI)//*[local-name(.) = 'seg' and @type='whitespace'])"/>
            </xsl:call-template>
        </span>
    </xsl:template>
    
    <xsl:template match="milestone[@type='symbol'][@rend='bracketsMW'] | tei:milestone[@type='symbol'][@rend='bracketsMW']" mode="record-data" priority="1">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <span class="{$class}">):( <span class="dots-triangle">.<span class="dots-triangle sup">.</span>.</span>
        </span>
    </xsl:template>
    <xsl:template match="tei:figure | figure" mode="record-data" priority="1">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <span class="{$class}">
            <xsl:apply-templates mode="record-data"/>
        </span>
    </xsl:template>
    <xsl:template match="tei:reg | reg" mode="record-data" priority="1"/>
    <xsl:template match="tei:supplied | supplied" mode="record-data" priority="1"/>
    
    <!-- lb in runden oder eckigen Klammern sollen nicht zu <br> transformiert werden. -->
    <xsl:template match="tei:lb[ancestor::tei:corr] | lb[ancestor::corr]" mode="record-data" priority="1">
        <xsl:choose>
            <xsl:when test="@type='d'">
                <xsl:text>=</xsl:text>
            </xsl:when>
            <xsl:when test="@type='s'">
                <xsl:text>-</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    
    <xsl:template match="tei:corr | corr" mode="record-data" priority="1">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <span class="{$class}" title="Korrektur">
            <a href="#">
                <xsl:text>[</xsl:text>
                <span class="tei-{local-name()}-content">
                   <xsl:apply-templates mode="record-data"/>
                </span>
                <xsl:text>]</xsl:text>
            </a>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:ref | ref" mode="record-data" priority="1">
        <xsl:call-template name="inline">
            <xsl:with-param name="insertTrailingBlank" select="not(ancestor::*[local-name(.) = 'TEI']//*[local-name(.) = 'seg' and @type='whitespace'])"/>
        </xsl:call-template>
    </xsl:template>    
    
    <xsl:template match="tei:seg[@type = 'header' or @type = 'footer'] | seg[@type = 'header' or @type = 'footer']" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <div class="{$class}">
            <xsl:apply-templates mode="record-data"/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:hi[@rend='initialCapital'] | hi[@rend='initialCapital']" mode="record-data" priority="1">
        <xsl:variable name="children">
            <xsl:apply-templates mode="record-data"/>
        </xsl:variable>
        <span class="tei-hi tei-rend-initialCapital">
            <xsl:value-of select="substring(normalize-space(.),1,1)"/>
        </span>
        <xsl:variable name="classes" as="xs:string*">
            <xsl:for-each select="descendant::*">
                <xsl:call-template name="classnames"/>
            </xsl:for-each>
        </xsl:variable>
        <span class="{string-join($classes, ' ')}">
            <xsl:value-of select="substring(normalize-space(.),2)"/>
        </span>
    </xsl:template>
    
    <xsl:template match="ptr | tei:ptr" mode="record-data" priority="1"/>
        
    <xd:doc>
        <xd:desc>per default wird tei:p zu html:span umgewandelt; header und footer werden jedoch zu html:divs umgewandelt (fehlerhafte Struktur, daher  Darstellungsfehler in Chrome etc.); daher wird tei:p -&gt; tei:div, wenn sich darin ein tei:seg[@type=('header','footer')] befindet.</xd:desc>
    </xd:doc>
    <xsl:template match="p[descendant::seg[@type[.='header' or .='footer']]] | tei:p[descendant::tei:seg[@type[.='header' or .='footer']]]" mode="record-data" priority="1">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <div class="{$class}">
            <xsl:apply-templates mode="record-data"/>
        </div>
    </xsl:template>
    
</xsl:stylesheet>