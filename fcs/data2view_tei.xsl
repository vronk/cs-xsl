<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:aac="urn:general" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:sru="http://www.loc.gov/zing/srw/" xmlns:exist="http://exist.sourceforge.net/NS/exist" xmlns:exsl="http://exslt.org/common" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" version="1.0" exclude-result-prefixes="xsl exsl aac tei sru exist xd">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>Stylesheet for formatting TEI-elements inside a FCS/SRU-result. the TEI-elements
                are expected without namespace (!) (just local names) This is not nice, but is
                currently in results like that.</xd:p>
            <xd:p> The templates are sorted by TEI-elements they match. if the same transformation
                applies to multiple elements, it is extracted into own named-template and called
                from the matching templates. the named templates are at the bottom.</xd:p>
        </xd:desc>
    </xd:doc>

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
                    <xsl:when test="@xml:id">
                        <xsl:value-of select="concat('tei-TEI ', @xml:id)"/>
                    </xsl:when>
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
    <xd:doc>
        <xd:desc>Generate some generally useful information contained in the TEI header</xd:desc>
    </xd:doc>
    <xsl:template match="tei:fileDesc" mode="record-data">
        <h1>
            <xsl:value-of select="tei:titleStmt/tei:title"/>
        </h1>
        <p class="tei-authors">
            <xsl:apply-templates select="tei:author" mode="record-data"/>
        </p>
        <p class="tei-publicationStmt">
            <xsl:value-of select="tei:publicationStmt/tei:pubPlace"/>,
                <xsl:value-of select="tei:publicationStmt/tei:date"/>
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
    </xsl:template>
    
    <xd:doc>
        <xd:desc>revisionDesc is not meaningful right now, content may be referenced elsewhere</xd:desc>
    </xd:doc>
    <xsl:template match="tei:revisionDesc" mode="record-data"/>
    
    <xsl:template match="tei:change">
        <xsl:value-of select="text()"/>
        <xsl:if test="tei:fs">
            Last changed <xsl:value-of select="tei:fs/tei:f[@name='when']/tei:symbol/@value"/> by <xsl:value-of select="tei:fs/tei:f[@name='who']/tei:symbol/@value"/>
        </xsl:if>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>encodingDesc is not meaningful right now, content may be referenced elsewhere</xd:desc>
    </xd:doc>
    <xsl:template match="tei:encodingDesc" mode="record-data"/>
    
    <xd:doc>
        <xd:desc>A table listing all the latin diacritics used in transliterates content.</xd:desc>
    </xd:doc>
    <xsl:template match="tei:charDecl" mode="record-data">
        <xsl:variable name="mapping-list">
            <xsl:call-template name="get-char-mappings"/>
        </xsl:variable>
        <table class="tei-charDecl">
            <thead>
                <tr>
                    <th class="tei-charProp-value"><xsl:call-template name="dict">
                        <xsl:with-param name="key">VICAV</xsl:with-param>
                    </xsl:call-template></th>
                    <xsl:for-each select="exsl:node-set($mapping-list)/tei:mapping">
                        <th class="tei-mapping-{@type}"><xsl:call-template name="dict">
                            <xsl:with-param name="key" select="@type"/>
                        </xsl:call-template></th>                
                    </xsl:for-each>
                    <th class="tei-charProp-localName"><xsl:call-template name="dict">
                        <xsl:with-param name="key">Sound Description</xsl:with-param>
                    </xsl:call-template></th>   
                    <th class="tei-charProp-unicodeName"><xsl:call-template name="dict">
                        <xsl:with-param name="key">Unicode Character Name</xsl:with-param>
                    </xsl:call-template></th>           
                </tr>
            </thead>
            <tbody>
                <xsl:apply-templates mode="record-data"/>
            </tbody>
        </table>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Customization point that returns a list of all mappings of characters
            that are used in this resource.
        <xd:p>Note: There is no meaningful default.</xd:p>
        <xd:p>
           Example:<xd:pre>
        &lt;tei:mapping type="arabic"/>
        &lt;tei:mapping type="vicavMSA"/>
        &lt;tei:mapping type="DIN"/>
        &lt;tei:mapping type="IPA"/>
        &lt;tei:mapping type="chat"/>                
           </xd:pre> 
        </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="get-char-mappings"/>      
    
    <xd:doc>
        <xd:desc>A table row for each diacritic latin character described in encodingDesc</xd:desc>
    </xd:doc>
    <xsl:template match="tei:char" mode="record-data">
        <xsl:variable name="mapping-list">
            <xsl:call-template name="get-char-mappings"/>
        </xsl:variable>
        <xsl:variable name="cur-char" select="."/>
        <tr>
            <td class="tei-charProp-value"><xsl:value-of select="tei:charProp/tei:value"/></td>
            <xsl:for-each select="exsl:node-set($mapping-list)/tei:mapping">
                <xsl:variable name="type" select="./@type"/>
                <td class="tei-mapping-{$type}"><xsl:call-template name="string-join">
                    <xsl:with-param name="nodes-to-join" select="exsl:node-set($cur-char)/tei:mapping[@type=$type]"/>
                    <xsl:with-param name="join-with">,</xsl:with-param>
                </xsl:call-template></td>
            </xsl:for-each>
            <td class="tei-charProp-localName"><xsl:value-of select="tei:charProp/tei:localName"/></td>
            <td class="tei-charProp-unicodeName"><xsl:value-of select="tei:charProp/tei:unicodeName"/></td>
        </tr>    
    </xsl:template>
    
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
        <xd:desc>Presents monographs <xd:p> Convention used is: </xd:p>
            <xd:p> Author, Author, ... : Title, Title, ... </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="tei:monogr" mode="record-data">
        <span class="tei-authors">
            <xsl:apply-templates mode="record-data" select="tei:author"/>
        </span>
        <span class="xsl-separator tei-title tei-author">: </span>
        <span class="tei-titles">
            <xsl:apply-templates mode="record-data" select="tei:title"/>
        </span>.<xsl:apply-templates mode="record-data" select="tei:imprint"/>
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
        <xsl:if test="./text() != ''">
        <span class="tei-publisher">
            <xsl:value-of select="."/>
        </span>
        <xsl:if test="following-sibling::tei:pubPlace">
            <span class="xsl-separator tei-publisher-tei-pubplace-sep">, </span>
        </xsl:if>
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
        </span><span class="xsl-separator tei-imprint-sep">.</span>
    </xsl:template>
    <xd:doc>
        <xd:desc>TEI pubPlace as pubPlace span</xd:desc>
    </xd:doc>
    <xsl:template match="tei:pubPlace[parent::tei:imprint]" mode="record-data">
        <xsl:if test="./text() != ''">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <span class="{$class}">
            <xsl:value-of select="."/>
        </span>
        </xsl:if>
    </xsl:template>

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
        <xd:desc>In bibliographies a series in which a monography was published.</xd:desc>
    </xd:doc>
    <xsl:template match="tei:series" mode="record-data">
        <xsl:if test="./text() != ''">
        <div class="tei-series">
            <xsl:apply-templates mode="record-data"/><span class="xsl-separator tei-imprint-sep">.</span></div>
        </xsl:if>
    </xsl:template>
    <xd:doc>
        <xd:desc>Series as part of imprint</xd:desc>
    </xd:doc>
    <xsl:template match="tei:series[parent::tei:imprint]" mode="record-data">
        <xsl:if test="./text() != ''">
            <span class="xsl-separator tei-imprint-sep">. In: </span><span class="tei-series"><xsl:apply-templates mode="record-data"/></span>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:settlement|settlement" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <span class="{$class}">
            <xsl:apply-templates mode="record-data"/>
        </span>
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
        <div class="indexTerms">
            <ul class="{$class}">
                <xsl:apply-templates mode="record-data"/>
            </ul>
        </div>
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
                    <a href="{$href}" class="search-caller">
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
        <xd:desc>A head section is assumed to contain a number of headings <xd:p> To generate HTML
                headings from these we use another mode. If you want the heading to contain an
                author you can supersede the getAuthor template in your projects customization.
            </xd:p>
        </xd:desc>
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
        <xd:desc>Count div elemetents that are ancestor of this node and have a tei:head element</xd:desc>
    </xd:doc>
    <xsl:template name="tei-div-count">
        <xsl:variable name="div-count-raw" select="count(./ancestor-or-self::tei:div[tei:head|@type])"/>
        <xsl:choose>
            <xsl:when test="./ancestor::tei:body/tei:head">
                <xsl:value-of select="$div-count-raw + 1"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$div-count-raw"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>Utillity "function" to get the contetn into the right header tag
            <xd:p>To generate a contents (back) link set the variable $contents-link
                to the approproiate link target (#id).
            </xd:p>
            
        </xd:desc>
    </xd:doc>
    <xsl:template name="div-count-to-html-header">
        <xsl:param name="div-count" select="1"/>
        <xsl:param name="content"/>
        <xsl:param name="id" select="concat(//tei:TEI/@xml:id, '-', @xml:id)"/>
        <xsl:param name="contents-target" select="$contents-target"/>
        <xsl:choose>
            <xsl:when test="$div-count = 1">
                <h1>
                    <xsl:if test="$id">
                        <xsl:attribute name="id">
                            <xsl:value-of select="$id"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:copy-of select="$content"/>
                </h1>
            </xsl:when>
            <xsl:when test="$div-count = 2">
                <h2>
                    <xsl:if test="$id">
                        <xsl:attribute name="id">
                            <xsl:value-of select="$id"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:copy-of select="$content"/>
                </h2>
            </xsl:when>
            <xsl:when test="$div-count = 3">
                <h3>
                    <xsl:if test="$id">
                        <xsl:attribute name="id">
                            <xsl:value-of select="$id"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:copy-of select="$content"/>
                </h3>
            </xsl:when>
            <xsl:when test="$div-count = 4">
                <h4>
                    <xsl:if test="$id">
                        <xsl:attribute name="id">
                            <xsl:value-of select="$id"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:copy-of select="$content"/>
                </h4>
            </xsl:when>
            <xsl:when test="$div-count = 5">
                <h5>
                    <xsl:if test="$id">
                        <xsl:attribute name="id">
                            <xsl:value-of select="$id"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:copy-of select="$content"/>
                </h5>
            </xsl:when>
            <xsl:otherwise>
                <h6>
                    <xsl:if test="$id">
                        <xsl:attribute name="id">
                            <xsl:value-of select="$id"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:copy-of select="$content"/>
                </h6>
                <!-- there are no more html h tags! -->
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="$contents-target">
            <a class="xsl-aContents" href="{$contents-target}">
                <xsl:call-template name="dict">
                    <xsl:with-param name="key">Go to contents</xsl:with-param>
                </xsl:call-template>
            </a>
        </xsl:if>
    </xsl:template>
    
    <xsl:variable name="contents-target"/>

    <xsl:template name="getAuthor"/>
    
    <xsl:template match="tei:*" mode="record-data" priority="-1">
        <xsl:call-template name="inline"/>
    </xsl:template>
    <xsl:template match="tei:ref[contains(@target, '.JPG') or
        contains(@target, '.jpg') or
        contains(@target, '.PNG') or
        contains(@target, '.PNG')]" mode="record-data">
        <xsl:call-template name="generateImgHTMLTags"/>
    </xsl:template>
    
    <xsl:template match="tei:*" mode="tei-body-headings">
        <xsl:call-template name="div-count-to-html-header">
            <xsl:with-param name="div-count">
                <xsl:call-template name="tei-div-count"/>
            </xsl:with-param>
            <xsl:with-param name="content">
                <xsl:apply-templates mode="record-data"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xd:doc>
        <xd:desc>Generate headings according to the type attribute of a div <xd:p> Superseed this in
                your local projects xsl if you want to adapt it. </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="typeToHeading">
        <xsl:call-template name="typeToHeading_base"/>
    </xsl:template>

    <xd:doc>
        <xd:desc>Default implementation of the type lookup <xd:p>This uses the dict.xml file.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="typeToHeading_base">
        <xsl:variable name="lookup" select="@type"/>
        <xsl:call-template name="div-count-to-html-header">
            <xsl:with-param name="div-count">
                <xsl:call-template name="tei-div-count"/>
            </xsl:with-param>
            <xsl:with-param name="content">
                <xsl:call-template name="dict">
                    <xsl:with-param name="key" select="@type"/>
                </xsl:call-template>
            </xsl:with-param>
        </xsl:call-template>            
    </xsl:template>

    <xsl:template match="tei:div[@type]" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <div class="{$class}">
            <xsl:call-template name="typeToHeading"/>
            <xsl:apply-templates mode="record-data"/>
        </div>
    </xsl:template>
    <xd:doc>
        <xd:desc>some special elements retained in data, due to missing correspondencies in tei if
            it will get more, we should move to separate file</xd:desc>
    </xd:doc>
    <xsl:template match="aac_HYPH1 | aac:HYPH1" mode="record-data">
        <xsl:apply-templates/>
        <xsl:text> </xsl:text>
    </xsl:template>
    <xd:doc>
        <xd:desc>some special elements retained in data, due to missing correspondencies in tei if
            it will get more, we should move to separate file</xd:desc>
    </xd:doc>
    <xsl:template match="aac_HYPH2  | aac:HYPH2" mode="record-data">
        <xsl:apply-templates/>
        <xsl:text> </xsl:text>
    </xsl:template>
    <xd:doc>
        <xd:desc>some special elements retained in data, due to missing correspondencies in tei if
            it will get more, we should move to separate file</xd:desc>
    </xd:doc>
    <xsl:template match="aac_HYPH3  | aac:HYPH3" mode="record-data">
        <xsl:apply-templates/>
        <xsl:text> </xsl:text>
    </xsl:template>
    <xd:doc>
        <xd:desc>tei:address elements are mapped to html:address (???) elements <xd:p>Suche elements
                occur in ... </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="address | tei:address" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <address class="{$class}">
            <xsl:if test="tei:street">
                <xsl:value-of select="tei:street"/>
                <xsl:call-template name="br"/>
            </xsl:if>
            <xsl:if test="tei:postCode | tei:settlement">
                <xsl:value-of select="tei:postCode"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="tei:settlement"/>
                <xsl:call-template name="br"/>
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
    <xsl:template match="tei:ref|ref" mode="record-data"/>
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
    <xsl:template match="tei:ref|ref" mode="record-data"/>
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
        <xd:desc>tei:cit elements are mapped to html:quote elements <xd:p>Suche elements occur in
                ... </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="cit|tei:cit" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <quote class="{$class}">
            <xsl:apply-templates mode="record-data"/>
        </quote>
    </xsl:template>
    <xd:doc>
        <xd:desc>tei:data elements are formatted as spans with an apropriate class <xd:p>Suche
                elements occur in ... </xd:p>
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
        <xd:desc>tei:div elements are mapped to html:div elements <xd:p>Note: html:div elements are
                defined even fuzzier than tei:div elements.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="div|tei:div" mode="record-data">
