<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cr="http://aac.ac.at/content_repository" xmlns:cmd="http://www.clarin.eu/cmd/" xmlns:diag="http://www.loc.gov/zing/srw/diagnostic/" xmlns:utils="http://aac.ac.at/content_repository/utils" xmlns:saxon="http://saxon.sf.net/" xmlns:sru="http://www.loc.gov/zing/srw/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fcs="http://clarin.eu/fcs/1.0" xmlns:exsl="http://exslt.org/common" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" version="2.0" exclude-result-prefixes="#all">
    <xd:doc scope="stylesheet">
        <xd:desc>Generate html view of a sru-result-set  (eventually in various formats)
            <xd:p>History:
                <xd:ul>
                    <xd:li>2011-12-06: created by:"vr": based on cmdi/scripts/mdset2view.xsl retrofitted for XSLT 1.0</xd:li>
                </xd:ul>
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xd:doc>
        <xd:desc>Note: method="xhtml" is saxon-specific! prevents  collapsing empty &lt;script&gt; tags, that makes browsers choke</xd:desc>
    </xd:doc>
    <xsl:output method="xhtml" media-type="text/html" indent="yes" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"/>
    <xsl:include href="../commons_v2.xsl"/>
    <xsl:include href="../fcs/data2view_v2.xsl"/>
    <xsl:param name="title">
        <xsl:text>Result Set</xsl:text>
    </xsl:param>
    <xsl:variable name="cols">
        <col>all</col>
    </xsl:variable>
    <xsl:template name="continue-root">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="sru:searchRetrieveResponse">
        <div>
            <xsl:apply-templates select="sru:diagnostics"/>
            
                <!--actually we want the header all of the time, no?
                    <xsl:if test="contains($format, 'htmlpage')">
                    <xsl:call-template name="header"/>
                    </xsl:if>-->
<!--                <xsl:call-template name="header"/>-->
            <xsl:apply-templates select="sru:records" mode="list"/>
    <!-- switch mode depending on the $format-parameter -->        
                <!--<xsl:choose>   
                    <xsl:when test="contains($format,'htmltable')">
                        <xsl:apply-templates select="records" mode="table"/>
                    </xsl:when>
                    <xsl:when test="contains($format,'htmllist')">
                        <xsl:apply-templates select="records" mode="list"/>
                    </xsl:when> 
                    <xsl:when test="contains($format, 'htmlpagelist')">
                        <xsl:apply-templates select="records" mode="list"/>
                    </xsl:when>
                     <xsl:otherwise>mdset2view: unrecognized format: <xsl:value-of select="$format"/>
                    </xsl:otherwise>
                </xsl:choose>-->
        </div>
    </xsl:template>
    <xsl:template name="header">
        <div class="result-header" data-numberOfRecords="{$numberOfRecords}">
            <xsl:if test="contains($format, 'page')">
                <xsl:call-template name="query-input"/>
            </xsl:if>
            <span class="label">showing </span>
            <span class="value hilight">
                <xsl:value-of select="sru:extraResponseData/fcs:returnedRecords"/>
            </span>
            <span class="label"> out of </span>
            <span class="value hilight">
                <xsl:value-of select="$numberOfRecords"/>
            </span>
            <span class="label"> entries (with </span>
            <span class="value hilight">
                <xsl:value-of select="$numberOfMatches"/>
            </span>
            <span class="label"> hits)</span>
            <div class="note">
                <xsl:for-each select="(sru:echoedSearchRetrieveRequest/*|sru:extraResponseData/*)">
                    <span class="label">
                        <xsl:value-of select="name()"/>: </span>
                    <span class="value">
                        <xsl:value-of select="."/>
                    </span>;
	        </xsl:for-each> 
                <!--<span class="label">duration: </span>
                <span class="value"> 
                    <xsl:value-of select="sru:extraResponseData/fcs:duration"/>
                    </span>;-->
            </div>
        </div>
    </xsl:template>
    <xsl:template match="sru:records" mode="list">
        <xsl:apply-templates select="sru:record" mode="list"/>
    </xsl:template>
    <xsl:template match="sru:record" mode="list">
        <xsl:variable name="curr_record" select="."/>
        <!--<xsl:variable name="fields">
            <div>
                <xsl:apply-templates select="*" mode="record-data"/>
            </div>
        </xsl:variable>-->
        <div class="record resource">
