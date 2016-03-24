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
   xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xsl xd tei sru"
   extension-element-prefixes="saxon str exsl"
   >
   <xsl:import href="result2view_v1.xsl"/>
   <xsl:output method="html" media-type="text/html" indent="yes" encoding="UTF-8" doctype-system="about:legacy-compat"/>
   <!--   <xsl:output method="html" media-type="text/xhtml" indent="yes" encoding="UTF-8" omit-xml-declaration="yes" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/> -->

   <xsl:template name="getTitle">
   </xsl:template>
   
   <xsl:template name="callback-header">
      <link href="/static/fonts/andika/Andika.css" type="text/css" rel="stylesheet"/>
      <style type="text/css">
         body { font: 13px/1.5 AndikaW, 'Andika', serif; }
         input.virtual-keyboard-input { font-family: AndikaW, 'Andika', serif } 
      </style>
      <link href="{$scripts_url}style/glossary.css" type="text/css" rel="stylesheet"/>      
      <script type="text/javascript" src="{$scripts_url}js/URI.js"></script>
      <script type="text/javascript" src="{$scripts_url}js/jquery/jquery.selection.js"></script>
      <script type="text/javascript" src="scripts/js/params.js"></script>
      <script type="text/javascript" src="{$scripts_url}js/virtual-keyboard.js"></script>
      <link href="{$scripts_url}style/virtual-keyboard.css" type="text/css" rel="stylesheet"/>
      <script type="text/javascript">
         VirtualKeyboard.keys = {
            "arz_eng_006": ["ʔ", "ā", "ḅ", "ʕ", "ḍ", "ḏ", "ē", "ġ", "ǧ", "ḥ", "ī", "ᴵ", "ḷ", "ṃ", "ō", "ṛ", "ṣ", "š", "ṭ", "ṯ", "ū", "ẓ", "ž"],
            "apc_eng_002": ["ʔ", "ā", "ḅ", "ʕ", "ḍ", "ḏ", "ē", "ǝ", "ᵊ", "ġ", "ǧ", "ḥ", "ī", "ᴵ", "ḷ", "ṃ", "ō", "ṛ", "ṣ", "š", "ṭ", "ṯ", "ū", "ẓ", "ž"],
            "aeb_eng_001__v001":["ʔ", "ā", "ḅ", "ʕ", "ḏ̣", "ḏ", "ē", "ġ", "ǧ", "ḥ", "ī", "ᴵ", "ḷ", "ṃ", "ō", "ṛ", "ṣ", "š", "ṭ", "ṯ", "ū", "ẓ", "ž"], 
			 "pes_eng_032": ["ï", "š", "ž", "ọ", "ẕ", "ṣ", "ṭ", "s̠", "ḫ", "ẓ", "â", "ḏ", "ḫ", "s̠", "ṯ", "ã", "ậ", "č", "ë", "ǧ"]
         }
         VirtualKeyboard.keys["aeb_eng_001__v001F"] = VirtualKeyboard.keys["aeb_eng_001__v001"]
         $(document).ready(function(){
            VirtualKeyboard.attachKeyboards()
         });
      </script>
      <xsl:call-template name="callback-header2"/>
   </xsl:template>
   
   <xsl:template name="callback-header2"/>
   
   <xsl:template name="queryTextUI">
      <span class="virtual-keyboard-input-combo virtual-keyboard-input-above">
         <input name="query" type="text" size="18" class="queryinput active virtual-keyboard-input" id="query-text-ui" value="{$q}" data-context="{$x-context}"/>
         <input type="checkbox" value="unused" class="virtual-keyboard-toggle" id="glueToLabel1" checked="checked"/>
         <label for="glueToLabel1" class="virtual-keyboard-first-three">äöü</label>
      </span>       
   </xsl:template>
   
   <xsl:template match="fcs:Resource" mode="record-data">
      <xsl:apply-templates select=".//fcs:DataView[not(@type='metadata')]" mode="record-data"/>
      <xsl:apply-templates select=".//fcs:DataView[@type='metadata']" mode="record-data"/>
   </xsl:template>
   
   <xsl:template name="analyzeAna">
      <xsl:variable name="anaParts" select="substring-after(@ana, '#')"/>
      <xsl:choose>
         <xsl:when test="function-available('saxon:tokenize')">
            <xsl:for-each select="saxon:tokenize($anaParts, '_')">
               <span class="tei-form-ana"><xsl:value-of select="."/></span>
            </xsl:for-each>            
         </xsl:when>
         <xsl:when test="function-available('str:tokenize')">
            <xsl:for-each select="str:tokenize($anaParts, '_')">
               <span class="tei-form-ana"><xsl:value-of select="."/></span>
            </xsl:for-each>            
         </xsl:when>
      </xsl:choose>
          
   </xsl:template>
   
   <xd:doc>
      <xd:desc>For private use.</xd:desc>
   </xd:doc>
   <xsl:template match="tei:xr" mode="record-data"/>
   
</xsl:stylesheet>