<!-- needs merging generic class attribute with specific generation -  check - FIXME -->
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>

        <div>
            <xsl:choose>
                <xsl:when test="@rend|@type">
                    <xsl:attribute name="class">
                        <xsl:value-of select="concat('tei-div ', @rend, ' ', @type)"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="class">tei-div</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates mode="record-data"/>
        </div>
    </xsl:template>
    <xd:doc>
        <xd:desc>tei:p elements are mapped to html:p elements</xd:desc>
        <xd:p>A style attribute is either <xd:ul>
                <xd:li>translated into a html style attribute if it contains even one ':'</xd:li>
                <xd:li>or it is translated into a class attribute</xd:li>
            </xd:ul>
        </xd:p>       
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
        <xsl:element name="{$elementName}" namespace="http://www.w3.org/1999/xhtml">
            <xsl:choose>
<!-- FIXME: needs merging 
                <xsl:when test="@style">
                    <xsl:choose>
                        <xsl:when test="contains(@style, ':')">
                            <xsl:attribute name="class">tei-p</xsl:attribute>
                            <xsl:attribute name="style">
                                <xsl:value-of select="@style"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="class">tei-p <xsl:value-of select="@style"/>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
-->
                <xsl:when test="@rend">
                    <xsl:attribute name="class">
                        <xsl:value-of select="$class"/>
                        <xsl:text> </xsl:text>
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
        <xd:desc>TEI ptr elements are mapped to "Click here" links
        </xd:desc>
    </xd:doc>
    <xsl:template match="tei:ptr|ptr" mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <a href="{@target}" class="{$class}">Click here!</a>
