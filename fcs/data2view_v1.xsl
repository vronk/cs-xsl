<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exist="http://exist.sourceforge.net/NS/exist" xmlns:hits="http://clarin.eu/fcs/dataview/hits" xmlns:exsl="http://exslt.org/common" xmlns:kwic="http://clarin.eu/fcs/1.0/kwic" xmlns:sru="http://www.loc.gov/zing/srw/" xmlns:fcs="http://clarin.eu/fcs/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:cr="http://aac.ac.at/content_repository" version="1.0" exclude-result-prefixes="cr kwic xsl tei sru xs fcs exist xd exsl hits">
    <xd:doc scope="stylesheet">
        <xd:desc>Provides more specific handling of sru-result-set recordData <xd:p>History: <xd:ul>
                    <xd:li>2013-04-17: created by: "m": </xd:li>
                    <xd:li>2011-11-14: created by: "vr": based on cmdi/scripts/xml2view.xsl</xd:li>
                </xd:ul>
            </xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    <xsl:include href="data2view_cmd.xsl"/><!--    <xsl:import href="../amc/dataset2view.xsl"/>-->
    <xsl:include href="data2view_tei.xsl"/><!--    <xsl:include href="../stand_weiss.xsl"/>-->
    <xd:doc>
        <xd:desc>Default starting-point <xd:p>In mode record-data this this and all included style
                sheets define the transformation.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="sru:recordData" mode="record-data">
        <xsl:apply-templates select="*" mode="record-data"/>
    </xsl:template>
    <xd:doc>
        <xd:desc>default fallback: display the xml-structure <xd:p/>
        </xd:desc>
    </xd:doc>
    <xsl:template match="*" mode="record-data"><!--<xsl:variable name="overrides">
            <xsl:apply-imports/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$overrides">
                <xsl:copy-of select="$overrides"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="format-xmlelem"/>
            </xsl:otherwise>
        </xsl:choose>-->
        <xsl:apply-templates select="." mode="format-xmlelem"/>
    </xsl:template><!-- hide meta-information about the record from output-->
    <xd:doc>
        <xd:desc>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    <xsl:template match="sru:recordSchema | sru:recordPacking" mode="record-data"/>
    <xd:doc>
        <xd:desc>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    <xsl:template match="sru:recordIdentifier | sru:recordPosition" mode="record-data"/>
    <xd:doc>
        <xd:desc>
            <xd:p>Remove administrative attributes</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="@cr:project-id | @cr:resource-pid | @cr:id | @xml:id | @xml:space" mode="format-attr"/><!-- kwic match -->
    <xd:doc>
        <xd:desc>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    <xsl:template match="exist:match" mode="record-data">
        <span class="hilight match">
            <xsl:apply-templates mode="record-data"/><!--            <xsl:value-of select="."/>-->
        </span>
    </xsl:template><!-- FCS-wrap -->
    <xd:doc>
        <xd:desc>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    <xsl:template match="fcs:Resource" mode="record-data">
        <xsl:variable name="pid" select="@pid"/><!-- this is quite specialized only for the navigation-ResourceFragments! 
            nav links are created from specialized ResourceFragments[@type=prev|next].
                    Handling via fcs:DataView was based on erroneous data, that provided
                    the resourcefragments wrapped in fcs:DataView           --><!--<div class="navigation">
            <xsl:apply-templates select=".//fcs:ResourceFragment[@type][not(fcs:DataView)]" mode="record-data"/>
        </div>-->
        <xsl:apply-templates select=".//fcs:DataView" mode="record-data">
            <xsl:with-param name="resource-pid" select="$pid"/>
        </xsl:apply-templates>
    </xsl:template>
    <xd:doc>
        <xd:desc>Handle DataViews other than full (eg. xmlescaped, facs) by creating a div with
            appropriate classes </xd:desc>
    </xd:doc>
    <xsl:template match="fcs:DataView" mode="record-data">
        <xsl:param name="resource-pid"/>
        <xsl:variable name="resourcefragment-pid" select="parent::fcs:ResourceFragment/@pid"/><!-- don't show full view if, there is kwic, title-view is called separately, and  -->
        <xsl:if test="not((contains(@type, 'full') and parent::*/fcs:DataView[contains(@type, 'kwic')]) or contains(@type, 'title') or contains(@type, 'facs'))">
            <div class="data-view {translate(@type, '/+', '__')}" data-resource-pid="{$resource-pid}" data-resourcefragment-pid="{$resourcefragment-pid}">
                <xsl:call-template name="dataview-full-contents"/>
                <div class="wrapper {translate(@type, '/+', '__')}">
                    <xsl:apply-templates mode="record-data"/>
                </div>
            </div>
        </xsl:if>
    </xsl:template>
    <xd:doc>
        <xd:desc>Supersede this to generate some sort of contents block as first element of the data
            view.</xd:desc>
    </xd:doc>
    <xsl:template name="dataview-full-contents"/>
    <xd:doc>
        <xd:desc>Handle DataViews other than full (eg. xmlescaped, facs) by creating a div with
            appropriate classes </xd:desc>
    </xd:doc>
    <xsl:template match="fcs:DataView[contains(@type, 'xmlescaped')]" mode="record-data">
        <xsl:param name="resource-pid"/><!-- don't show full view if, there is kwic, title-view is called separately, and  -->
        <xsl:if test="not((contains(@type, 'full') and parent::*/fcs:DataView[contains(@type, 'kwic')]) or contains(@type, 'title') or contains(@type, 'facs'))">
            <div class="data-view {@type}" data-resource-pid="{$resource-pid}">
                <textarea rows="25" cols="80">
                    <xsl:apply-templates mode="record-data"/>
                </textarea>
            </div>
        </xsl:if>
    </xsl:template>
    <xd:doc>
        <xd:desc>Handle DataViews that have a non-empty @ref by creating a div with appropriate
            classes </xd:desc>
    </xd:doc>
    <xsl:template match="fcs:DataView[@ref][not(@ref = '')]" mode="record-data">
        <xsl:param name="resource-pid"/>
        <div class="data-view {@type}" data-resource-pid="{$resource-pid}">
            <a href="{@ref}">
                <xsl:value-of select="@type"/>
            </a>
        </div>
    </xsl:template>
    <xsl:template match="fcs:DataView[@ref][contains(@type, 'facs') or contains(@type, 'image')]" mode="record-data" priority="10">
        <xsl:param name="resource-pid"/>
        <xsl:param name="linkTo" select="@ref"/>
        <div class="data-view {@type}" data-resource-pid="{$resource-pid}">
            <xsl:choose><!-- ends-with in XPath 1.0) see http://stackoverflow.com/questions/11848780/use-ends-with-in-xslt-v1-0 -->
                <xsl:when test="substring(@ref, string-length(@ref) - string-length('.m4a') + 1) = '.m4a'">
                    <xsl:call-template name="generateAudioHTMLTags">
                        <xsl:with-param name="ref" select="$linkTo"/>
                        <xsl:with-param name="sourceType" select="''"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="generateImgHTMLTags">
                        <xsl:with-param name="ref" select="$linkTo"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template><!-- better hide the fullview (the default view is too much)
        TODO: some more condensed view --><!--    <xsl:template match="fcs:DataView[@type='full']" mode="record-data"/>--><!--  this would be to use, if including a stylesheet without mode=record-data (like aac:stand.xsl)       
    <xsl:template match="fcs:DataView[@type='full']/*" mode="record-data">
        <xsl:apply-templates></xsl:apply-templates>
    </xsl:template>
