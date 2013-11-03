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
                &lt;explain xsi:schemaLocation="http://explain.z3950.org/dtd/2.0/ file:/C:/Users/m/3lingua/corpus_shell/_repo2/corpus_shell/fcs/schemas/zeerex-2.0.xsd" authoritative="false" id="id1">
                    &lt;serverInfo protocol="SRU" version="1.2" transport="http">
                        &lt;host>TODO: config:param-value($config, "base-url")&lt;/host>
                        &lt;port>80&lt;/port>
                        &lt;database>cr&lt;/database>
                    &lt;/serverInfo>
                    &lt;databaseInfo>
                        &lt;title lang="en" primary="true">ICLTT Content Repository&lt;/title>
                        &lt;description lang="en" primary="true"/>
                        &lt;author/>
                        &lt;contact/>
                    &lt;/databaseInfo>
                    &lt;metaInfo>
                        &lt;dateModified>TODO&lt;/dateModified>
                    &lt;/metaInfo>
                    &lt;indexInfo>
                        &lt;set identifier="isocat.org/datcat" name="isocat">
                            &lt;title>ISOcat data categories&lt;/title>
                        &lt;/set>
                        &lt;set identifier="clarin.eu/fcs" name="fcs">
                            &lt;title>CLARIN - Federated Content Search&lt;/title>
                        &lt;/set>
                        &lt;!-- &lt;index search="true" scan="true" sort="false">
                            &lt;title lang="en">Resource&lt;/title>
                            &lt;map>
                            &lt;name set="fcs">resource&lt;/name>
                            &lt;/map>
                            &lt;/index> -->
                        &lt;index search="true" scan="true" sort="false">
                            &lt;title lang="en">ana&lt;/title>
                            &lt;map>
                                &lt;name set="fcs">ana&lt;/name>
                            &lt;/map>
                        &lt;/index>
                        &lt;index search="true" scan="true" sort="false">
                            &lt;title lang="en">birth-date&lt;/title>
                            &lt;map>
                                &lt;name set="fcs">birth-date&lt;/name>
                            &lt;/map>
                        &lt;/index>
                    &lt;/indexInfo>
                &lt;/explain>
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
    <xsl:template match="/">
        <xsl:variable name="countIndexes" select="count(//zr:indexInfo/zr:index)"/>
        <xsl:text>{"explain":"explain",</xsl:text>
<!--        <xsl:value-of select="$x-context"/>-->
        <xsl:text> "countIndexes":"</xsl:text>
        <xsl:value-of select="$countIndexes"/>
        <xsl:text>", </xsl:text><!--"countReturned":"</xsl:text>
        <xsl:value-of select="$countReturned"/>
        <xsl:text>", </xsl:text>-->
        <xsl:apply-templates select="//zr:indexInfo"/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    
    <xd:doc>
        <xd:desc> Generate JSON for one indexInfo Item
            <xd:p>sample data:</xd:p>
            <xd:pre>
            &lt;sru:term>
                &lt;sru:value>cartesian&lt;/sru:value>
                &lt;sru:numberOfRecords>35645&lt;/sru:numberOfRecords>
                &lt;sru:displayTerm>Carthesian&lt;/sru:displayTerm>
                &lt;sru:extraTermData>&lt;/sru:extraTermData>
            &lt;/sru:term>
            </xd:pre>
        </xd:desc>
    </xd:doc>    
    <xsl:template match="zr:indexInfo">
        <xsl:text>
"context_sets": {
</xsl:text>
        <xsl:apply-templates select="zr:set"/>
        <xsl:text>},</xsl:text>
        <xsl:text>
"indexes": {
</xsl:text>
        <xsl:apply-templates select="zr:index"/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    <xsl:template match="zr:set">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@name"/>
        <xsl:text>": "</xsl:text>
        <xsl:value-of select="zr:title"/>
        <xsl:text>"</xsl:text>
        <xsl:if test="not(position()=last())">, </xsl:if>
    </xsl:template>
    <xsl:template match="zr:index">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="zr:title"/>
        <xsl:text>": {"search": "</xsl:text>
        <xsl:value-of select="@search"/>
        <xsl:text>", </xsl:text>
        <xsl:text>"scan": "</xsl:text>
        <xsl:value-of select="@scan"/>
        <xsl:text>", </xsl:text>
        <xsl:text>"sort": "</xsl:text>
        <xsl:value-of select="@sort"/>
        <xsl:text>"}</xsl:text>
        <xsl:if test="not(position()=last())">, </xsl:if>
        
        <!--<xsl:text>{"title": "</xsl:text>
        <xsl:value-of select="translate(sru:value,'"','')"/>
        <xsl:text>", </xsl:text>
        <xsl:text>"label": "</xsl:text>
        <xsl:value-of select="translate((sru:displayTerm, sru:value)[1],'"','')"/> |<xsl:value-of select="sru:numberOfRecords"/>
        <xsl:text>|", </xsl:text>
        <xsl:text>"count": "</xsl:text>
        <xsl:value-of select="sru:numberOfRecords"/>
        <xsl:text>"}</xsl:text>
        <xsl:if test="not(position()=last())">, </xsl:if>
        <xsl:apply-templates select="sru:extraTermData/sru:terms/sru:term"/>-->
    </xsl:template>
</xsl:stylesheet>