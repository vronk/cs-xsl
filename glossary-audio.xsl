<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:exsl="http://exslt.org/common"
    xmlns:sru="http://www.loc.gov/zing/srw/"
    xmlns:fcs="http://clarin.eu/fcs/1.0"
    xmlns:xspf="https://xspf.org/ns/0/"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xsl exsl xd tei sru fcs xspf"
    version="1.0">
    <xsl:import href="glossary.xsl"/>
    <xsl:output method="html" media-type="text/html" indent="yes" encoding="UTF-8" doctype-system="about:legacy-compat"/>
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Nov 10, 2014</xd:p>
            <xd:p><xd:b>Author:</xd:b> simar</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:template name="callback-header2">
        <style type="text/css">
            .xsl-audio.xsl-outer {
            <xsl:value-of select="concat('background-image: url(', $scripts_url, 'style/base/images/ui-icons_2e83ff_256x240.png)/*{iconsContent}*/;')"/>
            }
        </style>
        <style type="text/css">
            .xsl-audio.xsl-outer {
                display: inline-block;
                background-position: -48px -192px;
                width: 16px;
                height: 16px;
                margin-right: 0.5em;
                margin-left: 0.5em;
                position: relative;
             }
            .xsl-audio.xsl-outer:hover .xsl-audio.xsl-inner,
            .xsl-audio.xsl-inner:hover,
            .xsl-audio.xsl-inner:hover:active {display: block}
            .xsl-audio.xsl-inner {
                display: none;
                position: absolute;
                top: -8px;
                left: 14px;
            }        
        </style>
    </xsl:template>
    
    <xsl:variable name="audiolist" select="exsl:node-set(document('http://localhost/static/audio/words/aeb_eng_001__v001/Omar_Siam/list.xspf'))"/>
    
    <xsl:template match="tei:orth" mode="record-data">
        <xsl:apply-imports/>
        <xsl:variable name="audioname">
            <xsl:apply-templates mode="record-data"/>
        </xsl:variable>
        <xsl:variable name="audiofile">
            <xsl:value-of select="$audiolist/xspf:playlist/xspf:trackList/xspf:track[xspf:title=$audioname]/xspf:location"/>
        </xsl:variable>
        <xsl:if test="$audiofile != ''">
        <span class="xsl-audio xsl-outer tei-orth {@xml:lang}">
            <div class="xsl-audio xsl-inner">
            <audio controls="controls" preload="none">
                <source src="{$audiofile}" type="audio/mp4"/>
                <a href="{$audiofile}">Download</a>
            </audio>
            </div>
        </span>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>