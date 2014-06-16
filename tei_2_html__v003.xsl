<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:egXML="http://www.tei-c.org/ns/Examples" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:fcs="http://clarin.eu/fcs/1.0" version="1.0">
    <xsl:output method="html" indent="no" encoding="UTF-8"/>

    <xsl:template match="/">
        <html>
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
                <style type="text/css">
                    h1{
                        border:1px solid rgb(0, 0, 198);
                        background:rgb(147, 147, 147);
                        padding-left:5px;
                        padding-bottom:2px;
                        color:rgb(0, 0, 206);
                    }
                    h2{
                        border:1px solid rgb(0, 0, 206);
                        background:rgb(192, 192, 192);
                        padding-left:5px;
                        padding-bottom:2px;
                        color:rgb(0, 0, 206);
                    }
                    h3{
                        border:1px solid rgb(0, 84, 168);
                        background:rgb(218, 218, 218);
                        padding-left:5px;
                        padding-bottom:2px;
                        margin-left:20px;
                        color:rgb(0, 0, 206);
                    }
                    p{
                        margin-left:20px;
                    }
                    
                    .tocEntry{
                        margin: 0;
                    }
                    
                    table{
                        margin-left:20px;
                        border-collapse:collapse;
                    }
                    td{
                        border:1px solid black;
                        background:rgb(245, 245, 245);
                        vertical-align:middle;
                        padding-left:3px;
                        padding-right:3px;
                    }
                    td.tdLabel{
                        background:rgb(218, 218, 218);
                    }
                    
                    .aGoTocontents{
                        font-size:8pt;
                    }
                    .aH2Contents{
                        text-decoration:none;
                        border:1px dotted black;
                        width:400px;
                        margin-left:20px;
                        display:block;
                        font-weight:bold;
                        padding-left:5px;
                    }
                    .aH3Contents{
                        text-decoration:none;
                        border:1px dotted black;
                        width:380px;
                        margin-left:40px;
                        display:block;
                        padding-left:5px;
                    }
                    .preBox{
                        border:1px solid black;
                        padding-left:5px;
                        background:rgb(221, 221, 221);
                        margin-left:20px;
			   white-space: pre;
                    }
                    .spAttrName{
                        color:rgb(0, 102, 0);
                        font-weight:bold;
                    }
                    .spEquals{
                        color:blue
                    }
                    .spQuotes{
                        color:rgb(79, 0, 39);
                    }
                    .spValue{
                        color:rgb(0, 0, 160);
                    }
                    .spRed{
                        color:red;
                    }</style>
            </head>

            <body>
                <div style="display: none;" class="result-header" data-numberofrecords="1"></div>
                <h1>
                    <xsl:value-of select="//tei:div1/tei:head"/>
                </h1>
                <p>
                    <i>
                        <xsl:for-each select="//tei:teiHeader/tei:fileDesc/tei:author">
                            <xsl:if test="position()&gt;1">, </xsl:if>
                            <xsl:value-of select="."/>
                        </xsl:for-each>
                    </i>
                </p>
                <p>
                    <i>
                        <xsl:value-of select="//tei:publicationStmt/tei:pubPlace"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="//tei:publicationStmt/tei:date"/>
                    </i>
                </p>

                <h2 id="contents">Contents</h2>
                <xsl:for-each select="//tei:div2 | //tei:div3">
                  <p class="tocEntry">
                    <xsl:choose>
                        <xsl:when test="local-name()='div2'">
                            <a class="aH2Contents">
                                <xsl:attribute name="href">#<xsl:value-of select="@xml:id"/></xsl:attribute>
                                <xsl:value-of select="count(preceding::tei:div2)+1"/>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="./tei:head"/>
                            </a>
                        </xsl:when>
                        <xsl:when test="local-name()='div3'">
                            <a class="aH3Contents"><xsl:attribute name="href">#<xsl:value-of select="@xml:id"/></xsl:attribute><xsl:value-of select="count(preceding::tei:div2)+1"/>.<xsl:value-of select="count(preceding-sibling::tei:div3)+1"/><xsl:text> </xsl:text><xsl:value-of select="./tei:head"/></a>
                        </xsl:when>
                    </xsl:choose>
                  </p>
                </xsl:for-each>
                <div class="dvContents" id="#contents"> </div>
                <xsl:apply-templates select="//fcs:DataView[@type = 'full']/@* | //fcs:DataView[@type = 'full']/node()"/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="tei:author | tei:bibl | tei:biblScope | tei:body | tei:cit | tei:date | tei:def | tei:entry | tei:etym | tei:form | tei:gram | tei:gramGrp | tei:lang | tei:mentioned | tei:orth | tei:p | tei:quote | tei:sense | tei:TEI | tei:teiHeader| tei:text | tei:usg">
        <p><xsl:apply-templates/></p>
    </xsl:template>

    <xsl:strip-space elements="egXML:*"/>
    
    <xsl:template name="generateWhiteSpace">
        <xsl:param name="c" select="0"/>
        <xsl:choose>
            <xsl:when test="$c &lt;= 1">
                <xsl:value-of select="''"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="generateWhiteSpace">
                    <xsl:with-param name="c" select="$c - 1"/>
                </xsl:call-template>
                <xsl:value-of select="'    '"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="*" mode="egXML">
        <span>
            <xsl:call-template name="generateWhiteSpace">
                <xsl:with-param name="c" select="count(ancestor::*) - count(ancestor::egXML:egXML/ancestor::*)"/>
            </xsl:call-template>