<!--            <xsl:call-template name="getTitle"></xsl:call-template>           -->
            <xsl:apply-templates select=".//fcs:Resource" mode="record-data"/>
        </div>
    </xsl:template>
    <xsl:template match="fcs:Resource" mode="record-data">
        <div class="header">
            <h4>
                <!--<xsl:value-of select=".//sourceDesc/bibl[@type='short']"/>-->
                <xsl:call-template name="getTitle"/>
            </h4>
            <xsl:call-template name="links"/>
        </div>
        <xsl:apply-templates select=".//fcs:DataView[@type='metadata']" mode="record-data"/>
        <xsl:apply-templates select=".//fcs:DataView[@type='image']" mode="record-data"/>
    </xsl:template>
    <xsl:template match="teiHeader" mode="record-data">
        <p>
            <xsl:apply-templates select=".//sourceDesc/bibl[@type='transcript']" mode="record-data"/>
        </p>
<!--        <xsl:apply-templates select=".//sourceDesc//imprint" mode="record-data"/>-->
        <xsl:apply-templates select=".//sourceDesc//msDesc" mode="record-data"/>
        <div class="div-after"/>
    </xsl:template>
    <xsl:template match="gap" mode="record-data"> [...] </xsl:template>
    
<!--    <xsl:template match="fcs:DataView[@type='image']" mode="record-data" />-->
    <xsl:template name="links">
        <xsl:variable name="resource-id" select="(.//fcs:Resource/data(@pid),ancestor-or-self::fcs:Resource/data(@pid))[1]"/>
        <xsl:variable name="toc-link">
            <xsl:call-template name="formURL">
                <xsl:with-param name="action" select="'scan'"/>
                <xsl:with-param name="format" select="$format"/>
                <xsl:with-param name="x-context" select="$resource-id"/>
                <xsl:with-param name="scanClause" select="'fcs.toc'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="md-link-cmdi">
            <xsl:call-template name="formURL">
                <xsl:with-param name="action" select="'get-metadata'"/>
                <xsl:with-param name="format" select="'htmlpage'"/>
                <xsl:with-param name="q" select="$resource-id"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="md-link-tei">
            <xsl:call-template name="formURL">
                <xsl:with-param name="action" select="'get-metadata'"/>
                <xsl:with-param name="format" select="'htmlpage'"/>
                <xsl:with-param name="md-format" select="'TEIHDR'"/>
                <xsl:with-param name="q" select="$resource-id"/>
            </xsl:call-template>
        </xsl:variable>
        <div class="links">
            <a class="link-info" href="#">Info</a>
            <a class="toc" href="{$toc-link}">ToC</a>
            <a class="tei" href="{$md-link-tei}">TEI</a>
            <a class="tei" href="{$md-link-cmdi}">CMD</a>
<!--            <a class="tei" href="TODO">Search</a>-->
<!--            <a class="tei" href="./fcs">FCS</a>-->
        </div>
        <div class="context-detail"/>
        <div class="div-after"/>
    </xsl:template>
    <xsl:template match="cmd:CMD" mode="record-data">
        <p>
            <xsl:apply-templates select=".//cmd:sourceDesc/cmd:bibl" mode="record-data"/>
        </p>
        <!--        <xsl:apply-templates select=".//sourceDesc//imprint" mode="record-data"/>-->
        <xsl:apply-templates select=".//cmd:sourceDesc//cmd:msDesc" mode="record-data"/>
        s
<!--        <xsl:apply-templates select=".//cmd:TotalSize" mode="record-data"/>-->
        <div class="div-after"/>
    </xsl:template>
</xsl:stylesheet>