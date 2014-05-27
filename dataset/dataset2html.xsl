<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:diag="http://www.loc.gov/zing/srw/diagnostic/" xmlns:utils="http://aac.ac.at/corpus_shell/utils" xmlns:sru="http://www.loc.gov/zing/srw/" xmlns:saxon="http://saxon.sf.net/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fcs="http://clarin.eu/fcs/1.0" xmlns:ds="http://aac.ac.at/corpus_shell/dataset" xmlns:exsl="http://exslt.org/common" version="2.0" exclude-result-prefixes="saxon xs exsl diag sru fcs utils ds">
    
<!--   
    <purpose> generate html view of a dataset, basically use dataset2table but also use commons to wrap it in html.</purpose>
<history>  
<change on="2013-01-24" type="created" by="vr"></change>	
</history>   
 -->
    <xsl:import href="dataset2table.xsl"/>
    <xsl:import href="../utils.xsl"/>
    <!--  method="xhtml" is saxon-specific! prevents  collapsing empty <script> tags, that makes browsers choke -->
    <!-- doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" -->
    <xsl:output method="html" media-type="text/xhtml" indent="yes" encoding="UTF-8"/>
    <xsl:include href="../commons_v2.xsl"/>
    <xsl:param name="site_logo" select="'../scripts/style/imgs/clarin-logo.png'"/>
    <xsl:param name="site_name">SMC statistics</xsl:param>
    
    <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
        <xd:desc>
            <xd:p>prefix for the file names, if outputing dataset to separate files</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="output_file_prefix">dataset_</xsl:param>
    
    <xsl:param name="title"/>
    <xsl:variable name="cols">
        <col>all</col>
    </xsl:variable>
    <xsl:template name="continue-root">
        <xsl:param name="mode" select="$mode"></xsl:param>
        <xsl:choose>
            <xsl:when test="contains($mode,'multiple-files')">
                <xsl:apply-templates select="//ds:dataset" mode="multi"/>
            </xsl:when>
            <xsl:otherwise>
                <div>
                    <xsl:apply-templates select="*" mode="data2table"/>
                </div>        
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    <xsl:template name="top-menu">
        <xsl:for-each select="//ds:dataset">
            <!-- this has to be in sync with  <xsl:template match="ds:dataset" mode="data2table"> in dataset2table.xsl -->
            <xsl:variable name="dataset-key" select="utils:dataset-key(.)"/>
<!--                <a href="#dataset-{@key}" ><xsl:value-of select="(@label,@key)[1]"></xsl:value-of></a> | -->
            <xsl:variable name="href">
                <xsl:choose>
                    <xsl:when test="contains($mode,'multiple-files')">
                        <xsl:value-of select="concat($output_file_prefix, $dataset-key,'.html')"></xsl:value-of>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('#table-', $dataset-key)"></xsl:value-of>   
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <a href="{$href}" title="{@key}">
                <xsl:value-of select="(@label,@key)[1]"/>
            </a> |
            
            </xsl:for-each>
    </xsl:template>
    <xsl:template name="callback-header">
        <!--  temporary fix - cmds-ui.css actually deprecated -->
<!--        <link href="{$scripts_url}style/cmds-ui.css" type="text/css" rel="stylesheet" ></link>-->
        <script type="text/javascript">
            $(function()
            {
         /*   $(".detail-caller").live("mouseover", function(event) {
                //console.log(this);
                $(this).parent().find('.detail').show();
              });
            
            $(".detail-caller").live("mouseout", function(event) {
                //console.log(this);
                $(this).parent().find('.detail').hide();
              });
           */ 
           
            $(".detail-caller").live("click", function(event) {
                //console.log(this);
                event.preventDefault();
                $(this).parent().find('.detail').toggle();
              });
              
            });
        </script>
        
    </xsl:template>
    
    <xsl:template match="ds:dataset" mode="multi">
        <xsl:variable name="dataset-key" select="utils:dataset-key(.)"/>
        <xsl:variable name="output_href" select="concat($output_file_prefix, $dataset-key, '.html') "></xsl:variable>
        <xsl:result-document href="{$output_href}">
            <xsl:call-template name="html-with-data" >
                <xsl:with-param name="payload">
                    <div>
                        <xsl:apply-templates select="." mode="data2table"/>
                    </div>        
                </xsl:with-param>
            </xsl:call-template>
            
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>