<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:exsl="http://exslt.org/common"
    xmlns:str="http://exslt.org/strings"
    xmlns:func="http://exslt.org/functions"
    xmlns:this="urn:general:encode-for-uri"
    exclude-result-prefixes="xd func str this"
    extension-element-prefixes="func"
    version="1.0">
    <xd:doc scope="stylesheet">
        <xd:desc>Cotains code that provides encoding for uri usage which works on Saxon 6.5.5 and libxslt/PHP
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <func:function name="this:encode-for-uri">
        <xsl:param name="aStr" />
        <xsl:param name="escapeAll"/>
        <!-- Note that libexslt doesn't provide/understand anything else as encoding! -->
        <xsl:param name="encoding" select="'UTF-8'"/>
        <xsl:variable name="res">
        <xsl:choose>
            <xsl:when test="function-available('str:encode-uri')">
                <!-- libxslt/PHP implements this -->
                <xsl:value-of select="str:encode-uri($aStr, $escapeAll, $encoding)"/>                              
            </xsl:when>
            <xsl:otherwise>
                <!-- Saxon 6.5.5 does not implement str:encode-uri but can call arbitary static Java methods. This uses + instead of %20 -->
                <xsl:variable name="enc" select="urlenc:encode($aStr, $encoding)"
                    xmlns:urlenc="java:java.net.URLEncoder"/>
                <xsl:call-template name="string-replace-all">
                    <xsl:with-param name="text" select="$enc"/>
                    <xsl:with-param name="replace" select="'+'"/>
                    <xsl:with-param name="with" select="'%20'"/>    
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        </xsl:variable>
        <func:result select="$res"/>
    </func:function>
    
    <xsl:template name="string-replace-all">
        <xsl:param name="text"/>
        <xsl:param name="replace"/>
        <xsl:param name="with"/>
        <xsl:choose>
            <xsl:when test="contains($text,$replace)">
                <xsl:value-of select="substring-before($text,$replace)"/>
                <xsl:value-of select="$with"/>
                <xsl:call-template name="replace-string">
                    <xsl:with-param name="text"
                        select="substring-after($text,$replace)"/>
                    <xsl:with-param name="replace" select="$replace"/>
                    <xsl:with-param name="with" select="$with"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>