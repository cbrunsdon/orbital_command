<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=iso-8859-1" />
		<link rel="icon" href="images/favicon.ico" type="image/x-icon" />
		<link rel="shortcut icon" href="images/favicon.ico" type="image/x-icon" />
		<script type="text/javascript" src="common.js"></script>
		<script type="text/javascript" src="lang_pack/english.js"></script>
		<script type="text/javascript" src="lang_pack/language.js"></script>
		<link type="text/css" rel="stylesheet" href="style/elegant/style.css" />
		<!--[if IE]><link type="text/css" rel="stylesheet" href="style/elegant/style_ie.css" /><![endif]-->
		<script type="text/javascript" src="js/prototype.js"></script>
		<script type="text/javascript" src="js/effects.js"></script>
		<script type="text/javascript" src="js/window.js"></script>
		<script type="text/javascript" src="js/window_effects.js"></script>
		<link type="text/css" rel="stylesheet" href="style/pwc/default.css" />
		<link type="text/css" rel="stylesheet" href="style/pwc/ddwrt.css" />
		<title>adun (build 13064) - Wireless Status</title>

<script type="text/javascript">
//<![CDATA[
function setWirelessTable() {
var table = document.getElementById("wireless_table");
var val = arguments;
cleanTable(table);
if(!val.length) {
var cell = table.insertRow(-1).insertCell(-1);
cell.colSpan = 10;
cell.align = "center";
cell.innerHTML = "- " + share.none + " -";
return;
}
for(var i = 0; i < val.length; i = i + 9) {
var row = table.insertRow(-1);

var mac = val[i];
var cellmac = row.insertCell(-1);
cellmac.title = share.oui;
cellmac.style.cursor = "pointer";
cellmac.style.textDecoration = "underline";
eval("addEvent(cellmac, 'click', function() { getOUIFromMAC('" + mac + "') })");
cellmac.innerHTML = mac;
var ifn = val[i + 1];
var iface = row.insertCell(-1);
iface.title = status_band.titl;
iface.style.cursor = "pointer";
iface.style.textDecoration = "none";
eval("addEvent(iface, 'click', function() { openBW('" + ifn + "') })");
iface.innerHTML = ifn;

row.insertCell(-1).innerHTML = val[i + 2];
row.insertCell(-1).innerHTML = val[i + 3];
row.insertCell(-1).innerHTML = val[i + 4];
row.insertCell(-1).innerHTML = val[i + 5];
row.insertCell(-1).innerHTML = val[i + 6];
row.insertCell(-1).innerHTML = val[i + 7];
setMeterBar(row.insertCell(-1), (val[i + 8] == "0" ? 0 : parseInt(val[i + 8]) * 0.1), "");
}
}
function setWDSTable() {
var table = document.getElementById("wds_table");
var val = arguments;
cleanTable(table);
if(!val.length) {
setElementVisible("wds", false);
return;
}
for(var i = 0; i < val.length; i = i + 6) {
var row = table.insertRow(-1);

var mac = val[i];
var cellmac = row.insertCell(-1);
cellmac.title = share.oui;
cellmac.style.cursor = "pointer";
cellmac.style.textDecoration = "underline";
eval("addEvent(cellmac, 'click', function() { getOUIFromMAC('" + mac + "') })");
cellmac.innerHTML = mac;
var ifn = val[i + 1];
var iface = row.insertCell(-1);
iface.title = status_band.titl;
iface.style.cursor = "pointer";
iface.style.textDecoration = "none";
eval("addEvent(iface, 'click', function() { openBW('" + ifn + "') })");
iface.innerHTML = ifn;

row.insertCell(-1).innerHTML = val[i + 2];
row.insertCell(-1).innerHTML = val[i + 3];
row.insertCell(-1).innerHTML = val[i + 4];
row.insertCell(-1).innerHTML = val[i + 5];
setMeterBar(row.insertCell(-1), (val[i + 3] == "0" ? 0 : parseInt(val[i + 3]) * 1.24 + 116), "");
}
setElementVisible("wds", true);
}
function setPacketInfo(val) {
var packet = val.replace(/[A-Za-z=]/g, "").split(";");
setMeterBar("packet_rx",
(parseInt(packet[1]) == 0 ? 100 : parseInt(packet[0]) / (parseInt(packet[0]) + parseInt(packet[1])) * 100),
packet[0] + " OK, " + (packet[1] > 0 ? packet[1] + " " + share.errs : share.none2 + " " + share.err)
);
setMeterBar("packet_tx",
(parseInt(packet[3]) == 0 ? 100 : parseInt(packet[2]) / (parseInt(packet[2]) + parseInt(packet[3])) * 100),
packet[2] + " OK, " + (packet[3] > 0 ? packet[3] + " " + share.errs : share.none2 + " " + share.err)
);
}
function OpenSiteSurvey () {
if( "1" == "1" ) {
openWindow('Site_Survey.asp', 760, 700);
}
else {
openWindow('Site_Survey.asp', 760, 700);
alert(errmsg.err59);
};
}
function OpenWiwizSurvey () {
if( "1" == "1" ) {
openWindow('Wiviz_Survey.asp', 760, 700);
}
else {
alert(errmsg.err59);
};
}	
var update;
addEvent(window, "load", function() {
setWirelessTable('00:21:5C:89:7D:4B','eth1','N/A','N/A','N/A','-80','-94','14','168','00:06:25:AA:DE:20','eth1','N/A','N/A','N/A','-56','-94','38','465');
setWDSTable();
setPacketInfo("SWRXgoodPacket=702118;SWRXerrorPacket=0;SWTXgoodPacket=1381339;SWTXerrorPacket=22;");
update = new StatusUpdate("Status_Wireless.live.asp", 3);
update.onUpdate("active_wireless", function(u) {
eval('setWirelessTable(' + u.active_wireless + ')');
});
update.onUpdate("active_wds", function(u) {
eval('setWDSTable(' + u.active_wds + ')');
});
update.onUpdate("packet_info", function(u) {
setPacketInfo(u.packet_info);
});
update.start();
});
function refresh(F)
{F.submit();
}
addEvent(window, "unload", function() {
update.stop();
});

