<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cr="http://aac.ac.at/content_repository" xmlns:utils="http://aac.ac.at/content_repository/utils" xmlns:sru="http://www.loc.gov/zing/srw/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fcs="http://clarin.eu/fcs/1.0" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" version="2.0" extension-element-prefixes="sru fcs utils xs xd">
    <xsl:import href="scan2view_v1.xsl"/>
    <xsl:import href="../commons_v2.xsl"/>
    <xsl:output method="xhtml" indent="yes" encoding="UTF-8"/>
    <xd:doc scope="stylesheet">
        <xd:desc>generate a view for a values-list (index scan) 
            <xd:p>Note: This is called eg. from fsc:scan with mode "subsequence".</xd:p>
            <xd:p>
                <xd:pre>
&lt;sru:scanResponse xmlns:sru="http://www.loc.gov/zing/srw/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fcs="http://clarin.eu/fcs/1.0/"&gt;
&lt;sru:version&gt;1.2&lt;/sru:version&gt;
   &lt;sru:terms path="//div[@type='diary-day']/p/date/substring(xs:string(@value),1,7)"&gt;
        &lt;sru:term&gt;
        &lt;sru:value&gt;1903-01&lt;/sru:value&gt;
        &lt;sru:numberOfRecords&gt;30&lt;/sru:numberOfRecords&gt;
        &lt;/sru:term&gt;
        &lt;sru:term&gt;
        &lt;sru:value&gt;1903-02&lt;/sru:value&gt;
        &lt;sru:numberOfRecords&gt;28&lt;/sru:numberOfRecords&gt;
        &lt;/sru:term&gt;
        &lt;sru:term&gt;
        &lt;sru:value&gt;1903-03&lt;/sru:value&gt;
        &lt;sru:numberOfRecords&gt;31&lt;/sru:numberOfRecords&gt;
        &lt;/sru:term&gt;
   &lt;/sru:terms&gt;
   &lt;sru:extraResponseData&gt;
        &lt;fcs:countTerms&gt;619&lt;/fcs:countTerms&gt;
    &lt;/sru:extraResponseData&gt;
    &lt;sru:echoedScanRequest&gt;
        &lt;sru:scanClause&gt;diary-month&lt;/sru:scanClause&gt;
        &lt;sru:maximumTerms&gt;100&lt;/sru:maximumTerms&gt;
    &lt;/sru:echoedScanRequest&gt;        
 &lt;/sru:scanResponse&gt;
</xd:pre>
            </xd:p>
        </xd:desc>
    </xd:doc>
    
    <!-- <xsl:param name="size_lowerbound">0</xsl:param>
<xsl:param name="max_depth">0</xsl:param>
<xsl:param name="freq_limit">20</xsl:param>
<xsl:param name="show">file</xsl:param> -->
    <xsl:param name="sort">x</xsl:param>
    <xsl:param name="list-mode"/> <!-- table -->
    <xsl:param name="parts">header</xsl:param> <!-- header -->
    
    <!-- <xsl:param name="mode" select="'htmldiv'" />     -->
    <xsl:param name="title" select="concat('scan: ', $scanClause )"/>
    
    <!--