<!--            <xsl:if test="preceding-sibling::node()[1]/self::*">
                <xsl:text>
 </xsl:text>
            </xsl:if>-->
            <span class="spRed"><xsl:value-of select="concat('&lt;',local-name())"/></span>
            <xsl:apply-templates select="@*" mode="egXML"/>
            <xsl:choose>
                <xsl:when test="node()">
                    <span class="spRed"><xsl:text>&gt;
</xsl:text></span>
                    <xsl:apply-templates mode="egXML"/>
                    <xsl:call-template name="generateWhiteSpace">
                        <xsl:with-param name="c" select="count(ancestor::*) - count(ancestor::egXML:egXML/ancestor::*)"/>
                    </xsl:call-template>
                    <span class="spRed"><xsl:text>&lt;/</xsl:text><xsl:value-of select="local-name()"/><xsl:text>&gt;
</xsl:text></span>
                </xsl:when>
                <xsl:otherwise>
                    <span class="spRed"><xsl:text>/&gt;
</xsl:text></span>
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:template>

    <xsl:template match="@*" mode="egXML">
        <span>
            <xsl:text> </xsl:text>
            <span class="spAttrName"><xsl:value-of select="local-name()"/></span><span class="spEquals">=</span><span class="spQuotes">"</span><span class="spValue"><xsl:value-of select="."/></span><span class="spQuotes">"</span>
        </span>
    </xsl:template>

    <xsl:template match="text()" mode="egXML">
        <xsl:call-template name="generateWhiteSpace">
            <xsl:with-param name="c" select="count(ancestor::*) - count(ancestor::egXML:egXML/ancestor::*) - 1"/>
        </xsl:call-template><xsl:value-of select="normalize-space(.)"/><xsl:text>
