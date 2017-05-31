<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:t="http://www.tei-c.org/ns/1.0" xmlns:egXML="http://www.tei-c.org/ns/Examples" version="1.0" exclude-result-prefixes="xsl egXML t">
    <xsl:import href="commons_v1.xsl"/>
    <xsl:output method="html" indent="yes" encoding="UTF-8"/>
    <xsl:strip-space elements="t:body t:TEI t:teiHeader t:text t:ref t:p         t:fileDesc t:titleStmt t:publicationStmt t:editionStmt t:revisionDesc t:sourceDesc t:availability         t:div t:div1 t:div2 t:div3 t:div4 t:div5"/>

    <xsl:variable name="title">
        <xsl:value-of select="//t:titleStmt/t:title"/>
    </xsl:variable>

    <xsl:template name="callback-header">
        <link rel="stylesheet" type="text/css" href="{$scripts_url}style/guidelines.css"/>
    </xsl:template>
    
    <xsl:template name="continue-root">
        <div class="content guidelines">        
        <xsl:if test="$format = 'html'">
                <xsl:call-template name="callback-header"/>
        <h1>
            <xsl:value-of select="//t:div1/t:head"/>
        </h1>
        </xsl:if>
        <p>
            <i>
                <xsl:for-each select="//t:teiHeader/t:fileDesc/t:author">
                    <xsl:if test="position()&gt;1">, </xsl:if>
                    <xsl:value-of select="."/>
                </xsl:for-each>
            </i>
        </p>
        <p>
            <i>
                <xsl:value-of select="//t:publicationStmt/t:pubPlace"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="//t:publicationStmt/t:date"/>
            </i>
        </p>
        <div class="dvContents" id="contents">
            <h2>Contents</h2>
            <xsl:for-each select="//t:div2 | //t:div3 | //t:div4">
                <p class="tocEntry">
                    <xsl:choose>
                        <xsl:when test="name()='div2'">
                            <a class="aH2Contents">
                                <xsl:attribute name="href">#<xsl:value-of select="@xml:id"/>
                                </xsl:attribute>
                                <xsl:value-of select="count(preceding::t:div2)+1"/>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="./t:head"/>
                            </a>
                        </xsl:when>
                        <xsl:when test="name()='div3'">
                            <a class="aH3Contents">
                                <xsl:attribute name="href">#<xsl:value-of select="@xml:id"/>
                                </xsl:attribute>
                                <xsl:value-of select="count(preceding::t:div2)+1"/>.<xsl:value-of select="count(preceding-sibling::t:div3)+1"/>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="./t:head"/>
                            </a>
                        </xsl:when>
                        <xsl:when test="name()='div4'">
                            <a class="aH4Contents">
                                <xsl:attribute name="href">#<xsl:value-of select="@xml:id"/>
                                </xsl:attribute>
                                <xsl:value-of select="count(preceding::t:div2)+1"/>.<xsl:value-of select="count(preceding-sibling::t:div3)+1"/>.<xsl:value-of select="count(preceding-sibling::t:div4)+1"/>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="./t:head"/>
                            </a>
                        </xsl:when>
                    </xsl:choose>
                </p>
            </xsl:for-each>
        </div>
        <xsl:apply-templates select="@* | node()"/>
        </div>
    </xsl:template>

    <xsl:template match="t:body | t:TEI | t:teiHeader | t:text">
        <div>
            <xsl:attribute name="class">
            <xsl:choose>
                <xsl:when test="@type">
                        <xsl:value-of select="concat('tei-',name(), ' tei-type-', @type)"/>
                    </xsl:when>
                <xsl:otherwise>
                        <xsl:value-of select="concat('tei-',name())"/>
                    </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="t:author | t:bibl | t:biblScope | t:cit | t:date | t:def | t:entry | t:etym | t:form | t:gram | t:gramGrp | t:lang | t:mentioned | t:orth | t:p | t:quote | t:sense | t:usg">
        <p>
            <xsl:attribute name="class">
            <xsl:choose>
                <xsl:when test="@type">
                        <xsl:value-of select="concat('tei-',name(), ' tei-type-', @type)"/>
                    </xsl:when>
                <xsl:otherwise>
                        <xsl:value-of select="concat('tei-',name())"/>
                    </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="*" mode="egXML">
        <span>
            <xsl:if test="preceding-sibling::node()[1]/self::*">
                <xsl:text>
 </xsl:text>
            </xsl:if>
            <span class="spRed">
                <xsl:value-of select="concat('&lt;',local-name())"/>
            </span>
            <xsl:apply-templates select="@*" mode="egXML"/>
            <xsl:choose>
                <xsl:when test="node()">
                    <span class="spRed">
                        <xsl:text>&gt;</xsl:text>
                    </span>
                    <xsl:apply-templates mode="egXML"/>
                    <span class="spRed">
                        <xsl:text>&lt;/</xsl:text>
                        <xsl:value-of select="local-name()"/>
                        <xsl:text>&gt;</xsl:text>
                    </span>
                </xsl:when>
                <xsl:otherwise>
                    <span class="spRed">
                        <xsl:text>/&gt;</xsl:text>
                    </span>
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:template>

    <xsl:template match="@*" mode="egXML">
        <span>
            <xsl:text> </xsl:text>
            <span class="spAttrName">
                <xsl:value-of select="local-name()"/>
            </span>
            <span class="spEquals">=</span>
            <span class="spQuotes">"</span>
            <span class="spValue">
                <xsl:value-of select="."/>
            </span>
            <span class="spQuotes">"</span>
        </span>
    </xsl:template>
    
    <xsl:template match="@xml:*" mode="egXML">
        <span>
            <xsl:text> </xsl:text>
            <span class="spAttrName">
                <xsl:value-of select="concat('xml:',local-name())"/>
            </span>
            <span class="spEquals">=</span>
            <span class="spQuotes">"</span>
            <span class="spValue">
                <xsl:value-of select="."/>
            </span>
            <span class="spQuotes">"</span>
        </span>
    </xsl:template>

    <xsl:template match="egXML:egXML">
        <pre class="preBox">
            <xsl:apply-templates select="node()" mode="egXML"/>
        </pre>
        <xsl:variable name="biblID" select="substring-after(@source, '#')"/>
        <div class="dictSource">
            <xsl:value-of select="//node()[@xml:id=$biblID]"/>
        </div>
    </xsl:template>


    <xsl:template match="@*">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="t:graphic">
        <img src="{@url}" alt="{@url}"/>        
    </xsl:template>
    
    <xsl:template match="t:lb">
        <br/>
    </xsl:template>

    <xsl:template match="t:ptr">
        <xsl:choose>
            <xsl:when test="ancestor::egXML">
                <span class="spRed">&lt;ptr</span>
                <xsl:text> </xsl:text>
                <xsl:for-each select="@*">
                    <span class="spAttrName">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="name()"/>
                        <span class="spEquals">=</span>
                        <span class="spQuotes">"</span>
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

    <xsl:template match="t:cell">
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
    
    <xsl:template match="t:row">
        <tr>
            <xsl:apply-templates/>
        </tr>
    </xsl:template>
    
    <xsl:template match="t:table">
        <xsl:choose>
            <xsl:when test="parent::t:div[@type='verbParadigm']">
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
                                <xsl:value-of select="t:row/t:cell[@role='1s']"/>
                            </i>
                        </td>
                        <td>
                            <i>
                                <xsl:value-of select="t:row/t:cell[@role='1p']"/>
                            </i>
                        </td>
                    </tr>

                    <tr>
                        <td class="tdLabel">2. m.</td>
                        <td>
                            <i>
                                <xsl:value-of select="t:row/t:cell[@role='2sm']"/>
                            </i>
                        </td>
                        <td rowspan="2">
                            <i>
                                <xsl:value-of select="t:row/t:cell[@role='2p']"/>
                            </i>
                        </td>
                    </tr>

                    <tr>
                        <td class="tdLabel">2. f.</td>
                        <td>
                            <i>
                                <xsl:value-of select="t:row/t:cell[@role='2sf']"/>
                            </i>
                        </td>
                    </tr>

                    <tr>
                        <td class="tdLabel">3. m.</td>
                        <td>
                            <i>
                                <xsl:value-of select="t:row/t:cell[@role='3sm']"/>
                            </i>
                        </td>
                        <td rowspan="2">
                            <i>
                                <xsl:value-of select="t:row/t:cell[@role='3p']"/>
                            </i>
                        </td>
                    </tr>

                    <tr>
                        <td class="tdLabel">3. f.</td>
                        <td>
                            <i>
                                <xsl:value-of select="t:row/t:cell[@role='3sf']"/>
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

    <xsl:template match="t:list[@type='ol']">
        <ol>
            <xsl:apply-templates/>
        </ol>
    </xsl:template>
    <xsl:template match="t:item">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>

    <xsl:template match="t:ref">
        <a href="{@target}">
            <xsl:apply-templates/>
        </a>
    </xsl:template>
    
    <xsl:template match="t:ref[@type='license']">
        <a href="{@target}" class="tei-type-license">Copyright notice</a>
    </xsl:template>
    
    <xsl:template match="t:egXML">
        <pre class="preBox">
            <xsl:apply-templates/>
        </pre>
    </xsl:template>

    <xsl:template match="t:head[parent::t:div2]">
        <h2>
            <xsl:if test="parent::t:div2[@xml:id]">
                <xsl:attribute name="id">
                    <xsl:value-of select="parent::t:div2/@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="count(preceding::t:div2)+1"/>
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
    </xsl:template>
    
    <xsl:template match="t:head[parent::t:div3]">
        <h3>
            <xsl:if test="parent::t:div3[@xml:id]">
                <xsl:attribute name="id">
                    <xsl:value-of select="parent::t:div3/@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="count(preceding::t:div2)+1"/>.<xsl:value-of select="count(parent::t:div3/preceding-sibling::t:div3)+1"/>
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
            <a class="aGoTocontents" title="CONTENTS" href="#contents">(Go
                to contents)</a>
        </h3>
    </xsl:template>
    
    <xsl:template match="t:head[parent::t:div4]">
        <h4>
            <xsl:if test="parent::t:div4[@xml:id]">
            <xsl:attribute name="id">
                <xsl:value-of select="parent::t:div4/@xml:id"/>
            </xsl:attribute>
        </xsl:if>
            <xsl:value-of select="count(preceding::t:div2)+1"/>.<xsl:value-of select="count(parent::t:div3/preceding-sibling::t:div3)+1"/>.<xsl:value-of select="count(parent::t:div4/preceding-sibling::t:div4)+1"/>
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
            <a class="aGoTocontents" title="CONTENTS" href="#contents">(Go
                to contents)</a>
        </h4>
    </xsl:template>
    
    <xsl:template match="t:head"/>
    

    <xsl:template match="t:div1 | t:div2 | t:div3 | t:div4">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="t:code | t:hi[@rend='italic']">
        <i>
            <xsl:apply-templates/>
        </i>
    </xsl:template>
    <xsl:template match="t:hi[@rend='bold']">
        <b>
            <xsl:apply-templates/>
        </b>
    </xsl:template>
    <xsl:template match="t:hi[@rend='red']">
        <b style="color:red">
            <xsl:apply-templates/>
        </b>
    </xsl:template>
    <xsl:template match="t:span">
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

    <xsl:template match="t:sourceDesc/t:bibl"/>
    <xsl:template match="t:teiHeader/t:fileDesc/t:author"/>
    <xsl:template match="t:titleStmt/t:title"/>
    <xsl:template match="t:publicationStmt/t:pubPlace"/>
    <xsl:template match="t:publicationStmt/t:date"/>
    <xsl:template match="t:editionStmt/t:edition"/>
    
    <xsl:template match="t:*">
        <xsl:value-of select="name()"/>
        <xsl:apply-templates/>
    </xsl:template>

</xsl:stylesheet>