<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
   xmlns:tei="http://www.tei-c.org/ns/1.0"
   xmlns:exsl="http://exslt.org/common"
   xmlns:sru="http://www.loc.gov/zing/srw/"
   xmlns:fcs="http://clarin.eu/fcs/1.0"
   xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xsl exsl xd tei sru fcs">
   <xsl:import href="fcs/result2view_v1.xsl"/>
   <xsl:output method="html" media-type="text/xhtml" indent="yes" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/> 

   <xsl:template name="getTitle">
   </xsl:template>
   
   <xsl:template name="callback-header">
      <link href="/static/fonts/istok/istokweb.css" type="text/css" rel="stylesheet"/>  
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
         }
         $(document).ready(function(){
            VirtualKeyboard.attachKeyboards()
         });
      </script>
   </xsl:template>
   
   <xsl:template match="fcs:Resource" mode="record-data">
      <xsl:apply-templates select=".//fcs:DataView[not(@type='metadata')]" mode="record-data"/>
      <xsl:apply-templates select=".//fcs:DataView[@type='metadata']" mode="record-data"/>
   </xsl:template>
   
   <xd:doc>
      <xd:desc>For private use.</xd:desc>
   </xd:doc>
   <xsl:template match="tei:xr" mode="record-data"/>
   
</xsl:stylesheet>