//]]>
</script>
</head>
<body class="gui">

<div id="wrapper">
<div id="content">
<div id="header">
<div id="logo"><h1>DD-WRT Control Panel</h1></div>
<div id="menu">
 <div id="menuMain">
  <ul id="menuMainList">
   <li><a href="index.asp"><script type="text/javascript">Capture(bmenu.setup)</script></a></li>
   <li><a href="Wireless_Basic.asp"><script type="text/javascript">Capture(bmenu.wireless)</script></a></li>
   <li><a href="Services.asp"><script type="text/javascript">Capture(bmenu.services)</script></a></li>
   <li><a href="Firewall.asp"><script type="text/javascript">Capture(bmenu.security)</script></a></li>
   <li><a href="Filters.asp"><script type="text/javascript">Capture(bmenu.accrestriction)</script></a></li>
   <li><a href="ForwardSpec.asp"><script type="text/javascript">Capture(bmenu.applications)</script></a></li>
   <li><a href="Management.asp"><script type="text/javascript">Capture(bmenu.admin)</script></a></li>
   <li class="current"><span><script type="text/javascript">Capture(bmenu.statu)</script></span>
    <div id="menuSub">
     <ul id="menuSubList">
      <li><a href="Status_Router.asp"><script type="text/javascript">Capture(bmenu.statuRouter)</script></a></li>
      <li><a href="Status_Internet.asp"><script type="text/javascript">Capture(bmenu.statuInet)</script></a></li>
      <li><a href="Status_Lan.asp"><script type="text/javascript">Capture(bmenu.statuLAN)</script></a></li>
      <li><span><script type="text/javascript">Capture(bmenu.statuWLAN)</script></span></li>
      <li><a href="Status_Bandwidth.asp"><script type="text/javascript">Capture(bmenu.statuBand)</script></a></li>
      <li><a href="Info.htm"><script type="text/javascript">Capture(bmenu.statuSysInfo)</script></a></li>
     </ul>
    </div>
    </li>
  </ul>
 </div>
