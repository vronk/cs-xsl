<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:utils="http://aac.ac.at/corpus_shell/utils" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ds="http://aac.ac.at/corpus_shell/dataset" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:exsl="http://exslt.org/common" version="2.0" extension-element-prefixes="exsl" exclude-result-prefixes="exsl xs utils xd ds">
    <xsl:import href="../utils.xsl"/>
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>
                <xd:b>Created on:</xd:b> 2012-09-26</xd:p>
            <xd:p>
                <xd:b>Author:</xd:b> m</xd:p>
            <xd:p>sub-stylesheet to produce a html table out of the internal dataset-representation</xd:p>
        </xd:desc>
    </xd:doc>
    
    <!--    values: dataseries-table or #any-->
    <xsl:param name="mode"/> 


  <!-- taken from cmd2graph.xsl  should be available at in helpers.xsl-->
<!--    <xsl:function name="utils:normalize">
        <xsl:param name="value"/>
        <xsl:value-of select="translate($value,'*/-.'',$@={}:[]()#>< ','XZ__')"/>
    </xsl:function>-->
    <xsl:template match="/">
   <!-- some root element, to deliver well-formed x(ht)ml -->
        <div>
            <xsl:apply-templates select="*" mode="data2table"/>
        </div>
    </xsl:template>
    <xsl:template match="*" mode="data2table">
        <xsl:apply-templates select="*" mode="data2table"/>
    </xsl:template>
    <xsl:template match="ds:dataset" mode="data2table">
        <xsl:param name="data" select="."/>
<!--        <xsl:param name="dataset-name" select="concat(utils:normalize(@name),position())"/>-->
        <xsl:variable name="dataset-key" select="utils:dataset-key(.)"/>
        <xsl:choose>
            <xsl:when test="$mode='dataseries-table'">
                <xsl:apply-templates select="$data" mode="dataseries-table"/>
            </xsl:when>
            <xsl:otherwise>
                <div id="table-{$dataset-key}">
                    <h3 class="title">
                        <xsl:value-of select="$data/(@name,@label,@key)[1]"/>
                    </h3>
                    <table class="show">
<!--                      XX<xsl:value-of select="count($data/ds:labels/ds:label)" />-<xsl:value-of select="count($data/ds:dataseries)" />-<xsl:value-of select="count($data/ds:labels/ds:label) > count($data/ds:dataseries)" />-->
                        <xsl:choose>
                            <xsl:when test="count($data/ds:labels/ds:label) &gt; count($data/ds:dataseries)">
                                <xsl:variable name="inverted-dataset">
                <!--<xsl:apply-templates select="exsl:node-set($data)" mode="invert"/>-->
                                    <xsl:apply-templates select="$data" mode="invert"/>
                                </xsl:variable>
                                <xsl:apply-templates select="$inverted-dataset" mode="table"/>
              <!--<xsl:copy-of select="."></xsl:copy-of>
                            <xsl:copy-of select="$inverted-dataset"></xsl:copy-of>-->
                            </xsl:when>
                            <xsl:otherwise>
              <!--                            <xsl:apply-templates select="exsl:node-set($data)" mode="table"/>-->
                                <xsl:apply-templates select="$data" mode="table"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </table>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
  <!--<xsl:template match="dataset" mode="data2table">
    <xsl:param name="data" select="."></xsl:param>
<xsl:choose>
  
    <xsl:when test="$mode='dataseries-table'">
      <xsl:apply-templates select="$data" mode="dataseries-table"></xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
        <table >
          <caption><xsl:value-of select="exsl:node-set($data)/@label"/></caption>
          <xsl:choose>
            <xsl:when test="count($data/labels/label) > count($data/dataseries)">
              <xsl:variable name="inverted-dataset">
                <xsl:apply-templates select="exsl:node-set($data)" mode="invert"></xsl:apply-templates>
              </xsl:variable>
              
              <xsl:apply-templates select="$inverted-dataset" mode="table"></xsl:apply-templates>
            </xsl:when>
            
            <xsl:otherwise>
              <xsl:apply-templates select="exsl:node-set($data)" mode="table"></xsl:apply-templates>
            </xsl:otherwise>
          </xsl:choose>
        </table>
    </xsl:otherwise>