</xsl:text>
    </xsl:template>

    <xsl:template match="egXML:egXML">
        <pre class="preBox"><xsl:apply-templates select="node()" mode="egXML"/></pre>
    </xsl:template>



    <xsl:template match="@*">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>

    <xsl:template match="tei:ptr">
        <xsl:choose>
            <xsl:when test="ancestor::egXML">
                <span class="spRed">&lt;ptr</span>
                <xsl:text> </xsl:text>
                <xsl:for-each select="@*">
                    <span class="spAttrName">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="name()"/>
                        <span class="spEquals">=</span><span class="spQuotes">"</span>
                        <span class="spValue">
                            <xsl:value-of select="."/>
                        </span>
                        <span class="spQuotes">"</span>
                    </span>
                </xsl:for-each>
                <span class="spRed">/&gt;</span>
            </xsl:when>
            <xsl:otherwise>
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="@target"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:cell">
        <xsl:choose>
            <xsl:when test="@xml:lang='ar-x-DMG'">
                <td style="font-style:italic">
                    <xsl:apply-templates/>
                </td>
            </xsl:when>
            <xsl:when test="@xml:lang='ar'">
                <td style="direction:rtl">
                    <xsl:apply-templates/>
                </td>
            </xsl:when>
            <xsl:otherwise>
                <td>
                    <xsl:apply-templates/>
                </td>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:row">
        <tr>
            <xsl:apply-templates/>
        </tr>
    </xsl:template>
    <xsl:template match="tei:table">
        <xsl:choose>
            <xsl:when test="parent::tei:div[@type='verbParadigm']">
                <table>
                    <tr>
                        <td class="tdLabel"/>
                        <td class="tdLabel">Sg.</td>
                        <td class="tdLabel">Pl.</td>
                    </tr>
                    <tr>
                        <td class="tdLabel">1.</td>
                        <td>
                            <i>
                                <xsl:value-of select="tei:row/tei:cell[@role='1s']"/>
                            </i>
                        </td>
                        <td>
                            <i>
                                <xsl:value-of select="tei:row/tei:cell[@role='1p']"/>
                            </i>
                        </td>
                    </tr>

                    <tr>
                        <td class="tdLabel">2. m.</td>
                        <td>
                            <i>
                                <xsl:value-of select="tei:row/tei:cell[@role='2sm']"/>
                            </i>
                        </td>
                        <td rowspan="2">
                            <i>
                                <xsl:value-of select="tei:row/tei:cell[@role='2p']"/>
                            </i>
                        </td>
                    </tr>

                    <tr>
                        <td class="tdLabel">2. f.</td>
                        <td>
                            <i>
                                <xsl:value-of select="tei:row/tei:cell[@role='2sf']"/>
                            </i>
                        </td>
                    </tr>

                    <tr>
                        <td class="tdLabel">3. m.</td>
                        <td>
                            <i>
                                <xsl:value-of select="tei:row/tei:cell[@role='3sm']"/>
                            </i>
                        </td>
                        <td rowspan="2">
                            <i>
                                <xsl:value-of select="tei:row/tei:cell[@role='3p']"/>
                            </i>
                        </td>
                    </tr>

                    <tr>
                        <td class="tdLabel">3. f.</td>
                        <td>
                            <i>
                                <xsl:value-of select="tei:row/tei:cell[@role='3sf']"/>
                            </i>
                        </td>
                    </tr>
                </table>
            </xsl:when>
            <xsl:otherwise>
                <table>
                    <xsl:apply-templates/>
                </table>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template match="tei:list[@type='ol']">
        <ol>
            <xsl:apply-templates/>
        </ol>
    </xsl:template>
    <xsl:template match="tei:item">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>

    <xsl:template match="egXML">
        <pre class="preBox"><xsl:apply-templates/></pre>
    </xsl:template>

    <xsl:template match="tei:head">
        <xsl:if test="parent::tei:div2">
            <h2>
                <xsl:if test="parent::tei:div2[@xml:id]">
                    <xsl:attribute name="id">
                        <xsl:value-of select="parent::tei:div2/@xml:id"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:value-of select="count(preceding::tei:div2)+1"/>
                <xsl:text> </xsl:text>
                <xsl:choose>
                    <xsl:when test="@xml:lang='ar-x-DMG'">
                        <span style="font-style:italic">
                            <xsl:apply-templates/>
                        </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text> </xsl:text>
                <a class="aGoTocontents" title="CONTENTS" href="#contents">(Go to contents)</a>
            </h2>
        </xsl:if>

        <xsl:if test="parent::tei:div3">
            <h3><xsl:if test="parent::tei:div3[@xml:id]"><xsl:attribute name="id"><xsl:value-of select="parent::tei:div3/@xml:id"/></xsl:attribute></xsl:if>
                <xsl:value-of select="count(preceding::tei:div2)+1"/>.<xsl:value-of select="count(parent::tei:div3/preceding-sibling::tei:div3)+1"/><xsl:text> </xsl:text>
                <xsl:choose>
                    <xsl:when test="@xml:lang='ar-x-DMG'"><span style="font-style:italic"><xsl:apply-templates/></span></xsl:when>
                    <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
                </xsl:choose>
                <xsl:text> </xsl:text><a class="aGoTocontents" title="CONTENTS" href="#contents">(Go
                    to contents)</a></h3>
        </xsl:if>
    </xsl:template>

    <xsl:template match="tei:div1 | tei:div2 | tei:div3">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:code | tei:hi[@rend='italic']">
        <i>
            <xsl:apply-templates/>
        </i>
    </xsl:template>
    <xsl:template match="tei:hi[@rend='bold']">
        <b>
            <xsl:apply-templates/>
        </b>
    </xsl:template>
    <xsl:template match="tei:hi[@rend='red']">
        <b style="color:red">
            <xsl:apply-templates/>
        </b>
    </xsl:template>
    <xsl:template match="tei:span">
        <xsl:choose>
            <xsl:when test="@xml:lang='ar-x-DMG'">
                <span style="font-style:italic">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:teiHeader/tei:fileDesc/tei:author"/>
    <xsl:template match="tei:titleStmt/tei:title"/>
    <xsl:template match="tei:publicationStmt/tei:pubPlace"/>
    <xsl:template match="tei:publicationStmt/tei:date"/>
    <xsl:template match="tei:editionStmt/tei:edition"/>
    <xsl:template match="fcs:DataView/@type"/>

</xsl:stylesheet>
