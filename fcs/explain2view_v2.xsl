<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:utils="http://aac.ac.at/content_repository/utils" xmlns:sru="http://www.loc.gov/zing/srw/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fcs="http://clarin.eu/fcs/1.0" xmlns:cr="http://aac.ac.at/content_repository" version="2.0" xpath-default-namespace="http://explain.z3950.org/dtd/2.0/">
    <xsl:import href="explain2view_v1.xsl"/>
    <xsl:import href="../commons_v2.xsl"/>
    <xsl:output method="html"/>
    <xsl:param name="lang" select="'en'"/>
    <xsl:decimal-format name="european" decimal-separator="," grouping-separator="."/>
    <xsl:variable name="title" select="concat('explain: ', (//databaseInfo/title[@lang=$lang]/text(), //databaseInfo/title/text(), $site_name)[1])"/>
    <xsl:template name="continue-root">
        <div class="explain">
            <xsl:choose>
                <xsl:when test="$format='htmllist'"> 
                    <!-- only list the indexes to scan-->
                    <!--DEBUG:
                    base_url:<xsl:value-of select="$base_url"/>
                    x-context:<xsl:value-of select="$x-context"/>-->
                    <xsl:apply-templates select=".//indexInfo">
                        <xsl:with-param name="only_scan" select="true()"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </div>
        <!--<div class="explain-view">
            <xsl:apply-templates select="." mode="format-xmlelem"/>
        </div>-->
    </xsl:template>
    <xsl:template match="serverInfo"/>
    <xsl:template match="schemaInfo"/>
    <xsl:template match="databaseInfo">
        databaseInfo
        <h2>
            <xsl:value-of select="(title[@lang=$lang],title)[1]"/>
        </h2>
        <div>
            <xsl:value-of select="(description[@lang=$lang], description)[1]"/>
        </div>
    </xsl:template>
    <xsl:template match="indexInfo">
    <!--    <div>
            <a href="{concat('?operation=searchRetrieve&query=test&x-context=', $x-context, '&x-format=', $format )}">search</a>
        </div>-->
        <h3>Available indexes</h3>
        <ul class="indexInfo">
            <xsl:apply-templates select="index"/>
        </ul>
        <div class="div-after"/>
    </xsl:template>
    <xsl:template match="index">
        <xsl:param name="only_scan" select="true()"/>
        <xsl:param name="format" select="if($format='htmllist') then 'html' else $format"/>
        <xsl:variable name="scan-index">
            <xsl:call-template name="formURL">
                <xsl:with-param name="action" select="'scan'"/>
                <xsl:with-param name="scanClause" select="map/name"/>
                <xsl:with-param name="maximumTerms" select="if (xs:string(@cr:type)='nested') then 0 else $maximumTerms"/>
                <xsl:with-param name="format" select="$format"/>
            </xsl:call-template>
        </xsl:variable>
        
<!--        <xsl:variable name="scan-index" select="concat('fcs?operation=scan&scanClause=', map/name , '&x-context=', $x-context, '&x-format=', $format )"/>-->
        <xsl:choose>
            <xsl:when test="@scan='true'">
                <li>
                    <a href="{$scan-index}">
                        <xsl:value-of select="(title[@lang=$lang],title)[1]"/>
                    </a>
                </li>
            </xsl:when>
            <xsl:when test="$only_scan=true()"/>
            <xsl:otherwise>
                <li>
                    <xsl:value-of select="(title[@lang=$lang],title)[1]"/>
                </li>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>