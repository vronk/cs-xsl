<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:aac="urn:general"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:sru="http://www.loc.gov/zing/srw/"
    xmlns:exist="http://exist.sourceforge.net/NS/exist"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    version="1.0" 
    exclude-result-prefixes="xsl aac tei sru exist xd">

    <xd:doc scope="stylesheet">
        <xd:desc>
<xd:p>Stylesheet for formatting TEI-elements  inside a FCS/SRU-result.
the TEI-elements are expected without namespace (!) (just local names)
This is not nice, but is currently in results like that.</xd:p>
<xd:p>
The templates are sorted by TEI-elements they match.
if the same transformation applies to multiple elements,
it is extracted into own named-template and called from the matching templates.
the named templates are at the bottom.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:include href="data2view_teiHeader.xsl"/>
    
    
    <xd:doc>
        <xd:desc>Put TEI content into a div</xd:desc>
    </xd:doc>
    <xsl:template match="TEI | tei:TEI" mode="record-data">
        <div class="tei-TEI">
            <xsl:if test="@xml:id">
                <xsl:attribute name="class">
                    <xsl:value-of select="concat('tei-TEI ', @xml:id)"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates mode="record-data"/>
        </div>
    </xsl:template>
    
    <xsl:template match="text | body| front | back | tei:text | tei:body | tei:front | tei:back" mode="record-data">
        <xsl:apply-templates mode="record-data"/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Put TEI Header content into a div</xd:desc>
    </xd:doc>
    <xsl:template match="tei:teiHeader" mode="record-data">
        <div class="tei-teiHeader">
            <xsl:apply-templates mode="record-data"/>
        </div>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Generate some generelly useful information contained in the TEI header</xd:desc>
    </xd:doc>
    <xsl:template match="tei:fileDesc" mode="record-data">
            <h1><xsl:value-of select="tei:titleStmt/tei:title"/></h1>
            <p class="tei-author">by <xsl:value-of select="tei:author"/></p>
            <p class="tei-publicationStmt"><xsl:value-of select="tei:publicationStmt/tei:pubPlace"/>, <xsl:value-of select="tei:publicationStmt/tei:date"/></p>
            <p class="tei-editionStmt">Edition: <xsl:value-of select="tei:editionStmt/tei:edition"/></p>
            <p class="tei-sourceDesc">
                <xsl:for-each select="tei:sourceDesc/tei:p">
                    <p><xsl:value-of select="."/></p>
                </xsl:for-each>
            </p>
            <xsl:choose>
                <xsl:when test="tei:publicationStmt/tei:availability[@status='restricted']">
                    <p class="tei-publicationStmt">All rights reserved!</p>
                    <xsl:if test="tei:publicationStmt/tei:availability//tei:ref[@type='license']">
                        <p class="tei-ref-license"><a href="{tei:publicationStmt/tei:availability//tei:ref[@type='license']/@target}">License</a></p>
                    </xsl:if>
                </xsl:when>            
            </xsl:choose>      
    </xsl:template>

    <xd:doc>
        <xd:desc>A TEI biblStruct is mapped to a HTML div element</xd:desc>
    </xd:doc>
    <xsl:template match="tei:biblStruct" mode="record-data">
        <div class="tei-biblStruct" id="{@xml:id}">            
            <xsl:apply-templates mode="record-data"/>
        </div>
    </xsl:template>

    <xd:doc>
        <xd:desc>Presents monographs
            <xd:p>
                Convention used is:
            </xd:p>
            <xd:p>
                Author, Author, ... : Title, Title, ...
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="tei:monogr" mode="record-data">
        <span class="tei-authors"><xsl:apply-templates mode="record-data" select="tei:author"/></span>: <span class="tei-titles"><xsl:apply-templates mode="record-data" select="tei:title"/></span>.<xsl:apply-templates mode="record-data" select="tei:imprint"/>
    </xsl:template>

    <xd:doc>
        <xd:desc>Presents dependent publications
            <xd:p>
                Convention used is:
            </xd:p>
            <xd:p>
                Author, Author, ... : Title, Title, ... in -> monogr
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="tei:analytic" mode="record-data">
        <span class="tei-authors"><xsl:apply-templates mode="record-data" select="tei:author"/></span>: <span class="tei-titles"><xsl:apply-templates mode="record-data" select="tei:title"/></span> in
    </xsl:template>

    <xd:doc>
        <xd:desc>Return text and spacer if needed</xd:desc>
    </xd:doc>
    <xsl:template match="tei:author" mode="record-data">
        <span class="tei-author"><xsl:value-of select="."/></span><xsl:if test="following-sibling::tei:author">, </xsl:if>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Return text and spacer if needed</xd:desc>
    </xd:doc>
    <xsl:template match="tei:title" mode="record-data">
        <span class="tei-title"><xsl:value-of select="."/></span><xsl:if test="following-sibling::tei:title">, </xsl:if>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>TEI Imprint as imprint span</xd:desc>
    </xd:doc>
    <xsl:template match="tei:imprint" mode="record-data">
        <span class="tei-imprint"><xsl:apply-templates mode="record-data"/></span>.
    </xsl:template>
    
    <xd:doc>
        <xd:desc>TEI pubPlace as pubPlace span</xd:desc>
    </xd:doc>
    <xsl:template match="tei:pubPlace" mode="record-data">
        <span class="tei-pubPlace"><xsl:value-of select="."/></span>
    </xsl:template>    
    
    <xsl:template match="tei:imprint/tei:date" mode="record-data">
        <span class="tei-imprint-date"><xsl:value-of select="."/></span>
        <xsl:if test="following-sibling::tei:idno|following-sibling::tei:biblScope">
            <xsl:value-of select="'. '"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:idno[@type='issn']" mode="record-data">
        <xsl:if test=". != ''">
            <span class="tei-idno-issn">ISSN: <xsl:value-of select="."/></span>
            <xsl:if test="following-sibling::tei:biblScope">
                <xsl:value-of select="', '"/>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:biblScope" mode="record-data">
        <xsl:if test=". != ''">
            <span class="tei-biblScope"><xsl:value-of select="."/></span>
            <xsl:if test="following-sibling::tei:biblScope">
                <xsl:value-of select="', '"/>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:biblScope[@type = 'vol']" mode="record-data">
        <xsl:if test=". != ''">
            <span class="tei-biblScope-vol">Volume: <xsl:value-of select="."/></span>
            <xsl:if test="following-sibling::tei:biblScope">
                <xsl:value-of select="', '"/>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:biblScope[@type = 'issue']" mode="record-data">
        <xsl:if test=". != ''">
            <span class="tei-biblScope-issue">Issue: <xsl:value-of select="."/></span>
            <xsl:if test="following-sibling::tei:biblScope">
                <xsl:value-of select="', '"/>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:biblScope[@type = 'pages']" mode="record-data">
        <xsl:if test=". != ''">
            <span class="tei-biblScope-pages"><xsl:value-of select="."/> pages</span>
            <xsl:if test="following-sibling::tei:biblScope">
                <xsl:value-of select="', '"/>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:biblScope[@type = 'startPage']" mode="record-data">
        <xsl:if test=". != ''">
            <span class="tei-biblScope-startPage">p. <xsl:value-of select="."/></span>
            <xsl:if test="following-sibling::tei:biblScope">
                <xsl:value-of select="', '"/>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xd:doc>
        <xd:desc></xd:desc>
    </xd:doc>
    <xsl:template match="tei:series" mode="record-data">
        <div class="cs-xsl-error">
            TODO!
        </div>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Notes in biblStruct are used to specify index terms</xd:desc>
    </xd:doc>
    <xsl:template match="tei:biblStruct/tei:note" mode="record-data">
        <xsl:apply-templates mode="record-data"/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Notes in biblStruct are used to specify index terms</xd:desc>
    </xd:doc>
    <xsl:template match="tei:biblStruct/tei:note/tei:index" mode="record-data">
        <ul class="tei-index"><xsl:apply-templates mode="record-data"/></ul>
    </xsl:template>
    
    <xsl:template match="tei:index/tei:term" mode="record-data">
        <xsl:variable name="href">
            <xsl:call-template name="formURL">
                <xsl:with-param name="q" select="concat('vicavTaxonomy=', .)"></xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <li>
            <xsl:choose>
                <xsl:when test="@type = 'vicavTaxonomy'">
                    <a href="{$href}"><xsl:value-of select="."/></a>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </li>
    </xsl:template>
    <xd:doc>
        <xd:desc>Ignore the text tag for TEI</xd:desc>
    </xd:doc>
    <xsl:template match="tei:TEI/tei:text" mode="record-data">
        <xsl:apply-templates mode="record-data"/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Put TEI body content into a div</xd:desc>
    </xd:doc>
    <xsl:template match="tei:body" mode="record-data">
        <div class="tei-body">
            <xsl:apply-templates mode="record-data"/>
        </div>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>A head section is assumed to contain a number of headings
        <xd:p>
            To generate HTML headings from these we use another mode.
        </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="tei:head" mode="record-data">
        <div class="tei-head">
            <xsl:apply-templates mode="tei-body-headings"/>
        </div>
    </xsl:template>
    
    <xsl:template match='*' mode="tei-body-headings">
        <h2>
            <xsl:apply-templates mode="record-data"/>
        </h2>
    </xsl:template>
    
    <xsl:template match="tei:div[@type]" mode="record-data">
        <div class="tei-div {@type}">
            <h3><xsl:value-of select="@type"/></h3>
            <xsl:apply-templates mode="record-data"/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:ref[contains(@target, '.JPG') or 
                                 contains(@target, '.jpg') or
                                 contains(@target, '.PNG') or
                                 contains(@target, '.PNG')]" mode="record-data">