<xsl:param name="detail_uri_prefix"  select="'?q='"/> 
-->
    <xsl:decimal-format name="european" decimal-separator="," grouping-separator="."/>
    <xsl:variable name="countTerms" select="(/sru:scanResponse/sru:extraResponseData/fcs:countTerms[@level='total'], /sru:scanResponse/sru:extraResponseData/fcs:countTerms)[1]"/>
    <xsl:param name="scanClause-array" select="tokenize($scanClause,'=')"/>
    <xsl:param name="index" select="$scanClause-array[1]"/>
    <xsl:param name="start-term" select="$scanClause-array[2]"/>
    <xsl:template name="continue-root">
        <div class="scan-index-{translate($index,'.','-')}"> <!-- class="cmds-ui-block  init-show" -->
            <xsl:if test="contains($format, 'page') or $parts='header'">
                <xsl:call-template name="header"/>
            </xsl:if>
            <div class="content scan">
                <xsl:apply-templates select="/sru:scanResponse/sru:terms"/>
            </div>
        </div>
    </xsl:template>
    
    <!-- <sru:extraResponseData>
        <fcs:countTerms>619</fcs:countTerms>
        </sru:extraResponseData>
        <sru:echoedScanRequest>
        <sru:scanClause>diary-month</sru:scanClause>
        <sru:maximumTerms>100</sru:maximumTerms>        
        </sru:echoedScanRequest> -->
    <xsl:template name="header">
        <xsl:variable name="countTerms" select="((/sru:scanResponse/sru:extraResponseData/fcs:countTerms[@level='total'] - /sru:scanResponse/sru:extraResponseData/fcs:countTerms[@level='top']), /sru:scanResponse/sru:extraResponseData/fcs:countTerms)[1]"/>
        <xsl:variable name="start-item" select="'TODO:start-item=?'"/>
        <xsl:variable name="maximum-items" select="/sru:scanResponse/sru:echoedScanRequest/sru:scanClause"/>
        <div class="header">
            <xsl:attribute name="data-countTerms" select="$countTerms"/>
<!--            x-context:<xsl:value-of select="$x-context"/>-->
            <form>
                <input type="hidden" name="index" value="{$index}"/>
                <input class="scan-filter-text" type="text" name="x-filter" value="{$x-filter}"/>
                <input type="hidden" name="operation" value="scan"/>
                <input type="hidden" name="x-format" value="{$format}"/>
                <input type="hidden" name="x-context" value="{$x-context}"/>
                <input class="scan-filter-submit" type="submit" value="filter"/>
                <xsl:call-template name="prev-next-terms"/>
            </form>
            <!--<xsl:variable name="show_all-link">
                    <xsl:call-template name="formURL">
                        <xsl:with-param name="maximumTerms" select="$countTerms"/>                        
                    </xsl:call-template>
            </xsl:variable>-->
            <div class="hilight">
                <xsl:value-of select="(//sru:term[1]/sru:extraTermData/fcs:position)[last()]"/>
                <span class=""> - </span>
                <xsl:value-of select="(//sru:term[last()]/sru:extraTermData/fcs:position)[last()]"/>
                <span class=""> (</span>
                <xsl:value-of select="(count(//sru:terms/sru:term) - /sru:scanResponse/sru:extraResponseData/fcs:countTerms[@level='top'])"/>
                <span class="">) / </span><!--                <a class="internal show-all" href="{$show_all-link}" title="Show all">-->
                <xsl:value-of select="$countTerms"/><!--                </a> -->
                <xsl:text/>
                <xsl:value-of select="/sru:scanResponse/sru:extraResponseData/fcs:indexLabel"/>
            </div>
        </div>
    </xsl:template>
    
    <!-- 
