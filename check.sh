#!/bin/bash
# bash shell script
#
# --------------------------------------------------------------------------------------------------
# a light safe-check tool for CentOS server , 														|
# share the earlier version for learning and inspiring more creative thoughts						|
# some shell programming, lua, regular expression knowledge may help comprehend this proj			|
# if you are keen on infomation security and automatic scan,										|
# please share your idea or experience, lets make it better											|
# author: cornsoiliml 346415320@qq.com																|
# you may check other script for apk-check or code-check using godeyes(a free scan engine)			|
# thank you 																						|
# For Sylvanas Windrunner! :-D																		|
# --------------------------------------------------------------------------------------------------
#

#-----------------define your output style in this file.-----------------
#-----------------by the way, using Markdown is another choice. notice markdown.pl in my project-----------------
cat /root/servercheck/head >/root/servercheck/$2

echo "companyname_server safe 检测报告" >>/root/servercheck/$2

echo "<hr />" >>/root/servercheck/$2
#echo $$
#echo "\$0 script_name" $0

#-----------------infomaiton input from web application-----------------
echo "<h3 id="mail"> user :$1" | cut -d @ -f 1 >>/root/servercheck/$2
# $2:ID
echo "</h3>" >>/root/servercheck/$2
echo "<h3 id="ip"> 主机ip:$3</h3>" >>/root/servercheck/$2
echo "<h3 id="user"> SSH_user:$4</h3>" >>/root/servercheck/$2
if [ ! -n "$4" ] ;then
	echo "<h3 id="password"> SSH_password:</h3>" >>/root/servercheck/$2
else
	echo "<h3 id="password"> SSH_password:******</h3>" >>/root/servercheck/$2
fi
#echo "\$5 test var:"$5 >>/root/servercheck/$2

echo " ">>/root/servercheck/$2

echo "  ">>/root/servercheck/$2

#-----------------using nmap for port scan, you can program your own nmap lua-script-----------------
echo "<hr />">>/root/servercheck/$2
echo "<h2 id="portstart"> 端口扫描检测</h2>" >>/root/servercheck/$2
echo "  ">>/root/servercheck/$2
echo "<code><pre>" >>/root/servercheck/$2
nmap --script=default $3 >>/root/servercheck/$2
echo >>/root/servercheck/$2
echo "</code></pre>" >>/root/servercheck/$2
echo "  ">>/root/servercheck/$2
echo "<h3 id="portdone"> 主机的端口、服务及存在风险信息如上</h3>" >>/root/servercheck/$2
echo " ">>/root/servercheck/$2

#-----------------if ssh info submitted, login and check-----------------
echo "  ">>/root/servercheck/$2
echo "<hr />">>/root/servercheck/$2
if [ ! -n "$4" ] ;then
	echo "<h2 id="noconf"> 没有提交配置检测</h2>" >>/root/servercheck/$2
else 
	echo "<h2 id="conf"> 主机配置检测</h2>" >>/root/servercheck/$2
	echo "<p>&nbsp;&nbsp;&nbsp;&nbsp;" >>/root/servercheck/$2
	/root/conf.exp $3 $4 $5 >>/root/servercheck/$2
fi
	sed -i '/~/d' /root/servercheck/$2
	sed -i '/@/d' /root/servercheck/$2
	#sed -i '/*/d' /root/servercheck/$2
	sed -i 's/\r//g' /root/servercheck/$2 
    sed -i '/Some Capabilities/d' /root/servercheck/$2
echo "</p>">>/root/servercheck/$2
echo "<hr />">>/root/servercheck/$2
echo "<h3 id="thanks"> 感谢使用本检测</h3>" >>/root/servercheck/$2
echo "</div></body>" >>/root/servercheck/$2
#mail -s "report for $2" $1 < /root/servercheck/$2
#/root/markdown.pl /root/servercheck/$2 > /root/servercheck/md$2.html

#-----------------using sendEmail to send safe-check report, type your own email info if necessary-----------------
/root/sendEmail -f xxx@company.com -t $1 -s smtp.company.com -u "report_for_$3" -o message-content-type=html -o message-charset=utf8 -xu xxx(user) -xp xxx(password) -o message-file=/root/servercheck/$2


