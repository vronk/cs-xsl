<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cr="http://aac.ac.at/content_repository" xmlns:utils="http://aac.ac.at/content_repository/utils" xmlns:sru="http://www.loc.gov/zing/srw/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fcs="http://clarin.eu/fcs/1.0" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:exsl="http://exslt.org/common" version="1.0" exclude-result-prefixes="xsl utils sru xs fcs xd exsl">
    <xsl:import href="../commons_v1.xsl"/>
    <xd:doc scope="stylesheet">
        <xd:desc> generate a view for a values-list (index scan)
            <xd:p>History:
                <xd:ul>
                    <xd:li>2012-02-06: created by:"vr": from values2view.xsl, from model2view.xsl</xd:li>
                </xd:ul>
            </xd:p>
            <xd:p>
                <xd:pre>
&lt;sru:scanResponse xmlns:sru="http://www.loc.gov/zing/srw/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fcs="http://clarin.eu/fcs/1.0/"&gt;
&lt;sru:version&gt;1.2&lt;/sru:version&gt;
   &lt;sru:terms path="//div[@type='diary-day']/p/date/substring(xs:string(@value),1,7)"&gt;
        &lt;sru:term&gt;
        &lt;sru:value&gt;1903-01&lt;/sru:value&gt;
        &lt;sru:numberOfRecords&gt;30&lt;/sru:numberOfRecords&gt;
        &lt;/sru:term&gt;
        &lt;sru:term&gt;
        &lt;sru:value&gt;1903-02&lt;/sru:value&gt;
        &lt;sru:numberOfRecords&gt;28&lt;/sru:numberOfRecords&gt;
        &lt;/sru:term&gt;
        &lt;sru:term&gt;
        &lt;sru:value&gt;1903-03&lt;/sru:value&gt;
        &lt;sru:numberOfRecords&gt;31&lt;/sru:numberOfRecords&gt;
        &lt;/sru:term&gt;
   &lt;/sru:terms&gt;
   &lt;sru:extraResponseData&gt;
        &lt;fcs:countTerms&gt;619&lt;/fcs:countTerms&gt;
    &lt;/sru:extraResponseData&gt;
    &lt;sru:echoedScanRequest&gt;
        &lt;sru:scanClause&gt;diary-month&lt;/sru:scanClause&gt;
        &lt;sru:maximumTerms&gt;100&lt;/sru:maximumTerms&gt;
    &lt;/sru:echoedScanRequest&gt;        
 &lt;/sru:scanResponse&gt;
</xd:pre>
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:output method="html" media-type="text/xhtml" indent="yes" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/> 
    
    <!-- <xsl:param name="size_lowerbound">0</xsl:param>
<xsl:param name="max_depth">0</xsl:param>
<xsl:param name="freq_limit">20</xsl:param>
<xsl:param name="show">file</xsl:param> -->
    <xsl:param name="sort">x</xsl:param>
    <!-- s=size|n=name|t=time|x=default -->
    <xsl:param name="name_col_width">50%</xsl:param>
    <xsl:param name="list-mode">table</xsl:param>

    <!-- <xsl:param name="mode" select="'htmldiv'" />     -->
    <xsl:param name="title" select="concat('scan: ', $scanClause )"/>

    <!--
<xsl:param name="detail_uri_prefix"  select="'?q='"/> 
-->
    <xsl:decimal-format name="european" decimal-separator="," grouping-separator="."/>
    <xsl:param name="scanClause" select="/sru:scanResponse/sru:echoedScanRequest/sru:scanClause"/>