</xsl:choose>          

        
  </xsl:template>
  -->
    <xsl:template match="ds:labels" mode="table">
        <thead>
            <tr>
                <th>key</th>
                <xsl:apply-templates mode="table"/>
            </tr>
        </thead>
    </xsl:template>
    <xsl:template match="ds:dataseries" mode="table">
        <tr>
            <td title="{@key}">
                <xsl:value-of select="(@name,@label,@key)[not(.='')][1]"/>
                <xsl:if test="@type='reldata'">
                    <br/>
                    <xsl:value-of select="ancestor::ds:dataset/@percentile-unit"/>
                </xsl:if>
            </td>
            <xsl:apply-templates mode="table"/>
        </tr>
    </xsl:template>
    <xsl:template match="ds:labels" mode="dataseries-table"/>
    <xsl:template match="ds:dataseries" mode="dataseries-table">
  <!--  variable $labels not used yet, todo :  -->
        <xsl:variable name="labels" select="../ds:labels"/>
        <div id="{concat(utils:normalize(../@key), '-', utils:normalize(@key))}">
            <table class="show">
                <caption>
                    <xsl:value-of select="(@name,@label,@key)[not(.='')][1]"/>
                </caption>
                <xsl:for-each select="ds:value">
                    <xsl:variable name="label" select="$labels/ds:label[@key=current()/@key]/text()"/>
                    <tr>
                        <td>
                            <xsl:value-of select="($label|@label|@key)[not(.='')][1]"/>
                        </td>
                        <xsl:apply-templates select="." mode="table"/>
                    </tr>
                </xsl:for-each>
            </table>
        </div>
    </xsl:template>
    <xsl:template match="ds:label" mode="table">
        <th colspan="{if (xs:string(@type)='reldata') then 2 else 1}">
            <xsl:value-of select="(.|@key)[not(.='')][1]"/>
        </th>
    </xsl:template>
    <xsl:template match="ds:value" mode="table">
        <xsl:variable name="val">
            <xsl:choose>
                <xsl:when test="@formatted">
                    <xsl:value-of select="@formatted"/>
                </xsl:when>
                <xsl:when test="@abs">
                    <xsl:value-of select="@abs"/>
                </xsl:when>
                <xsl:when test="ds:list">
                    <xsl:value-of select="count(ds:list/*)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="class-number">
            <xsl:if test="number($val)=number($val)">number value</xsl:if>
        </xsl:variable>
        <td class="{$class-number}">
            <xsl:choose>
                <xsl:when test="ds:list">
                    <a class="detail-caller" href="">
                        <xsl:value-of select="$val"/>
                    </a>
                    <div class="detail">
                        <xsl:apply-templates select="ds:list" mode="table"/>
                    </div>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$val"/>
                </xsl:otherwise>
            </xsl:choose>
        </td>
        <xsl:if test="@rel_formatted">
            <td class="value number">
                <xsl:value-of select="@rel_formatted"/>
            </td>
        </xsl:if>
      
<!--      <xsl:value-of select="@abs" />-->
<!--      <xsl:value-of select="@formatted" />-->
<!--      <xsl:if test="@rel_formatted">
        <br/><xsl:value-of select="@rel_formatted" />
      </xsl:if>-->
    </xsl:template>
    <xsl:template match="ds:list" mode="table">
        <ul>
            <xsl:apply-templates select="*" mode="table"/>
        </ul>
    </xsl:template>
    <xsl:template match="ds:li" mode="table">
        <xsl:variable name="key" select="utils:normalize(@key)"/>
        <li>
            <a href=".?selected={$key}" data-key="{$key}" title="{(@title,$key)[1]}">
                <xsl:value-of select="."/>
            </a>
        </li>
    </xsl:template>
    
    <!-- moved to amc-helpers.xsl
    <xsl:template match="dataset" mode="invert">
        <xsl:param name="dataset" select="."/>
        <dataset>
            <xsl:copy-of select="@*"/>
            <labels>
                <xsl:for-each select="dataseries">
                    <label>
                        <xsl:if test="@type">
                            <xsl:attribute name="type" select="@type"/>
                        </xsl:if>
                        <xsl:if test="@key">
                            <xsl:attribute name="key" select="@key"/>
                        </xsl:if>
                        <xsl:value-of select="(@name, @label ,@key)[1]"/>
                    </label>
                </xsl:for-each>
            </labels>
            <xsl:for-each select="labels/label">
                <xsl:variable name="curr_label_old" select="(@key, text())[1]"/>
                <dataseries key="{$curr_label_old}" label="{text()}">
                    <xsl:for-each select="$dataset//value[$curr_label_old=@key or $curr_label_old=@label]">
                        <value key="{(../@name, ../@label,../@key)[not(.='')][1]}">
                            <xsl:copy-of select="@*[not(.='')]"/>
              <!-\- formatted="{@formatted}"
                <xsl:if test="../@type"><xsl:attribute name="type" select="../@type"></xsl:attribute></xsl:if>-\->
                            <xsl:value-of select="."/>
                        </value>
                    </xsl:for-each>
                </dataseries>
            </xsl:for-each>
        </dataset>
    </xsl:template>-->
</xsl:stylesheet>