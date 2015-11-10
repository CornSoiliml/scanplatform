#!/bin/bash
# bash shell script
#
# ----------------------------------------------------------------------------------------------------------
# for this part, many pre-work should be done. you may find all required components in my project.			|
# if any of them omitted, please let me know. By the way, some of them could be replaced.					|
# author: cornsoiliml 346415320@qq.com																		|
# however if the apk source code were mixed, the scan work could be hard									|
# it means the match pattern for object in rules may not work 												|
# so, better scan it before code-mix																		|
# thanks for components included																			|
# ----------------------------------------------------------------------------------------------------------
#


# -----------------set these as follows otherwise the web server tomcat will be stuck if the size of upload-file is too large-----------------
exec 1>/dev/null
exec 2>/dev/null
#$1 email
#$2 ID
#$3 apkname  demo.apk
name=$(echo $1 | cut -d @ -f 1)
var=$(echo $3 | cut -d . -f 1)
mail=$1
id=$2

# -----------------change name & unzip apk with same folder-----------------
mv /root/dex2jar/$3 /root/dex2jar/$id.zip
unzip -o /root/dex2jar/$id.zip -d /root/dex2jar/$id;
#route=/root/dex2jar/$id/classes.dex
mkdir /root/dex2jar/report/$id

# -----------------trans .dex to .jar and decompile-----------------
_classpath="."
if [ `uname -a | grep -i -c cygwin` -ne 0 ]; then # Cygwin, translate the path
    for k in /root/dex2jar/lib/*.jar
    do
        _classpath="${_classpath};`cygpath -w ${k}`"
    done
else
    for k in /root/dex2jar/lib/*.jar
    do
        _classpath="${_classpath}:${k}"
    done
fi

java -classpath ${_classpath} com.googlecode.dex2jar.tools.Dex2jarCmd /root/dex2jar/$id/classes.dex -f -o /root/dex2jar/$id/classes-dex2jar.jar 2>&1



java -jar /root/dex2jar/jd-core-java-1.2.jar /root/dex2jar/$id/classes-dex2jar.jar /root/dex2jar/report/$id 2>&1

java -jar /root/dex2jar/AXMLPrinter2.jar /root/dex2jar/$id/AndroidManifest.xml > /root/dex2jar/$id/$id.xml;

cat /root/servercheck/head >/root/dex2jar/report/$id.html;
echo >>/root/dex2jar/report/$id.html

echo "<p class=MsoToc1><span class=SpellE><span lang=EN-US>app</font></font><span lang=EN-US> safe </font>检测报告</p>" >>/root/dex2jar/report/$id.html
echo "<hr />" >>/root/dex2jar/report/$id.html
echo "<h3 id="mail"> 你的账户:$name</h3>" >>/root/dex2jar/report/$id.html
echo "<h3 id="app"> 你的应用:$3</h3>" >>/root/dex2jar/report/$id.html
echo "<hr />" >>/root/dex2jar/report/$id.html

echo "<h3> 应用威胁详情 </h3>" >>/root/dex2jar/report/$id.html
echo \<br /\> >>/root/dex2jar/report/$id.html


# -----------------scan rules including dangerous functions, unsafe settings and info-extract-----------------
if grep -r -q "addJavascriptInterface" /root/dex2jar/report/$id/bolts ;then
	echo "<li>bolts/:</li>" >>/root/dex2jar/report/$id.html
	echo "<table><tr><td><pre style=\"background-color:WhiteSmoke;\"><code><font face=\"Verdana\" style=\"font-size:18px;\">" >>/root/dex2jar/report/$id.html

	echo "    addJavascriptInterface存在高危远程代码执行漏洞，应尽量避免使用。" >>/root/dex2jar/report/$id.html
	echo "修复建议:" >>/root/dex2jar/report/$id.html
	echo "    用@JavascriptInterface 代替addjavascriptInterface" >>/root/dex2jar/report/$id.html
	echo >>/root/dex2jar/report/$id.html
	echo "</font></code></pre></td></tr></table>" >>/root/dex2jar/report/$id.html
elif grep -r -q "addJavascriptInterface" /root/dex2jar/report/$id ;then
	echo "<li>addJavascriptInterface:</li>" >>/root/dex2jar/report/$id.html
	echo "<table><tr><td><pre style=\"background-color:WhiteSmoke;\"><code><font face=\"Verdana\" style=\"font-size:18px;\">" >>/root/dex2jar/report/$id.html

	echo "    addJavascriptInterface存在高危远程代码执行漏洞，应尽量避免使用。" >>/root/dex2jar/report/$id.html
	echo "修复建议:" >>/root/dex2jar/report/$id.html
	echo "    用@JavascriptInterface 代替addjavascriptInterface" >>/root/dex2jar/report/$id.html
	echo >>/root/dex2jar/report/$id.html
	echo "</font></code></pre></td></tr></table>" >>/root/dex2jar/report/$id.html
else
	echo "未检测到addjavascriptInterface危险函数" >>/root/dex2jar/report/$id.html
	echo >>/root/dex2jar/report/$id.html
	echo "</font></code></pre></td></tr></table>" >>/root/dex2jar/report/$id.html
fi
echo >>/root/dex2jar/report/$id.html
echo \<br /\> >>/root/dex2jar/report/$id.html


echo \<br /\> >>/root/dex2jar/report/$id.html
if grep -q "allowBackup=\"true\"" /root/dex2jar/$id/$id.xml ;then
	echo "<li>AndroidManifest:</li>" >>/root/dex2jar/report/$id.html	
	echo "<table><tr><td><pre style=\"background-color:WhiteSmoke;\"><code><font face=\"Verdana\" style=\"font-size:18px;\">" >>/root/dex2jar/report/$id.html

	echo "    android:allowBackup这个标志被设置为true或不设置该标志时应用程序数据可以备份和恢复，" >>/root/dex2jar/report/$id.html
	echo "    adb调试备份允许恶意攻击者复制应用程序数据。" >>/root/dex2jar/report/$id.html
	echo "修复建议:" >>/root/dex2jar/report/$id.html
	echo "    android:allowBackup="false"" >>/root/dex2jar/report/$id.html
	echo >>/root/dex2jar/report/$id.html
	echo "</font></code></pre></td></tr></table>" >>/root/dex2jar/report/$id.html
else
	echo "allowBackup设置安全" >>/root/dex2jar/report/$id.html
	echo >>/root/dex2jar/report/$id.html
	echo "</font></code></pre></td></tr></table>" >>/root/dex2jar/report/$id.html
fi
echo >>/root/dex2jar/report/$id.html
echo \<br /\> >>/root/dex2jar/report/$id.html

# -----------------you may add your own rules and regex to scan better -----------------
echo \<br /\> >>/root/dex2jar/report/$id.html
if grep -r -q "setSeed(paramString1.getBytes())" /root/dex2jar/report/$id/com ;then
	echo "<li>com:</li>" >>/root/dex2jar/report/$id.html
	echo "<table><tr><td><pre style=\"background-color:WhiteSmoke;\"><code><font face=\"Verdana\" style=\"font-size:18px;\">" >>/root/dex2jar/report/$id.html

	echo "    使用SecureRandom时不要使用SecureRandom (byte[] seed)这个构造函数，" >>/root/dex2jar/report/$id.html
	echo "    会造成生成的随机数不随机。" >>/root/dex2jar/report/$id.html
	echo "修复建议:" >>/root/dex2jar/report/$id.html
	echo "    建议通过/dev/urandom或者/dev/random获取的熵值来初始化伪随机数生成器PRNG" >>/root/dex2jar/report/$id.html
	echo >>/root/dex2jar/report/$id.html
	echo "</font></code></pre></td></tr></table>" >>/root/dex2jar/report/$id.html
else 
	echo "未检测到随机函数风险" >>/root/dex2jar/report/$id.html
	echo >>/root/dex2jar/report/$id.html
	echo "</font></code></pre></td></tr></table>" >>/root/dex2jar/report/$id.html
fi
echo >>/root/dex2jar/report/$id.html
echo \<br /\> >>/root/dex2jar/report/$id.html

echo \<br /\> >>/root/dex2jar/report/$id.html
if grep -r -q "ALLOW_ALL_HOSTNAME_VERIFIER" /root/dex2jar/report/$id/com ;then
	echo "<li>com:</li>" >>/root/dex2jar/report/$id.html
	echo "<table><tr><td><pre style=\"background-color:WhiteSmoke;\"><code><font face=\"Verdana\" style=\"font-size:18px;\">" >>/root/dex2jar/report/$id.html

	echo "    ALLOW_ALL_HOSTNAME_VERIFIER可能导致中间人攻击" >>/root/dex2jar/report/$id.html
	echo "修复建议:" >>/root/dex2jar/report/$id.html 
	echo "    使用STRIC_HOSTNAME_VERIFIER并校验证书" >>/root/dex2jar/report/$id.html
	echo >>/root/dex2jar/report/$id.html
	echo "</font></code></pre></td></tr></table>" >>/root/dex2jar/report/$id.html
else 
	echo "未检测到ALLOW_ALL_HOSTNAME_VERIFIER风险" >>/root/dex2jar/report/$id.html
	echo >>/root/dex2jar/report/$id.html
	echo "</font></code></pre></td></tr></table>" >>/root/dex2jar/report/$id.html
fi
echo >>/root/dex2jar/report/$id.html
echo \<br /\> >>/root/dex2jar/report/$id.html

echo \<br /\> >>/root/dex2jar/report/$id.html
if grep -r -q "private char\[\] a" /root/dex2jar/report/$id/com ; then
	echo "<li>com:</li>" >>/root/dex2jar/report/$id.html
	echo "<table><tr><td><pre style=\"background-color:WhiteSmoke;\"><code><font face=\"Verdana\" style=\"font-size:12px;\">" >>/root/dex2jar/report/$id.html
	echo "密钥硬编码问题:" >>/root/dex2jar/report/$id.html
	echo "    抓取到AES密钥" >>/root/dex2jar/report/$id.html
	grep -r "private char\[\] a" >>/root/dex2jar/report/$id.html
	echo "    抓取到AESsalt:" >>/root/dex2jar/report/$id.html
	grep -r "private byte\[\] b" >>/root/dex2jar/report/$id.html
	echo >>/root/dex2jar/report/$id.html
	echo "</font></code></pre></td></tr></table>" >>/root/dex2jar/report/$id.html
else
	echo "未破解AES信息" >>/root/dex2jar/report/$id.html
	echo >>/root/dex2jar/report/$id.html
	echo "</font></code></pre></td></tr></table>" >>/root/dex2jar/report/$id.html
fi
echo >>/root/dex2jar/report/$id.html
echo \<br /\> >>/root/dex2jar/report/$id.html

# -----------------sometimes a normal part may be identified unsafe, u can fix it since source code is simple and adjustable -----------------
echo \<br /\> >>/root/dex2jar/report/$id.html
if grep -r -q "WebView" /root/dex2jar/report/$id/com ;then
	echo "<li>检测到使用WebView  com: </li>" >>/root/dex2jar/report/$id.html
	echo "<table><tr><td><pre style=\"background-color:WhiteSmoke;\"><code><font face=\"Verdana\" style=\"font-size:18px;\">" >>/root/dex2jar/report/$id.html

	if grep -r -q "setSavePassword\(false\)" /root/dex2jar/report/$id/com ; then
		echo "    webview自动保存密码已关闭" >>/root/dex2jar/report/$id.html
		echo >>/root/dex2jar/report/$id.html
		echo "</font></code></pre></td></tr></table>" >>/root/dex2jar/report/$id.html
	else
		echo "    使用WebView时需要关闭webview的自动保存密码功能,防止用户密码被webview明文存储" >>/root/dex2jar/report/$id.html
		echo "修复建议:" >>/root/dex2jar/report/$id.html 
		echo "    设置webView.getSetting().setSavePassword(false)" >>/root/dex2jar/report/$id.html
		echo >>/root/dex2jar/report/$id.html
		echo "</font></code></pre></td></tr></table>" >>/root/dex2jar/report/$id.html 
	fi
else
	echo "未检测到WebView风险" >>/root/dex2jar/report/$id.html 
	echo >>/root/dex2jar/report/$id.html
	echo "</font></code></pre></td></tr></table>" >>/root/dex2jar/report/$id.html
fi
echo >>/root/dex2jar/report/$id.html
echo \<br /\> >>/root/dex2jar/report/$id.html

echo \<br /\> >>/root/dex2jar/report/$id.html
if grep -r -q "WebView" /root/dex2jar/report/$id/bolts ;then
	echo "<li>检测到使用WebView  bolts/: </li>" >>/root/dex2jar/report/$id.html
	echo "<table><tr><td><pre style=\"background-color:WhiteSmoke;\"><code><font face=\"Verdana\" style=\"font-size:18px;\">" >>/root/dex2jar/report/$id.html

	if grep -r -q "setSavePassword\(false\)" /root/dex2jar/report/$id/com ; then
		echo "    webview自动保存密码已关闭" >>/root/dex2jar/report/$id.html
		echo >>/root/dex2jar/report/$id.html
		echo "</font></code></pre></td></tr></table>" >>/root/dex2jar/report/$id.html
	else
		echo "    使用WebView时需要关闭webview的自动保存密码功能,防止用户密码被webview明文存储" >>/root/dex2jar/report/$id.html
		echo "修复建议:" >>/root/dex2jar/report/$id.html 
		echo "    设置webView.getSetting().setSavePassword(false)" >>/root/dex2jar/report/$id.html
		echo >>/root/dex2jar/report/$id.html
		echo "</font></code></pre></td></tr></table>" >>/root/dex2jar/report/$id.html 
	fi
else 
	echo "未检测到WebView风险" >>/root/dex2jar/report/$id.html 
	echo >>/root/dex2jar/report/$id.html
	echo "</font></code></pre></td></tr></table>" >>/root/dex2jar/report/$id.html
fi
echo >>/root/dex2jar/report/$id.html
echo \<br /\> >>/root/dex2jar/report/$id.html

echo "<hr />" >>/root/dex2jar/report/$id.html
echo "<h3 id="thanks"> 感谢使用本检测产品</h3>" >>/root/dex2jar/report/$id.html
echo "</div></body>" >>/root/dex2jar/report/$id.html

/root/sendEmail -f xxx@company.com -t $mail -s smtp.company.com -u "APP_report_$name" -o message-content-type=html -o message-charset=utf8 -xu xxx(user) -xp xxx(password) -o message-file=/root/dex2jar/report/$id.html