<!--    <xsl:template match="tei:ref[contains(@target, '.jpg')]" mode="record-data">-->
        <xsl:call-template name="generateImg"/>
    </xsl:template>
    <xd:doc>
        <xd:desc>some special elements retained in data, due to missing correspondencies in tei 
            if it will get more, we should move to separate file</xd:desc>
    </xd:doc>
    <xsl:template match="aac_HYPH1 | aac:HYPH1" mode="record-data">
        <xsl:apply-templates/>
        <xsl:text> </xsl:text>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>some special elements retained in data, due to missing correspondencies in tei 
            if it will get more, we should move to separate file</xd:desc>
    </xd:doc>
    <xsl:template match="aac_HYPH2  | aac:HYPH2" mode="record-data">
        <xsl:apply-templates/>
        <xsl:text> </xsl:text>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>some special elements retained in data, due to missing correspondencies in tei 
            if it will get more, we should move to separate file</xd:desc>
    </xd:doc>
    <xsl:template match="aac_HYPH3  | aac:HYPH3" mode="record-data">
        <xsl:apply-templates/>
        <xsl:text> </xsl:text>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>tei:address elements are mapped to html:address (???) elements
            <xd:p>Suche elements occur in ... </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="address | tei:address" mode="record-data">
        <address>
            <xsl:if test="tei:street">
                <xsl:value-of select="tei:street"/>
                <br/>
            </xsl:if>
            <xsl:if test="tei:postCode | tei:settlement">
                <xsl:value-of select="tei:postCode"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="tei:settlement"/>
                <br/>
            </xsl:if>
            <xsl:if test="tei:country">
                <xsl:value-of select="tei:country"/>
            </xsl:if>
        </address>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>tei:bibl elements are (???)</xd:desc>
    </xd:doc>
    <xsl:template match="bibl | tei:bibl" mode="record-data">
        <xsl:call-template name="inline"/>
    </xsl:template>
    <xsl:template match="tei:birth" mode="record-data">
        <div>
            <span class="label">geboren: </span>
            <span class="{local-name()}" data-when="{@when}">
                <xsl:value-of select="concat(@when, ', ', tei:placeName)"/>
            </span>
        </div>
    </xsl:template>
    
    <xsl:template match="choice | tei:choice " mode="record-data">
        <span class="choice">
            <xsl:apply-templates mode="record-data"/>
        </span>
    </xsl:template>
    <xsl:template match="orig | tei:orig | tei:sic | sic" mode="record-data">
        <xsl:call-template name="inline">
            <xsl:with-param name="insertTrailingBlank" select="not(ancestor::*[local-name(.) = 'TEI']//*[local-name(.) = 'seg' and @type='whitespace'])"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="tei:ref|ref|tei:ptr|ptr" mode="record-data"/>
    <xsl:template match="tei:note|note" mode="record-data">
        <span>
            <xsl:attribute name="class">
                <xsl:text>note</xsl:text>
                <xsl:if test="@type"> note-<xsl:value-of select="@type"/>
                </xsl:if>
                <xsl:if test="@type"> note-<xsl:value-of select="@place"/>
                </xsl:if>
            </xsl:attribute>
            <xsl:apply-templates mode="record-data"/>
        </span>
    </xsl:template>
    <xsl:template match="tei:corr | corr" mode="record-data">
        <sup>
            <xsl:text>(</xsl:text>
            <xsl:call-template name="inline">
                <xsl:with-param name="insertTrailingBlank" select="not(ancestor::*[local-name(.) = 'TEI']//*[local-name(.) = 'seg' and @type='whitespace'])"/>
            </xsl:call-template>
            <xsl:text>)</xsl:text>
        </sup>
    </xsl:template>
    <xsl:template match="tei:supplied | supplied" mode="record-data">
        <sup>
            <xsl:text>〈</xsl:text>
            <xsl:call-template name="inline">
                <xsl:with-param name="insertTrailingBlank" select="not(ancestor::*[local-name(.) = 'TEI']//*[local-name(.) = 'seg' and @type='whitespace'])"/>
            </xsl:call-template>
            <xsl:text>〉</xsl:text>
        </sup>
    </xsl:template>
    <xsl:template match="tei:reg | reg" mode="record-data">
        <sup>
            <xsl:text>[</xsl:text>
            <xsl:call-template name="inline">
                <xsl:with-param name="insertTrailingBlank" select="not(ancestor::*[local-name(.) = 'TEI']//*[local-name(.) = 'seg' and @type='whitespace'])"/>
            </xsl:call-template>
            <xsl:text>]</xsl:text>
        </sup>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>tei:cit elements are mapped to html:quote elements
            <xd:p>Suche elements occur in ... </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="cit | tei:cit" mode="record-data">
        <quote>
            <xsl:apply-templates mode="record-data"/>
        </quote>
    </xsl:template>
   
    <xd:doc>
        <xd:desc>tei:data elements are formatted as spans with an apropriate class
            <xd:p>Suche elements occur in ... </xd:p>
        </xd:desc>
    </xd:doc>    
    <xsl:template match="date|tei:date" mode="record-data">
        <span class="date">
            <!--<xsl:value-of select="."/>-->
            <xsl:apply-templates mode="record-data"/>
            <!--            <span class="note">[<xsl:value-of select="@value"/>]</span>-->
        </span>
    </xsl:template>
    <xsl:template match="tei:death" mode="record-data">
        <div>
            <span class="label">gestorben: </span>
            <span class="{local-name()}" data-when="{@when}">
                <xsl:value-of select="concat(@when, ', ', tei:placeName)"/>
            </span>
        </div>
    </xsl:template>
    
 <xd:doc>
        <xd:desc>tei:div elements are mapped to html:div elements
            <xd:p>Note: html:div elements are defined even fuzzier than tei:div elements.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="div|tei:div" mode="record-data">
        <div >
			<xsl:if test="@type">
                <xsl:attribute name="class"><xsl:value-of select="concat('tei-type-', @type)"/></xsl:attribute>
            </xsl:if>
            <xsl:apply-templates mode="record-data"/>
        </div>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>tei:p elements are mapped to html:p elements
        </xd:desc>
    </xd:doc>
    <xsl:template match="p|tei:p" mode="record-data">
        <p>
            <xsl:if test="@rend">
                <xsl:attribute name="class"><xsl:call-template name="rend-without-color"><xsl:with-param name="rend-text" select="@rend"/></xsl:call-template></xsl:attribute>
                <xsl:if test="substring-after(string(@rend), 'color(')">
                    <xsl:attribute name="style"><xsl:call-template name="rend-color-as-html-style"><xsl:with-param name="rend-text" select="@rend"/></xsl:call-template></xsl:attribute>
            </xsl:if>
            </xsl:if>
            <xsl:apply-templates mode="record-data"/>
        </p>
    </xsl:template>

    <xd:doc>
        <xd:desc>TEI ptr elements are mapped to "Click here" links
        <xd:p>
            Note: You most likely have to supply you're own logic by superseding this.
        </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="tei:ptr" mode="record-data">
        <a href="{@target}">Click here!</a>
    </xsl:template>

    <xd:doc>
        <xd:desc>tei:table elements are mapped to html:table elements
            <xd:p>Note: These elements are found eg. in the mecmua transkription.</xd:p>
            <xd:p>There is a class attribute "tei-table" so it is possible to format these
            tables differently form eg. blind tables used elsewhere.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="table|tei:table" mode="record-data">
        <table class="tei-table">
            <xsl:apply-templates mode="record-data"/>
        </table>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>tei:row elements are mapped to html:tr elements
        </xd:desc>
    </xd:doc>
    <xsl:template match="row|tei:row" mode="record-data">
        <tr>
            <xsl:apply-templates mode="record-data"/>
        </tr>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>tei:cell elements are mapped to html:td elements
        </xd:desc>
    </xd:doc>
    <xsl:template match="cell|tei:cell" mode="record-data">
        <td>
            <xsl:if test="./@cols">
                <xsl:attribute name="colspan"><xsl:value-of select="./@cols"/></xsl:attribute>
            </xsl:if>
            <xsl:apply-templates mode="record-data"/>
        </td>
    </xsl:template>
     
    <xd:doc>
        <xd:desc>tei:entry elements are the base elements for any lexicographical definitions
            <xd:p>
     TODO: this has to be broken down to individual children-elements.
     the styles should be moved to CSS and referenced by classes 
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="entry | tei:entry" mode="record-data">
        <div class="profiletext">
            <div style="margin-top: 15px; background:rgb(242,242,242); border: 1px solid grey">
                <b>
                    <xsl:value-of select="form[@type='lemma']/orth[contains(@xml:lang,'Trans')]"/>
                    <xsl:if test="form[@type='lemma']/orth[contains(@xml:lang,'arabic')]">
                        <xsl:text> </xsl:text>(<xsl:value-of select="form[@type='lemma']/orth[contains(@xml:lang,'arabic')]"/>)</xsl:if>
                </b>
                <xsl:if test="gramGrp/gram[@type='pos']">
                    <span style="color:rgb(0,64,0)">
                        <xsl:text>           </xsl:text>[<xsl:value-of select="gramGrp/gram[@type='pos']"/>
                        <xsl:if test="gramGrp/gram[@type='subc']">; <xsl:value-of select="gramGrp/gram[@type='subc']"/>
                        </xsl:if>]</span>
                </xsl:if>
                <xsl:for-each select="form[@type='inflected']">
                    <div style="margin-left:30px">
                        <xsl:choose>
                            <xsl:when test="@ana='#adj_f'">
                                <b style="color:blue">
                                    <i>(f) </i>
                                </b>
                            </xsl:when>
                            <xsl:when test="@ana='#adj_pl'">
                                <b style="color:blue">
                                    <i>(pl) </i>
                                </b>
                            </xsl:when>
                            <xsl:when test="@ana='#n_pl'">
                                <b style="color:blue">
                                    <i>(pl) </i>
                                </b>
                            </xsl:when>
                            <xsl:when test="@ana='#v_pres_sg_p3'">
                                <b style="color:blue">
                                    <i>(pres) </i>
                                </b>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:value-of select="orth[contains(@xml:lang,'Trans')]"/>
                        <xsl:if test="orth[contains(@xml:lang,'arabic')]">
                            <xsl:text> </xsl:text>(<xsl:value-of select="orth[contains(@xml:lang,'arabic')]"/>)</xsl:if>
                    </div>
                </xsl:for-each>
                <xsl:for-each select="sense">
                    <xsl:if test="def">
                        <div style="margin-top: 5px; border-top:0.5px dotted grey;">
                            <xsl:if test="def[@xml:lang='en']">
                                <xsl:value-of select="def[@xml:lang='en']"/>
                            </xsl:if>
                            <xsl:if test="def[@xml:lang='de']">
                                <xsl:text> </xsl:text>
                                <span style="color:rgb(126,126,126); font-style: italic">(<xsl:value-of select="def[@xml:lang='de']"/>)</span>
                            </xsl:if>
                        </div>
                    </xsl:if>
                    <xsl:if test="cit[@type='translation']">
                        <div style="margin-top: 5px; border-top:0.5px dotted grey;">
                            <xsl:if test="cit[(@type='translation')and(@xml:lang='en')]">
                                <xsl:value-of select="cit[(@type='translation')and(@xml:lang='en')]"/>
                            </xsl:if>
                            <xsl:if test="cit[(@type='translation')and(@xml:lang='de')]">
                                <xsl:text> </xsl:text>
                                <span style="color:rgb(126,126,126); font-style: italic">(<xsl:value-of select="cit[(@type='translation')and(@xml:lang='de')]"/>)</span>
                            </xsl:if>
                        </div>
                    </xsl:if>
                    <xsl:for-each select="cit[@type='example']">
                        <div style="margin-left:30px">
                            <xsl:value-of select="quote[contains(@xml:lang,'Trans')]"/>
                            <i>
                                <xsl:value-of select="cit[(@type='translation')and(@xml:lang='en')]"/>
                            </i>
                            <xsl:if test="cit[(@type='translation')and(@xml:lang='de')]">
                                <xsl:text> </xsl:text>
                                <span style="color:rgb(126,126,126); font-style: italic">(<xsl:value-of select="cit[(@type='translation')and(@xml:lang='de')]"/>)</span>
                            </xsl:if>
                        </div>
                    </xsl:for-each>
                </xsl:for-each>
            </div>
        </div>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>tei:foreign elements are formatted as divs with an apropriate language class
            <xd:p>Suche elements occur in ... </xd:p>
        </xd:desc>
    </xd:doc>  
    <xsl:template match="foreign | tei:foreign" mode="record-data">
        <span class="foreign" xml:lang="{@xml:lang}">
            <xsl:apply-templates mode="record-data"/>
            <!--<xsl:if test="@xml:lang">
                <sup>
                    <xsl:value-of select="@xml:lang"/>
                </sup>
            </xsl:if>-->
        </span>
    </xsl:template>
    <xsl:template match="fw | tei:fw" mode="record-data">
        <span>
            <xsl:attribute name="class">
                <xsl:choose>
                    <xsl:when test="@type='catch'">
                        <xsl:choose>
                            <xsl:when test="@place='bot_right'">fw catch float-right</xsl:when>
                            <xsl:otherwise>fw catch</xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>fw</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:call-template name="inline">
                <xsl:with-param name="insertTrailingBlank" select="not(ancestor::*[local-name(.) = 'TEI']//*[local-name(.) = 'seg' and @type='whitespace'])"/>
            </xsl:call-template>
        </span>
    </xsl:template>