</div>

</div>
<div id="main">
<div id="contents">
<form name="Status_Wireless" action="apply.cgi" method="post">
<input type="hidden" name="submit_button" value="Status_Wireless" />
<input type="hidden" name="next_page" value="Status_Wireless.asp" />
<input type="hidden" name="change_action" value="gozila_cgi" />
<input type="hidden" name="submit_type" value="refresh" />
<h2><script type="text/javascript">Capture(status_wireless.h2)</script></h2>

<fieldset>
<legend><script type="text/javascript">Capture(status_wireless.legend)</script></legend>

<div class="setting">
<div class="label"><script type="text/javascript">Capture(share.mac)</script></div>
<script type="text/javascript">
//<![CDATA[
document.write("<span id=\"wl_mac\" style=\"cursor:pointer; text-decoration:underline;\" title=\"" + share.oui + "\" onclick=\"getOUIFromMAC('00:14:BF:4B:14:45')\" >");
document.write("00:14:BF:4B:14:45");
document.write("</span>");
//]]>
</script>&nbsp;
</div>
<div class="setting">
<div class="label"><script type="text/javascript">Capture(wl_basic.radio)</script></div>
<span id="wl_radio">Radio is On</span>&nbsp;
</div>								
<div class="setting">
<div class="label"><script type="text/javascript">Capture(share.mode)</script></div>
<script type="text/javascript">Capture(wl_basic.ap)</script>&nbsp;
&nbsp;
</div>
<div class="setting">
<div class="label"><script type="text/javascript">Capture(status_wireless.net)</script></div>
<script type="text/javascript">Capture(wl_basic.mixed)</script>&nbsp;
&nbsp;
</div>
<div class="setting">
<div class="label"><script type="text/javascript">Capture(share.ssid)</script></div>
<span id="wl_ssid">adun</span>&nbsp;
</div>
<div class="setting">
<div class="label"><script type="text/javascript">Capture(share.channel)</script></div>
<span id="wl_channel">6</span>&nbsp;
</div>
<div class="setting">
<div class="label"><script type="text/javascript">Capture(wl_basic.TXpower)</script></div>
<span id="wl_xmit">71 mW</span>&nbsp;
</div>
<div class="setting">
<div class="label"><script type="text/javascript">Capture(share.rates)</script></div>
<span id="wl_rate">11 Mbps</span>&nbsp;
</div>

<div class="setting">
<div class="label"><script type="text/javascript">Capture(share.encrypt)</script>&nbsp;-&nbsp;<script type="text/javascript">Capture(share.intrface)</script>&nbsp;wl0</div>
<script type="text/javascript">Capture(share.enabled)</script>,&nbsp;WEP
</div>

<div class="setting">
<div class="label"><script type="text/javascript">Capture(status_wireless.pptp)</script></div>
<script type="text/javascript">Capture(share.disconnected)</script>&nbsp;
</div>
</fieldset><br />

<fieldset>
<legend><script type="text/javascript">Capture(status_wireless.legend2)</script></legend>
<div class="setting">
<div class="label"><script type="text/javascript">Capture(status_wireless.rx)</script></div>
<span id="packet_rx"></span>&nbsp;
</div>
<div class="setting">
<div class="label"><script type="text/javascript">Capture(status_wireless.tx)</script></div>
<span id="packet_tx"></span>&nbsp;
</div>
</fieldset><br />