</xsl:template>

    <xsl:template match="tei:ptr[not(contains(@target, '.JPG') or
        contains(@target, '.jpg') or
        contains(@target, '.PNG') or
        contains(@target, '.png') or
        substring(@target, 1, 1) = '#')]" mode="record-data">
        <xsl:call-template name="generateTarget"/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>TEI ref elements are mapped to links that contain the contents of ref 
        </xd:desc>
    </xd:doc>
    <xsl:template match="tei:ref[not(contains(@target, '.JPG') or          contains(@target, '.jpg') or         contains(@target, '.PNG') or         contains(@target, '.png'))]" mode="record-data">
        <xsl:call-template name="generateTarget">
            <xsl:with-param name="linkText">
                <xsl:apply-templates mode="record-data"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
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
    <xsl:template match="tei:ptr[contains(@target, '.JPG') or
        contains(@target, '.jpg') or
        contains(@target, '.PNG') or
        contains(@target, '.png')]" mode="record-data">
        <xsl:call-template name="generateImgHTMLTags"/>
    </xsl:template>
    
    <xsl:template match="tei:ptr[substring(@target, 1, 1) = '#']"
        mode="record-data">
        <xsl:variable name="target_id" select="substring(@target,2)"/>
        <xsl:apply-templates select="//*[@xml:id=$target_id]" mode="record-data"/>
    </xsl:template>
    
    <xsl:template match="tei:ref[contains(@target, '.JPG') or
        contains(@target, '.jpg') or
        contains(@target, '.PNG') or
        contains(@target, '.png')]" mode="record-data">
        <xsl:call-template name="generateImgHTMLTags">
            <xsl:with-param name="altText">
                <xsl:value-of select="."/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Special handling of target declarations that point to other resources
            <xd:p> Note: You most likely have
                to supply you're own logic by superseding this. </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="generateTarget">
        <xsl:param name="linkText" select="'Click here'"/>
        <xsl:choose>
            <xsl:when test="starts-with(@target, 'http://') or starts-with(@target, 'https://')">
                <a href="{@target}" target="_blank">
                    <xsl:value-of select="$linkText"/>
                </a>
            </xsl:when>
            <xsl:when test="starts-with(@target, '/')">
                <a href="{@target}" class="value-caller">
                    <xsl:value-of select="$linkText"/>
                </a>
            </xsl:when>
            <xsl:when test="contains(@target, '|')">
                <xsl:variable name="linkTarget">
                    <xsl:call-template name="formURL">
                        <xsl:with-param name="action">searchRetrieve</xsl:with-param>
                        <xsl:with-param name="q" select="substring-after(@target, '|')"/>
                        <xsl:with-param name="x-context" select="substring-before(@target, '|')"/>
                    </xsl:call-template>
                </xsl:variable>
                <a href="{$linkTarget}" class="search-caller">
                    <xsl:value-of select="$linkText"/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="linkTarget">
                    <xsl:call-template name="formURL">
                        <xsl:with-param name="action">explain</xsl:with-param>
                        <xsl:with-param name="x-context" select="@target"/>
                        <xsl:with-param name="q" select="@target"/>
                    </xsl:call-template>
                </xsl:variable>
                <a href="{$linkTarget}" class="value-caller">
                    <xsl:value-of select="$linkText"/>
                </a>
            </xsl:otherwise>
            
        </xsl:choose>        
    </xsl:template>
    <xd:doc>
        <xd:desc>Generates img tags from ref or ptr. Generic handler for image references passed by the facs data view.
        <xd:p>Supersede this if you want to change the default lookup path for example.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="generateImgHTMLTags">
        <xsl:param name="altText" select="@target"/>
        <xsl:choose>
            <xsl:when test="@ref">
                <img src="{@ref}" alt="{@ref}"/>
            </xsl:when>
            <xsl:when test="starts-with(@target, 'http://') or starts-with(@target, '/') or starts-with(@target, 'https://')">
                <img src="{@target}" alt="{$altText}"/>
            </xsl:when>
            <xsl:otherwise>
                <span class="cs-xsl-error">You need to supersede the generateImgHTMLTags template in your project's XSL customization!</span>                
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>tei:table elements are mapped to html:table elements <xd:p>Note: These elements are
                found eg. in the mecmua transkription.</xd:p>
            <xd:p>There is a class attribute "tei-table" so it is possible to format these tables
                differently form eg. blind tables used elsewhere.</xd:p>
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
        <xd:desc>tei:row elements are mapped to html:tr elements </xd:desc>
    </xd:doc>
    <xsl:template match="row|tei:row" mode="record-data">
        <tr>
            <xsl:apply-templates mode="record-data"/>
        </tr>
    </xsl:template>
    <xd:doc>
        <xd:desc>tei:cell elements are mapped to html:td elements </xd:desc>
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
                        <xsl:attribute name="class">tei-cell <xsl:call-template name="rend-without-color">
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
    <!-- merged in template #tei-hi -->
    <!--<xd:doc>
        <xd:desc>tei:hi is mapped to html:span and @rend is mapped to @class</xd:desc>
        <xd:p>Note these elements are found eg. in the mecmua transkription</xd:p>
        <xd:p>A style attribute is either
            <xd:ul>
                <xd:li>translated into a html style attribute if it contains even one ':'</xd:li>
                <xd:li>or it is translated into a class attribute</xd:li>
            </xd:ul>
        </xd:p>
    </xd:doc>
    <xsl:template match="hi|tei:hi" mode="record-data">
        <xsl:variable name="wrapper-class" select="(@rend|@rendition|@style)[1]"/>
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <span>
            <xsl:choose>
                <!-\- FIXME This is a temporary hack to allow initial Caps, we need to adjust the "inline" template -\->
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
                        <xsl:otherwise>
                            <xsl:attribute name="class">tei-hi <xsl:value-of select="@style"/>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="@rend">
                    <xsl:attribute name="class">tei-hi <xsl:call-template name="rend-without-color">
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
            </xsl:choose>
            <xsl:apply-templates mode="record-data"/>
            <xsl:if test="not((ancestor::tei:TEI|ancestor::TEI)//*[local-name(.) = 'seg' and @type='whitespace'])">
                <xsl:text> </xsl:text>
            </xsl:if>
        </span>
    </xsl:template>-->
    
    <xsl:template match="tei:re" mode="record-data">
        <span class="tei-re">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:form[@type]" mode="record-data" priority="0.4">
        <span class="tei-form-{@type}">
            <xsl:apply-templates/>
        </span>
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
            <xsl:apply-templates select="tei:orth[contains(@xml:lang, '-vicav')]|tei:orth[@xml:lang = 'ar']" mode="record-data"/>
            <xsl:text> </xsl:text>
            <xsl:apply-templates select="tei:orth[not(contains(@xml:lang, '-vicav')) and (@xml:lang != 'ar')]" mode="record-data"/>
            <xsl:apply-templates select="tei:orth[not(@xml:lang)]" mode="record-data"/>
            <xsl:apply-templates select="*[not(name() = 'orth' or name() = 'bibl')]" mode="record-data"/>
        </span>        
    </xsl:template>
    
    <xsl:template match="tei:form[@type='inflected']" mode="record-data">
        <span class="tei-form-inflected">
            <xsl:apply-templates select="tei:orth[contains(@xml:lang, '-vicav')]|tei:orth[@xml:lang = 'ar']" mode="record-data"/>
            <xsl:text> </xsl:text>
            <xsl:apply-templates select="tei:orth[not(contains(@xml:lang, '-vicav')) and (@xml:lang != 'ar')]" mode="record-data"/>
            <xsl:apply-templates select="tei:orth[not(@xml:lang)]" mode="record-data"/>
            <xsl:call-template name="analyzeAna"/>
            <xsl:apply-templates select="*[not(name() = 'orth')]" mode="record-data"/>
        </span>
    </xsl:template>
    
    <xsl:template name="analyzeAna">
        <span class="tei-form-ana">
            <xsl:choose>
                <xsl:when test="@ana='#adj_f'">f</xsl:when>
                <xsl:when test="@ana='#adj_pl'">pl</xsl:when>
                <xsl:when test="@ana='#n_pl'">pl</xsl:when>
                <xsl:when test="@ana='#v_pres_sg_p3'">impf</xsl:when>
            </xsl:choose>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:orth" mode="record-data">
        <span class="tei-orth {@xml:lang}">
            <xsl:apply-templates mode="record-data"/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:gramGrp" mode="record-data">
        <dl class="tei-gramGrp">
            <xsl:apply-templates mode="record-data"/>
        </dl>
    </xsl:template>
    
    <xsl:template match="tei:gram[@type and text()]" mode="record-data">
        <xsl:variable name="first-of-group">
            <xsl:call-template name="first-of-group"/>
        </xsl:variable>
        <dt class="tei-gram {$first-of-group}">
            <xsl:call-template name="dict">
                <xsl:with-param name="key" select="@type"/>
            </xsl:call-template>
        </dt>
        <dd class="tei-gram {@type} {$first-of-group}">
            <xsl:apply-templates mode="record-data"/> 
        </dd>
    </xsl:template>

    <xsl:template name="first-of-group">
        <xsl:if test="(@type != preceding-sibling::*[1]/@type) or (normalize-space(preceding-sibling::*[1]/text()) = '')">xsl-first-of-group</xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:gram" mode="record-data"/>
        
    <xsl:template match="tei:sense" mode="record-data">
        <div class="tei-sense">
            <xsl:if test="tei:form[@type='construction']">
                <div class="tei-form-construction">
                    <xsl:apply-templates select="tei:form[@type='construction']" mode="record-data"/>
                </div>
            </xsl:if>
            <xsl:if test="tei:def">            
                <div class="tei-defs">
                    <xsl:apply-templates select="tei:def[@xml:lang='en']" mode="record-data"/>
                    <xsl:apply-templates select="tei:def[@xml:lang='de' or (@lang|@xml:lang)='deu']" mode="record-data"/>
                    <xsl:apply-templates select="tei:def[not(@xml:lang='en' or @xml:lang='de')]" mode="record-data"/>               
                </div>
            </xsl:if>
            <xsl:if test="tei:usg[@type='dom']">
                <div class="tei-usg-doms">
                    <xsl:apply-templates select="tei:usg[@type='dom']" mode="record-data"/>
                </div>
            </xsl:if>
            <xsl:if test="tei:usg[@type='prag']">
                <div class="tei-usg-prags">
                    <xsl:apply-templates select="tei:usg[@type='prag']" mode="record-data"/>
                </div>
            </xsl:if>
            <xsl:if test="tei:cit">
                <div class="tei-cits">
                    <xsl:apply-templates select="tei:cit" mode="record-data"/>
                </div>
            </xsl:if>
            <xsl:apply-templates select="*[not(name() = 'def' or name() = 'cit' or name() = 'usg' or name() = 'gramGrp' or @type = 'construction')]" mode="record-data"/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:def[@xml:lang]" mode="record-data">
        <span class="tei-def lang-{@xml:lang}">
            <xsl:apply-templates mode="record-data"/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:cit[(@type='translation')]" mode="record-data">
         <span class="tei-cit translation-{(@xml:lang|@lang)[1]}">
            <xsl:apply-templates mode="record-data"/>
        </span>                 
    </xsl:template>
    
    <xsl:template match="tei:cit[@type='example']" mode="record-data">
        <div class="tei-cit example">
            <xsl:apply-templates mode="record-data"/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:cit[@type='example']" mode="result-data-table">
        <td class="tei-cit example">
            <xsl:apply-templates mode="record-data"/>
        </td>
    </xsl:template>
    
    <xsl:template match="tei:quote[contains(@xml:lang,'-vicav')]" mode="record-data">
        <span class="tei-quote vicav-transcr">
            <xsl:apply-templates mode="record-data"/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:quote[not(contains(@xml:lang,'-vicav'))]" mode="record-data">
        <span class="tei-quote lang-{@xml:lang}">
            <xsl:apply-templates mode="record-data"/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:quote[not(@xml:lang)]" mode="record-data" priority="0.6">
        <span class="tei-quote">
            <xsl:apply-templates mode="record-data"/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:usg" mode="record-data">
        <span class="tei-usg tei-type-{@type} lang-{(@xml:lang|@lang)[1]}">
            <xsl:apply-templates mode="record-data"/>
        </span>
    </xsl:template>

    <xsl:template match="tei:bibl" mode="record-data">
        <span class="tei-bibl">
            <xsl:apply-templates mode="record-data"/>
        </span>
        <xsl:text> </xsl:text>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>tei:entry elements are the base elements for any lexicographical definitions
            <xd:p/>
        </xd:desc>
    </xd:doc>
                                          
    <xsl:template match="tei:entry" mode="result-data-table">
        <td class="tei-entry">
           <xsl:call-template name="_tei_entry"/> 
        </td>
    </xsl:template>
    
    <xsl:template name="_tei_entry">
        <xsl:for-each select="tei:sense">
            <xsl:choose>
                <xsl:when test="tei:form/@type = 'construction'">
                    <xsl:apply-templates select="." mode="record-data"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="../tei:form[@type='lemma']|../tei:form[@type='multiWordUnit']" mode="record-data"/>
                    <xsl:apply-templates select="./tei:gramGrp" mode="record-data"/>
                    <xsl:apply-templates select="../tei:gramGrp" mode="record-data"/>
                    <span class="tei-bibls">
                        <xsl:for-each select="../tei:form[@type='lemma']/tei:bibl">
                            <xsl:apply-templates select="." mode="record-data"/>
                        </xsl:for-each>
                    </span>
                    <xsl:if test="not(@rend) or ./@rend != 'singular_only'">
                        <xsl:apply-templates select="../tei:form[@type='inflected']" mode="record-data"/>
                    </xsl:if>
                    <!-- Assumes tei:gramGrp is not rendered, see above -->
                    <xsl:apply-templates select="." mode="record-data"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>        
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
        <xd:desc>division headings are transformed into their html h1-h6 counterparts</xd:desc>
    </xd:doc>
    <xsl:template match="head[parent::div] | tei:head[parent::tei:div | parent::tei:body] " mode="record-data">
        <div class="tei-head">
            <xsl:apply-templates select="." mode="tei-body-headings"/>
        </div>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>list headings are transformed into li elements</xd:desc>
    </xd:doc>
    <xsl:template match="head[parent::list] | tei:head[parent::tei:list] " mode="record-data">
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <li class="{$class}">
            <xsl:apply-templates mode="record-data"/>
        </li>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>headings other than list and division headings are transformed into a generic html span</xd:desc>
    </xd:doc>
    <xsl:template match="head[not(parent::div)] | tei:head[not(parent::tei:div | parent::tei:body)]" mode="record-data">
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

    <xd:doc>
        <xd:desc>tei:geo elements are mapped to spans optionally as link to more

            information.</xd:desc>
