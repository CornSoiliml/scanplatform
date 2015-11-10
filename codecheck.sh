#!/bin/bash
# bash shell script
#
# ----------------------------------------------------------------------
# here we come the last part, using godeyes for source code checking.	|
# same as apkcheck, you may find all required components in my project.	|
# godeyes is a tool for scaning vulnerabilites may cause app crush		|
# it helps a lot and keeps updating by IT engineer from baidu.com		|
# what a great job 														|
# for now, they don't let users apply self-made scan rules			|
# so i just set the config file to match it requirement and run.		|
# make sure the name of zip/rar file is same as Android project's name	|
# author: cornsoiliml 346415320@qq.com									|
# respect to godeyes													|
# ----------------------------------------------------------------------
#				

exec 1>/dev/null 
exec 2>/dev/null

# $1 邮箱
# $2 ID
# $3 rar/zip名
name=$(echo $1 | cut -d @ -f 1)
var=$(echo $3 | cut -d . -f 1)
ftype=$(echo $3 | cut -d . -f 2)
cd /root/godeyes/task
if [ $ftype == "rar" ] ;then
	mv $3 $2.rar
	rar x -o+ $2.rar
	mv $var $2
elif [ $ftype == "zip" ] ;then
	mv $3 $2.zip
	unzip -o $2.zip
	mv $var $2
else 
	/root/sendEmail -f xxx@company.com -t $1 -s smtp.company.com -u "Error_for_$var" -o message-content-type=html -o message-charset=ANSI -xu xxx(user) -xp xxx(password) -m error file type
fi;



echo "#<h1 id="hi"> hi,主机 $3 的检测报告</h1>" >/root/godeyes/task/godeyes.properties
echo "godeyesPath=/home/user/cmdGodEyes.V2.1" >> /root/godeyes/task/godeyes.properties
echo "projectPath=/root/godeyes/task/$2" >>/root/godeyes/task/godeyes.properties
echo "projectSrcEncodings=UTF-8" >>/root/godeyes/task/godeyes.properties
echo "reportOutputPath=/root/godeyes/report" >>/root/godeyes/task/godeyes.properties
echo "reportProductName=$2" >>/root/godeyes/task/godeyes.properties
echo "minSDK=" >>/root/godeyes/task/godeyes.properties
echo >>/root/godeyes/task/godeyes.properties
echo "SystemAPICompatibility=true" >>/root/godeyes/task/godeyes.properties
echo "ArrayListInitNullReturnInvoNPE=true" >>/root/godeyes/task/godeyes.properties
echo "ThrowNewExceptionTryCatch=true" >>/root/godeyes/task/godeyes.properties
echo "SQLiteOperationTryCatch=true" >>/root/godeyes/task/godeyes.properties
echo "CancelDialogisShowingCheck=true" >>/root/godeyes/task/godeyes.properties
echo "HashMapGetObjInvocationNPE=true" >>/root/godeyes/task/godeyes.properties
echo "ParseCheck=true" >>/root/godeyes/task/godeyes.properties
echo "WindowDismissCheck=true" >>/root/godeyes/task/godeyes.properties
echo "ReturnNullInvocation=true" >>/root/godeyes/task/godeyes.properties
echo "IDNotBelongThisLayout=true" >>/root/godeyes/task/godeyes.properties
echo "ArrayListGetJudgeIndex=true" >>/root/godeyes/task/godeyes.properties
echo "StringSplitBoundCheck=true" >>/root/godeyes/task/godeyes.properties
echo "SearchTooBigDrawable=true" >>/root/godeyes/task/godeyes.properties
echo "DBCursorCloseCheck=true" >>/root/godeyes/task/godeyes.properties
echo "SubStringLengthCheck=true" >>/root/godeyes/task/godeyes.properties
echo "StreamCloseCheck=true" >>/root/godeyes/task/godeyes.properties
echo "SuperFunctionCheck=true" >>/root/godeyes/task/godeyes.properties
echo "DenminatorLengthCheck=true" >>/root/godeyes/task/godeyes.properties
echo "FragmentAddedCheck=true" >>/root/godeyes/task/godeyes.properties
echo >>/root/godeyes/task/godeyes.properties
echo "WhiteList=" >>/root/godeyes/task/godeyes.properties


java -jar /home/user/cmdGodEyes.V2.1/cmdGodEyes.jar /root/godeyes/task/godeyes.properties 2>&1;


sed -i "1426a<hr /><h3 id=\"mail\"> User Account: $name </h3><h3 id=\"package\"> Project Name: $var </h3><hr />" /root/godeyes/report/$2.html
sed -i '$i<hr /><h3 id="thanks"> Thanks for your confidence in our product </h3>' /root/godeyes/report/$2.html;

/root/sendEmail -f xxx@company.com -t $1 -s smtp.company.com -u "code_report_$name" -o message-content-type=html -o message-charset=ANSI -xu xxx(user) -xp xxx(password) -o message-file=/root/godeyes/report/$2.html