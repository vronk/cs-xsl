<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:exsl="http://exslt.org/common"
    xmlns:fcs="http://clarin.eu/fcs/1.0"
    xmlns:sru="http://www.loc.gov/zing/srw/"
    xmlns:zr="http://explain.z3950.org/dtd/2.0/"
    xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xsl exsl xd tei fcs sru zr">
    <xsl:import href="fcs/explain2view_v1.xsl"/>
    <xsl:output method="html" media-type="text/xhtml" indent="yes" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/> 
    <xd:doc>
        <xd:desc>Examples of search queries that work with noske tunico data.</xd:desc>
    </xd:doc>
    <xsl:template name="default-query-string">
        <xsl:choose>
            <xsl:when test="zr:title = 'word'">tūnis</xsl:when>
            <xsl:when test="zr:title = 'pos'">verb</xsl:when>
            <xsl:when test="zr:title = 'lemma'">mʕā</xsl:when>
            <xsl:when test="zr:title = 'id'">wid_00436</xsl:when>
            <xsl:when test="zr:title = 'lemmaID'">kaan_001</xsl:when>
            <xsl:otherwise>test</xsl:otherwise>
        </xsl:choose>        
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Examples of native (CorpusQL) search queries that work with noske tunico data.</xd:desc>
    </xd:doc>
    <xsl:template name="native-query-string">
        <xsl:choose>
            <xsl:when test="zr:title = 'word'">"tūnis"</xsl:when>
            <xsl:when test="zr:title = 'pos'">[pos = "verb"] []{0,3} [pos="preposition"]</xsl:when>
            <xsl:when test="zr:title = 'lemma'">[lemma = ".*mʕā.*"]</xsl:when>
            <xsl:when test="zr:title = 'id'">[id="wid_00436"]</xsl:when>
            <xsl:when test="zr:title = 'lemmaID'">[lemmaID = "kaan_001"]</xsl:when>
            <xsl:otherwise>test</xsl:otherwise>
        </xsl:choose>        
    </xsl:template>
    
    <xsl:template name="scan-clause-string">
        <xsl:value-of select="concat(zr:map/zr:name, '=')"/>
    </xsl:template>
    
</xsl:stylesheet>