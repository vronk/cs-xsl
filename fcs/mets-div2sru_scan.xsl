<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sru="http://www.loc.gov/zing/srw/" xmlns:fcs="http://clarin.eu/fcs/1.0" xmlns:cr="http://aac.ac.at/content_repository" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:mets="http://www.loc.gov/METS/" version="2.0" exclude-result-prefixes="msxsl">
    <xsl:output method="xml" indent="yes"/>
    <xsl:param name="index-key">resource</xsl:param>
    <xsl:template match="/">
        <sru:scanResponse>
<!--            <xsl:copy-of select="."/>-->
            <sru:version>1.2</sru:version>
            <sru:terms>
                <xsl:apply-templates/>
            </sru:terms>
            <sru:extraResponseData>
                <fcs:countTerms level="top">
                    <xsl:value-of select="count(mets:div)"/>
                </fcs:countTerms>
                <fcs:countTerms level="total">
                    <xsl:value-of select="count(.//mets:div)"/>
                </fcs:countTerms>
            </sru:extraResponseData>
            <sru:echoedScanRequest>
                <sru:version>1.2</sru:version>
                <sru:scanClause>{$index-key}</sru:scanClause>
                <sru:responsePosition/>
                <sru:maximumTerms/>
            </sru:echoedScanRequest>
        </sru:scanResponse>
    </xsl:template>
    <xsl:template match="mets:structMap">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="mets:div">
        <sru:term>
            <sru:value><!--
                
                <xsl:value-of select="@ID"/>-->
                <xsl:choose>
                    <xsl:when test="@ID">
                        <xsl:value-of select="@ID"/>
                    </xsl:when>
                    <xsl:when test="@CONTENTIDS">
                        <xsl:value-of select="replace(@CONTENTIDS,'#','')"/>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </sru:value>
<!--                <sru:numberOfRecords><xsl:value-of select="count(map)" /></sru:numberOfRecords>-->
            <sru:displayTerm>
                <!-- very specific fix for stripping page prefix: 'S.' -->
                <xsl:value-of select="if (starts-with(@LABEL,'S.')) then substring-after(@LABEL,'S.') else @LABEL "/>
            </sru:displayTerm>
            <sru:extraTermData>
                <xsl:if test="@TYPE">
                    <cr:type>
                        <xsl:value-of select="@TYPE"/>
                    </cr:type>
                </xsl:if>
                <xsl:if test="count(mets:div) > 0">
                    <sru:terms>
                        <xsl:apply-templates select="mets:div"/>
                    </sru:terms>
                    <fcs:countTerms>
                        <xsl:value-of select="count(mets:div)"/>
                    </fcs:countTerms>
                </xsl:if>
                <fcs:position>
                    <xsl:value-of select="count(preceding-sibling::mets:div)+1"/>
                </fcs:position>               
            </sru:extraTermData>
        </sru:term>
    </xsl:template>
</xsl:stylesheet>