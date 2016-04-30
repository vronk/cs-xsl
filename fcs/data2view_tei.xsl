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
    <xd:doc scope="component">
        <xd:desc>
            <xd:p>This template generates the CSS classes from any element following the convention:</xd:p>
            <xd:ul>
                <xd:li>namespace prefix (tei) + local name</xd:li>
                <xd:li>if present: namespace prefix + "type" + value of @type</xd:li>
                <xd:li>if present: namespace prefix + "rend" + value of @rend</xd:li>
                <xd:li>if present: namespace prefix + "place" + value of @place</xd:li>
                <xd:li>if present: namespace unit + @unit name + value of @unit</xd:li>
            </xd:ul>
            <xd:p>The various parts of a name are concatenated with hyphens. Blanks in @rend are replaced by underscores.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="classnames">
        <xsl:value-of select="concat('tei-',local-name(.))"/>
        <xsl:if test="@type">
            <xsl:value-of select="concat(' tei-type-',@type)"/>
        </xsl:if>
        <xsl:if test="@rend">
            <xsl:value-of select="concat(' tei-rend-',translate(@rend,' ','_'))"/>
        </xsl:if>
        <xsl:if test="@place">
            <xsl:value-of select="concat(' tei-place-',@place)"/>
        </xsl:if>
        <xsl:if test="@unit">
            <xsl:value-of select="concat(' tei-unit-',@unit)"/>
        </xsl:if>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Put TEI content into a div</xd:desc>
    </xd:doc>
    <xsl:template match="TEI | tei:TEI" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <div class="{$class}">
                <xsl:attribute name="class">
                <xsl:choose>
                    <xsl:when test="@xml:id"><xsl:value-of select="concat('tei-TEI ', @xml:id)"/></xsl:when>
                    <xsl:otherwise>tei-TEI</xsl:otherwise>
                </xsl:choose>
                </xsl:attribute>
            <xsl:apply-templates mode="record-data"/>
        </div>
    </xsl:template>

    <xsl:template match="text | front | back | tei:text | tei:front | tei:back" mode="record-data">
        <div class="tei-{local-name()}">
        <xsl:apply-templates mode="record-data"/>
        </div>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Put TEI Header content into a div</xd:desc>
    </xd:doc>
    <xsl:template match="tei:teiHeader" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <div class="{$class}">
            <xsl:apply-templates mode="record-data"/>
        </div>
    </xsl:template>
    <!--<xd:doc>
        <xd:desc>Generate some generelly useful information contained in the TEI header</xd:desc>
    </xd:doc>
    <xsl:template match="tei:fileDesc" mode="record-data">
        <h1>
            <xsl:value-of select="tei:titleStmt/tei:title"/>
        </h1>
        <p class="tei-author">by <xsl:value-of select="tei:author"/>
        </p>
        <p class="tei-publicationStmt">
            <xsl:value-of select="tei:publicationStmt/tei:pubPlace"/>, <xsl:value-of select="tei:publicationStmt/tei:date"/>
        </p>
        <p class="tei-editionStmt">Edition: <xsl:value-of select="tei:editionStmt/tei:edition"/>
        </p>
        <p class="tei-sourceDesc">
            <xsl:for-each select="tei:sourceDesc/tei:p">
                <p>
                    <xsl:value-of select="."/>
                </p>
            </xsl:for-each>
        </p>
        <xsl:choose>
            <xsl:when test="tei:publicationStmt/tei:availability[@status='restricted']">
                <p class="tei-publicationStmt">All rights reserved!</p>
                <xsl:if test="tei:publicationStmt/tei:availability//tei:ref[@type='license']">
                    <p class="tei-ref-license">
                        <a href="{tei:publicationStmt/tei:availability//tei:ref[@type='license']/@target}">License</a>
                    </p>
                </xsl:if>
            </xsl:when>
        </xsl:choose>
    </xsl:template>-->
    <xd:doc>
        <xd:desc>A TEI biblStruct is mapped to a HTML div element</xd:desc>
    </xd:doc>
    <xsl:template match="tei:biblStruct" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <div class="{$class}">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
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
        <span class="tei-authors"><xsl:apply-templates mode="record-data" select="tei:author"
        /></span><span class="xsl-separator tei-title tei-author">: </span><span class="tei-titles"><xsl:apply-templates mode="record-data"
                select="tei:title"/></span>.<xsl:apply-templates mode="record-data"
            select="tei:imprint"/>
    </xsl:template>
    <xd:doc>
        <xd:desc>Presents dependent publications
            <xd:p>
                Convention used is:
            </xd:p>
            <xd:p>
                Author, Author, ... : Title, Title, ... in -&gt; monogr
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="tei:analytic" mode="record-data">
        <span class="tei-authors"><xsl:apply-templates mode="record-data" select="tei:author"
        /></span><span class="xsl-separator tei-title-tei-author-sep">: </span><span class="tei-titles"><xsl:apply-templates mode="record-data"
                select="tei:title"/></span> in </xsl:template>

    <xd:doc>
        <xd:desc>Return text and spacer if needed</xd:desc>
    </xd:doc>
    <xsl:template match="tei:author" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <span class="{$class}">
            <xsl:value-of select="."/>
        </span>
        <xsl:if test="following-sibling::tei:author"><span class="xsl-separator tei-author-sep">, </span>
        </xsl:if>
    </xsl:template>
    <xd:doc>
        <xd:desc>Return text</xd:desc>
    </xd:doc>
    <xsl:template match="tei:imprint/tei:publisher" mode="record-data">
        <span class="tei-publisher">
            <xsl:value-of select="."/>
        </span>
        <xsl:if test="following-sibling::tei:pubPlace">
            <span class="xsl-separator tei-publisher-tei-pubplace-sep">, </span>
        </xsl:if>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Return text and spacer if needed</xd:desc>
    </xd:doc>
    <xsl:template match="tei:title" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <span class="{$class}">
            <xsl:value-of select="."/>
        </span>
        <xsl:if test="following-sibling::tei:title"><span class="xsl-separator tei-title-sep">, </span></xsl:if>
    </xsl:template>
    <xd:doc>
        <xd:desc>TEI Imprint as imprint span</xd:desc>
    </xd:doc>
    <xsl:template match="tei:imprint" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <span class="{$class}">
            <xsl:apply-templates mode="record-data"/>
        </span>.
    </xsl:template>
    <xd:doc>
        <xd:desc>TEI pubPlace as pubPlace span</xd:desc>
    </xd:doc>
    <xsl:template match="tei:imprint/tei:date" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <span class="{$class}">
            <xsl:value-of select="."/>
        </span>
        <xsl:if test="following-sibling::tei:idno|following-sibling::tei:biblScope">
            <xsl:value-of select="'. '"/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:idno[@type='issn']" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <xsl:if test=". != ''">
            <span class="{$class}">ISSN: <xsl:value-of select="."/>
            </span>
            <xsl:if test="following-sibling::tei:biblScope">
                <xsl:value-of select="', '"/>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:biblScope" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <xsl:if test=". != ''">
            <span class="{$class}">
                <xsl:value-of select="."/>
            </span>
            <xsl:if test="following-sibling::tei:biblScope">
                <xsl:value-of select="', '"/>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:biblScope[@type = 'vol']" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <xsl:if test=". != ''">
            <span class="{$class}">Volume: <xsl:value-of select="."/>
            </span>
            <xsl:if test="following-sibling::tei:biblScope">
                <xsl:value-of select="', '"/>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:biblScope[@type = 'issue']" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <xsl:if test=". != ''">
            <span class="{$class}">Issue: <xsl:value-of select="."/>
            </span>
            <xsl:if test="following-sibling::tei:biblScope">
                <xsl:value-of select="', '"/>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:biblScope[@type = 'pages']" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <xsl:if test=". != ''">
            <span class="{$class}">
                <xsl:value-of select="."/> pages</span>
            <xsl:if test="following-sibling::tei:biblScope">
                <xsl:value-of select="', '"/>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:biblScope[@type = 'startPage']" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <xsl:if test=". != ''">
            <span class="{$class}">p. <xsl:value-of select="."/>
            </span>
            <xsl:if test="following-sibling::tei:biblScope">
                <xsl:value-of select="', '"/>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
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
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <ul class="{$class}">
            <xsl:apply-templates mode="record-data"/>
        </ul>
    </xsl:template>
    <xsl:template match="tei:index/tei:term" mode="record-data">
        <xsl:variable name="href">
            <xsl:call-template name="formURL">
                <xsl:with-param name="q" select="concat('vicavTaxonomy=', .)"/>
            </xsl:call-template>
        </xsl:variable>
        <li>
            <xsl:choose>
                <xsl:when test="@type = 'vicavTaxonomy'">
                    <a href="{$href}">
                        <xsl:value-of select="."/>
                    </a>
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
    <xsl:template match="body | tei:body" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <div class="{$class}">
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
    <!--there is already a template for head
        <xsl:template match="tei:head" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <div class="{$class}">
            <xsl:apply-templates mode="tei-body-headings"/>
        </div>
    </xsl:template>
    <xsl:template match="*" mode="tei-body-headings">
        <h2>
            <xsl:apply-templates mode="record-data"/>
        </h2>
    </xsl:template>-->
    <xsl:template match="tei:ref[contains(@target, '.JPG') or                                   contains(@target, '.jpg') or                                  contains(@target, '.PNG') or                                  contains(@target, '.PNG')]" mode="record-data">
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
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <address class="{$class}">
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
        <xd:desc>tei:bibl elements are (???)
        <xd:p>moved to data2view_teiHeader.xsl</xd:p>
        </xd:desc>
    </xd:doc>
    <!--<xsl:template match="bibl | tei:bibl" mode="record-data">
        <xsl:call-template name="inline"/>
    </xsl:template>-->
    <xsl:template match="tei:birth" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <div>
            <span class="label">geboren: </span>
            <span class="{$class}">
                <xsl:if test="@when">
                    <xsl:attribute name="data-when">
                        <xsl:value-of select="@when"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:value-of select="concat(@when, ', ', tei:placeName)"/>
            </span>
        </div>
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
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <span class="{$class}">
            <xsl:apply-templates mode="record-data"/>
        </span>
    </xsl:template>
    <xsl:template match="orig | tei:orig | tei:sic | sic" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <span class="{$class}">
            <xsl:call-template name="inline">
                <xsl:with-param name="insertTrailingBlank" select="not(ancestor::*[local-name(.) = 'TEI']//*[local-name(.) = 'seg' and @type='whitespace'])"/>
            </xsl:call-template>
        </span>
    </xsl:template>
    <xsl:template match="tei:note|note" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <span class="{$class}">
            <xsl:apply-templates mode="record-data"/>
        </span>
    </xsl:template>
    <xsl:template match="tei:corr | corr" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <span class="{$class}">
            <sup>
                <xsl:text>[</xsl:text>
                <xsl:call-template name="inline">
                    <xsl:with-param name="insertTrailingBlank" select="not(ancestor::*[local-name(.) = 'TEI']//*[local-name(.) = 'seg' and @type='whitespace'])"/>
                </xsl:call-template>
                <xsl:text>]</xsl:text>
            </sup>
        </span>
    </xsl:template>
    <xsl:template match="tei:supplied | supplied" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <span class="{$class}">
            <sup>
                <xsl:text>〈</xsl:text>
                <xsl:call-template name="inline">
                    <xsl:with-param name="insertTrailingBlank" select="not(ancestor::*[local-name(.) = 'TEI']//*[local-name(.) = 'seg' and @type='whitespace'])"/>
                </xsl:call-template>
                <xsl:text>〉</xsl:text>
            </sup>
        </span>
    </xsl:template>
    <xsl:template match="tei:reg | reg" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <span class="{$class}">
            <sup>
                <xsl:text>[</xsl:text>
                <xsl:call-template name="inline">
                    <xsl:with-param name="insertTrailingBlank" select="not(ancestor::*[local-name(.) = 'TEI']//*[local-name(.) = 'seg' and @type='whitespace'])"/>
                </xsl:call-template>
                <xsl:text>]</xsl:text>
            </sup>
        </span>
    </xsl:template>
    <xsl:template match="orig | tei:orig | tei:sic | sic" mode="record-data">
        <xsl:call-template name="inline">
            <xsl:with-param name="insertTrailingBlank" select="not(ancestor::*[local-name(.) = 'TEI']//*[local-name(.) = 'seg' and @type='whitespace'])"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="tei:ref|ref|tei:ptr|ptr" mode="record-data"/>

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
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <quote class="{$class}">
            <xsl:apply-templates mode="record-data"/>
        </quote>
    </xsl:template>
    <xd:doc>
        <xd:desc>tei:data elements are formatted as spans with an apropriate class
            <xd:p>Suche elements occur in ... </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="date|tei:date" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <span class="{$class}">
            <!--<xsl:value-of select="."/>-->
            <xsl:apply-templates mode="record-data"/>
            <!--            <span class="note">[<xsl:value-of select="@value"/>]</span>-->
        </span>
    </xsl:template>
    <xsl:template match="tei:death" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <span class="label">gestorben: </span>
        <span class="{$class}" data-when="{@when}">
            <xsl:value-of select="concat(@when, ', ', tei:placeName)"/>
        </span>
    </xsl:template>
    <xd:doc>
        <xd:desc>tei:div elements are mapped to html:div elements
            <xd:p>Note: html:div elements are defined even fuzzier than tei:div elements.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="div|tei:div" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <div class="{$class}">
            <xsl:apply-templates mode="record-data"/>
        </div>
    </xsl:template>
    <xd:doc>
        <xd:desc>tei:p elements are mapped to html:p elements unless they reside inside another tei:p element (e.g. in the construct tei:p/tei:figure/tei:p). <xd:b>This does not use the <xd:ref>classnames</xd:ref> template to produce CSS class names when a @rend attribute is present.</xd:b>
        </xd:desc>
    </xd:doc>
    <xsl:template match="p | tei:p" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <xsl:variable name="elementName">
            <xsl:choose>
                <xsl:when test="ancestor::tei:p or ancestor::p">
                    <xsl:text>span</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>p</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="{$elementName}">
            <xsl:choose>
                <xsl:when test="@rend">
                    <xsl:attribute name="class">
                        <xsl:value-of select="$class"/>
                        <xsl:text xml:space="preserve"> </xsl:text>
                        <xsl:call-template name="rend-without-color">
                            <xsl:with-param name="rend-text" select="@rend"/>
                        </xsl:call-template>
                    </xsl:attribute>
                    <xsl:if test="substring-after(string(@rend), 'color(')">
                        <xsl:attribute name="class">
                            <xsl:value-of select="$class"/>
                        </xsl:attribute>
                        <xsl:attribute name="style">
                            <xsl:call-template name="rend-color-as-html-style">
                                <xsl:with-param name="rend-text" select="@rend"/>
                            </xsl:call-template>
                        </xsl:attribute>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="class">
                        <xsl:value-of select="$class"/>
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates mode="record-data"/>
        </xsl:element>
    </xsl:template>
    <xd:doc>
        <xd:desc>tei:table elements are mapped to html:table elements
            <xd:p>Note: These elements are found eg. in the mecmua transkription.</xd:p>
            <xd:p>There is a class attribute "tei-table" so it is possible to format these
            tables differently form eg. blind tables used elsewhere.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:template match="table|tei:table" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <table class="{$class}">
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
                <xsl:attribute name="colspan">
                    <xsl:value-of select="./@cols"/>
                </xsl:attribute>
            </xsl:if>
                <xsl:choose>
                    <xsl:when test="@style">
                        <xsl:choose>
                            <xsl:when test="contains(@style, ':')">
                                <xsl:attribute name="class">tei-cell</xsl:attribute>
                                <xsl:attribute name="style">
                                    <xsl:value-of select="@style"/>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="class">tei-cell <xsl:value-of select="@style"/>
                                </xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="@rend">
                        <xsl:attribute name="class">tei-cell <xsl:call-template
                                name="rend-without-color">
                                <xsl:with-param name="rend-text" select="@rend"/>
                            </xsl:call-template>
                        </xsl:attribute>
                        <xsl:if test="substring-after(string(@rend), 'color(')">
                            <xsl:attribute name="style">
                                <xsl:call-template name="rend-color-as-html-style">
                                    <xsl:with-param name="rend-text" select="@rend"/>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="class">tei-cell</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                            
            <xsl:apply-templates mode="record-data"/>
        </td>
    </xsl:template>
