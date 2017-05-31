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
  <xsl:import href="http://localhost/corpus_shell/xsl/dictionary-sites/glossary.xsl"/>
  <xsl:output method="html" media-type="text/html" indent="yes" encoding="UTF-8" doctype-system="about:legacy-compat"/>
  <xsl:template name="callback-header">
    <style>
      html, body {
      background: white;
      color:#000 
      }
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
      .jumbotron{
      color: rgb(255,128,0); !important;
      padding-left: 2rem;
      background-color: rgb(255,187,119) !important; 
      height:80px !important;
      padding-top:2rem !important;
      margin-bottom:0 !important; }
      .dvExample {
      margin-left: 10px;
      background: rgb(255,209,164);
      padding-left: 3px;
      padding-right: 3px;
      color: green;
      border: 1px solid rgb(174,87,0);
      }
      .dvRoundLemmaBox {
      text-align: right; 
      padding-right: 5px; 
      position:relative; 
      top: 3px; left:-10px; width: 100px; 
      border-radius: 5px;  
      background: rgb(255,226,198);
      font-weight: bold;
      border: 1px solid rgb(140,70,0);
      }
      .tdNorm {
      border-bottom: 1px solid #CCC;
      padding-left:3px;
      vertical-align: top;
      background: rgb(255,187,119);
      }
      .tbLemma {
      border-collapse: collapse;
      width: 100%;
      margin-bottom: 10px;
      border: 1px solid rgb(174,87,0);
      box-shadow: 10px 10px 5px rgb(131,107,27);
      }
      .tdLeft {
      text-align: right;
      padding-right: 5px;
      padding-left: 5px;
      vertical-align: top;
      border-bottom: 1px solid #CCC;
      background: rgb(255,128,0);
      color: #E3E2B0 !important;
      font-weight: bold;
      width: 70px;
      }
      h4 {
      padding-right: 20px;
      padding-left: 3px;
      padding-right:3px;
      }
      .spHighRed {
      color: #B05045;
      }
      .spHead2_left {
      color: rgb(187,94,0);
      font-weight: bold;
      }
      .spHead2_right {
      color: rgb(187,94,0);
      font-weight: bold;
      font-style: italic;
      }
      .spHead2_centre {
      color: rgb(147,73,0);
      font-weight: bold;
      }
      .spUsg {
      color: teal;
      font-style: italic;
      font-size: smaller;
      }
      .wordforms {
      color: rgb(130,28,198);
      }
      .dvExample {
      margin-left:20px;
      background: rgb(255,209,164);
      color: green;
      border: 1px solid rgb(174,87,0);
      }
      .spPos {
      color: rgb(0,0,176);
      font-style: italic;
      font-size: smaller;
      }
      .exTranslation {
      color: rgb(157,79,0);
      }
      .dvSenses {
      color: rgb(187,61,0);
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
      .internal.prev, .internal.next {position:static !important;display:none;}
      .internal.prev {float:left;}
      .internal.next {float:right;}
      .cmd_prev {left:0;padding:0rem 0.5rem !important;}
      .cmd_next {right:0;padding:0rem 0.5rem !important;}
      
      .result-navigation {height:auto;}
      @media screen 
      and (min-device-width: 1200px) 
      {.container {margin-left:2rem !important;}}
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
    </div>
  </xsl:template>
  <xsl:template name="impressum">
    <div class="impressum" id="impressum">
      impressum
    </div>
  </xsl:template>
  <xsl:template match="tei:entry" mode="record-data">
    <div>
      
      <div class="dvRoundLemmaBox"><xsl:value-of select="tei:form[@type='lemma']/tei:orth | tei:form[@type='multiWordUnit']/tei:orth"/></div>
      <table class="tbLemma">
        <tr>
          <td class="tdLeft">Lemma</td>
          <td class="tdNorm">
            <xsl:value-of select="tei:form[@type='lemma']/tei:orth | tei:form[@type='multiWordUnit']/tei:orth"/>
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
        <xsl:for-each select="tei:form[@type='inflected']">
          <tr>
            <td class="tdLeft">
              <xsl:choose>
                <xsl:when test="@ana='#n_pl'">Plural</xsl:when>
                <xsl:when test="@ana='#n_loc'">Locative</xsl:when>
                <xsl:otherwise>Infl. form</xsl:otherwise>
              </xsl:choose>
            </td>
            <td class="tdNorm"><xsl:value-of select="tei:orth"/></td>
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
                  <div class="dvExample">
                    <xsl:value-of select="tei:quote"/>
                    <xsl:text> </xsl:text><i class="exTranslation">
                      <xsl:value-of select="tei:cit[@type='translation' and @xml:lang='en']/tei:quote"/></i>
                  </div>
                </xsl:for-each>
                <xsl:for-each select="tei:cit[@type='multiWordUnit']">
                  <div class="dvExample">
                    <xsl:value-of select="tei:quote"/>
                    <xsl:text> </xsl:text><i class="exTranslation">
                      <xsl:value-of select="tei:cit[@type='translation' and @xml:lang='en']/tei:quote"/></i>
                  </div>
                </xsl:for-each>
              </div>
            </td>
          </tr>
        </xsl:for-each>
      </table>
    </div>
  </xsl:template>
</xsl:stylesheet>