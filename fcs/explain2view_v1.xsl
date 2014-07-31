<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:zr="http://explain.z3950.org/dtd/2.0/" xmlns:utils="http://aac.ac.at/content_repository/utils" xmlns:sru="http://www.loc.gov/zing/srw/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fcs="http://clarin.eu/fcs/1.0" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:exsl="http://exslt.org/common" version="1.0" exclude-result-prefixes="xsl utils sru zr xs fcs xd exsl">
    <xsl:import href="../commons_v1.xsl"/>
    <xd:doc scope="stylesheet">
        <xd:desc>generate a view for the explain-record (http://www.loc.gov/standards/sru/specs/explain.html) </xd:desc>
    </xd:doc>
    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:output method="html" media-type="text/xhtml" indent="yes" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"/>
    <xsl:param name="lang" select="'en'"/>
    <xsl:import href="../commons_v1.xsl"/>
    <xsl:output method="html"/>
    <xsl:param name="lang" select="'de'"/>
    <xsl:decimal-format name="european" decimal-separator="," grouping-separator="."/>
    <xd:doc>
        <xd:desc>Called from common_v1.xsl to present a title string
        <xd:p>
            Note: only called if a complete page is requested.
        </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:variable name="title">
        <xsl:text>explain: </xsl:text>
        <xsl:choose>
            <xsl:when test="//zr:databaseInfo/zr:title[@lang=$lang]/text()">
                <xsl:value-of select="//zr:databaseInfo/zr:title[@lang=$lang]/text()"/>
            </xsl:when>
            <xsl:when test="//zr:databaseInfo/zr:title/text()">
                <xsl:value-of select="//zr:databaseInfo/zr:title[1]/text()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$site_name"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xd:doc>
        <xd:desc>Entry point called from commons_v1.xsl
        <xd:p>
            If the requested format contains table try to display
            as much information as we can else this is most likely
            an ajax request so repsond just with the heading and the list
            of possible indexes.
        </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="continue-root">
        <xsl:choose>
            <xsl:when test="contains($format, 'page')">
                <xsl:apply-templates mode="verbose"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
        
        <!--<div class="explain-view">
            <xsl:apply-templates select="." mode="format-xmlelem"/>
        </div>-->
    </xsl:template>
    <xsl:template match="sru:version" mode="verbose">
        <div class="sru-version">
            SRU version: <xsl:value-of select="."/>
        </div>
    </xsl:template>
    <xsl:template match="sru:recordPacking" mode="verbose">
        <div class="sru-recordPacking">
            Default record packing: <xsl:value-of select="."/>
        </div>
    </xsl:template>
    <xsl:template match="sru:recordSchema" mode="verbose">
        <div class="sru-recordSchema">
            Record schema: <xsl:value-of select="."/>
        </div>
    </xsl:template>
    <xsl:template match="zr:serverInfo" mode="verbose">
        <div class="zr-serverInfo">
            <p>Host: <xsl:value-of select="zr:host"/>:<xsl:value-of select="zr:port"/>
            </p>
            <p>Database: <xsl:value-of select="zr:database"/>
            </p>
        </div>
    </xsl:template>
    <xsl:template match="zr:schemaInfo" mode="verbose">
        <p>Schema info available in XML.</p>
        <xsl:apply-templates mode="verbose"/>
    </xsl:template>
    <xd:doc>
        <xd:desc>Fetches the database's name and the descreption if available</xd:desc>
    </xd:doc>
    <xsl:template match="zr:databaseInfo">
        <h2>
            <xsl:value-of select="zr:title[@lang=$lang]"/>
        </h2>
        <div>
            <xsl:value-of select="zr:description[@lang=$lang]"/>
        </div>
    </xsl:template>
    <xd:doc>
        <xd:desc>Generates a heading and stars the list of possible indexes</xd:desc>
    </xd:doc>
    <xsl:template match="zr:indexInfo">
        <h3>Available indexes</h3>
        <ul class="zr:indexInfo">
            <xsl:apply-templates select="zr:index"/>
        </ul>
    </xsl:template>
    <xd:doc>
        <xd:desc>Generate a list item that links to a scan for every known index</xd:desc>
    </xd:doc>
    <xsl:template match="zr:index">
        <xsl:variable name="scan-index">
            <xsl:call-template name="formURL">
                <xsl:with-param name="action" select="'scan'"/>
                <xsl:with-param name="scanClause" select="zr:map/zr:name"/>
            </xsl:call-template>
        </xsl:variable>
        <li>
            <a href="{$scan-index}">
                <xsl:choose>
                    <xsl:when test="zr:title[@lang=$lang]">
                        <xsl:value-of select="zr:title[@lang=$lang]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="zr:title"/>
                    </xsl:otherwise>
                </xsl:choose>
            </a>
        </li>
    </xsl:template>
    <!--
    <xsl:template match="*[@lang]" >
        
    </xsl:template>-->
    <xd:doc>
        <xd:desc>In verbose mode first display the list and then the 
            items only generated in this mode</xd:desc>
    </xd:doc>
    <xsl:template match="zr:explain" mode="verbose">
        <xsl:apply-templates/>
        <xsl:apply-templates mode="verbose"/>
    </xsl:template>
    <xsl:template match="zr:configInfo" mode="verbose">
        <div class="zr-serverInfo">
            <p>Default number of records: <xsl:value-of select="zr:default[@type='numberOfRecords']"/>
            </p>
            <p>Settings: maximum records returned: <xsl:value-of select="zr:setting[@type='maximumRecords']"/>, result TTL: <xsl:value-of select="zr:setting[@type='resultSetTTL']"/>
            </p>
        </div>
    </xsl:template>
    <xd:doc>
        <xd:desc>In verbose mode even give hints to unprocessed nodes by including
        their text as comment</xd:desc>
    </xd:doc>
    <xsl:template match="text()" mode="verbose">
        <xsl:if test="normalize-space(.) != ''">
            <xsl:comment>
                <xsl:value-of select="."/>
            </xsl:comment>
        </xsl:if>
    </xsl:template>
    <xd:doc>
        <xd:desc>Normally zap any text not beloging to processed nodes</xd:desc>
    </xd:doc>
    <xsl:template match="text()"/>
</xsl:stylesheet>