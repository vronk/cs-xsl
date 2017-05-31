<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:zr="http://explain.z3950.org/dtd/2.0/"
    xmlns:utils="http://aac.ac.at/content_repository/utils"
    xmlns:sru="http://www.loc.gov/zing/srw/"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fcs="http://clarin.eu/fcs/1.0"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:exsl="http://exslt.org/common"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="1.0">
    
    <xd:doc scope="stylesheet">
        <xd:desc> generate a json object of the explain
            <xd:p>Output</xd:p>
            <xd:pre>
     {explain:"$scanClause", count:"$countIndexes",
      indexes: [{label:"label1", value:"value1", count:"#number"}, ...]            
     }
            </xd:pre>
            <xd:p>Sample Input</xd:p>
            <xd:pre>
                &lt;explain xsi:schemaLocation="http://explain.z3950.org/dtd/2.0/ file:/C:/Users/m/3lingua/corpus_shell/_repo2/corpus_shell/fcs/schemas/zeerex-2.0.xsd" authoritative="false" id="id1"&gt;
                    &lt;serverInfo protocol="SRU" version="1.2" transport="http"&gt;
                        &lt;host&gt;TODO: config:param-value($config, "base-url")&lt;/host&gt;
                        &lt;port&gt;80&lt;/port&gt;
                        &lt;database&gt;cr&lt;/database&gt;
                    &lt;/serverInfo&gt;
                    &lt;databaseInfo&gt;
                        &lt;title lang="en" primary="true"&gt;ICLTT Content Repository&lt;/title&gt;
                        &lt;description lang="en" primary="true"/&gt;
                        &lt;author/&gt;
                        &lt;contact/&gt;
                    &lt;/databaseInfo&gt;
                    &lt;metaInfo&gt;
                        &lt;dateModified&gt;TODO&lt;/dateModified&gt;
                    &lt;/metaInfo&gt;
                    &lt;indexInfo&gt;
                        &lt;set identifier="isocat.org/datcat" name="isocat"&gt;
                            &lt;title&gt;ISOcat data categories&lt;/title&gt;
                        &lt;/set&gt;
                        &lt;set identifier="clarin.eu/fcs" name="fcs"&gt;
                            &lt;title&gt;CLARIN - Federated Content Search&lt;/title&gt;
                        &lt;/set&gt;
                        &lt;!-- &lt;index search="true" scan="true" sort="false"&gt;
                            &lt;title lang="en"&gt;Resource&lt;/title&gt;
                            &lt;map&gt;
                            &lt;name set="fcs"&gt;resource&lt;/name&gt;
                            &lt;/map&gt;
                            &lt;/index&gt; --&gt;
                        &lt;index search="true" scan="true" sort="false"&gt;
                            &lt;title lang="en"&gt;ana&lt;/title&gt;
                            &lt;map&gt;
                                &lt;name set="fcs"&gt;ana&lt;/name&gt;
                            &lt;/map&gt;
                        &lt;/index&gt;
                        &lt;index search="true" scan="true" sort="false"&gt;
                            &lt;title lang="en"&gt;birth-date&lt;/title&gt;
                            &lt;map&gt;
                                &lt;name set="fcs"&gt;birth-date&lt;/name&gt;
                            &lt;/map&gt;
                        &lt;/index&gt;
                    &lt;/indexInfo&gt;
                &lt;/explain&gt;
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
    <!-- s=size|n=name|t=time|x=default -->
    <xsl:param name="title" select="concat('scan: ', $scanClause )"/>
    <xsl:decimal-format name="european" decimal-separator="," grouping-separator="."/>
    <xsl:param name="scanClause" select="/sru:scanResponse/sru:echoedScanRequest/sru:scanClause"/>
    <xsl:param name="index" select="$scanClause"/>
    <xsl:template match="/">
        <xsl:variable name="countIndexes" select="count(//zr:indexInfo/zr:index)"/>
        <xsl:text>{
    "explain":"explain",
</xsl:text>
<!--        <xsl:value-of select="$x-context"/>-->
        <xsl:text>    "countIndexes":"</xsl:text>
        <xsl:value-of select="$countIndexes"/>
        <xsl:text>", </xsl:text><!--"countReturned":"</xsl:text>
        <xsl:value-of select="$countReturned"/>
        <xsl:text>", </xsl:text>-->
        <xsl:apply-templates select="//zr:indexInfo"/>
        <xsl:if test="//zr:databaseInfo/zr:description[tei:teiHeader]">,</xsl:if>
        <xsl:apply-templates select="//zr:databaseInfo/zr:description[tei:teiHeader]"/>
        <xsl:text>
}
        </xsl:text>
    </xsl:template>
    <xd:doc>
        <xd:desc> Generate JSON for one indexInfo Item
            <xd:p>sample data:</xd:p>
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
    <xsl:template match="zr:indexInfo">
        <xsl:text>
    "context_sets": {</xsl:text>
        <xsl:apply-templates select="zr:set"/>
        <xsl:text>
    },</xsl:text>
        <xsl:text>
    "indexes": {</xsl:text>
        <xsl:apply-templates select="zr:index"/>
        <xsl:text>
    }</xsl:text>
    </xsl:template>
    <xsl:template match="zr:set">
        <xsl:text>
        "</xsl:text>
        <xsl:value-of select="@name"/>
        <xsl:text>": "</xsl:text>
        <xsl:value-of select="zr:title"/>
        <xsl:text>"</xsl:text>
        <xsl:if test="not(position()=last())">, </xsl:if>
    </xsl:template>
    
    <xsl:template match="zr:index">
        <xsl:text>
        "</xsl:text>
        <xsl:value-of select="zr:title"/>
        <xsl:text>": {"search": "</xsl:text>
        <xsl:value-of select="@search"/>
        <xsl:text>", </xsl:text>
        <xsl:text>"scan": "</xsl:text>
        <xsl:value-of select="@scan"/>
        <xsl:text>", </xsl:text>
        <xsl:text>"sort": "</xsl:text>
        <xsl:value-of select="@sort"/>
        <xsl:text>", </xsl:text>
        <xsl:text>"name": "</xsl:text>
        <xsl:value-of select=".//zr:name[@set='fcs']"/>
        <xsl:text>"}</xsl:text>
        <xsl:if test="not(position()=last())">, </xsl:if>
    </xsl:template>
    
    <xsl:template match="zr:description">
        <xsl:text>
    "description": {</xsl:text>
        <xsl:apply-templates select="//tei:titleStmt/tei:title"/>
        <xsl:if test="//tei:encodingDesc"><xsl:text>,
</xsl:text></xsl:if>
        <xsl:apply-templates select="//tei:encodingDesc"/><xsl:text> }</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:title">
        <xsl:text>
        "title": "</xsl:text><xsl:value-of select="text()"/>"      
    </xsl:template>
    
    <xsl:template match="tei:charDecl">
        <xsl:text>
        "encoding": {
            "countNonASCIIChars": "</xsl:text><xsl:value-of select="count(tei:char)"/><xsl:text>",
            "chars": {</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>
            }
        }</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:char">
        <xsl:text>
                "</xsl:text><xsl:value-of select="@xml:id"/><xsl:text>": {</xsl:text>
        <xsl:apply-templates select="tei:mapping"/>
        <xsl:text>
                }</xsl:text><xsl:if test="(position() + 1) &lt; last()">, </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:mapping">
        <xsl:text>
                    "</xsl:text><xsl:value-of select="@type"/><xsl:text>": "</xsl:text><xsl:value-of select="text()"/><xsl:text>"</xsl:text><xsl:if test="position() &lt; last()">, </xsl:if>
    </xsl:template>
</xsl:stylesheet>