</xd:doc>
    <xsl:template match="hi | tei:hi" mode="record-data" xml:id="tei-hi">
        <xsl:variable name="wrapper-class" select="(@rend|@rendition|@style)[1]"/>
        <xsl:variable name="class">
            <xsl:call-template name="classnames"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="@style">
                <span class="{$wrapper-class} {$class}">
                    <!-- simple test, if @style contains a CSS category and value - if so, it is copied over to the html -->
                    <xsl:if test="contains(@style, ':')">
                        <xsl:attribute name="style">
                            <xsl:value-of select="@style"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="inline">
                        <xsl:with-param name="insertTrailingBlank" select="not((ancestor::tei:TEI|ancestor::TEI)//*[local-name(.) = 'seg' and @type='whitespace'])"/>
                    </xsl:call-template>
                </span>
            </xsl:when>
            <!-- FIXME This is a temporary hack to allow initial Caps, we need to adjust the "inline" template -->
            <xsl:when test="@rend='initialCapital'">
                <span class="initialCapital">
                    <xsl:value-of select="substring(normalize-space(.),1,1)"/>
                </span>
                <xsl:value-of select="substring(normalize-space(.),2)"/>
                <xsl:if test="not((ancestor::tei:TEI|ancestor::TEI)//*[local-name(.) = 'seg' and @type='whitespace'])">
                    <xsl:text> </xsl:text>
                </xsl:if>
            </xsl:when>
            <xsl:when test="@rend[contains(.,'color(')]">
                <span>
                    <xsl:attribute name="class">
                        <xsl:call-template name="classnames">
                            <xsl:with-param name="ignore">@rend</xsl:with-param>
                        </xsl:call-template>
                        <xsl:text> </xsl:text>
                        <xsl:call-template name="rend-without-color">
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
                    <xsl:apply-templates mode="record-data"/>
                    <xsl:if test="not((ancestor::tei:TEI|ancestor::TEI)//*[local-name(.) = 'seg' and @type='whitespace'])">
                        <xsl:text> </xsl:text>
                    </xsl:if>
                </span>
            </xsl:when>
            <xsl:when test="@rend">
                <span class="{$wrapper-class} {$class}">
                    <xsl:apply-templates mode="record-data"/>
                    <xsl:if test="not((ancestor::tei:TEI|ancestor::TEI)//*[local-name(.) = 'seg' and @type='whitespace'])">
                        <xsl:text> </xsl:text>
                    </xsl:if>
                </span>
            </xsl:when>
            <xsl:when test="@rendition">
                <span class="{$wrapper-class} {$class}">
                    <xsl:apply-templates mode="record-data"/>
                    <xsl:if test="not((ancestor::tei:TEI|ancestor::TEI)//*[local-name(.) = 'seg' and @type='whitespace'])">
                        <xsl:text> </xsl:text>
                    </xsl:if>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="{$class}">
                    <xsl:apply-templates mode="record-data"/>
                </span>
                <xsl:if test="not((ancestor::tei:TEI|ancestor::TEI)//*[local-name(.) = 'seg' and @type='whitespace'])">
                    <xsl:text> </xsl:text>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
