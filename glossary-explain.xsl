<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:exsl="http://exslt.org/common"
    xmlns:fcs="http://clarin.eu/fcs/1.0"
    xmlns:sru="http://www.loc.gov/zing/srw/"
    xmlns:zr="http://explain.z3950.org/dtd/2.0/"
    xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xsl exsl xd tei fcs sru zr">
    <xsl:import href="fcs/explain2view_v1.xsl"/>
    <xsl:output method="html" media-type="text/xhtml" indent="yes" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/> 
    
    <xsl:variable name="style-type" select="' glossary'"/>
    
    <xd:doc>
        <xd:desc></xd:desc>
    </xd:doc>
    <xsl:template name="default-query-string">
        <xsl:choose>
            <xsl:when test=".//zr:name='sense'">
                =Wasser
            </xsl:when>
            <xsl:otherwise>
                =water
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="zr:indexInfo">
        <div class="zr-indexInfo">
            <div>
                <h3>Search Options</h3>
                <dl>
                    <xsl:apply-templates select="zr:index"/>
                </dl>
            </div>
        </div>
    </xsl:template>
    
    <xsl:template name="generateImgHTMLTags">
        <xsl:param name="altText" select="@target"/>
        <xsl:choose>
            <xsl:when test="starts-with(@target, 'http://') or starts-with(@target, '/') or starts-with(@target, 'https://')">
                <img src="{@target}" alt="{$altText}"/>
            </xsl:when>
            <xsl:otherwise>
                <img src="http://corpus3.aac.ac.at/vicav/images/{@target}" alt="{@target}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Suppress, handled elsewhere</xd:desc>
    </xd:doc>
    <xsl:template match="tei:front/tei:div/tei:ref[contains(@target, '.JPG') or 
        contains(@target, '.jpg') or
        contains(@target, '.PNG') or
        contains(@target, '.png')]" mode="record-data"/>
    
    <xsl:template match="zr:databaseInfo[//tei:teiHeader|//tei:front]">
        <div class="zr-description">
            <xsl:apply-templates mode="record-data" select=".//tei:teiHeader/*|.//tei:front/*"/>
        </div>
        <div class="zr-description background">
            <xsl:attribute name="style">
                <xsl:value-of select="concat('background-image:url(', .//tei:front/tei:div/tei:ref[contains(@target, '.JPG') or 
                    contains(@target, '.jpg') or
                    contains(@target, '.PNG') or
                    contains(@target, '.png')]/@target, ');')"/>
            </xsl:attribute>
        </div>
    </xsl:template>
    
</xsl:stylesheet>