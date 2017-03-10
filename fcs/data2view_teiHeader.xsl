<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:sru="http://www.loc.gov/zing/srw/"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:cmd="http://www.clarin.eu/cmd/"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:exist="http://exist.sourceforge.net/NS/exist"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    version="1.0" exclude-result-prefixes="xs xsl tei sru cmd html exist xd">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>Stylesheet for formatting TEI-elements  in teiHeader inside a FCS/SRU-result.</xd:p>
            <xd:p>For legacy reasons TEI-elements both with and without namespace (just local names) match.
Also "tei"-elements in CMD namespace to cover for teiHeader CMDI-Profile </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="imprint[ancestor::teiHeader] | tei:imprint[ancestor::tei:teiHeader] | cmd:imprint" mode="record-data">
        <div class="imprint">
            <xsl:call-template name="string-join">
                <xsl:with-param name="nodes-to-join" select="./*"/>
                <xsl:with-param name="join-with">, </xsl:with-param>
            </xsl:call-template>
        </div>
    </xsl:template>
    <xsl:template match="msDesc| tei:msDesc | cmd:msDesc" mode="record-data">
        <xsl:apply-templates mode="record-data"/>
    </xsl:template>
    <xsl:template match="msIdentifier| tei:msIdentifier | cmd:msIdentifier" mode="record-data">
        <xsl:variable name="surrogates-ptr" select="(../additional/surrogates/ptr/@target|
                                                     ../tei:additional/tei:surrogates/tei:ptr/@target|
                                                     ../cmd:additional/cmd:surrogates/cmd:ptr/@target)[1]"/>
        <div class="msIdentifier">
            <xsl:value-of select="(repository|tei:repository|cmd:repository)[1]"/>
            <xsl:text> (Signatur </xsl:text>
            <xsl:choose>
                <xsl:when test="boolean($surrogates-ptr)">
                    <a href="{$surrogates-ptr}">
                        <xsl:value-of select="(idno|tei:idno|cmd:idno)[1]"/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="(idno|tei:idno|cmd:idno)[1]"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>)</xsl:text>
        </div>
    </xsl:template>
    <xsl:template match="bibl | tei:bibl | cmd:bibl" mode="record-data"><!--        <xsl:call-template name="inline"/>-->
        <xsl:apply-templates mode="record-data"/>
    </xsl:template>
    <xsl:template match="html:*" mode="record-data">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="msDesc/additional | tei:msDesc/tei:additional | cmd:msDesc/cmd:additional" mode="record-data"/>
</xsl:stylesheet>