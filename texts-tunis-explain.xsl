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
        <xd:desc></xd:desc>
    </xd:doc>
    <xsl:template name="default-query-string">
        <xsl:choose>
            <xsl:when test="zr:title = 'word'">tūnis</xsl:when>
            <xsl:when test="zr:title = 'tag'">verb</xsl:when>
            <xsl:when test="zr:title = 'lemma'">mʕā</xsl:when>
            <xsl:when test="zr:title = 'id'">wid_00436</xsl:when>
            <xsl:when test="zr:title = 'lemmaID'">kaan_001</xsl:when>
            <xsl:otherwise>test</xsl:otherwise>
        </xsl:choose>        
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Generate a list item that links to a scan for every known index</xd:desc>
    </xd:doc>
    <xsl:template match="zr:index">
        <xsl:variable name="scan-index">
            <xsl:call-template name="formURL">
                <xsl:with-param name="action" select="'scan'"/>
                <xsl:with-param name="scanClause" select="zr:map/zr:name"/>
                <xsl:with-param name="contextset">
                    <!--                    <xsl:if test="zr:map/zr:name/@set">
                        <xsl:value-of select="concat(zr:map/zr:name/@set, '.')"/>
                    </xsl:if>-->
                    <xsl:if test="zr:map/zr:name = 'resource'">
                        <xsl:if test="zr:map/zr:name/@set = 'fcs'">
                            <xsl:value-of select="concat(zr:map/zr:name/@set, '.')"/>
                        </xsl:if>
                    </xsl:if>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="search-query">
            <xsl:variable name="default-query-string">
                <xsl:call-template name="default-query-string"/>              
            </xsl:variable>
            <xsl:call-template name="formURL">
                <xsl:with-param name="action" select="'searchRetrieve'"/>
                <xsl:with-param name="q" select="concat(.//zr:name, '=', normalize-space($default-query-string))"/>
            </xsl:call-template>
        </xsl:variable>
        <dt>
            <xsl:attribute name="class"><xsl:value-of select="concat('zr-index ', translate(zr:map/zr:name, '.', '-'))"/></xsl:attribute>
            <xsl:choose>              
                <xsl:when test="zr:title[@lang=$lang]" >                        
                    <xsl:call-template name="dict">
                        <xsl:with-param name="key" select="zr:title[@lang=$lang]"/>
                    </xsl:call-template>                        
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="dict">
                        <xsl:with-param name="key" select="zr:title"/>
                    </xsl:call-template>   
                </xsl:otherwise>
            </xsl:choose>
        </dt>
        <dd>
            <a href="{$search-query}" class="search-caller">
                <xsl:call-template name="dict">
                    <xsl:with-param name="key">Search</xsl:with-param>
                </xsl:call-template>
            </a>
        </dd>
    </xsl:template>
    
    
</xsl:stylesheet>