sample data:        
        <sru:term>
        <sru:value>cartesian</sru:value>
        <sru:numberOfRecords>35645</sru:numberOfRecords>
        <sru:displayTerm>Carthesian</sru:displayTerm>
        <sru:extraTermData></sru:extraTermData>
        </sru:term>
    -->
    <xsl:template match="sru:terms">
        <!--        <xsl:variable name="index" select="my:xpath2index(@path)"/>-->
        <xsl:choose>
            <xsl:when test="$list-mode = 'table'">
                <table>
                    <xsl:apply-templates select="sru:term"/>
                </table>
            </xsl:when>
            <xsl:otherwise>
                <ul>
                    <xsl:if test="../cr:type">
                        <xsl:attribute name="class">
                            <xsl:value-of select="../cr:type"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:apply-templates select="sru:term"/>
                </ul>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="sru:term">
        <xsl:variable name="depth" select="count(ancestor::sru:term)"/>
        <xsl:variable name="href">
            <!--                        special handling for special index -->
            <xsl:choose>
                <xsl:when test="$index = 'fcs.resource'">
                    <!--                    <xsl:value-of select="utils:formURL('explain', $format, sru:value)"/>-->
                    <!--                    <xsl:value-of select="utils:formURL('get-data',$format,sru:value)"/>-->
                    <xsl:call-template name="formURL">
                        <xsl:with-param name="action" select="'scan'"/>
                        <xsl:with-param name="format" select="$format"/>
                        <xsl:with-param name="x-context" select="sru:value"/>
                        <xsl:with-param name="scanClause" select="'fcs.toc'"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$index = 'fcs.toc'">
                    <!--                    <xsl:value-of select="utils:formURL('explain', $format, sru:value)"/>-->
                    <!--                    <xsl:value-of select="utils:formURL('get-data',$format,sru:value)"/>-->
                    <xsl:variable name="q">
                        <xsl:choose>
                            <xsl:when test="sru:extraTermData/cr:type='resourcefragment'">
                                <xsl:value-of select="concat('fcs.rf', '%3D%22', sru:value, '%22')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat($index, '%3D%22', sru:value, '%22')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <!--<xsl:value-of select="utils:formURL('searchRetrieve', $format, $q)"/>-->
                    <xsl:call-template name="formURL">
                        <xsl:with-param name="action" select="'searchRetrieve'"/>
                        <xsl:with-param name="format" select="$format"/>
                        <!--<xsl:with-param name="x-context" select="ancestor::sru:extraTermData[cr:type='resource']/replace(preceding-sibling::sru:value,'_toc$','')"/>-->
                        <xsl:with-param name="q" select="$q"/>
                    </xsl:call-template>
                </xsl:when>
                <!-- TODO: special handling for cmd.collection? -->
                <!--<xsl:when test="$index = 'cmd.collection'">
                    <xsl:value-of select="utils:formURL('explain', $format, sru:value)"/>
                </xsl:when>-->
                <xsl:otherwise>
                    <xsl:variable name="q">
                        <xsl:choose>
                            <xsl:when test="sru:extraTermData/cr:type">
                                <xsl:value-of select="concat(sru:extraTermData/cr:type, '%3D%3D%22', sru:value, '%22')"/>
                            </xsl:when>
                            <xsl:when test="ancestor::sru:term">
                                <xsl:variable name="group-term" select="ancestor::sru:term[1]"/>
                                <xsl:value-of select="concat($group-term/sru:extraTermData/cr:type, '%3D%3D%22', $group-term/sru:value, '%22', ' and ', $index, '%3D%22', sru:value, '%22')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat($index, '%3D%3D%22', sru:value, '%22')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <!--<xsl:value-of select="utils:formURL('searchRetrieve', $format, $q)"/>-->
                    <xsl:call-template name="formURL">
                        <xsl:with-param name="action" select="'searchRetrieve'"/>
                        <xsl:with-param name="format" select="$format"/>
                        <!--<xsl:with-param name="x-context" select="ancestor::sru:extraTermData[cr:type='resource']/replace(preceding-sibling::sru:value,'_toc$','')"/>-->
                        <xsl:with-param name="q" select="$q"/>
                    </xsl:call-template>
                    <!-- currently utils:formURL does not support a 4th argument, and even though the underlying template supports a number of further parameters, none is for dataview
                         This should rather be moved as default into the searchRetrieve response. 
                        -->
