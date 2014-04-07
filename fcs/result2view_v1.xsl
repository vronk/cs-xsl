<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:diag="http://www.loc.gov/zing/srw/diagnostic/" xmlns:saxon="http://saxon.sf.net/" xmlns:sru="http://www.loc.gov/zing/srw/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fcs="http://clarin.eu/fcs/1.0" xmlns:exsl="http://exslt.org/common" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" version="1.0" exclude-result-prefixes="saxon xs exsl diag sru fcs xd">
    <xd:doc scope="stylesheet">
        <xd:desc>Generate html view of a sru-result-set  (eventually in various formats).
            <xd:p>History:
                <xd:ul>
                    <xd:li>2011-12-06: created by:"vr": based on cmdi/scripts/mdset2view.xsl retrofitted for XSLT 1.0</xd:li>
                </xd:ul>
            </xd:p>
        </xd:desc>
        <xd:param name="title"/>
    </xd:doc>
    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:output method="html" media-type="text/xhtml" indent="yes" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"/>
    <xd:doc>
        <xd:desc>Common stuff that works with XSL 1.0</xd:desc>
    </xd:doc>
    <xsl:include href="../commons_v1.xsl"/>
    <xd:doc>
        <xd:desc>Use data view framework.</xd:desc>
    </xd:doc>
    <xsl:include href="data2view_v1.xsl"/>
    <xsl:param name="title">
        <xsl:text>Result Set</xsl:text>
    </xsl:param>
    <xd:doc>
        <xd:desc>???</xd:desc>
    </xd:doc>
    <xsl:variable name="cols">
        <col>all</col>
    </xsl:variable>
    <xd:doc>
        <xd:desc>Main entry point. Called by commons_v1.xsl's / matching template.
            <xd:p>
                
            </xd:p>
            <xd:p>
                TODO: Finish switching to different modes depending on the $format parameter.
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="continue-root">
        <xsl:for-each select="sru:searchRetrieveResponse">
            <xsl:apply-templates select="sru:diagnostics"/>
            <div>
                <!--                <xsl:if test="contains($format, 'htmlpage')">-->
                <xsl:call-template name="header"/>
                <!--                </xsl:if>-->
                        <xsl:apply-templates select="sru:records" mode="list"/>
                <!-- switch mode depending on the $format-parameter -->        
                <!--<xsl:choose> 
                    <xsl:when test="contains($format,'htmltable')">
                        <xsl:apply-templates select="records" mode="table"/>
                    </xsl:when>
                    <xsl:when test="contains($format,'htmllist')">
                        <xsl:apply-templates select="records" mode="list"/>
                    </xsl:when> 
                    <xsl:when test="contains($format, 'htmlpagelist')">
                        <xsl:apply-templates select="records" mode="list"/>
                    </xsl:when>
                    <xsl:otherwise>mdset2view: unrecognized format: <xsl:value-of select="$format"/>
                    </xsl:otherwise>
                </xsl:choose>-->
            </div>
        </xsl:for-each>
    </xsl:template>
    <xd:doc>
        <xd:desc>Generates a header for each of the &lt;div&gt; containers
            <xd:ref name="continue-root" type="template">continue-root</xd:ref> creates.</xd:desc>
    </xd:doc>
    <xsl:template name="header">
        <div class="result-header" data-numberOfRecords="{$numberOfRecords}">
            <xsl:if test="contains($format, 'page')">
                <xsl:call-template name="query-input"/>
            </xsl:if>
            <xsl:apply-templates select="sru:facetedResults"/>
            <xsl:variable name="link_xml">
                <xsl:call-template name="formURL">
                    <xsl:with-param name="format" select="'xml'"/>
                </xsl:call-template>
            </xsl:variable>
            <a class="xml-link debug" href="{$link_xml}">XML</a>
            <div class="note debug">
                <xsl:for-each select="(sru:echoedSearchRetrieveRequest/*|sru:extraResponseData/*)">
                    <span class="label">
                        <xsl:value-of select="name()"/>: </span>
                    <span class="value">
                        <xsl:value-of select="."/>
                    </span>;
	        </xsl:for-each> 
                    <!--<span class="label">duration: </span>
                <span class="value">
                    <xsl:value-of select="sru:extraResponseData/fcs:duration"/>
                    </span>;-->
            </div>
            <xsl:call-template name="prev-next"/>
        </div>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template match="sru:records" mode="list">
        <div class="result-body scrollable-content-box">
            <table class="show">
            <!--<thead>
                <tr>
                    <th>pos</th>
                    <th>record</th>
                </tr>
            </thead>-->
                <tbody>
                <xsl:apply-templates select="sru:record" mode="list"/>
                </tbody>
            </table>
        </div>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template match="sru:record" mode="list">
        <xsl:variable name="curr_record" select="."/>
        <xsl:variable name="fields">
            <div>
                <xsl:apply-templates select="*" mode="record-data"/>
            </div>
        </xsl:variable>
        <xsl:call-template name="record-table-row">
            <xsl:with-param name="fields" select="exsl:node-set($fields)"/>
        </xsl:call-template>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="record-table-row">
        <xsl:param name="fields"/>
        <!-- @field absolute_position compute records position over whole recordset, ie add `startRecord` (important when paging)
 -->
        <xsl:variable name="absolute_position">
            <xsl:choose>
        <!--      CHECK: Does this check if $startRecord is a number, or is it an error?          -->
                <xsl:when test="number($startRecord)=number($startRecord)">
                    <xsl:value-of select="number($startRecord) + position() - 1"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="position()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="rec_uri">
            <xsl:choose>
                <xsl:when test=".//sru:recordIdentifier">
                    <xsl:value-of select=".//sru:recordIdentifier"/>
                </xsl:when>
                <xsl:when test=".//fcs:Resource/@ref">
                    <xsl:value-of select=".//fcs:Resource/@ref"/>
                </xsl:when>
                <xsl:otherwise>
                    <!-- TODO: this won't work yet, the idea is to deliver only the one record as a fall-back
                        (i.e. when there is no other view, no further link) supplied for the Resource) -->
                    <xsl:call-template name="formURL">
                        <xsl:with-param name="action" select="'record'"/>
                        <xsl:with-param name="q" select="$absolute_position"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tr class="record-top">
            <td rowspan="2" valign="top">
                <xsl:choose>
                    <xsl:when test="$rec_uri">
                        <!-- it was: htmlsimple, htmltable -link-to-> htmldetail; otherwise -> htmlpage -->
                        <!--                        <a class="internal" href="{my:formURL('record', $format, my:encodePID(.//recordIdentifier))}">-->
                        <a class="internal" href="{$rec_uri}&amp;x-format={$format}">
                            <xsl:value-of select="$absolute_position"/>
                        </a>                         
                        <!--                        <span class="cmd cmd_save"/>-->
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- FIXME: generic link somewhere anyhow! -->
                        <xsl:value-of select="$absolute_position"/>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
            <td>
                <!--
                    TODO: handle context 
                    <xsl:call-template name="getContext"/>-->
                <div class="title">
                                <xsl:call-template name="getTitle"/>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <xsl:copy-of select="exsl:node-set($fields)"/>
            </td>
        </tr>
    </xsl:template>
    <xd:doc>
        <xd:desc>If the request cannot be served a sru:diagnostics record is returned instead of</xd:desc>
    </xd:doc>
    <xsl:template match="sru:diagnostics">
        <div class="error">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template match="diag:diagnostic">
        <xsl:value-of select="diag:message"/> (<xsl:value-of select="diag:uri"/>)
    </xsl:template>
    <xsl:template match="sru:facetedResults">
        <div class="facets">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="sru:facet">
        <div class="facets">
            <h4>
                <xsl:value-of select="sru:facetDisplayLabel"/>
            </h4>
            <xsl:apply-templates select="sru:terms"/>
        </div>
    </xsl:template>
    <xsl:template match="sru:facet/sru:terms">
        <xsl:variable name="orig-request">
            <xsl:call-template name="formURL">
                <xsl:with-param name="action" select="'searchRetrieve'"/>
                <xsl:with-param name="x-context" select="''"/>
            </xsl:call-template>
        </xsl:variable>
        <table>
            <tr>
                <td>
                    <span class="hilight">
                        <xsl:value-of select="$numberOfRecords"/>
                    </span>
                </td>
                <td>
                    <a href="{$orig-request}">all</a>
                </td>
            </tr>
            <xsl:apply-templates select="sru:term"/>
        </table>
    </xsl:template>
    <xsl:template match="sru:facet/sru:terms/sru:term">
        <tr>
            <td>
                <xsl:value-of select="sru:count"/>
            </td>
            <td>
                <a href="{sru:requestUrl}&amp;x-format={$format}">
                    <xsl:value-of select="sru:actualTerm"/>
                </a>
            </td>
        </tr>
    </xsl:template>
</xsl:stylesheet>