-->
    <xd:doc>
        <xd:desc>
            <xd:p>special handling for navigation fragments (@type=prev|next)</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="fcs:ResourceFragment[@type]" mode="record-data">
        <xsl:variable name="link-text">
            <xsl:choose>
                <xsl:when test="@label">
                    <xsl:value-of select="@label"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@pid"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <a href="{@ref}&amp;x-format={$format}" rel="{@type}" class="{@type}" title="{$link-text}">
            <xsl:value-of select="$link-text"/>
        </a>
    </xsl:template><!-- handle generic metadata-fields -->
    <xd:doc>
        <xd:desc>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    <xsl:template match="fcs:f" mode="record-data">
        <span class="label">
            <xsl:value-of select="@key"/>: </span>
        <span class="value">
            <xsl:value-of select="."/>
        </span>; </xsl:template>
    <xd:doc>
        <xd:desc>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    <xsl:template match="kwic:kwic" mode="record-data">
        <div class="kwic-line">
            <xsl:if test="tei:ptr">
                <span class="tei-ptr-doc">
                    <xsl:value-of select="tei:ptr/@cRef"/>
                </span>
            </xsl:if>
            <xsl:apply-templates mode="record-data"/>
        </div>
    </xsl:template>
    <xd:doc>
        <xd:desc>Text with hits in standard HTML context, e.g. not in a search results table
        </xd:desc>
    </xd:doc>
    <xsl:template match="hits:Result" mode="record-data">
        <div class="kwic-line">
            <xsl:if test="tei:ptr">
                <span class="tei-ptr-doc">
                    <xsl:value-of select="tei:ptr/@cRef"/>
                </span>
            </xsl:if>
            <xsl:apply-templates mode="record-data"/>
        </div>
    </xsl:template>
    <xd:doc>
        <xd:desc>Text with hits in a search results table </xd:desc>
    </xd:doc>
    <xsl:template match="hits:Result" mode="result-data-table">
        <xsl:choose>
            <xsl:when test="tei:ptr">
                <td class="tei-ptr-doc">
                    <xsl:value-of select="tei:ptr/@cRef"/>
                </td>
            </xsl:when>
            <xsl:when test="tei:ref">
                <td class="tei-ptr-doc">
                    <xsl:value-of select="tei:ref"/>
                </td>
            </xsl:when>
            <xsl:otherwise>
                <td/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="hits:Hit" mode="result-data-table"/>
    </xsl:template>
    <xsl:template match="tei:ref[parent::hits:Result]" mode="record-data" priority="0.6"/>
    <xsl:template match="sru:recordData" mode="result-data-table">
        <xsl:apply-templates mode="result-data-table"/>
    </xsl:template>
    <xsl:template match="fcs:Resource" mode="result-data-table">
        <xsl:apply-templates mode="result-data-table"/>
    </xsl:template>
    <xsl:template match="fcs:ResourceFragment" mode="result-data-table">
        <xsl:apply-templates mode="result-data-table"/>
    </xsl:template>
    <xsl:template match="fcs:DataView" mode="result-data-table">
        <xsl:apply-templates mode="result-data-table"/>
    </xsl:template>
    <xd:doc>
        <xd:desc>Transform title to a column. That most likely should be changed in
            customization.</xd:desc>
    </xd:doc>
    <xsl:template match="fcs:DataView[@type = 'title']" mode="result-data-table">
        <td>
            <xsl:apply-templates select=". | text()" mode="record-data"/>
        </td>
    </xsl:template>
    <xsl:template match="*" mode="result-data-table">
        <xsl:apply-templates select="." mode="record-data"/>
    </xsl:template><!--
     handle KWIC-DataView:
     <c type="left"></c><kw></kw><c type="right"></c>
     WATCHME: temporarily accepting both version (fcs and kwic namespacEe)
 -->
    <xd:doc>
        <xd:desc>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    <xsl:template match="kwic:c | fcs:c" mode="record-data">
        <span class="context {@type}">
            <xsl:apply-templates mode="record-data"/>
        </span>
        <xsl:if test="following-sibling::*[1][local-name() = 'c']">
            <xsl:call-template name="br"/>
        </xsl:if>
    </xsl:template>
    <xd:doc>
        <xd:desc>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    <xsl:template match="kwic:kw | fcs:kw" mode="record-data">
        <xsl:text/>
        <span class="kw hilight">
            <xsl:apply-templates mode="record-data"/>
        </span>
        <xsl:text/>
    </xsl:template>
    <xd:doc>
        <xd:desc>A hit with its context in normal HTML context </xd:desc>
    </xd:doc>
    <xsl:template match="hits:Hit" mode="record-data">
        <xsl:apply-templates select="preceding-sibling::*" mode="record-data"/>
        <xsl:text/>
        <span class="kw hilight">
            <xsl:apply-templates mode="record-data"/>
        </span>
        <xsl:text/>
        <xsl:apply-templates select="following-sibling::*" mode="record-data"/>
    </xsl:template>
    <xd:doc>
        <xd:desc>A hit with its context in search result context </xd:desc>
    </xd:doc>
    <xsl:template match="hits:Hit" mode="result-data-table">
        <td class="left context">
            <xsl:apply-templates select="preceding-sibling::* | preceding-sibling::text()" mode="record-data"/>
        </td>
        <td class="kw hilight">
            <xsl:apply-templates mode="record-data"/>
        </td>
        <td class="right context">
            <xsl:apply-templates select="following-sibling::* | following-sibling::text()" mode="record-data"/>
        </td>
    </xsl:template><!-- ************************ --><!-- named templates starting -->
    <xd:doc>
        <xd:desc>
            <xd:p>get the title for the shown piece of data (i.e. normally the title of the shown
                resource fragment )</xd:p>
            <xd:p>expected to be delivered in the input xml in fcs:DataView[@type='title'] (needs
                index=title in mappings and contains(x-dataview,'title')</xd:p>
            <xd:p>Can be be overridden in your project's XSL customization!</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="getTitle">
        <xsl:choose>
            <xsl:when test=".//fcs:DataView[@type = 'title']">
                <xsl:value-of select=".//fcs:DataView[@type = 'title']"/>
            </xsl:when>
            <xsl:when test=".//date/@value">
                <xsl:value-of select=".//date/@value"/>
            </xsl:when>
            <xsl:when test=".//tei:persName">
                <xsl:value-of select=".//tei:persName"/>
            </xsl:when>
            <xsl:otherwise>
                <span class="cs-xsl-error">You need to supersede the getTitle template in your
                    project's XSL customization!</span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xd:doc>
        <xd:desc>Common template to insert a TEI element as a span with an appropriate class.
            <xd:p>XSL 1.0 port.</xd:p>
            <xd:p>If there is a known way to link to more information the span is placed inside a
                link.</xd:p>
            <xd:p>Advanced functionality is available with XSL 2.0 using features. See
                data2view_v2.xsl</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="inline">
        <xsl:param name="descendants-to-ignore"/>
        <xsl:variable name="elem-link">
            <xsl:call-template name="elem-link"/>
        </xsl:variable>
        <xsl:variable name="inline-content"><!-- moved from .//text() to node(), because otherwise all the descendants got flattened -->
            <xsl:for-each select="node()">
                <xsl:choose><!--                Handled like a tei: tag so don't create an infinite loop. Check exist:match match before changing this!    
                    <xsl:when test="parent::exist:match">
                        <xsl:apply-templates select="parent::exist:match" mode="record-data"/>
                    </xsl:when>-->
                    <xsl:when test="self::text()">
                        <xsl:value-of select="."/>
                        <xsl:text/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates mode="record-data"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="class"><!-- This genereates CSS class attributes for HTML elements. As far as I know
                it doesn't matter if the class is specified once or n-times so for 1.0 just forget
                about distinct-values() for now and let's see --><!--<xsl:for-each select="descendant-or-self::*">
                <xsl:value-of select="concat(local-name(.), ' ', concat('tei-', local-name(.)), ' ', @rend)"/>
            </xsl:for-each>-->
            <xsl:value-of select="local-name(.)"/>
            <xsl:if test="@type">
                <xsl:value-of select="concat(' ', @type)"/>
            </xsl:if>
            <xsl:if test="@subtype">
                <xsl:value-of select="concat(' ', @subtype)"/>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="inline-elem">
            <xsl:choose>
                <xsl:when test="not($elem-link = '')">
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
                <span class="attributes">
                    <xsl:call-template name="descendants-table">
                        <xsl:with-param name="elem-name">
                            <xsl:call-template name="dict">
                                <xsl:with-param name="key">this element</xsl:with-param>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </span>
            </xsl:if>
            <xsl:copy-of select="$inline-elem"/>
        </span>
    </xsl:template>
    <xsl:template name="join-attributes-with-space">
        <xsl:param name="nodes"/>
        <xsl:for-each select="$nodes/@*">
            <xsl:value-of select="."/>
            <xsl:text/>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="descendants-table">
        <xsl:param name="elem-name" select="name()"/>
        <table>
            <tr>
                <td colspan="2">
                    <xsl:value-of select="$elem-name"/>
                </td>
            </tr>
            <tr>
                <td>
                    <xsl:if test="./@*[not((local-name() = 'id') or (local-name() = 'rend') or (local-name() = 'style'))]">
                        <table style="float:left">
                            <xsl:for-each select="./@*[not((local-name() = 'id') or (local-name() = 'rend') or (local-name() = 'style'))]">
                                <tr>
                                    <td class="label">
                                        <xsl:value-of select="concat('@', name())"/>
                                    </td>
                                    <td class="value">
                                        <xsl:value-of select="."/>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </table>
                    </xsl:if>
                    <xsl:for-each select="child::*">
                        <xsl:call-template name="descendants-table"/>
                    </xsl:for-each>
                </td>
            </tr>
        </table>
    </xsl:template>
</xsl:stylesheet>