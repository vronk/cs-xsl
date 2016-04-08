<xsl:stylesheet
   xmlns="http://www.w3.org/1999/xhtml"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:diag="http://www.loc.gov/zing/srw/diagnostic/"
   xmlns:tei="http://www.tei-c.org/ns/1.0"
   xmlns:saxon="http://saxon.sf.net/"
   xmlns:sru="http://www.loc.gov/zing/srw/"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:fcs="http://clarin.eu/fcs/1.0"
   xmlns:exsl="http://exslt.org/common"
   xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
   exclude-result-prefixes="saxon xs exsl diag sru fcs xd tei"
   version="1.0">
   <xsl:import href="../../dictionary-sites/glossary.xsl"/>
   <xsl:output method="html" media-type="text/html" indent="yes" encoding="UTF-8" doctype-system="about:legacy-compat"/>
   <xsl:variable name="site_name">
      <!--default html-element is h2-->
      <h2><span class="spHead2_left">A digital dictionary of <span class="spHead2_right"><i>DAMASCENE</i></span> Arabic</span></h2>
   </xsl:variable>
   <xsl:template name="sitename">
      <xsl:copy-of select="$site_name"/>
   </xsl:template>
   <xsl:variable name="site_logo">
      <!-- if you like to have a logo in the header add file-path to your header logo here -->
   </xsl:variable>
   
   <xsl:template name="callback-header">
      
      <style>
         html, body {background-image:linear-gradient(rgba(255, 255, 255, 0.6), rgba(255, 255, 255, 0.6)),url("https://minerva.arz.oeaw.ac.at/static/images/vicav/Dam-Babassalam3.JPG");
         color:#000;background-size:cover;background-position:0;background-attachment:fixed;background-repeat:no-repeat;}
         table {font-size:0.9em;}
         tbody {display:table;width:100%;}
         .navbar {border-radius:0;background-image:none;}
         .tei-entry {margin-bottom:2rem;border:2px solid #304E75;padding:1rem;}
         dt.tei-gram { display: none;}
         .result-navigation p {padding-left:1rem !important;}
         .tei-cit {display:block;}
         .label {color:black !important;}
         .tei-gramGrp,dd.tei-gram {display: inline;color:#238DD1;}
         .tei-orth {margin-right:0.4rem;}
         .tei-orth:first-child {font-weight:bold;}
         .label:nth-of-type(5),.label:nth-of-type(7){display:none !important;}
         .searchresults {color:black !important;float:left;}
         .form-control {font-size:0.8em !important;padding:0rem !important;height:2rem !important;}
         #submit-query {height:2rem !important;padding:0rem !important;}
         .note {display:none!important;}
         #querysearch br {display:none !important;}
         .result-navigation {display:block !important;}
         .record-top {display:none !important;}
         .ui-state-default {background:none !important; color:white !important; border:none !important;}
         h1 {color:white !important;}
         h4 {
         padding-right: 20px;
         padding-left: 3px;
         padding-right:3px;
         border: 1px solid #B05045;
         background: #B05045;
         color: rgb(247,254,160) !important; 
         }
         .spHighRed {
         color: #B05045;
         }
         .spHead2_left {
         color: black;
         font-weight: bold;
         }
         .spHead2_right {
         color: #1A3769;
         font-weight: bold;
         }
         .spHead2_centre {
         color: #1A3769;
         font-weight: bold;
         }
         .wordforms {
         color: rgb(130,28,198);
         }
         .spPos {
         color: rgb(130,28,198);
         }
         .dvSenses {
         color: rgb(187,61,0);
         }
         .cantoneseSenses {
         color: rgb(185,181,2);
         }
         .germanSenses {
         color: rgb(55,117,0);
         }
         #glueToLabel1 {display:none;}
         .virtual-keyboard-first-three {display:none;}
         #front .tei-teiHeader {display:none;}
         iframe {margin-top:6rem;width:auto;height:auto;float:left;}
         
         .navbar-brand {padding:0 !important;}
         .entrytable td:first-child {
         white-space: normal;
         }
         
         .row {margin:0 !important;}
         .result-body {margin-top:2rem;}
         #dvLanguage {display:none;}
         #dvDocumentation {display:none;}
         .disabled {visibility:hidden !important;}
         .result-navigation {margin-top:1rem;} 
         .counter {display:none;}
         
         .tdNorm {
         border-bottom: 1px solid #CCC;
         padding-left:3px;
         vertical-align: top;
         word-break:break-all;
         background: rgb(232, 234, 151);
         }
         
         .tdLeft {
         text-align: right;
         padding-right: 5px;
         padding-left: 5px;
         vertical-align: top;
         border-bottom: 1px solid #CCC;
         background: rgb(176, 179, 91);
         color: rgb(250, 250, 250); !important;
         font-weight: bold;
         width:100px;
         }
         .tbLemma {
         border-collapse: collapse;
         width: 100%;
         margin-bottom: 10px;
         border: 1px solid rgb(174,87,0);
         box-shadow: 10px 10px 5px rgb(131,107,27);
         }
         .jumbotron{
         
         padding-left: 2rem; 
         background-color:transparent;
         padding-top: 15px !important;
         margin-bottom: 0!important; 
         }
         .dvRoundLemmaBox {
         text-align: right;
         padding-right: 5px;
         position: relative;
         top: 3px;
         left: -10px;
         width: 100px;
         border-radius: 5px;
         background: rgb(232, 234, 151);
         font-weight: bold;
         border: 1px solid rgb(140,70,0);
         }
         @media screen and (-webkit-min-device-pixel-ratio: 3.0) and (max-width: 1080px), screen and (max-width: 480px) {
         .jumbotron { padding-top: 0 !important;
         }
         h2 { margin-top: 0 !important;padding-top:5px !important;}
         }         
         .xsl-audio.xsl-outer {
         <xsl:value-of select="concat('background-image: url(', $scripts_url, 'style/base/images/ui-icons_2e83ff_256x240.png)/*{iconsContent}*/;')"/>
         display: inline-block;
         background-position: 0 -160px;
         width: 16px;
         height: 16px;
         margin-right: 0.5em;
         margin-left: 0.5em;
         position: relative;
         }
         .xsl-audio.xsl-outer:hover .xsl-audio.xsl-inner,
         .xsl-audio.xsl-inner:hover,
         .xsl-audio.xsl-inner:hover:active {display: block}
         .xsl-audio.xsl-inner {
         display: none;
         position: absolute;
         top: -8px;
         left: 14px;
         } 
      </style>
      
   </xsl:template>
   
   
   <xsl:template name="menu-content">        
      <ul class="nav navbar-nav">
         <li id="li-search"><a>Search</a></li>
         <li id="li-language"><a>Help</a></li>
         <li id="li-about"><a>About</a></li>
         <li id="li-impressum"><a>Impressum</a></li>
      </ul>
   </xsl:template>
   
   <xsl:template name="page-content">
      <div id="main">
         <xsl:call-template name="front"/>
         <xsl:call-template name="continue-root"/>
         <xsl:call-template name="help"/>
         <xsl:call-template name="about"/>
         <xsl:call-template name="impressum"/>
      </div>          
   </xsl:template>
   
   <xsl:template name="about">
      <div class="container" id="about">
         <xsl:call-template name="getVICAVDictionariesAbout"/>
      </div>
   </xsl:template>
   
   <xsl:template match="tei:entry" mode="record-data">
      
      <div class="dvRoundLemmaBox">
         <xsl:value-of select="tei:form[@type='lemma']/tei:orth[@xml:lang='ar-apc-x-damascus-vicavTrans'] |  tei:form[@type='multiWordUnit']/tei:orth[@xml:lang='ar-apc-x-damascus-vicavTrans']"/>
         
      </div>
      <table class="tbLemma">
         <tr>
            <td class="tdLeft">Lemma</td>
            <td class="tdNorm">
               <xsl:value-of select="tei:form[@type='lemma']/tei:orth[@xml:lang='ar-apc-x-damascus-vicavTrans'] | tei:form[@type='multiWordUnit']/tei:orth[@xml:lang='ar-apc-x-damascus-vicavTrans']"/>
               <xsl:apply-templates select="tei:form[@type='lemma']/tei:media"/>
            </td>
         </tr>
         <xsl:if test="tei:gramGrp/tei:gram[@type='pos']">
            <tr>
               <td class="tdLeft">POS</td>
               <td class="tdNorm">
                  <span class="spPos"><xsl:value-of select="tei:gramGrp/tei:gram[@type='pos']"/></span>
               </td>
            </tr>
         </xsl:if>
         <xsl:if test="tei:form[@type='inflected']">
            <tr>
               <td class="tdLeft">
                  <xsl:choose>
                     <xsl:when test="tei:form[@ana='#n_pl']">Plural</xsl:when>
                     <xsl:otherwise>Infl. form</xsl:otherwise>
                  </xsl:choose>
               </td>
               <td class="tdNorm">
                  <xsl:for-each select="tei:form[@type='inflected']">
                     <xsl:if test="position() > 1">, </xsl:if>
                     <xsl:value-of select="tei:orth[@xml:lang='ar-apc-x-damascus-vicavTrans']"/>                     
                     <xsl:apply-templates select="tei:media"/>
                  </xsl:for-each>
               </td>
            </tr>
            
            
         </xsl:if>
         <xsl:for-each select="tei:sense">
            <tr>
               <td class="tdLeft">Sense</td>
               <td class="tdNorm">
                  <div>
                     <xsl:value-of select="tei:cit[@xml:lang='en']/tei:quote"/>
                     <xsl:if test="tei:usg[@type='dom']"><b class="spUsg"> [<xsl:value-of select="tei:usg[@type='dom']"/>]</b></xsl:if>
                     <xsl:for-each select="tei:cit[@type='example']">
                        <div class="dvExample">
                           <xsl:value-of select="tei:quote[@xml:lang='ar-apc-x-damascus-vicavTrans']"/>
                           <xsl:text> </xsl:text><i class="exTranslation">
                              <xsl:value-of select="tei:cit[@type='translation' and @xml:lang='en']/tei:quote"/></i>
                        </div>
                     </xsl:for-each>
                  </div>
               </td>
            </tr>
         </xsl:for-each>
      </table>
   </xsl:template>
   
   <xsl:template match="tei:media[@mimeType='audio/wav']">
      <xsl:variable name="audiofile"
         select="concat('https://minerva.arz.oeaw.ac.at/static/audio/words/apc_eng_002/', @url)"/>      
      <span class="xsl-audio xsl-outer tei-orth">
         <div class="xsl-audio xsl-inner">
            <audio controls="controls" preload="none">
               <source src="{$audiofile}" type="audio/wav"/>
               <a href="{$audiofile}">Download</a>
            </audio>
         </div>
      </span>
   </xsl:template>
   
</xsl:stylesheet>