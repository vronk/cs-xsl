<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" version="1.0">
   <xsl:import href="http://localhost/dictobserver/xsl/glossary.xsl"></xsl:import>
   <xsl:output method="html" media-type="text/html" indent="yes" encoding="UTF-8" doctype-system="about:legacy-compat"></xsl:output>
   <xsl:template name="callback-header">
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css"/>
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap-theme.min.css"/>
      <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
      <style>
            html, body {background:#fff !important;color:#000 !important;}
            table {font-size:0.9em;}
            tbody {display:table;width:100%;}
            
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
            color: white;
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
            .tei-teiHeader {display:none;}
            iframe {margin-top:6rem;width:auto;height:auto;float:left;}
           
            .navbar-brand {padding:0 !important;}
            .entrytable td:first-child {
               white-space: normal;
             }
        
            .row {margin:0 !important;}
            .result-body {margin-top:2rem;}
            #searchcontainer {display:none;padding:0;important!}
            #dvLanguage {display:none;}
            #dvDocumentation {display:none;}
            .disabled {visibility:hidden !important;}
            .result-navigation {margin-top:1rem;} 
            .counter {display:none;}
            #contextlabel {}
            .internal.prev, .internal.next {position:static !important;}
            .internal.prev {float:left;}
            .internal.next {float:right;}
            .cmd_prev {left:0;padding:0rem 0.5rem !important;}
            .cmd_next {right:0;padding:0rem 0.5rem !important;}
@media screen and (min-device-width: 1200px) 
{.container {margin-left:2rem !important;}}
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
      color:#000 !important;
      padding-left: 2rem; 
      background-color: rgb(194, 186, 89) !important;
      height:80px !important;
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
      </style>
      
      <script>
      var i = 1;
      var url = "https://minerva.arz.oeaw.ac.at/damasz//modules/fcs-aggregator/switch.php?version=1.2&amp;operation=searchRetrieve&amp;x-context=apc_eng_002&amp;maximumRecords=10&amp;x-format=htmlpagetable&amp;x-dataview=kwic,title";
      $(document).ready(function(){
      $("tr").on("click", "a", function(event){
      event.preventDefault();
      $("iframe").remove();
      $("iframe").attr("src",$(this).attr("href"));
      });
      $("#project").on("click", "a", function(event){
         event.preventDefault();
         $("#dvProject").css("display","block");
         $("#searchcontainer").css("display","none");
         $("#dvLanguage").css("display","none");
         $("#dvDocumentation").css("display","none");
      });
    $("#search").on("click", "a", function(event){
         event.preventDefault();
         $("#searchcontainer").css("display","block");
         $("#dvLanguage").css("display","none");
         $("#dvProject").css("display","none");
         $("#dvDocumentation").css("display","none");
      });
   $("#language").on("click", "a", function(event){
         event.preventDefault();
         $("#searchcontainer").css("display","none");
         $("#dvLanguage").css("display","block");
         $("#dvProject").css("display","none");
         $("#dvDocumentation").css("display","none");
      });
      $("#documentation").on("click", "a", function(event){
         event.preventDefault();
         $("#searchcontainer").css("display","none");
         $("#dvLanguage").css("display","none");
         $("#dvProject").css("display","none");
         $("#dvDocumentation").css("display","block");
      });
   $("body").on("submit","form",function(event){
         event.preventDefault();
         var a = $("#query-text-ui").val();
         var o = $("#operator").val();
    var f = $("#field").val();
   field = f;
         $("#searchcontainer").load("https://minerva.arz.oeaw.ac.at/damasz//modules/fcs-aggregator/switch.php?version=1.2&amp;operation=searchRetrieve&amp;query="+f+o+encodeURIComponent(a)+"&amp;x-context=apc_eng_002&amp;startRecord=1&amp;maximumRecords=10&amp;x-format=htmlpagetable&amp;x-dataview=kwic,title #result-container",function(){$("#query-text-ui").val(a);$("#operator").val(o);$("#field").val(f);});
         $("#dvLanguage").css("display","none");
         $("#dvProject").css("display","none");
         $("#dvDocumentation").css("display","none");
         
});
$(".navbar-nav li a").click(function(event) {
    $(".navbar-collapse").collapse("hide");
  });
$("body").on("click",".internal.next",function(event){
i = i+10;
   event.preventDefault();
   $(".internal.prev").removeClass("disabled");
   var a = $("#query-text-ui").val();
   var o = $("#operator").val();
   var f = $("#field").val();
  
   $("#searchcontainer").load(url +"&amp;query="+f+o+encodeURIComponent(a)+"&amp;startRecord="+i+" #result-container",function(){$("#query-text-ui").val(a);$("#operator").val(o);$("#field").val(f);});
});
$("body").on("click",".internal.prev",function(event){
   event.preventDefault();
  i = i-10;
   $(".internal.next").removeClass("disabled");
   var a = $("#query-text-ui").val();
   var o = $("#operator").val();
   var f = $("#field").val();
   $("#searchcontainer").load(url +"&amp;query="+f+o+encodeURIComponent(a)+"&amp;startRecord="+i+" #result-container",function(){$("#query-text-ui").val(a);$("#operator").val(o);$("#field").val(f);});
 
   });
      });
      </script>
   </xsl:template>
   <xsl:template name="page-header">
      <div class="jumbotron">
         <h2><span class="spHead2_left">A digital dictionary of <span class="spHead2_right"><i>DAMASCENE</i></span> Arabic</span></h2>
      </div>
      <nav class="navbar navbar-inverse">
         <div class="container-fluid"> <div class="navbar-header">
               <button id="navtoggle" type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target=".navbar-collapse" aria-expanded="false">
                  <span class="sr-only">Toggle navigation</span>
                  <span class="icon-bar"></span>
                  <span class="icon-bar"></span>
                  <span class="icon-bar"></span>
                  <span class="icon-bar"></span>
               </button>
              
            </div>
<!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse">
               <ul class="nav navbar-nav">
                  <li id="project"><a href="#">Project <span class="sr-only">(current)</span></a></li>
                  <li id="search"><a href="#">Search</a></li>
                  <li id="language"><a href="#">Language <span class="sr-only">(current)</span></a></li>
                  <li id="documentation"><a href="#">Documentation</a></li>
               </ul>
            </div>
         </div>
      </nav>
      <div id="dvProject" class="container"><div class="row"><div class="col-xs-12 col-sm-12 col-lg-12">
               <p>The Digital Dictionary of Damascene Arabic was compiled by <i>Carmen Berlinches Ramos</i> and
                  <i>Stephan Procházka</i>. The lexicographic work was accomplished in collaboration with
                  <i>Rima Aldoukhi</i> and <i>Anna Telic</i> and published for the first time in this
               form in 2015.
               </p>
               <p>This web interface was created as part of a cooperation between the <i>Austrian Centre of
               Digital Humanities - OEAW (ACDH-OeAW)</i> and the <i>Institute for Oriental Studies 
               (University of Vienna)</i>.
               </p>
            </div></div> </div>
      <div id="dvLanguage" class="container">
         <div class="row">
            <div class="col-xs-12 col-sm-12 col-lg-12">
               <p>Dagaare is a language spoken in West Africa by about 2 million people. It belongs to the Gur
         branch of the Niger-Congo language family. Genetically, it is unrelated to Chinese but there are 
         some interesting typological features under which the two languages can be compared. Two prominent 
         examples are tonal phonology and the concept of serial verbs. To illustrate, like Chinese, most West 
         African languages, including Dagaare, are tone languages. But while Chinese has a complex system of 
         four to nine tonemes, Dagaare and many West African languages have only a two-tone system. However, 
         tonal perturbations such as downstep and downdrift become fairly complex in both Chinese and 
         Dagaare. The nominal and verbal paradigms, along with tonal markings provided in this lexicon 
         constitute handy raw data for a comparative study of the morphophonology, syntax and lexical 
         semantics of these languages.
               </p>
            </div>
         </div>
      </div>
      <div id="dvDocumentation" class="container">
         <div class="row">
            <div class="col-xs-12 col-sm-12 col-lg-12">
               <p>This edition of the lexicon comprises more than 1250 entries. Headwords or entries
               contain other words in paradigmatic relation to the headword. Thus the dictionary actually 
               comprises 3000-4000 words. Even though tone is not indicated in standard Dagaare orthography, 
               tonal markings are indicated for each entry. This is followed by 
               categorial, and, where necessary, subcategorial information, such as intransitive verb, 
               question word, etc. of the entry. 
               A salient feature of the lexicon is a comprehensive provision of verbal and nominal paradigms 
               for each verbal and nominal headword. These paradigms serve as important indicators of the 
               salient aspects of Dagaare grammar.
               </p>
               <p>The data available in this interface was edited by means of the <a href="https://clarin.oeaw.ac.at/vle">Viennese
               Lexicographic Editor</a>, a freely available XML Editor for lexicographic data. The underlying data model is a very simple 
               TEI-based schema.
               </p>
            </div></div></div>

      <div id="dvHelp" class="container">
         <div class="row">
            <div class="col-xs-12 col-sm-12 col-lg-12">
               <p>You may use wildcards</p>
      </div></div></div>
   </xsl:template>
   <xsl:template name="query-input">
      <div class="cmds-ui-block init-show" id="querysearch">
         <div class="header ui-widget-header ui-state-default ui-corner-top">
                Search
         </div>
         <div class="content" id="query-input">
              
            <form id="searchretrieve" action="" method="get">
               <div class="row">
                  <input type="hidden" name="x-format" value="{$format}"/>
                  <input type="hidden" name="operation" value="{$operation}"/>
                  <input type="hidden" name="version" value="1.2"/>
                  <input type="hidden" name="x-dataview" value="{//fcs:x-dataview}"/>
                  <input type="hidden" name="maximumRecords" value="{$maximumRecords}"/>
                  <xsl:if test="$queryType != ''">
                     <input type="hidden" name="queryType" value="{$queryType}"/>
                  </xsl:if>
                  <xsl:call-template name="br"/>
                   
                  <select value="" id="field" style="width:22%;display:inline;" class="form-control">
                     <option value="lemma">Lemma</option>
                     <option value="pos">POS</option>
                     <option value="root">Root</option>
                     <option value="senses_english">English</option>
                     <option value="senses_german">German</option>
                     <option value="senses_spanish">Spanish</option>
                     <option value="inflected">Inflected forms</option></select>
                  <select value="" id="operator" style="margin-left:0.5%;width:30%;display:inline;" class="form-control"><option value="=">contains</option>
                     <option value="==">matches exactly</option></select>
                  <input id="query-text-ui" style="margin-left:0.5%;width:23.5%;display:inline;"  type="text" class="form-control"/>
                 
                  <input  style="margin-left:0.5%;width:23%;display:inline;" class="btn btn-default" type="submit" value="submit" id="submit-query"/>
               
               </div>
            </form>
            
         </div>
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
                     <xsl:if test="position()&amp;gt;1">, </xsl:if>
                     <xsl:value-of select="tei:orth[@xml:lang='ar-apc-x-damascus-vicavTrans']"/></xsl:for-each>
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
   <fs type="change"><f name="who"><symbol value="charly"></symbol></f><f name="when"><symbol value="2015_08_03"></symbol></f></fs>
   <fs type="change"><f name="who"><symbol value="babsi"></symbol></f><f name="when"><symbol value="2015_08_04"></symbol></f></fs>
   <fs type="change"><f name="who"><symbol value="babsi"></symbol></f><f name="when"><symbol value="2015_08_05"></symbol></f></fs>
   <fs type="change"><f name="who"><symbol value="babsi"/></f><f name="when"><symbol value="2015_08_05"/></f></fs>
   <fs type="change"><f name="who"><symbol value="babsi"/></f><f name="when"><symbol value="2015_08_06"/></f></fs>
   <fs type="change"><f name="who"><symbol value="charly"/></f><f name="when"><symbol value="2015_08_06"/></f></fs>
   <fs type="change"><f name="who"><symbol value="babsi"/></f><f name="when"><symbol value="2015_08_07"/></f></fs>
   <fs type="change"><f name="who"><symbol value="charly"/></f><f name="when"><symbol value="2015_08_07"/></f></fs>
   <fs type="change"><f name="who"><symbol value="charly"/></f><f name="when"><symbol value="2015_08_08"/></f></fs>
   <fs type="change"><f name="who"><symbol value="babsi"/></f><f name="when"><symbol value="2015_08_08"/></f></fs>
   <fs type="change"><f name="who"><symbol value="babsi"/></f><f name="when"><symbol value="2015_08_10"/></f></fs>
   <fs type="change"><f name="who"><symbol value="babsi"/></f><f name="when"><symbol value="2015_08_11"/></f></fs>
   <fs type="change"><f name="who"><symbol value="babsi"/></f><f name="when"><symbol value="2015_08_12"/></f></fs>
   <fs type="change"><f name="who"><symbol value="babsi"/></f><f name="when"><symbol value="2015_10_05"/></f></fs>
   <fs type="change"><f name="who"><symbol value="babsi"/></f><f name="when"><symbol value="2015_10_28"/></f></fs>
   <fs type="change"><f name="who"><symbol value="babsi"/></f><f name="when"><symbol value="2015_10_29"/></f></fs>
   <fs type="change"><f name="who"><symbol value="charly"/></f><f name="when"><symbol value="2015_10_29"/></f></fs>
   <fs type="change"><f name="who"><symbol value="charly"/></f><f name="when"><symbol value="2015_10_30"/></f></fs>
   <fs type="change"><f name="who"><symbol value="babsi"/></f><f name="when"><symbol value="2015_11_02"/></f></fs>
   <fs type="change"><f name="who"><symbol value="charly"/></f><f name="when"><symbol value="2015_11_03"/></f></fs>
   <fs type="change"><f name="who"><symbol value="charly"/></f><f name="when"><symbol value="2016_03_08"/></f></fs>
   <fs type="change"><f name="who"><symbol value="charly"/></f><f name="when"><symbol value="2016_03_09"/></f></fs>
   <fs type="change"><f name="who"><symbol value="babsi"/></f><f name="when"><symbol value="2016_03_09"/></f></fs>
   <fs type="change"><f name="who"><symbol value="charly"/></f><f name="when"><symbol value="2016_03_11"/></f></fs>
   <fs type="change"><f name="who"><symbol value="charly"/></f><f name="when"><symbol value="2016_03_14"/></f></fs>
</xsl:stylesheet>
