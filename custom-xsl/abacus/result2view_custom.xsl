<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:diag="http://www.loc.gov/zing/srw/diagnostic/" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:utils="http://aac.ac.at/content_repository/utils" xmlns:sru="http://www.loc.gov/zing/srw/" xmlns:saxon="http://saxon.sf.net/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fcs="http://clarin.eu/fcs/1.0" xmlns:exist="http://exist.sourceforge.net/NS/exist" xmlns:exsl="http://exslt.org/common" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" version="2.0" exclude-result-prefixes="#all">
     <xsl:import href="../../fcs/result2view_v1.xsl"/>
    <xd:doc scope="stylesheet"> 
        <xd:desc>Customization for abacus project. copied directly from /db/apps/cr-xq-mets/modules/cs-xsl/fcs/result2view.xsl</xd:desc>
    </xd:doc>
    <xsl:output method="xhtml" media-type="text/html" indent="no" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
<!--    <xsl:output method="xhtml" omit-xml-declaration="yes" indent="no"/>-->
    <xsl:include href="../../fcs/../commons_v2.xsl"/>
    <xsl:include href="../../fcs/data2view_v2.xsl"/>
    <xsl:strip-space elements="*"/>
<!--    <xsl:preserve-space elements="tei:seg"/>-->
    <!-- wenn eine Seite keinen Textinhalt hat, hat der div in der Anzeige keine Breite, ergo rutscht das Faksimilie nach links; wird durch einen nbsp verhindert.-->
    <!--<xsl:template match="TEI | tei:TEI" mode="record-data">
        <xsl:if test="normalize-space(.)=''"> </xsl:if>
        <xsl:text>***</xsl:text>  
        <xsl:next-match/>  
    </xsl:template>--> 
    
    <xsl:template match="w|tei:w|pc|tei:pc" mode="record-data" priority="1">
        <span class="inline-wrap">
            <!-- .attributes immer nur für die _innersten_ w-tags angeben und für jene ignorieren, die descendant w-Tags haben, 
                da ansonsten die obersten attribute _immer_ angezeigt werden -->
            <!-- , cf. TC Abb. vor S. 303 (rf abacus3_503):
                    <w lemma="ihr" type="PPOSAT">ih
                        <lb type="d"/>
                        <fw>...</fw>
                        <pb/>
                        <figure>
                            <p><hi>1000</hi></p>
                            <p>
                                <cit>
                                    <foreign>
                                       <hi rend="antiqua">
                                            <quote>
                                                <tei:w>Vestra</tei:w>
                                                <tei:w>abundantia</tei:w>
                                                ...
                                             
                        </figure> 
            -->
            <xsl:if test="@* and not(descendant::w|descendant::tei:w)">
                <span class="attributes" style="display:none;">
                    <xsl:choose>
                        <xsl:when test="@type='span'">
                            <xsl:variable name="next" select="following::tei:w[@type!='-'][1]"/>
                            <xsl:text>Wortteil (</xsl:text>
                            <xsl:value-of select="concat($next/@lemma,if($next/@ana='#oov')then '*' else ())"/>
                            <br/>
                            <xsl:value-of select="$next/@type"/>
                            <xsl:text>)</xsl:text>
                        </xsl:when>
                        <xsl:when test="self::tei:pc and @type='internal'">
                            <xsl:text>$(</xsl:text>
                        </xsl:when>
                        <xsl:when test="self::tei:pc and @type='final'">
                            <xsl:text>$.</xsl:text>
                        </xsl:when>
                        <xsl:when test="self::tei:pc and @type='comma'">
                            <xsl:text>$,</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:if test="@lemma">
                                <xsl:value-of select="concat(@lemma,if (@ana='#oov') then '*' else())"/>
                                <br/>
                            </xsl:if>
                            <xsl:value-of select="@type"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </span>
            </xsl:if>
            <xsl:call-template name="inline">
                <xsl:with-param name="insertTrailingBlank" select="not((ancestor::tei:TEI|ancestor::TEI)//*[local-name(.) = 'seg' and @type='whitespace'])"/>
            </xsl:call-template>
        </span>
    </xsl:template>
    
    <xsl:template match="*[parent::fcs:DataView/@type='full'][normalize-space(.)='']" mode="record-data">
        <xsl:text>&#160;</xsl:text>
        <xsl:next-match/>
    </xsl:template>
    
    <!--<xsl:template match="tei:lb|lb" mode="record-data" priority="1">
        <br/>
    </xsl:template>-->

    <xsl:template match="exist:match" mode="record-data" priority="1">
        <xsl:apply-templates select="tei:fw[@type='header']" mode="#current"/>
        <span class="hilight match">
            <xsl:apply-templates mode="inmatch"/>
        </span>
        <xsl:apply-templates select="(tei:fw[@type='footer' or contains(@place,'bot_')]|tei:note[@place='bottom'])" mode="#current"/>
    </xsl:template>
    
    <xsl:template match="*" mode="inmatch">
        <xsl:apply-templates select="." mode="record-data"/>
    </xsl:template>
    
    <xsl:template match="fw | tei:fw | seg[@type=('footer','header')] | tei:seg[@type=('footer','header')] | tei:note[@place='bottom']" mode="inmatch"/>
        
    
    
    <xsl:template match="tei:head | head" mode="record-data" priority="1">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <span class="{$class}">
            <xsl:call-template name="inline">
                <xsl:with-param name="insertTrailingBlank" select="not((ancestor::tei:TEI|ancestor::TEI)//*[local-name(.) = 'seg' and @type='whitespace'])"/>
            </xsl:call-template>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:g[@ref='#bracketsMW']|g[@ref='#bracketsMW']" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <span class="{$class}">):( <span class="dots-triangle">.<span class="dots-triangle sup">.</span>.</span>
        </span>
    </xsl:template>
    <xsl:template match="tei:figure | figure" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <span class="{$class}">
            <xsl:apply-templates mode="record-data"/>
        </span>
    </xsl:template>
    <xsl:template match="tei:reg | reg" mode="record-data"/>
    <xsl:template match="tei:supplied | supplied" mode="record-data">
        <xsl:text>&#160;</xsl:text>
    </xsl:template>
    
    <!-- lb in runden oder eckigen Klammern sollen nicht zu <br> transformiert werden. -->
    <xsl:template match="tei:lb[ancestor::tei:corr] | lb[ancestor::corr]" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="@rend='line'">
                <span class="{$class}">&#160;</span>
            </xsl:when>
            <xsl:when test="@rend='line high'">
                <span class="{$class}">&#160;</span>
            </xsl:when>
            <xsl:when test="@type='d'">
                <xsl:text>=</xsl:text>
            </xsl:when>
            <xsl:when test="@type='s'">
                <xsl:text>-</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    
    <xsl:template match="tei:corr | corr" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <span class="{$class}" title="Korrektur">
            <a href="#">
                <xsl:text>[</xsl:text>
                <span class="tei-{local-name()}-content">
                   <xsl:apply-templates mode="record-data"/>
                </span>
                <xsl:text>]</xsl:text>
            </a>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:ref | ref" mode="record-data">
        <xsl:call-template name="inline">
            <xsl:with-param name="insertTrailingBlank" select="not(ancestor::*[local-name(.) = 'TEI']//*[local-name(.) = 'seg' and @type='whitespace'])"/>
        </xsl:call-template>
    </xsl:template>    
    
    <xsl:template match="tei:fw[@type = 'header' or @type = 'footer'] | fw[@type = 'header' or @type = 'footer']" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <span class="{$class}">
            <xsl:apply-templates mode="record-data"/>
        </span>
    </xsl:template>
    
    <!--<xsl:template match="tei:seg[@rend='initialCapital']" mode="record-data" priority="1">
        <xsl:variable name="class" as="xs:string*">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <span class="{$class}">
            <xsl:value-of select="."/>
        </span>
    </xsl:template>-->
    
    <xsl:template match="tei:seg[@rend='initialCapital']" mode="record-data" priority="1">
        <xsl:variable name="this" select="."/>
        <!--<xsl:variable name="children">
            <xsl:apply-templates mode="record-data"/>
        </xsl:variable>-->
        <xsl:variable name="classes" as="xs:string*">
            <xsl:for-each select="descendant::*">
                <xsl:call-template name="classnames"/>
            </xsl:for-each>
        </xsl:variable>
        <!-- HACK: wir bauen das inline-wrap template nach -->
        <span class="inline-wrap">
            <xsl:if test="descendant::*[@lemma or @type]">
                <!--<span class="attributes" style="display:none;">
                    <xsl:value-of select="concat((descendant::*/@lemma)[1],' ',(descendant::*/@type)[1])"/>
                </span>-->
                <span class="attributes" style="display:none;">
                    <xsl:choose>
                        <xsl:when test="*/@type='-'">
                            <xsl:variable name="next" select="following::tei:w[@type!='-'][1]"/>
                            <xsl:text>Wortteil (</xsl:text>
                            <xsl:value-of select="concat($next/@lemma,if($next/@ana='#oov')then '*' else ())"/>
                            <br/>
                            <xsl:value-of select="$next/@type"/>
                            <xsl:text>)</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat(*/@lemma,if (*/@ana='#oov') then '*' else())"/>
                            <br/>
                            <xsl:value-of select="*/@type"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </span>
            </xsl:if>
            <span class="tei-hi tei-rend-initialCapital">
                <xsl:value-of select="substring(normalize-space(.),1,1)"/>
            </span>
            <span class="{string-join($classes, ' ')}">
                <xsl:choose>
                    <xsl:when test="tei:lb">
                        <xsl:value-of select="substring(normalize-space(string-join(tei:lb/preceding::text()[ancestor::tei:seg is $this],'')),2)"/>
                        <xsl:apply-templates select="tei:lb[1]" mode="#current"/>
                        <xsl:value-of select="normalize-space(string-join(tei:lb/following::text()[ancestor::tei:seg is $this],''))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring(normalize-space(.),2)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </span>
        </span>
    </xsl:template>
    
    <xsl:template match="ptr | tei:ptr" mode="record-data"/>
        
    <!-- fw-template angepasst, daher nicht mehr notwendig -->
    <!--<xd:doc>
        <xd:desc>per default wird tei:p zu html:span umgewandelt; header und footer werden jedoch zu html:divs umgewandelt (fehlerhafte Struktur, daher  Darstellungsfehler in Chrome etc.); daher wird tei:p -> tei:div, wenn sich darin ein tei:seg[@type=('header','footer')] befindet.</xd:desc>
    </xd:doc>
    <xsl:template match="p[descendant::fw[@type[.='header' or .='footer']]] | tei:p[descendant::tei:fw[@type[.='header' or .='footer']]]" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <div class="{$class}">
            <xsl:apply-templates mode="record-data"/>
        </div>
    </xsl:template>-->
    
    <xsl:template match="tei:g[@ref='#bracketsTC'] | g[@ref='#bracketsTC']" mode="record-data">
        <xsl:variable name="ref" select="@ref"/>
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <xsl:if test="preceding-sibling::*[1]/*[self::g or self::tei:g][@ref = $ref]">
            <xsl:text>&#160;</xsl:text>
        </xsl:if>
        <span class="{$class}" style="font-size:18pt;">)(</span>
    </xsl:template>
    
</xsl:stylesheet>