<h2><script type="text/javascript">Capture(status_wireless.h22)</script></h2>
<fieldset>
<legend><script type="text/javascript">Capture(status_wireless.legend3)</script></legend>
<table class="table center" cellspacing="5" id="wireless_table" summary="wireless clients table">
<tr>
<th width="16%"><script type="text/javascript">Capture(share.mac)</script></th>
<th width="10%"><script type="text/javascript">Capture(share.intrface)</script></th>
<th width="10%"><script type="text/javascript">Capture(status_router.sys_up)</script></th>
<th width="8%"><script type="text/javascript">Capture(share.txrate)</script></th>
<th width="8%"><script type="text/javascript">Capture(share.rxrate)</script></th>
<th width="8%"><script type="text/javascript">Capture(share.signal)</script></th>
<th width="8%"><script type="text/javascript">Capture(share.noise)</script></th>
<th width="8%">SNR</th>
<th width="24%"><script type="text/javascript">Capture(status_wireless.signal_qual)</script></th>
</tr>
</table>
<script type="text/javascript">
//<![CDATA[
var t = new SortableTable(document.getElementById('wireless_table'), 1000);
//]]>
</script>
</fieldset><br />

<div id="wds" style="display:none">
<fieldset>
<legend><script type="text/javascript">Capture(status_wireless.wds)</script></legend>
<table class="table center" cellspacing="5" id="wds_table" summary="wds clients table">
<tr>
<th width="16%"><script type="text/javascript">Capture(share.mac)</script></th>
<th width="10%"><script type="text/javascript">Capture(share.intrface)</script></th>
<th width="26%"><script type="text/javascript">Capture(share.descr)</script></th>
<th width="8%"><script type="text/javascript">Capture(share.signal)</script></th>
<th width="8%"><script type="text/javascript">Capture(share.noise)</script></th>
<th width="8%">SNR</th>
<th width="24%"><script type="text/javascript">Capture(status_wireless.signal_qual)</script></th>
</tr>
</table>
<script type="text/javascript">
//<![CDATA[
var t = new SortableTable(document.getElementById('wds_table'), 1000);
//]]>
</script>
</fieldset><br />

</div>
<div class="center">
<script type="text/javascript">
//<![CDATA[
document.write("<input class=\"button\" type=\"button\" name=\"site_survey\" value=\"" + sbutton.survey + "\" onclick=\"OpenSiteSurvey()\" />");
document.write("<input class=\"button\" type=\"button\" name=\"wiviz_survey\" value=\"Wiviz survey\" onclick=\"OpenWiwizSurvey()\" />");
//]]>
</script>
</div><br />
<div class="submitFooter">
<script type="text/javascript">
//<![CDATA[
var autoref = sbutton.autorefresh;
submitFooterButton(0,0,0,autoref);
//]]>
</script>
</div>
</form>
</div>
</div>
<div id="helpContainer">
<div id="help">
<div><h2><script type="text/javascript">Capture(share.help)</script></h2></div>
<dl>
<dt class="term"><script type="text/javascript">Capture(share.mac)</script>:</dt>
<dd class="definition"><script type="text/javascript">Capture(hstatus_wireless.right2)</script></dd>
<dt class="term"><script type="text/javascript">Capture(status_wireless.net)</script>:</dt>
<dd class="definition"><script type="text/javascript">Capture(hstatus_wireless.right4)</script></dd>
<dt class="term"><script type="text/javascript">Capture(share.oui)</script>:</dt>
<dd class="definition"><script type="text/javascript">Capture(hstatus_lan.right10)</script></dd>
</dl><br />
<a href="javascript:openHelpWindow('HStatusWireless.asp');"><script type="text/javascript">Capture(share.more)</script></a>
</div>
</div>
<div id="floatKiller"></div>
<div id="statusInfo">
<div class="info"><script type="text/javascript">Capture(share.firmware)</script>:
<script type="text/javascript">
//<![CDATA[
document.write("<a title=\"" + share.about + "\" href=\"javascript:openAboutWindow()\">DD-WRT v24-sp2 (10/10/09) mini</a>");
//]]>
</script>
</div>
<div class="info"><script type="text/javascript">Capture(share.time)</script>:  <span id="uptime"> 23:41:05 up 16:39, load average: 0.25, 0.10, 0.03</span></div>
<div class="info">WAN<span id="ipinfo">&nbsp;IP: 0.0.0.0</span></div>
</div>
</div>
</div>
</body>
</html>