<!--    <xd:doc>
        <xd:desc>tei:hi is mapped to html:span and @rend is mapped to @class</xd:desc>
        <xd:p>Note these elements are found eg. in the mecmua transkription</xd:p>
    </xd:doc>    
    <xsl:template match="hi | tei:hi" mode="record-data">
        <xsl:variable name="wrapper-class" select="(@rend|@rendition|@style)[1]"/>
        <xsl:choose>
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
    </xsl:template> -->
    
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
                <!-- FIXME This is a temporary hack to allow initial Caps, we need to adjust the "inline" template -->
                <xsl:when test="@rend='initialCapital'">
                    <span class="initialCapital">
                        <xsl:value-of select="substring(normalize-space(.),1,1)"/>
                    </span>
                    <xsl:value-of select="substring(normalize-space(.),2)"/>
                </xsl:when>
                <xsl:when test="@style">
                    <xsl:choose>
                        <xsl:when test="contains(@style, ':')">
                            <xsl:attribute name="class">tei-hi</xsl:attribute>
                            <xsl:attribute name="style">
                                <xsl:value-of select="@style"/>
                            </xsl:attribute>
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
                </xsl:when>
                        </xsl:choose>
            <xsl:apply-templates mode="record-data"/>
            <xsl:if test="not((ancestor::tei:TEI|ancestor::TEI)//*[local-name(.) = 'seg' and @type='whitespace'])">
                <xsl:text> </xsl:text>
            </xsl:if>
                    </div>
                </xsl:for-each>
            </div>
        </div>
    </xsl:template>

    <xd:doc>
        <xd:desc>Lemma form
        <xd:p>
            Default priority="0.5"
            We do enforce latin before arabic script.
        </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="tei:form[@type='lemma' or @type='multiWordUnit']" mode="record-data">
        <span class="tei-form-{@type}">
            <xsl:apply-templates select="tei:orth[not(contains(@xml:lang, '-arabic'))]" mode="record-data"/><xsl:text> </xsl:text>
            <xsl:apply-templates select="tei:orth[contains(@xml:lang, '-arabic')]" mode="record-data"/>
            <xsl:apply-templates select="*[not(name() = 'orth')]" mode="record-data"/>
        </span>        
    </xsl:template>
    
    <xsl:template match="tei:form[@type='inflected']" mode="record-data">
        <span class="tei-form-inflected">
            <xsl:apply-templates select="tei:orth[not(contains(@xml:lang, '-arabic'))]" mode="record-data"/><xsl:text> </xsl:text>
            <xsl:apply-templates select="tei:orth[contains(@xml:lang, '-arabic')]" mode="record-data"/>
            <span class="tei-form-ana">
                <xsl:choose>
                    <xsl:when test="@ana='#adj_f'">f</xsl:when>
                    <xsl:when test="@ana='#adj_pl'">pl</xsl:when>
                    <xsl:when test="@ana='#n_pl'">pl</xsl:when>
                    <xsl:when test="@ana='#v_pres_sg_p3'">pres</xsl:when>
                </xsl:choose>
            </span>
            <xsl:apply-templates select="*[not(name() = 'orth')]" mode="record-data"/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:orth[contains(@xml:lang, '-vicav')]|tei:orth[contains(@xml:lang, '-arabic')]" mode="record-data">
        <span class="tei-orth {@xml:lang}">
            <xsl:apply-templates mode="record-data"/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:gramGrp" mode="record-data">
        <dl class="tei-gramGrp">
            <xsl:apply-templates mode="record-data"/>
        </dl>
    </xsl:template>
    
    <xsl:template match="tei:gram[@type]" mode="record-data">
        <dt class="tei-gram">
            <xsl:call-template name="dict">
                <xsl:with-param name="key" select="@type"/>
            </xsl:call-template>
        </dt>
        <dd class="tei-gram {@type}">
            <xsl:apply-templates mode="record-data"/> 
        </dd>
    </xsl:template>
    
    <xsl:template match="tei:sense" mode="record-data">
        <div class="tei-sense">
            <xsl:if test="tei:def">            
                <div class="tei-defs">
                    <xsl:apply-templates select="tei:def[@xml:lang='en']" mode="record-data"/>
                    <xsl:apply-templates select="tei:def[@xml:lang='de']" mode="record-data"/>
                    <xsl:apply-templates select="tei:def[not(@xml:lang='en' or @xml:lang='de')]" mode="record-data"/>               
                    </div>
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
            </xsl:if>
            </div>
    </xsl:template>
    <xd:doc>
        <xd:desc>tei:foreign elements are formatted as divs with an apropriate language class
            <xd:p>Suche elements occur in ... </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="foreign | tei:foreign" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <span class="{$class}">
            <xsl:if test="@xml:lang">
                <xsl:copy-of select="@xml:lang"/>
            </xsl:if>
            <xsl:apply-templates mode="record-data"/>
            <!--<xsl:if test="@xml:lang">
                <sup>
                    <xsl:value-of select="@xml:lang"/>
                </sup>
            </xsl:if>-->
        </span>
    </xsl:template>
    <xsl:template match="fw | tei:fw" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <span class="{$class}">
            <xsl:call-template name="inline">
                <xsl:with-param name="insertTrailingBlank" select="not(ancestor::*[local-name(.) = 'TEI']//*[local-name(.) = 'seg' and @type='whitespace'])"/>
            </xsl:call-template>
        </span>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>tei:geo elements are mapped to spans optionally as link to more
            information.</xd:desc>
    </xd:doc>    
    <xsl:template match="geo | tei:geo" mode="record-data">
        <xsl:call-template name="inline">
            <xsl:with-param name="insertTrailingBlank"
                select="not(ancestor::*[local-name(.) = 'TEI']//*[local-name(.) = 'seg' and @type='whitespace'])"
            />
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="head | tei:head " mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <span class="{$class}">
            <xsl:call-template name="inline">
                <xsl:with-param name="insertTrailingBlank" select="not((ancestor::tei:TEI|ancestor::TEI)//*[local-name(.) = 'seg' and @type='whitespace'])"/>
            </xsl:call-template>
        </span>
    </xsl:template>
    <xd:doc>
        <xd:desc>tei:hi is mapped to html:span.</xd:desc>
        <xd:p>Note these elements are found eg. in the mecmua transkription</xd:p>
    </xd:doc>
    <xsl:template match="hi | tei:hi" mode="record-data">
        <xsl:variable name="wrapper-class" select="(@rend|@rendition|@style)[1]"/>
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="@rend or @rendition or @style">
                <span class="{$wrapper-class} {$class}">
                    <xsl:call-template name="inline">
                        <xsl:with-param name="insertTrailingBlank" select="not((ancestor::tei:TEI|ancestor::TEI)//*[local-name(.) = 'seg' and @type='whitespace'])"/>
                    </xsl:call-template>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="{$class}">
                    <xsl:call-template name="inline">
                    <xsl:with-param name="insertTrailingBlank" select="not((ancestor::tei:TEI|ancestor::TEI)//*[local-name(.) = 'seg' and @type='whitespace'])"/>
                </xsl:call-template>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xd:doc>
        <xd:desc>tei:l elements are expanded and a html:br element as added.</xd:desc>
    </xd:doc>
    <xsl:template match="l | tei:l" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <span class="{$class}">
            <xsl:apply-templates mode="record-data"/>
        </span>
        <br/>
    </xsl:template>
    <xd:doc>
        <xd:desc>lb elements may also be used to mark up horizontal rules of various types. These are distinguished by values in the @rend attribute</xd:desc>
    </xd:doc>
    <xsl:template match="lb | tei:lb" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="@rend='line'">
                <span class="{$class}">&#160;</span>
            </xsl:when>
            <xsl:when test="@rend='line_high'">
                <span class="{$class}">&#160;</span>
            </xsl:when>
            <xsl:when test="@type='d'">
                <xsl:text>=</xsl:text>
                <br/>
            </xsl:when>
            <xsl:when test="@type='s'">
                <xsl:text>-</xsl:text>
                <br/>
            </xsl:when>
            <xsl:otherwise>
                <br/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>although they are block level elements, tei:lg are transformed into html:spans, because they may reside inside a tei:p (html:p) element, e.g. in tei:p/tei:figure/tei:lg - block level rendering has to be done with CSS styling.</xd:desc>
    </xd:doc>
    <xsl:template match="lg | tei:lg" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <span class="{$class}">
                <xsl:apply-templates mode="record-data"/>
        </span>
    </xsl:template>
    <xsl:template match="tei:link" mode="record-data">
        <li>
            <a href="{@target}">
                <xsl:value-of select="@target"/>
            </a>
        </li>
    </xsl:template>
    <xd:doc>
        <xd:desc>tei:milestone elements are not retained</xd:desc>
        <xd:p>Replced by three dots (...)</xd:p>
    </xd:doc>
    <xsl:template match="milestone | tei:milestone" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="@type[.='hr'] and @rend[.='line']">
                <span class="{$class}">&#160;</span>
                <span style="color:red;">[usage of <code>milestone type="hr"</code> is deprecated, use tei:lb instead]</span>
            </xsl:when>
            <xsl:when test="@type[.='hr'] and @rend[.='high']">
                <!--<span><hr class="hr-high"/></span>-->
                <span class="{$class}">&#160;</span>
                <span style="color:red;">[usage of <code>milestone type="hr"</code> is deprecated, use tei:lb instead]</span>
            </xsl:when>
            <xsl:when test="@type[.='hr'] and @rend[.='dotted']">
                <span class="{$class}">&#160;</span>
            </xsl:when>
            <xsl:when test="@type[.='separator'] and @rend[.='hr']">
                <span class="{$class}">&#160;</span>
            </xsl:when>
            <xsl:when test="@type[.='separator'] and @rend[.='asterisk']">
                <span class="{$class}">*</span>
            </xsl:when>
            <xsl:when test="@type[.='separator'] and @rend[.='asterism']">
                <span class="{$class}">*&#160;&#160;*&#160;&#160;*</span>
            </xsl:when>
            <xsl:when test="@type[.='separator'] and @rend[.='asterismUp']">
                <span class="{$class}">*&#160;&#160;<sup>*</sup>&#160;&#160;*</span>
            </xsl:when>
            <xsl:when test="@type[.='separator'] and @rend[.='asterismDown']">
                <p style="text-align:center">*&#160;&#160;<sub>*</sub>&#160;&#160;*</p>
            </xsl:when>
            <xsl:when test="@type[.='separator'] and (@rend[.='undefined'] or @unit[.='undetermined'])">
                <p class="{$class}">⌫⌦</p>
            </xsl:when>
            <xsl:when test="@type[.='symbol'] and @rend[.='blEtc']">રc.</xsl:when>
            <xsl:when test="@type[.='symbol'] and @rend[.='brackets' or .='bracketsTC']">
                <xsl:if test="preceding-sibling::*[1]/*[self::milestone or self::tei:milestone]/@rend[.='brackets' or .='bracketsTC']">
                    <xsl:text>&#160;</xsl:text>
                </xsl:if>
                <span class="{$class}" style="font-size:18pt;">)(</span>
                <span style="color:red;">[usage of <code>milestone type="symbol" rend="brackets"</code> is deprecated, use g element with @ref='#brackets' instead]</span>
            </xsl:when>
            <xsl:when test="@type[.='symbol'] and @rend[.='flower']">✾
                <span style="color:red;">[usage of <code>milestone type="symbol" rend="flower"</code> is deprecated, use appropriate unicode character instead]</span>
            </xsl:when>
            <xsl:when test="@type[.='symbol'] and @rend[.='footerDots']">
                <span class="{$class}">.&#160;<sup style="font-size: inherit;position: relative;top: -5px;">.</sup>&#160;.</span>
                <span style="color:red;">[usage of <code>milestone type="symbol" rend="footerDots"</code> is deprecated, use <code>&lt;g ref=#footerdots&gt;</code> instead]</span>
            </xsl:when>
            <xsl:when test="@type[.='symbol'] and @rend[.='Aquarius']">
                <span style="font-size:14pt;">♒</span>
                <span style="color:red;">[usage of <code>milestone type="symbol" rend="Aquarius"</code> is deprecated, use appropriate unicode character instead]</span>
            </xsl:when>
            <xsl:when test="@type[.='symbol'] and @rend[.='Mars']">
                <span style="font-size:14pt;">♂</span>
                <span style="color:red;">[usage of <code>milestone type="symbol" rend="Mars"</code> is deprecated, use appropriate unicode character instead]</span>
            </xsl:when>
            <xsl:when test="@type[.='symbol'] and @rend[.='Saturn']">
                <span style="font-size:14pt;">♄</span>
                <span style="color:red;">[usage of <code>milestone type="symbol" rend="Saturn"</code> is deprecated, use appropriate unicode character instead]</span>
            </xsl:when>
            <xsl:when test="@type[.='symbol'] and @rend[.='Jupiter']">
                <span style="font-size:14pt;">♃</span>
                <span style="color:red;">[usage of <code>milestone type="symbol" rend="Jupiter"</code> is deprecated, use appropriate unicode character instead]</span>
            </xsl:when>
            <xsl:when test="@type[.='symbol'] and @rend[.='Merkur']">
                <span style="font-size:14pt;">☿</span>
                <span style="color:red;">[usage of <code>milestone type="symbol" rend="Merkur"</code> is deprecated, use appropriate unicode character instead]</span>
            </xsl:when>
            <xsl:when test="@type[.='symbol'] and @rend[.='Virgo']">
                <span style="font-size:14pt;">♍</span>
                <span style="color:red;">[usage of <code>milestone type="symbol" rend="Virgo"</code> is deprecated, use appropriate unicode character instead]</span>
            </xsl:when>
            <xsl:when test="@type[.='symbol'] and @rend[.='undefined']">
                <b>☉</b>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>...</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:occupation" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <div class="{$class}">
            <xsl:value-of select="."/>
        </div>
    </xsl:template>
    <xsl:template match="epigraph | tei:epigraph" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <span class="{$class}">
            <xsl:apply-templates mode="record-data"/>
        </span>
    </xsl:template>
    <xsl:template match="figure | tei:figure" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <span class="{$class}">
            <xsl:apply-templates mode="record-data"/>
        </span>
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
    <xd:doc>
        <xd:desc>tei:persName, tei:placeName etc. elements are mapped to spans optionally as link to more information.</xd:desc>
    </xd:doc>
    <xsl:template match="name | persName | placeName | tei:name | tei:persName | tei:placeName" mode="record-data">
        <xsl:call-template name="inline">
            <xsl:with-param name="additional-style" select="string(../@rend)"/>
            <xsl:with-param name="insertTrailingBlank" select="not(//*[local-name(.) = 'seg' and @type='whitespace'])"/>
            <xsl:with-param name="descendants-to-ignore" select="'fw'"/>
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
    <!-- for STB: dont want seg -->
    <!--    <xsl:template match="seg | tei:seg" mode="record-data"/>-->
    <xsl:template match="seg | tei:seg" mode="record-data">
        <!--<xsl:call-template name="inline"/>-->
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <span class="{$class}">
            <xsl:choose>
                <xsl:when test="@type[.='whitespace' or .='ws']" xml:space="preserve">
                    <!--<xsl:value-of select="translate(.,' ',' ')"/>-->
                    <xsl:value-of select="."/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates mode="record-data"/>
                </xsl:otherwise>
            </xsl:choose>
        </span>      
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
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <div class="{$class}">
            <xsl:apply-templates mode="record-data" select="tei:birth|tei:death|tei:occupation"/>
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
    <xsl:template match="tei:docTitle | tei:titlePart | tei:docImprint | tei:pubPlace | tei:docAuthor | tei:docDate | docTitle | titlePart | docImprint | pubPlace | docAuthor | docDate" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <span class="{$class}">
            <xsl:apply-templates mode="record-data"/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:titlePage | tei:byline | titlePage | byline" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <div>
            <span class="{$class}">
                <xsl:apply-templates mode="record-data"/>
            </span>
        </div>
    </xsl:template>
    
    <xsl:template match="g|tei:g" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <span class="{$class}">
            <xsl:choose>
                <!-- to be deprecated -->
                <xsl:when test="@ref='#rc-glyph'">
                    <span class="{$class} rc-glyph">
                        <i>r</i>
                        <xsl:text>c</xsl:text>
                    </span>
                </xsl:when>
                <xsl:when test="@ref='#tironian-et'">
                    <span class="{$class} tironian-et">
                        <i>
                            <xsl:value-of select="."/>
                        </i>
                    </span>
                </xsl:when>
                <xsl:when test="@ref='#footerDots'">
                    <span class="{$class}">.&#160;<sup style="font-size: inherit;position: relative;top: -5px;">.</sup>&#160;.</span>
                </xsl:when>
                <xsl:when test="@ref='#brackets'">
                    <xsl:if test="preceding-sibling::*[1]/*[self::g or self::tei:g][@rend = 'brackets']">
                        <xsl:text>&#160;</xsl:text>
                    </xsl:if>
                    <span class="{$class}" style="font-size:18pt;">)(</span>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="inline">
                        <xsl:with-param name="insertTrailingBlank" select="not(ancestor::*[local-name(.) = 'TEI']//*[local-name(.) = 'seg' and @type='whitespace'])"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:template>

    <xsl:template match="tei:w" mode="record-data">
        <xsl:choose>
            <xsl:when test="tei:fs/tei:f[@name='wordform']">
                <!-- Special handling for notations like those used in sample texts -->
        <!-- XPath 1.0 if trick: from http://stackoverflow.com/questions/971067/is-there-an-if-then-else-statement-in-xpath and
        http://www.tkachenko.com/blog/archives/000156.html Becker's method, relies on substring start argument bigger than string lenght
        returns empty string and number(false) = 0, number(true) = 1. -->
        <!-- XPath 2.0:  if (tei:fs/tei:f[@name = 'pos']) then 'pos ' else '' -->
        <xsl:variable name="pos"
            select="concat(substring('pos ', number(not(tei:fs/tei:f[@name = 'pos'])) * string-length('pos ') + 1),
            substring('', number(tei:fs/tei:f[@name = 'pos']) * string-length('') + 1))"/>
        <span class="tei-w {$pos}{tei:fs/tei:f[@name = 'pos']}">
                    <xsl:if test="(tei:fs/tei:f[@name='wordform'])[@xml:lang]">
                        <xsl:attribute name="data-lang">
                            <xsl:value-of select="(tei:fs/tei:f[@name='wordform'])/@xml:lang"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="tei:fs/tei:f[@name='wordform']"/>
                    <xsl:apply-templates mode="record-data"/>
                </span>
                </xsl:when>
                <xsl:otherwise>
                <xsl:call-template name="inline">
                        <xsl:with-param name="insertTrailingBlank"
                            select="not((ancestor::tei:TEI|ancestor::TEI)//*[local-name(.) = 'seg' and @type='whitespace'])"
                        />
                </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>

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
            <xsl:when test="substring-after(string($rend-text), 'color(')">
                <xsl:value-of select="substring-after(substring-before(string($rend-text), 'color('), ')')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="string($rend-text)"/>
            </xsl:otherwise>
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