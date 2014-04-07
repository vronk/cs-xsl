<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:aac="urn:general" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:sru="http://www.loc.gov/zing/srw/" xmlns:html="http://www.w3.org/1999/xhtml" xmlns:exist="http://exist.sourceforge.net/NS/exist" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" version="2.0" exclude-result-prefixes="xsl aac tei sru html exist xd">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>Stylesheet for formatting TEI-elements  in teiHeader inside a FCS/SRU-result.
For legacy reasons TEI-elements both with and without namespace (just local names) match.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <!-- some special elements retained in data, due to missing correspondencies in tei 
        if it will get more, we should move to separate file -->
    <xsl:template match="imprint | tei:imprint" mode="record-data">
        <div class="imprint">
            <xsl:value-of select="string-join(*,',')"/>
        </div>
    </xsl:template>
    <xsl:template match="msDesc| tei:msDesc" mode="record-data">
        <xsl:apply-templates mode="record-data"/>
    </xsl:template>
    <xsl:template match="msIdentifier| tei:msIdentifier" mode="record-data">
        <div class="msIdentifier">
            <xsl:value-of select="concat(repository, ' (Signatur ',  idno, ')')"/>
        </div>
    </xsl:template>
</xsl:stylesheet>