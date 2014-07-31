<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:utils="http://aac.ac.at/content_repository/utils" xmlns:sru="http://www.loc.gov/zing/srw/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fcs="http://clarin.eu/fcs/1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:exsl="http://exslt.org/common" version="1.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            generate a json object of the scanResponse
            <xd:p>Output:</xd:p>
            <xd:pre>
     {index:"$scanClause", count:"$countTerms",
      terms: [{label:"label1", value:"value1", count:"#number"}, ...]
     }
</xd:pre>
            <xd:p>Sample input</xd:p>
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
        </xd:desc>
    </xd:doc>
    <xsl:output indent="no" method="text" media-type="application/json" encoding="UTF-8"/>
    <xsl:decimal-format name="european" decimal-separator="," grouping-separator="."/>
    <xd:doc>
        <xd:desc>Sort output by
            <xd:ul>
                <xd:li>s=size</xd:li>
                <xd:li>n=name</xd:li>
                <xd:li>t=time</xd:li>
                <xd:li>x=default</xd:li>
            </xd:ul>
        </xd:desc>
    </xd:doc>
    <xsl:param name="sort">x</xsl:param>
    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:param name="title" select="concat('scan: ', $scanClause )"/>
    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:param name="scanClause" select="/sru:scanResponse/sru:echoedScanRequest/sru:scanClause"/>
    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:param name="index" select="$scanClause"/>
    <xsl:template match="/">
        <xsl:variable name="countTerms" select="/sru:scanResponse/sru:extraResponseData/fcs:countTerms"/>
        <xsl:variable name="countReturned" select="count(/sru:scanResponse//sru:term)"/>
        <xsl:text>{"index":"</xsl:text>
        <xsl:value-of select="$scanClause"/>
        <xsl:text>", "indexSize":"</xsl:text>
        <xsl:value-of select="$countTerms"/>
        <xsl:text>", "countReturned":"</xsl:text>
        <xsl:value-of select="$countReturned"/>
        <xsl:text>", </xsl:text>
        <xsl:apply-templates select="/sru:scanResponse/sru:terms"/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    <xd:doc>
        <xd:desc>Converts a single term to json format
            <xd:p> sample data: </xd:p>
            <xd:pre>
        &lt;sru:term&gt;
        &lt;sru:value&gt;cartesian&lt;/sru:value&gt;
        &lt;sru:numberOfRecords&gt;35645&lt;/sru:numberOfRecords&gt;
        &lt;sru:displayTerm&gt;Carthesian&lt;/sru:displayTerm&gt;
        &lt;sru:extraTermData&gt;&lt;/sru:extraTermData&gt;
        &lt;/sru:term&gt;
</xd:pre>
        </xd:desc>
    </xd:doc>
    <xsl:template match="sru:terms">
        <xsl:text>
"terms": [
</xsl:text>
        <!-- flatten ( => dont go deeper ) -->
        <xsl:apply-templates select=".//sru:term"/>
        <xsl:text>]</xsl:text>
    </xsl:template>
    <xsl:template match="sru:term">
        <xsl:variable name="display">
            <xsl:choose>
                <xsl:when test="sru:displayTerm != ''">
                    <xsl:value-of select="sru:displayTerm"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="sru:value"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:text>{"value": "</xsl:text>
        <xsl:value-of select="translate(normalize-space(sru:value),'&#34;','')"/>
        <xsl:text>", </xsl:text>
        <xsl:text>"label": "</xsl:text>
        <xsl:value-of select="translate(normalize-space($display),'&#34;','')"/> | <xsl:value-of select="sru:numberOfRecords"/>
        <xsl:text>|", </xsl:text>
        <xsl:text>"count": "</xsl:text>
        <xsl:value-of select="sru:numberOfRecords"/>
        <xsl:text>"}</xsl:text>
        <xsl:if test="not(position()=last())">, </xsl:if>
        
        <!-- dont go deeper, because flattened <xsl:apply-templates select="sru:extraTermData/sru:terms/sru:term"/>-->
    </xsl:template>
</xsl:stylesheet>