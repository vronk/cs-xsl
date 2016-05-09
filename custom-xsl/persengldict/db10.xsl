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
  
   <xsl:template name="sitename">
      <h2>Persian <i>English</i> Dictionary</h2>
   </xsl:template>
   <xsl:variable name="site_logo">
<!-- if you like to have a logo in the header add file-path to your header logo here -->
   </xsl:variable>
   
   <xsl:template name="callback-header">
      
      <style>
         .tei-teiHeader h1 {display:none;}
         
         .zr-description h1 {display:none;}
         
         table {
            font-size:0.9em;
         }
         
         html {
           background: #f3ebc1;
         }
         
        body{
           background: transparent;
         }
         h2 {margin-bottom:0px;}
 
         tbody {
           display:table;
           width:100%;
         }
         
         .tei-entry {
            margin-bottom:2rem;
            border:2px solid #304E75;
            padding:1rem;
         }
 
         dt.tei-gram {
            display: none;
         }
 
         .tei-cit {
         display:block;
            }
            
         .tei-gramGrp,dd.tei-gram {
         display: inline;
            color:#238DD1;
            }
            
         .tei-orth {
         margin-right:0.4rem;
            }
            
         .tei-orth:first-child {
         font-weight:bold;
            }
            
         .ui-state-default {
         background:none !important; 
            color:white !important; 
            border:none !important;
            }
            
         .sense-en {color:black;}
         .sense-de {color:black;}
         .sense-es {color:black;}
         .lemma {color:black;}
         .inflected {color:black;}
         
         h1 {color:white;}
         
         h4 {
           padding-right: 20px;
           padding-left: 3px;
           padding-right:3px;
           border: 1px solid #B05045;
           background: #B05045;
           color: rgb(247,254,160); 
         }
         .spPos {
            color: rgb(130,28,198);
            font-style: normal;
         }
 
         .dvSenses {
            color: rgb(187,61,0);
         }
         #glueToLabel1 {display:none;}
         .virtual-keyboard-first-three {display:none;}
         #front .tei-teiHeader {display:none;}
         
        
      .entrytable td:first-child {
         white-space: normal;
      }
 
      .jumbotron {
             padding-left: 2rem; 
             padding-top: 5px;
             padding-bottom: 0;
             margin-bottom: 0; 
             background-color: orange;
       }
   
       #dvLanguage {display:none;}
       #dvDocumentation {display:none;}
      .spTransText {
         font-style: italic;
         color: rgb(122,124,58);
      }
 
      .tdNorm {
         border-bottom: 1px solid #CCC;
         padding-left:3px;
         vertical-align: top;
         word-break:break-all;
         background: rgb(232, 234, 151);
         word-break: keep-all;
       }
         
      .tdExampleNorm {
         border-bottom: 1px solid #CCC;
         padding-left:3px;
         vertical-align: top;
         word-break:break-all;
         background: rgb(242,243,194);
         word-break: keep-all;
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
  
     .tbExample {
         border-collapse: collapse;
         width: 100%;
         margin-bottom: 10px;
         border: 1px solid rgb(174,87,0);
         box-shadow: 10px 10px 5px rgb(131,107,27);
         word-break: keep-all;
      }
        
     
     .dvExample {
         left: -10px;
         padding-left: 5px;
         word-break: keep-all;
     }
    
     .dvLemmaExample {
         left: -10px;
         border: 1px solid black;
         margin-right: 3px;
         padding-left: 5px;
         padding-right: 5px;
         word-break: keep-all;
         background: rgb(247,248,218);
         color: rgb(137,139,65);
     }
    
     .spExTranslation {
        word-break: keep-all;
        color: black;
      }
 
     .dvRoundLemmaBox {
         text-align: right;
         direction: rtl;
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
         <li id="li-help"><a>Help</a></li>
         <li id="li-about"><a>About</a></li>
         <li id="li-lang"><a>Language</a></li>
         <li id="li-impressum"><a>Impressum</a></li>
      </ul>
   </xsl:template>
   
   <xsl:template name="page-content">
      <div id="main">
         <xsl:call-template name="front"/>
         <xsl:call-template name="continue-root"/>
         <xsl:call-template name="help"/>
         <xsl:call-template name="about"/>
         <xsl:call-template name="lang"/>
         <xsl:call-template name="impressum"/>
      </div>
   </xsl:template>
   
   <xsl:template name="front">
      <div class="front" id="front">
front
      </div>
   </xsl:template>
   <xsl:template name="help">
      <div class="help" id="help">
   help
      </div>
   </xsl:template>
   <xsl:template name="about">
      <div class="container" id="about">
         About.
      </div>
   </xsl:template>
   <xsl:template name="lang">
      <div class="front" id="front">
   Persian is a ...
      </div>
   </xsl:template>
   <xsl:template name="impressum">
      <div class="impressum" id="impressum">
   impressum
      </div>
   </xsl:template>
 
 
 
   <xsl:template match="tei:cit[@type='example']" mode="record-data">
      <div class="dvExample">
         <table class="tbExample">
            <tr>
               <td class="tdExampleNorm">
                  <span class="spTransText">
                     <xsl:value-of select="tei:quote[@xml:lang='fa-x-modDMG']"/>
                  </span>
               </td></tr>
    
            <xsl:if test="string-length(tei:quote[@xml:lang='fa-Arab'])&gt;1">
               <tr>
                  <td class="tdExampleNorm"><xsl:value-of select="tei:quote[@xml:lang='fa-Arab']"/></td></tr>
            </xsl:if>
            <tr><td class="tdExampleNorm"><xsl:value-of select="tei:cit[@type='translation']/tei:quote"/></td></tr>
         </table>
      </div>
   </xsl:template>
   <xsl:template match="tei:entry" mode="record-data">
      
      <div class="dvRoundLemmaBox">
         <xsl:value-of select="tei:form[@type='lemma']/tei:orth[@xml:lang='fa-Arab'] |  tei:form[@type='multiWordUnit']/tei:orth[@xml:lang='fa-Arab']"/>
      </div>
      <table class="tbLemma">
         <tr>
            <td class="tdLeft">Lemma</td>
            <td class="tdNorm">
               <span class="spTransText">
                  <xsl:value-of select="tei:form[@type='lemma']/tei:orth[@xml:lang='fa-x-modDMG'] | tei:form[@type='multiWordUnit']/tei:orth[@xml:lang='fa-x-modDMG']"/>
                  <xsl:if test="tei:gramGrp/tei:gram[@type='pos']">
                     <span class="spPos">   [<xsl:value-of select="tei:gramGrp/tei:gram[@type='pos']"/>]</span>
                  </xsl:if>
                  <xsl:apply-templates select="tei:form[@type='lemma']/tei:media"/>
               </span>
            </td>
         </tr>
         <xsl:for-each select="tei:form[@type='inflected'] | tei:form[contains(@type, 'Stem')]">
            <tr>
               <td class="tdLeft">
                  <xsl:if test="@ana='#n_pl'">Plural</xsl:if>
                  <xsl:if test="contains(@type,'Stem')"><xsl:value-of select="@type"/></xsl:if>
                  <xsl:if test="@type='inflected'"><xsl:value-of select="@type"/></xsl:if>
                  <xsl:if test="usg"> (<xsl:value-of select="usg"/>)</xsl:if>
               </td>
               <td class="tdNorm">
                  <span class="spTransText">
                     <xsl:value-of select="tei:orth[@xml:lang='fa-x-modDMG']"/>
                  </span>
               </td>
 
            </tr>
         </xsl:for-each>
         <xsl:for-each select="tei:sense">
            <tr>
               <td class="tdLeft">Sense</td>
               <td class="tdNorm">
                  <div>
                     <xsl:value-of select="tei:cit[@xml:lang='en']/tei:quote"/>
                     <xsl:if test="tei:usg[@type='dom']"><b class="spUsg"> [<xsl:value-of select="tei:usg[@type='dom']"/>]</b></xsl:if>
                     <xsl:for-each select="tei:cit[@type='example']">
  
                        <div class="dvLemmaExample">
                           <span class="spTransText"><xsl:value-of select="tei:quote[@xml:lang='fa-x-modDMG']"/></span>
                           <xsl:text> </xsl:text>
                           <span class="spExTranslation">
                              <xsl:value-of select="tei:cit[@type='translation' and @xml:lang='en']/tei:quote"/>
                           </span>
                        </div>
                     </xsl:for-each>
                  </div>
               </td>
 
            </tr>
         </xsl:for-each>
      </table>
   </xsl:template>
   
</xsl:stylesheet>