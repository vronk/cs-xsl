<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:sru="http://www.loc.gov/zing/srw/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fcs="http://clarin.eu/fcs/1.0" xmlns:kwic="http://clarin.eu/fcs/1.0/kwic" xmlns:exist="http://exist.sourceforge.net/NS/exist" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" version="2.0" exclude-result-prefixes="kwic xsl tei sru xs fcs exist xd">
    <xsl:import href="data2view_v1.xsl"/>
    <xd:doc scope="stylesheet">
        <xd:desc>Provides more specific handling of sru-result-set recordData
            <xd:p>History:
                <xd:ul>
                    <xd:li>2013-08-26: created by: "os": split additional element data display using XSL 2.0 funtionality</xd:li>
                </xd:ul>
            </xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    <xd:doc>
        <xd:desc>
            <xd:p>generic template, invoked link processing and places attributes of the element 
                (TODO: !and its parents!)
            in a separate hidden structure - viewable via mouseover (given appropriate css and js is supplied)</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="inline">
        <xsl:param name="additional-style"/>
        <xsl:param name="descendants-to-ignore" as="xs:string*"/>
        <xsl:param name="insertTrailingBlank" as="xs:boolean?"/>
        <xsl:variable name="elem-link">
            <xsl:call-template name="elem-link"/>
        </xsl:variable>
        <xsl:variable name="inline-content">
            <xsl:for-each select="node()">
<!--                   DEBUG:<xsl:value-of select="name()"></xsl:value-of>-->
                <xsl:choose>
<!--                Handled like a tei: tag so don't create an infinite loop. Check exist:match match before changing this!    
                        <xsl:when test="parent::exist:match">
                        <xsl:apply-templates select="parent::exist:match" mode="record-data"/>
                    </xsl:when>-->
                    <xsl:when test="self::text()">
                        <xsl:value-of select="."/>
                        <xsl:if test="$insertTrailingBlank">
                            <xsl:text xml:space="preserve"> </xsl:text>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="." mode="record-data">
                            <xsl:with-param name="insertTrailingBlank" select="$insertTrailingBlank"/>
                        </xsl:apply-templates>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="class">
            <!--<xsl:for-each select="distinct-values((descendant-or-self::*/name(), data(descendant-or-self::*/@type),  data(descendant-or-self::*/@subtype)))">
                <xsl:value-of select=".[. != $descendants-to-ignore]"/>
                <xsl:text> </xsl:text>
            </xsl:for-each>-->
            <xsl:value-of select="string-join((local-name(.),@type,@subtype),' ')"/>
        </xsl:variable>
        <xsl:variable name="inline-elem">
            <xsl:choose>
                <xsl:when test="not($elem-link='')">
                    <a href="{$elem-link}">
                        <span class="{$class}">
                            <xsl:if test="$additional-style">
                                <xsl:attribute name="style">
                                    <xsl:call-template name="rend-color-as-html-style">
                                        <xsl:with-param name="rend-text" select="$additional-style"/>
                                    </xsl:call-template>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:sequence select="$inline-content"/>
                        </span>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <span class="{$class}">
                        <xsl:attribute name="class">
                            <xsl:value-of select="$class"/>
                        </xsl:attribute>
                        <xsl:if test="$additional-style">
                            <xsl:attribute name="style">
                                <xsl:call-template name="rend-color-as-html-style">
                                    <xsl:with-param name="rend-text" select="$additional-style"/>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:sequence select="$inline-content"/>
                    </span>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!--<span class="inline-wrap">
            <!-\- only display element's own attributes -\->
            <xsl:if test="@*">
                <span class="attributes" style="display:none;">
                    <table>
<!-\-                        <xsl:for-each-group select="descendant-or-self::*" group-by="name()">-\->
                            <tr>
                                <td colspan="2">
                                    <xsl:value-of select="name()"/>
                                </td>
                            </tr>
                                <xsl:for-each select="@*">
                                                    <tr>
                                                        <td class="label">
                                                            <xsl:value-of select="name()"/>
                                                        </td>
                                                        <td class="value">
                                                            <xsl:value-of select="."/>
                                                        </td>
                                                    </tr>
                               </xsl:for-each>
                        
                    </table>
                </span>
            </xsl:if> 
            <xsl:sequence select="$inline-elem"/>
            </span>-->
        <xsl:sequence select="$inline-elem"/>
    </xsl:template>
    
    <!-- versioned going top-down (collecting the children of given element)
    <xsl:template name="inline">
        <xsl:variable name="elem-link">
            <xsl:call-template name="elem-link"/>
        </xsl:variable>
        <xsl:variable name="inline-content">
            <!-\-<xsl:choose>
                <xsl:when test="*">
                    <xsl:for-each select="*" >
                    <xsl:apply-templates select="*" mode="record-data"></xsl:apply-templates>
                     </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>-\->                    
            <!-\-            <xsl:value-of select="."/>-\->            
            <!-\- umständliche lösung to get spaces between children elements -\->
            <xsl:for-each select=".//text()">
                <!-\-<xsl:value-of select="."/>
                            <xsl:text> </xsl:text>-\->
                <xsl:choose>
                    <xsl:when test="parent::exist:match">
                        <!-\-                        <xsl:value-of select="name(.)"/>-\->
                        <xsl:apply-templates select="parent::exist:match" mode="record-data"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="."/>
                        <xsl:text> </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>        
            <!-\-    </xsl:otherwise>
            </xsl:choose>-\->
        </xsl:variable>
        <xsl:variable name="class">
            <xsl:for-each select="distinct-values(descendant-or-self::*/name())">
                <xsl:value-of select="."/>
                <xsl:text> </xsl:text>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="inline-elem">
            <xsl:choose>
                <xsl:when test="not($elem-link='')">
                    <a href="{$elem-link}">
                        <span class="{$class}">
                            <xsl:copy-of select="$inline-content"/>
                        </span>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <span class="{$class}">
                        <xsl:copy-of select="$inline-content"/>
                    </span>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <span class="inline-wrap">
            <xsl:if test="descendant-or-self::*/@*">
                <span class="attributes" style="display:none;">
                    <table>
                        <xsl:for-each-group select="descendant-or-self::*" group-by="name()">
                            <tr>
                                <td colspan="2">
                                    <xsl:value-of select="name()"/>
                                </td>
                            </tr>
                            
                            <!-\-                        <xsl:apply-templates select="@*" mode="format-attr"/>-\->
                            <tr>
                                <td>
                                    <xsl:for-each select="current-group()">
                                        <xsl:if test="@*">
                                            <table style="float:left">
                                                <xsl:for-each select="@*">
                                                    <tr>
                                                        <td class="label">
                                                            <xsl:value-of select="name()"/>
                                                        </td>
                                                        <td class="value">
                                                            <xsl:value-of select="."/>
                                                        </td>
                                                    </tr>
                                                </xsl:for-each>
                                            </table>
                                        </xsl:if>
                                    </xsl:for-each>
                                </td>
                            </tr>
                        </xsl:for-each-group>
                    </table>
                </span>
            </xsl:if>
            <xsl:copy-of select="$inline-elem"/>
        </span>
    </xsl:template> -->
</xsl:stylesheet>