<!--                    <xsl:value-of select="utils:formURL('searchRetrieve', $format, concat($index, encode-for-uri(concat('="', sru:value, '"'))))"/>-->
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="link">
            <span>
                <xsl:if test="sru:extraTermData/cr:type">
                    <xsl:attribute name="class">
                        <xsl:value-of select="sru:extraTermData/cr:type"/>
                    </xsl:attribute>
                </xsl:if>
                <!--                <xsl:value-of select="for $i in (1 to $depth) return '- '"/>-->
                <a class="search-caller" href="{$href}">  <!--target="_blank"-->
                    <xsl:value-of select="if (normalize-space((sru:displayTerm, sru:value)[1]) eq '') then '----------' else (sru:displayTerm, sru:value)[1]"/>
                </a>
            </span>
            <xsl:apply-templates select="sru:extraTermData/diagnostics"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$list-mode = 'table'">
                <tr>
                    <td align="right" valign="top">
                        <xsl:value-of select="sru:numberOfRecords"/>
                    </td>
                    <td>
                        <xsl:sequence select="$link"/>
                    </td>
                </tr>
                <xsl:apply-templates select="sru:extraTermData/sru:terms/sru:term"/>
            </xsl:when>
            <xsl:otherwise>
                <li>
                    <xsl:sequence select="$link"/>
                    <xsl:if test="number(sru:numberOfRecords) &gt;= 1">
                        <span class="note" data-content="recordcount">
                            <span class="recordcountDelimiter"> |</span>
                            <xsl:value-of select="sru:numberOfRecords"/>
                            <span class="recordcountDelimiter">|</span>
                        </span>
                    </xsl:if>
                    <!--DEBUG:<xsl:value-of select="exists(sru:extraTermData/sru:terms/sru:term)" />-->
                    <xsl:if test="sru:extraTermData/sru:terms/sru:term">
                        <xsl:apply-templates select="sru:extraTermData/sru:terms"/>
                    </xsl:if>
                </li>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xd:doc>
        <xd:desc>
            <xd:p>currently we support paging only for flat scans</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="prev-next-terms">
        <xsl:if test="(//fcs:countTerms[@level='top'] = 1) or (not(//sru:term//sru:term) or not(exists(//sru:term)))">
            <xsl:variable name="prev_responsePosition" select="if (string(number($maximumTerms)) ne 'NaN') then $maximumTerms + 1 else 0">
            <!--<xsl:choose>
                <xsl:when test="number($responsePosition) - number($maximumTerms) > 0">
                    <xsl:value-of select="format-number(number($responsePosition) - number($maximumTerms),'#')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="number($maximumTerms) - number($responsePosition)"/>
                </xsl:otherwise>
            </xsl:choose>-->
            </xsl:variable>
            <xsl:variable name="first_real_term" select="if (//fcs:countTerms[@level='top'] = 1) then 2 else 1"/>
            <xsl:variable name="prev_scanClause" select="concat($index, '=%22', replace((//sru:term)[$first_real_term]/sru:value,'\s+','%20'), '%22')"/>
            <xsl:variable name="link_prev">
                <xsl:call-template name="formURL">
                    <xsl:with-param name="responsePosition" select="$prev_responsePosition"/>
                    <xsl:with-param name="scanClause" select="$prev_scanClause"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="prev-disabled">
                <xsl:if test="number((//sru:term[1]/sru:extraTermData/fcs:position)[last()]) = 1">disabled</xsl:if>
            </xsl:variable>
            <xsl:variable name="next_scanClause" select="concat($index, '=%22', replace((//sru:term)[last()]/sru:value,'\s+','%20'), '%22')"/>
            <xsl:variable name="link_next">
                <xsl:call-template name="formURL">
                    <xsl:with-param name="responsePosition" select="'0'"/>
                    <xsl:with-param name="scanClause" select="$next_scanClause"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="next-disabled">
                <xsl:if test="number((//sru:term[last()]/sru:extraTermData/fcs:position)[last()]) &gt;= (number(/sru:scanResponse/sru:extraResponseData/fcs:countTerms[@level='total']) - /sru:scanResponse/sru:extraResponseData/fcs:countTerms[@level='top'])">disabled</xsl:if>
            </xsl:variable>
            <span class="result-navigation prev-next">
                <a class="internal prev {$prev-disabled}" href="{$link_prev}">
                    <span class="cmd cmd_prev">prev</span>
                </a>
                <a class="internal next {$next-disabled}" href="{$link_next}">
                    <span class="cmd cmd_next">next</span>
                </a>
            </span>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>