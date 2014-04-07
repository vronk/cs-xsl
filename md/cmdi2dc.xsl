<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcr="http://www.isocat.org/ns/dcr" xmlns="http://purl.org/dc/elements/1.1/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cmd="http://www.clarin.eu/cmd/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>
                <xd:b>Created on:</xd:b> Mar 25, 2014</xd:p>
            <xd:p>
                <xd:b>Author:</xd:b> Daniel Schopper</xd:p>
            <xd:p>Converts CMDI to Dublin Core</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:output method="xml"/>
    <xsl:param name="fedora-pid-namespace-prefix"/>
    <xsl:variable name="MdProfile" select="/cmd:CMD/cmd:Header[1]/cmd:MdProfile[1]"/>
    <xsl:variable name="cmd:CMD" select="/cmd:CMD[cmd:Header/cmd:MdProfile = $MdProfile]"/>
    <!--<xsl:variable name="dc:creator">
        <xsl:value-of select="$cmd:CMD/cmd:Components[1]/cmd:collection[1]/cmd:CollectionInfo[1]/cmd:Owner[1]"/>
        <xsl:value-of select="$cmd:CMD/cmd:Components/cmd:teiHeader[1]/cmd:fileDesc[1]/cmd:publicationStmt[1]/cmd:publisher[1]"/>
    </xsl:variable>
    <xsl:variable name="dc:title">
        <xsl:value-of select="$cmd:CMD/cmd:Components[1]/cmd:collection[1]/cmd:CollectionInfo[1]/cmd:Title[1]"/>
        <xsl:value-of select="$cmd:CMD/cmd:Components[1]/cmd:teiHeader[1]/cmd:fileDesc[1]/cmd:titleStmt[1]/cmd:title[1]"/>
    </xsl:variable>
    <xsl:variable name="dc:identifier">
        <xsl:value-of select="$cmd:CMD/cmd:Resources[1]/cmd:ResourceProxyList[1]/cmd:ResourceProxy[cmd:ResourceType='LandingPage']/@id"/>
        <xsl:value-of select="$cmd:CMD/cmd:Resources[1]/cmd:ResourceProxyList[1]/cmd:ResourceProxy[cmd:ResourceType='Resource']/@id"/>
    </xsl:variable>-->
    <xsl:variable name="dc:creator" select="(.//cmd:Owner, .//cmd:creator, .//cmd:publisher, .//cmd:Contact/cmd:Person)[1]"/>
    <xsl:variable name="dc:title" select="(.//cmd:Title, .//cmd:ResourceTitle, .//cmd:title, .//cmd:ResourceName, .//cmd:Name)[1]"/>
    <xsl:variable name="dc:identifier" select="(.//cmd:Resources[1]/cmd:ResourceProxyList[1]/cmd:ResourceProxy[cmd:ResourceType=('LandingPage','Resource')]/@id)[1]"/>
    <xsl:variable name="dc:date" select="(.//cmd:LastUpdate, .//date)[1]"/>
    <!--<oai_dc:dc xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd">-->
    <xsl:template match="/">
        <oai_dc:dc xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/">
            <title>
                <xsl:value-of select="$dc:title"/>
            </title>
            <identifier>
                <xsl:value-of select="concat(if ($fedora-pid-namespace-prefix!='') then concat(replace($fedora-pid-namespace-prefix,':$',''),':') else (),$dc:identifier)"/>
            </identifier>
            <creator>
                <xsl:value-of select="$dc:creator"/>
            </creator>
            <date>
                <xsl:value-of select="$dc:date"/>
            </date>
        </oai_dc:dc>
    </xsl:template>
</xsl:stylesheet>