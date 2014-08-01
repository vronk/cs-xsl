<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:aac="urn:general" xmlns:cmd="http://www.clarin.eu/cmd/" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:sru="http://www.loc.gov/zing/srw/" xmlns:html="http://www.w3.org/1999/xhtml" xmlns:exist="http://exist.sourceforge.net/NS/exist" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" version="2.0" exclude-result-prefixes="xsl aac tei sru html exist xd">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>Stylesheet for formatting TEI-elements  in teiHeader inside a FCS/SRU-result.</xd:p>
            <xd:p>For legacy reasons TEI-elements both with and without namespace (just local names) match.
Also "tei"-elements in CMD namespace to cover for teiHeader CMDI-Profile </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="imprint | tei:imprint | cmd:imprint" mode="record-data">
        <div class="imprint">
            <xsl:value-of select="string-join(*,',')"/>
        </div>
    </xsl:template>
    <xsl:template match="msDesc| tei:msDesc | cmd:msDesc" mode="record-data">
        <xsl:apply-templates mode="record-data"/>
    </xsl:template>
    <xsl:template match="msIdentifier| tei:msIdentifier | cmd:msIdentifier" mode="record-data">
        <div class="msIdentifier">
            <xsl:value-of select="concat((repository, tei:repository, cmd:repository)[1], ' (Signatur ',  (idno,tei:idno,cmd:idno)[1], ')')"/>
        </div>
    </xsl:template>
    <xsl:template match="bibl | tei:bibl | cmd:bibl" mode="record-data">
<!--        <xsl:call-template name="inline"/>-->
        <xsl:apply-templates mode="record-data"/>
    </xsl:template>
</xsl:stylesheet>