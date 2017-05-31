<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cmd="http://www.clarin.eu/cmd/" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" version="2.0" exclude-result-prefixes="#all">
    <xsl:import href="../commons_v2.xsl"/>
    <xsl:import href="../fcs/data2view_v2.xsl"/>
    <xd:doc scope="stylesheet">
        <xd:desc> generate a custom html-view for CMDI-metadata (based on the generic XML-rendering)
            <xd:p>History: 
                <xd:ul>
                    <xd:li>2013-08-27: created by:"os": split XSL 2.0 code</xd:li>
                </xd:ul>
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:output method="xhtml" indent="yes"/>
    <xsl:variable name="title">
        <xsl:value-of select="(.//cmd:title,.//cmd:Title,.//cmd:Name,.//cmd:ResourceName)[1]"/>
    </xsl:variable>
    <xsl:template name="continue-root">
        <div>
            <xsl:apply-templates mode="record-data"/>
        </div>
    </xsl:template>
    <xsl:template match="cmd:CMD" mode="record-data">
        <div class="cmd-record">
            <xsl:apply-templates select="cmd:Header" mode="record-data">
                <xsl:with-param name="strict" select="true()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="cmd:Resources/cmd:ResourceProxyList" mode="record-data">
                <xsl:with-param name="strict" select="true()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="cmd:Resources/cmd:IsPartOfList" mode="record-data">
                <xsl:with-param name="strict" select="true()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="cmd:Components/*" mode="record-data">
                <xsl:with-param name="strict" select="true()"/>
            </xsl:apply-templates>
        </div>
    </xsl:template>
</xsl:stylesheet>