</xsl:template>
    <xsl:template match="geo | tei:geo" mode="record-data">
        <xsl:call-template name="inline">
            <xsl:with-param name="insertTrailingBlank" select="not(ancestor::*[local-name(.) = 'TEI']//*[local-name(.) = 'seg' and @type='whitespace'])"/>
        </xsl:call-template>
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
        <xsl:call-template name="br"/>
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
        <xd:desc>tei:persName, tei:placeName etc. elements are mapped to spans optionally as link to
            more information.</xd:desc>
    </xd:doc>
    <xsl:template match="name | persName | placeName | tei:name | tei:persName | tei:placeName" mode="record-data">
        <xsl:call-template name="inline">
            <xsl:with-param name="additional-style" select="string(../@rend)"/>
            <xsl:with-param name="insertTrailingBlank" select="not(//*[local-name(.) = 'seg' and @type='whitespace'])"/>
            <xsl:with-param name="descendants-to-ignore" select="'fw'"/>
        </xsl:call-template>
    </xsl:template>

    <xd:doc>
        <xd:desc>tei:quote elements are mapped to spans optionally as link to more
            information.</xd:desc>
    </xd:doc>
    <xsl:template match="quote | tei:quote" mode="record-data">
        <xsl:call-template name="inline">
            <xsl:with-param name="insertTrailingBlank" select="not(//*[local-name(.) = 'seg' and @type='whitespace'])"/>
        </xsl:call-template>
    </xsl:template>
    <xd:doc>
        <xd:desc>tei:rs elements are mapped to spans optionally as link to more
            information.</xd:desc>
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
                <xsl:variable name="class">
                    <xsl:call-template name="classnames"/>
                </xsl:variable>
                <span class="{$class}">
                    <xsl:apply-templates mode="record-data"/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>a rather sloppy section optimized for result from aacnames listPerson/tei:person
                this should occur only in lists, not in text </xd:p>
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
        <xd:desc>Suppressed. Already used as a title. </xd:desc>
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
    
    <xsl:template match="tei:u" mode="record-data">
        <dl class="tei-u">
            <dt class="tei-u-who">
                <xsl:value-of select="@who"/>
            </dt>
            <dd class="tei-u-what">
                <xsl:apply-templates mode="record-data"/>
            </dd>
        </dl>
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

    <xsl:strip-space elements="tei:s tei:w tei:c tei:fs"/>
    <xd:doc>
        <xd:desc>Handle TEI sentence markers</xd:desc>
    </xd:doc>
    <xsl:template match="tei:s" mode="record-data">
        <span class="tei-s">
            <xsl:apply-templates mode="record-data"/>
        </span>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template match="tei:c" mode="record-data">
        <span class="tei-c">
            <xsl:value-of select="."/>
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
                <xsl:variable name="pos" select="concat(substring('pos ', number(not(tei:fs/tei:f[@name = 'pos'])) * string-length('pos ') + 1),                         substring('', number(tei:fs/tei:f[@name = 'pos']) * string-length('') + 1))"/>
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
            <xsl:when test="@ana">
                <span class="tei-w" data-ref="{@ana}">
                    <xsl:apply-templates mode="record-data"/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="inline">
                    <xsl:with-param name="insertTrailingBlank" select="not((ancestor::tei:TEI|ancestor::TEI)//*[local-name(.) = 'seg' and @type='whitespace'])"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template match="tei:w/tei:fs" mode="record-data">
        <dl class="tei-fs">
            <xsl:apply-templates mode="record-data"/>
        </dl>
    </xsl:template>

    <xsl:template match="tei:w/tei:fs/tei:f" mode="record-data" priority="0">
        <dt class="{@name}">
            <xsl:if test="@lang">
                <xsl:attribute name="data-lang">
                    <xsl:value-of select="@xml:lang"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:call-template name="dict">
                <xsl:with-param name="key" select="@name"/>
            </xsl:call-template>
        </dt>
        <dd>
            <xsl:value-of select="."/>
        </dd>
    </xsl:template>

    <xsl:template match="tei:w/tei:fs/tei:f[@name='wordform']" mode="record-data" priority="1"> </xsl:template>

    <xsl:template match="tei:w/tei:fs/tei:f[@name='pos']" mode="record-data" priority="1">
            <dt class="pos">
                <xsl:call-template name="dict">
                    <xsl:with-param name="key" select="@name"/>
                </xsl:call-template>
            </dt>
            <dd>
                <xsl:call-template name="dict">
                    <xsl:with-param name="key" select="normalize-space(.)"/>
                    <xsl:with-param name="fallback">Please add word form <xsl:value-of select="concat('&#34;', ., '&#34;')"/> to dict.xml!</xsl:with-param>
                </xsl:call-template>
            </dd>
    </xsl:template>

    <xd:doc>
        <xd:desc>For internal use, don't produce any HTML</xd:desc>
    </xd:doc>
    <xsl:template match="tei:fs[@type='change']" mode="record-data"/>
    
    <xd:doc>
        <xd:desc>For internal use, don't produce any HTML</xd:desc>
    </xd:doc>
    <xsl:template match="tei:fs[@type='create']" mode="record-data"/>
    
    <xd:doc>
        <xd:desc>Get the "argument" of color() used in @rend attributes and return it as html inline
            style attribute. <xd:p>Note: assumes only one color().</xd:p>
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
        <xd:desc>Get everything but the color() part in @rend attributes <xd:p>Note: assumes only
                one color().</xd:p>
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