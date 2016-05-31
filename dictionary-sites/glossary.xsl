<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
   xmlns:tei="http://www.tei-c.org/ns/1.0"
   xmlns:exsl="http://exslt.org/common"
   xmlns:sru="http://www.loc.gov/zing/srw/"
   xmlns:fcs="http://clarin.eu/fcs/1.0"
   xmlns:saxon="http://icl.com/saxon"
   xmlns:str="http://exslt.org/strings"
   xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xsl xd tei sru fcs"
   extension-element-prefixes="saxon str exsl"
   >
   <xsl:import href="../glossary.xsl"/>
   <xsl:output method="html" media-type="text/html" indent="yes" encoding="UTF-8" doctype-system="about:legacy-compat"/>
   
   <xd:doc>
      <xd:desc>Header can be much simpler.</xd:desc>
   </xd:doc>
   <xsl:template name="header">
      <div class="result-header" data-numberOfRecords="{$numberOfRecords}">
         <xsl:call-template name="query-input"/>
      </div>
   </xsl:template>
   
   <xd:doc>
      <xd:desc>Search results (default root element within body) needs to be wrapped in a div representing the
         search part of the web site.
      </xd:desc>
   </xd:doc>
   <xsl:template name="continue-root">
      <div id="searchcontainer" class="container">
         <input type="checkbox" value="unused" style="display: none;" id="exampleToggle"/>
         <xsl:call-template name="continue-root-base"/>
      </div>
   </xsl:template>
   
   <xd:doc>
      <xd:desc>Customized query input</xd:desc>
   </xd:doc>
   <xsl:template name="queryTextUI">
      <span class="virtual-keyboard-input-combo virtual-keyboard-input-above">
         <input name="query" type="text" size="18" class="queryinput active virtual-keyboard-input form-control" id="query-text-ui"
            value="{$q}" data-context="{$x-context}" data-index="{$index}" data-operator="{$operator}" data-searchstring="{$searchString}"/>
         <input type="checkbox" value="unused" class="virtual-keyboard-toggle" id="glueToLabel1" checked="checked"/>
         <label for="glueToLabel1" class="fa fa-keyboard-o" aria-hidden="true"/>
      </span>       
   </xsl:template>
   
   <xsl:template name="additional-search-ui-controls">
      <fieldset class="form-group">
         <span class="checkbox"><label for="exampleToggle" id="exampleToggle">Show examples</label></span>
      </fieldset>
   </xsl:template>
   
   
   <xd:doc>
      <xd:desc>Sets this variable to those classes that the bootstrap grid needs to create the search result
         with the right sizes on different screens.
      </xd:desc>
   </xd:doc>
   <xsl:variable name="additional-searchresults-classes">col-xs-12 col-sm-6 col-lg-4</xsl:variable>
   
   <xd:docc>
      <xd:desc>Treat a single result the same way as mulitple results.</xd:desc>
   </xd:docc>
   <xsl:template name="single-result">      
      <xsl:call-template name="multiple-results-table"/>
   </xsl:template>
   
</xsl:stylesheet>