<!--    <xsl:param name="scanClause-array" select="tokenize($scanClause,'=')"/>-->
    <xd:doc>
        <xd:desc>The index is defined as the part of the scanClause before the '='
        <xd:p>
            This is one possibility according to the
            <xd:a href="http://www.loc.gov/standards/sru/specs/scan.html">SRU documentation</xd:a>.
            The documentation states that scanClause can be "expressed as a complete index, relation, term clause in CQL". 
        </xd:p>
        <xd:p>
            Note: for the special scan clause fcs.resource this is an empty string.
            See <xd:a href="http://www.w3.org/TR/xpath/#function-substring-before">.XPath language definition</xd:a>
        </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="index">
        <xsl:choose>
            <xsl:when test="substring-before($scanClause,'=')">
                <xsl:value-of select="substring-before($scanClause,'=')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$scanClause"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:param>
    <xd:doc>
        <xd:desc>The filter is defined as the part of the scanClause after the '='
            <xd:p>
                This is one possibility according to the
                <xd:a href="http://www.loc.gov/standards/sru/specs/scan.html">SRU documentation</xd:a>.
                The documentation states that scanClause can be "expressed as a complete index, relation, term clause in CQL". 
            </xd:p>
            <xd:p>
                Note: for the special scan clause fcs.resource this is an empty string.
                See <xd:a href="http://www.w3.org/TR/xpath/#function-substring-after">.XPath language definition</xd:a>
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="filter" select="substring-after($scanClause,'=')"/>
    <xd:doc>
        <xd:desc>Standard callback from / template
        <xd:p>
            <xd:ul>
            <xd:li>If a htmlpage is requested generates input elements for the user to do another scan.</xd:li>
            <xd:li>Wraps the HTML representation of the result terms in an HTML div element.</xd:li>
            </xd:ul>
        </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="continue-root">
        <div> <!-- class="cmds-ui-block  init-show" -->
            <xsl:if test="contains($format, 'page')">
                <xsl:call-template name="header"/>
            </xsl:if>
            <div class="content">
                <xsl:apply-templates select="/sru:scanResponse/sru:terms"/>
            </div>
        </div>
    </xsl:template>
    <xd:doc>
        <xd:desc>Generates an HTML div element containing inputs so the user can initiate another scan</xd:desc>
    </xd:doc>
    <xsl:template name="header">
        <xsl:variable name="countTerms" select="/sru:scanResponse/sru:extraResponseData/fcs:countTerms"/>
        <xsl:variable name="start-item" select="'TODO:start-item=?'"/>
        <xsl:variable name="maximum-items" select="/sru:scanResponse/sru:echoedScanRequest/sru:scanClause"/>
        
        <!--  <h2>MDRepository Statistics - index values</h2>  -->
        <div class="header">
            <xsl:attribute name="data-countTerms">
                <xsl:value-of select="$countTerms"/>
            </xsl:attribute>
            <xsl:attribute name="start-item">
                <xsl:value-of select="$start-item"/>
            </xsl:attribute>
            <xsl:attribute name="maximum-items">
                <xsl:value-of select="$maximum-items"/>
            </xsl:attribute> 
            <!--<xsl:value-of select="$title"/>-->
            <form>
                <input type="hidden" name="version" value="1.2"/>
                <input type="text" name="scanClause" value="{$index}={$filter}"/>
                <input type="hidden" name="operation" value="scan"/>
                <input type="hidden" name="x-format" value="{$format}"/>
                <input type="hidden" name="x-context" value="{$x-context}"/>
                <input type="submit" value="suchen"/>
            </form>
            <xsl:value-of select="count(//sru:terms/sru:term)"/> out of <xsl:value-of select="$countTerms"/> Terms
            
        </div>
    </xsl:template>
    <xd:doc>
        <xd:desc>Operation scan returns any number of terms which are presented in HTML either nested as lists aor tables</xd:desc>
    </xd:doc>
    <xsl:template match="sru:terms">
<!--        <xsl:variable name="index" select="my:xpath2index(@path)"/>-->
        <xsl:choose>
            <xsl:when test="$list-mode = 'table'">
                <table>
                    <xsl:apply-templates select="sru:term"/>
                </table>
            </xsl:when>
            <xsl:otherwise>
                <ul>
                    <xsl:apply-templates select="sru:term"/>
                </ul>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xd:doc>
        <xd:desc>A term consits of a number for this term and the term itself
        <xd:p>The term is presented as a link that can be used to scan for that term.</xd:p>
        <xd:p>
            Sample data:
<xd:pre>
            &lt;sru:term&gt;
                &lt;sru:value&gt;cartesian&lt;/sru:value&gt;
                &lt;sru:numberOfRecords&gt;35645&lt;/sru:numberOfRecords&gt;
                &lt;sru:displayTerm&gt;Carthesian&lt;/sru:displayTerm&gt;
                &lt;sru:extraTermData&gt;&lt;/sru:extraTermData&gt;
            &lt;/sru:term&gt;
</xd:pre>
        </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="sru:term">
        <xsl:variable name="depth" select="count(ancestor::sru:term)"/>
        <xsl:variable name="href">
            <xsl:call-template name="generateLinkInScanResults">
                <xsl:with-param name="index" select="$index"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="link">
            <span>
                <xsl:if test="sru:extraTermData/cr:type">
                    <xsl:attribute name="class">
                        <xsl:value-of select="sru:extraTermData/cr:type"/>
                    </xsl:attribute>
                </xsl:if>
<!--                <xsl:value-of select="for $i in (1 to $depth) return '- '"/>-->
                <a class="search-caller" href="{$href}">  <!--target="_blank"-->
                    <xsl:choose>
                        <xsl:when test="sru:displayTerm != ''">
                            <xsl:value-of select="sru:displayTerm"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="sru:value"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </a>
            </span>
            <xsl:apply-templates select="sru:extraTermData/diagnostics"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$list-mode = 'table'">
                <tr>
                    <td align="right" valign="top">
                        <xsl:value-of select="sru:numberOfRecords"/>
                    </td>
                    <td>
                        <xsl:copy-of select="$link"/>
                    </td>
                </tr>
                <xsl:apply-templates select="sru:extraTermData/sru:terms/sru:term"/>
            </xsl:when>
            <xsl:otherwise>
                <li>
                    <xsl:copy-of select="$link"/>
                    <span class="note"> |<xsl:value-of select="sru:numberOfRecords"/>|</span>
                    <ul>
                        <xsl:apply-templates select="sru:extraTermData/sru:terms/sru:term"/>
                    </ul>
                </li>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>