<xd:doc>
        <xd:desc>tei:geo elements are mapped to spans optionally as link to more information.</xd:desc>
    </xd:doc>    
<xsl:template match="geo | tei:geo" mode="record-data">
        <xsl:call-template name="inline">
            <xsl:with-param name="insertTrailingBlank" select="not(ancestor::*[local-name(.) = 'TEI']//*[local-name(.) = 'seg' and @type='whitespace'])"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="head | tei:head " mode="record-data">
        <h4 class="{@type}">
            <xsl:call-template name="inline">
                <xsl:with-param name="insertTrailingBlank" select="not((ancestor::tei:TEI|ancestor::TEI)//*[local-name(.) = 'seg' and @type='whitespace'])"/>
            </xsl:call-template>
        </h4>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>tei:hi is mapped to html:span and @rend is mapped to @class</xd:desc>
        <xd:p>Note these elements are found eg. in the mecmua transkription</xd:p>
    </xd:doc>    
    <xsl:template match="hi | tei:hi" mode="record-data">
        <xsl:variable name="wrapper-class" select="(@rend|@rendition|@style)[1]"/>
        <xsl:choose>
            <!-- FIXME This is a temporary hack to allow initial Caps, we need to adjust the "inline" template -->
            <xsl:when test="@rend='initialCapital'">
                <span class="initialCapital">
                    <xsl:value-of select="substring(normalize-space(.),1,1)"/>
                </span>
                <xsl:value-of select="substring(normalize-space(.),2)"/>
            </xsl:when>
            <xsl:when test="@rend or @rendition or @style">
                <span class="{$wrapper-class}">
                    <xsl:call-template name="inline">
                        <xsl:with-param name="insertTrailingBlank" select="not((ancestor::tei:TEI|ancestor::TEI)//*[local-name(.) = 'seg' and @type='whitespace'])"/>
                    </xsl:call-template>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="inline">
                    <xsl:with-param name="insertTrailingBlank" select="not((ancestor::tei:TEI|ancestor::TEI)//*[local-name(.) = 'seg' and @type='whitespace'])"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xd:doc>
        <xd:desc>tei:l elements are expanded and a html:br element as added.</xd:desc>
    </xd:doc>
    <xsl:template match="l | tei:l" mode="record-data">
        <xsl:apply-templates mode="record-data"/>
        <br/>
    </xsl:template>
    <xsl:template match="lb | tei:lb" mode="record-data">
        <xsl:choose>
            <xsl:when test="@type='d'">
                <xsl:text>=</xsl:text>
            </xsl:when>
            <xsl:when test="@type='s'">
                <xsl:text>-</xsl:text>
            </xsl:when>
        </xsl:choose>
        <br/>
    </xsl:template>
    <xsl:template match="lg | tei:lg" mode="record-data">
        <div class="lg">
            <p>
                <xsl:apply-templates mode="record-data"/>
            </p>
        </div>
    </xsl:template>
   
    <xsl:template match="tei:link" mode="record-data">
        <li>
            <a href="{@target}">
                <xsl:value-of select="@target"/>
            </a>
        </li>
    </xsl:template>
  <xd:doc>
        <xd:desc>tei:milestone elemnts are not retained</xd:desc>
        <xd:p>Replced by three dots (...)</xd:p>
    </xd:doc>
    <xsl:template match="milestone | tei:milestone" mode="record-data">
        <xsl:choose>
            <xsl:when test="@type[.='hr'] and @rend[.='line']">
                <hr class="hr"/>
            </xsl:when>
            <xsl:when test="@type[.='hr'] and @rend[.='high']">
                <hr class="hr-high"/>
            </xsl:when>
            <xsl:when test="@type[.='hr'] and @rend[.='dotted']">
                <span class="hr-dotted"/>
            </xsl:when>
            <xsl:when test="@type[.='separator'] and @rend[.='asterisk']">
                <p style="text-align:center">*</p>
            </xsl:when>
            <xsl:when test="@type[.='separator'] and @rend[.='asterism']">
                <p style="text-align:center">*&#160;&#160;*&#160;&#160;*</p>
            </xsl:when>
            <xsl:when test="@type[.='separator'] and @rend[.='asterismUp']">
                <p style="text-align:center">*&#160;&#160;<sup>*</sup>&#160;&#160;*</p>
            </xsl:when>
            <xsl:when test="@type[.='separator'] and @rend[.='asterismDown']">
                <p style="text-align:center">*&#160;&#160;<sub>*</sub>&#160;&#160;*</p>
            </xsl:when>
            <xsl:when test="@type[.='separator'] and @rend[.='hr']">
                <hr style="width:100px;text-align:center"/>
            </xsl:when>
            <xsl:when test="@type[.='separator'] and @rend[.='undefined']">
                <p style="margin-left:100px;width:330px;text-align:center">⌫⌦</p>
            </xsl:when>
            <xsl:when test="@type[.='symbol'] and @rend[.='blEtc']">રc.</xsl:when>
            <xsl:when test="@type[.='symbol'] and @rend[.='brackets']">
                <span style="font-size:18pt;">)(</span>
            </xsl:when>
            <xsl:when test="@type[.='symbol'] and @rend[.='flower']">✾</xsl:when>
            <xsl:when test="@type[.='symbol'] and @rend[.='undefined']">
                <b>☉</b>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>...</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:occupation" mode="record-data">
        <div class="{local-name()}">
            <xsl:value-of select="."/>
        </div>
    </xsl:template>   

    <!-- for STB: dont want pb -->
    <xsl:template match="pb | tei:pb" mode="record-data"/>
    <!--<xsl:template match="pb" mode="record-data">
        <div class="pb">p. <xsl:value-of select="@n"/>
        </div>
    </xsl:template>-->
    <xsl:template match="pc | tei:pc" mode="record-data">
        <xsl:call-template name="inline">
            <xsl:with-param name="insertTrailingBlank" select="not(//*[local-name(.) = 'seg' and @type='whitespace'])"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="place | tei:place" mode="record-data">
        <xsl:copy>
            <xsl:apply-templates mode="record-data"/>
        </xsl:copy>
    </xsl:template>
xd:doc>
        <xd:desc>tei:persName, tei:placeName etc. elements are mapped to spans optionally as link to more information.</xd:desc>
    </xd:doc>
    <xsl:template match="name | persName | placeName | tei:name | tei:persName | tei:placeName" mode="record-data">
        <xsl:call-template name="inline">
            <xsl:with-param name="additional-style" select="string(../@rend)"/>
            <xsl:with-param name="insertTrailingBlank" select="not(//*[local-name(.) = 'seg' and @type='whitespace'])"/>
        </xsl:call-template>
    </xsl:template>
    <xd:doc>
        <xd:desc>tei:quote elements are mapped to spans optionally as link to more information.</xd:desc>
    </xd:doc>
    <xsl:template match="quote | tei:quote" mode="record-data">
        <xsl:call-template name="inline">
            <xsl:with-param name="insertTrailingBlank" select="not(//*[local-name(.) = 'seg' and @type='whitespace'])"/>
        </xsl:call-template>
    </xsl:template>
    <xd:doc>
        <xd:desc>tei:rs elements are mapped to spans optionally as link to more information.</xd:desc>
    </xd:doc>
    <xsl:template match="rs | tei:rs" mode="record-data">
        <xsl:call-template name="inline">
            <xsl:with-param name="insertTrailingBlank" select="not(//*[local-name(.) = 'seg' and @type='whitespace'])"/>
        </xsl:call-template>
    </xsl:template>

    <xd:doc>
        <xd:desc>tei:seg elements are mapped to spans optionally as link to more information.
        <xd:p>Note: These may not make sense in a particular project eg. STB.</xd:p>
        </xd:desc>
    </xd:doc> 
    <!-- for STB: dont want seg -->
    <!--    <xsl:template match="seg | tei:seg" mode="record-data"/>-->
    <xsl:template match="seg | tei:seg" mode="record-data">
        <!--<xsl:call-template name="inline"/>-->
        <xsl:choose>
            <xsl:when test="@type='whitespace'">
                <xsl:value-of select="."/>
            </xsl:when>
            <xsl:otherwise>
                <span class="seg seg-{@type}">
                    <xsl:apply-templates mode="record-data"/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- handing over to aac:stand.xsl -->
    <!--<xsl:template match="seg" mode="record-data">
        <xsl:apply-templates select="."/>
    </xsl:template>-->
    <!--
    <xsl:template match="seg[@type='header']" mode="record-data"/>
    <xsl:template match="seg[@rend='italicised']" mode="record-data">
        <em>
            <xsl:apply-templates mode="record-data"/>
        </em>
    </xsl:template>
    -->

    <xd:doc>
        <xd:desc>
            <xd:p>a rather sloppy section optimized for result from aacnames listPerson/tei:person
                this should occur only in lists, not in text
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="tei:person" mode="record-data">
        <div class="person">
            <xsl:apply-templates select="tei:birth|tei:death|tei:occupation" mode="record-data"/>
            <xsl:variable name="elem-link">
                <xsl:call-template name="elem-link"/>
            </xsl:variable>
            <a href="{$elem-link}">
                <xsl:value-of select="tei:persName"/> in text</a>

            <!--<div class="links">
                <ul>
                    <xsl:apply-templates select="tei:link" mode="record-data"/>
                </ul>
            </div>-->
        </div>
    </xsl:template>

    <xd:doc>
        <xd:desc>Suppressed. Already used as a title.
        </xd:desc>
    </xd:doc>
    <xsl:template match="tei:person/tei:persName" mode="record-data"/>

    <xd:doc>
        <xd:desc>Suppressed. Not directly usable for output.
        </xd:desc>
    </xd:doc>
    <xsl:template match="tei:sex" mode="record-data"/>
    
   
    <xsl:template match="tei:titlePage | tei:docTitle | tei:titlePart | tei:docImprint | tei:pubPlace | tei:docAuthor | tei:docDate | tei:byline | titlePage | docTitle | titlePart | docImprint | pubPlace | docAuthor | docDate | byline" mode="record-data">
        <div>
        <span class="{local-name(.)}">
            <xsl:apply-templates mode="record-data"/>
        </span>
        </div>
    </xsl:template>
   
    <xsl:template match="g|tei:g" mode="record-data">
        <xsl:call-template name="inline">
            <xsl:with-param name="insertTrailingBlank" select="not(ancestor::*[local-name(.) = 'TEI']//*[local-name(.) = 'seg' and @type='whitespace'])"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="w|tei:w" mode="record-data">
        <xsl:variable name="next" select="following-sibling::*[1]"/>
        <!--        <xsl:call-template name="inline"/>-->
        <span class="w-wrap">
            <xsl:if test="@*">
                <span class="attributes" style="display:none;">
                    <xsl:value-of select="concat(@lemma,' ',@type)"/>
                    <!--                <xsl:apply-templates select="@*" mode="format-attr"/>-->
                </span>
            </xsl:if>
            <xsl:call-template name="inline">
                <xsl:with-param name="insertTrailingBlank" select="not((ancestor::tei:TEI|ancestor::TEI)//*[local-name(.) = 'seg' and @type='whitespace'])"/>
            </xsl:call-template>
        </span>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Get the "argument" of color() used in @rend attributes and return it as html inline style attribute.
            <xd:p>Note: assumes only one color().</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="rend-color-as-html-style">
        <xsl:param name="rend-text"/>
        <xsl:choose>
            <xsl:when test="substring-after(string($rend-text), 'color(')">color: #<xsl:value-of select="substring-before(substring-after(string($rend-text), 'color('), ')')"/>;</xsl:when>
            <xsl:otherwise>
                <!-- there is nothing that could be returened, is there? -->
            </xsl:otherwise>
        </xsl:choose>        
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Get everything but the color() part in @rend attributes
            <xd:p>Note: assumes only one color().</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="rend-without-color">
        <xsl:param name="rend-text"/>
        <xsl:choose>
            <xsl:when test="substring-after(string($rend-text), 'color(')"><xsl:value-of select="substring-after(substring-before(string($rend-text), 'color('), ')')"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="string($rend-text)"/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
        
        <xsl:template name="clone">
            <xsl:param name="content"/>
            <xsl:choose>
                <xsl:when test="./self::text()">
                    <xsl:value-of select="$content"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy>
                        <xsl:copy-of select="@*"/>
                        <xsl:call-template name="clone">
                            <xsl:with-param name="content" select="$content"/>
                        </xsl:call-template>
                    </xsl:copy>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:template>
</xsl:stylesheet>