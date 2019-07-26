<%--
    Document   : Login
    Created on : 2013/12/05, 下午 02:38:55
    Author     : Mark
    產生一介面讓使用者輸入使用者名稱及密碼，執行登入的動作
    springboot升级改造
--%>

<%@page session="true" contentType="text/html" pageEncoding="UTF-8"%>
<%
    response.setHeader("Pragma","No-cache");
    response.setHeader("Cache-Control","no-cache");
    response.setDateHeader("Expires", 0);
    response.flushBuffer();
    Cookie killMyCookie = new Cookie("mycookie", null);
    killMyCookie.setMaxAge(0);
    killMyCookie.setPath("/");
    response.addCookie(killMyCookie);
%>
<!DOCTYPE html>
<HTML>
    <HEAD>
        <TITLE>GUI Login</TITLE>
        <meta http-equiv="Expires" CONTENT="0">
        <meta http-equiv="Cache-Control" CONTENT="no-cache">
        <meta http-equiv="Pragma" CONTENT="no-cache">
        
        <LINK REL='STYLEsheet' TYPE='text/css' HREF='../../static/js/ext/resources/css/ext-all.css'/>
        <LINK REL='STYLEsheet' TYPE='text/css' HREF='../../static/css/All.css'/>
        <LINK REL='STYLEsheet' TYPE='text/css' HREF='../../static/css/Button.css'/>
        <link rel="icon" href="../../static/photo/favicon.ico" type="image/x-icon" />
        <link rel="shortcut icon" href="../../static/photo/favicon.ico" type="image/x-icon" />
        <SCRIPT TYPE='text/javascript' SRC='../../static/js/CommonFunction.js'></SCRIPT>
        <SCRIPT TYPE='text/javascript' SRC='../../static/js/ext/ext-all-Mark.js'></SCRIPT>
        <SCRIPT TYPE='text/javascript' SRC="../../static/js/ext/locale/ext-lang-zh_TW.js"></SCRIPT>
        <script TYPE='text/javascript' SRC='../../static/js/HttpRequest.js'></script>
        <script TYPE='text/javascript' SRC='../../static/js/FrameRequest.js'></script>
        <SCRIPT TYPE='text/javascript' SRC='../../static/js/CommonFunction.js'></SCRIPT>
        <SCRIPT TYPE='text/javascript' SRC="../../static/js/ExtOperation.js"></SCRIPT>
        <SCRIPT TYPE='text/javascript' SRC='../../static/js/GlobalVariable.js'></SCRIPT>
        <SCRIPT type='text/javascript'>
            var LogOutTime = 12;     //當LoginStatus的時間超過LogOutTime的時間未更新則視為登出(單位秒)
            var LoginStatusCheckTime = 6; //LoginStatusCheckTime的時間執行一次Check_LoginStatus
            var ReviseWidth = 0;
            var ReviseHeight = 0;
            var BrowserType = 0;
            var System ="";
            var loadMarsk = null;
            //------------------------------畫面設定(Start)-----------------------------------------//
            Ext.onReady(function(){      //Boad載入完成後才載入
                var lableSystem = new Ext.form.Label({
                    id: 'lableSystem',
                    text : 'GUI Login',
                    style: "font-size:32px;text-align: center;",
                    width: 500,
                    x: 0,
                    y: 15
                });//<div style='font-weight:bold; font-size:16px; LINE-HEIGHT:20px; TEXT-ALIGN:center;'>
                var txtUserID = new Ext.form.TextField({
                    id: "txtUserID",  
                    fieldLabel: "使用者編號/UserID",
                    labelWidth:120,
                    labelStyle: "text-align: right;",
                    allowBlank:false,   //false時才會在空的時候顯示文字
                    blankText :"使用者編號是空的/UserID is Empty",
                    //maxLength :20,
                    //maxLengthText : "使用者編號超過最大長度",
                    vtype:'venString',
                    width:350,
                    x:50,
                    y:80,
                    enableKeyEvents : true,
                    listeners: {
                        specialkey : CheckEnter
                    }
                });
                var txtPassword = new Ext.form.TextField({
                    id: "txtPassword",
                    fieldLabel: "密碼/Password",
                    labelWidth:120,
                    labelStyle: "text-align: right;",
                    allowBlank:false,
                    blankText : "密碼是空的/Password is Empty",
                    vtype:'venString',
                    width:350,
                    x : 50,
                    y : 115,
                    inputType:"password", //顯示為password的類型 ***
                    enableKeyEvents : true,
                    listeners: {
                        specialkey : CheckEnter
                    }
                });
                var RadioBoxField = new Ext.form.RadioGroup({
                    id:'RadioBoxField',
                    columns: 1,
                    vertical: true, 
                    width: 350,
                    hidden: true,
                    x : 50,
                    y : 160,
                    fieldLabel:"語言/Language",
                    labelWidth:100,
                    labelStyle: "text-align: right;",
                    items: [
                        new Ext.form.Radio({ boxLabel: "中文", name: "Language", inputValue:"Local",checked: true}),
                        new Ext.form.Radio({id:"Language", boxLabel: "English", name: "Language", inputValue:"Default",labelSeparator:""})
                    ]
                });
                var btnApply = new Ext.Button({
                    id:"btnApply",
                    text: "登入/Login",
                    type:"button",
                    x : 150,
                    y : 220,
                    width: 100, 
                    height: 25,
                    listeners:{
                        "click": LoginCheck
                    }
                });
                var btnCancel = new Ext.Button({
                    id:"btnCencel",
                    text: "清除/Cancel",
                    type:"button",
                    x : 280,
                    y : 220,
                    width: 100, 
                    height: 25,
                    listeners:{ 
                        "click": Reset
                    }
                });    
                new Ext.form.FormPanel({
                    renderTo:"MainForm", //要渲染的div
                    id:"formLogin",
                    height: 260, 
                    width: 500, 
                    y:100,
                    frame: true,
                    layout : 'absolute',           //在容器中佈置為絕對位置
                    items : [
                        lableSystem
                        ,txtUserID
                        ,txtPassword
                        ,btnApply
                        ,btnCancel
                        ,RadioBoxField
                    ]
                });
                //------------------------------畫面設定(End)-----------------------------------------//
                BrowserType = CheckBrowser();
                SendRequestSetBrowser();
                //SendRequestLoadConfig();
                //SendRequestCheckLoginStatus();
                //window.setInterval("SendRequestCheckLoginStatus();",LoginStatusCheckTime*1000);
            });
            function SendRequestSetBrowser() {
                try{
                    if(typeof(SetBrowser) != "undefined")
                    {
                        SetBrowser(BrowserType);
                    }else
                    {
                        Ext.MessageBox.alert(ChangeLanguage("Error"),ChangeLanguage("SetBrowser not fined"));
                    }
                } catch(err)
                {
                    Ext.MessageBox.alert(ChangeLanguage("Error"),"SendRequestSetBrowser() "+err);
                }
            }
            function SendRequestLoadConfig() {
                try{
                    if(typeof(LoadConfig) != "undefined")
                    {
                        LoadConfig();
                    }else
                    {
                        Ext.MessageBox.alert(ChangeLanguage("Error"),ChangeLanguage("LoadConfig not fined"));
                    }
                } catch(err)
                {
                    Ext.MessageBox.alert(ChangeLanguage("Error"),"SendRequestLoadConfig() "+err);
                }
            }
            function GetConfigReport(Data_json) {
                try {
                    var DefaultLanguage = Data_json["LanguageDefault"];
                    var LanguageEnable = Data_json["LanguageEnable"];
                    System = Data_json["System"];
                    ReviseWidth = parseInt(Data_json["ReviseWidth"]);
                    ReviseHeight = parseInt(Data_json["ReviseHeight"]);
                    if(DefaultLanguage.toString().toLowerCase().indexOf("local") != -1)
                    {
                        if(Ext.getCmp("Language"))
                        {    
                            Ext.getCmp("Language").setValue("Local");
                        }
                    }else
                    {
                        if(Ext.getCmp("Language"))
                        {    
                            Ext.getCmp("Language").setValue("Default");
                        }
                    }
                    if(parseInt(LanguageEnable) == 1)
                    {
                        if(Ext.getCmp("RadioBoxField"))
                        {
                            Ext.getCmp("RadioBoxField").show();
                        }
                    }else
                    {
                        if(Ext.getCmp("RadioBoxField"))
                        {
                            Ext.getCmp("RadioBoxField").hide();
                        }
                    }
                    if(System.toString().length > 0)
                    {
                        if(Ext.getCmp("lableSystem"))
                        {    
                            Ext.getCmp("lableSystem").setText(System.toString().toUpperCase()+"  "+Ext.getCmp("lableSystem").text);
                        }
                    }     
                }catch (err)
                {
                    Ext.MessageBox.alert("Error","GetConfigReport() "+err);
                }  
            }
            function SendRequestCheckLoginStatus() {
                try{
                    if(typeof(CheckLoginStatus) != "undefined")
                    {
                        CheckLoginStatus(LogOutTime);
                    }else
                    {
                        Ext.MessageBox.alert(ChangeLanguage("Error"),ChangeLanguage("CheckLoginStatus not fined"));
                    }
                } catch(err)
                {
                    Ext.MessageBox.alert(ChangeLanguage("Error"),"SendRequestCheckLoginStatus() "+err);
                } 
            }     
            function SendRequestLogin(UserID,Password,Language) {
                try{
                    if(typeof(Login) != "undefined")
                    {
                        Login(UserID,Password,Language);
                    }else
                    {
                        Ext.MessageBox.alert(ChangeLanguage("Error"),ChangeLanguage("Login not fined"));
                    }
                } catch(err)
                {
                    Ext.MessageBox.alert(ChangeLanguage("Error"),"SendRequestLogin() "+err);
                } 
            } 
            function GetLoginReport(Data_json) {
                try {
                    var LoginReport = Data_json["Report"];
                    if(LoginReport.toString().indexOf("Success") != -1)
                    {
                        switch(BrowserType)
                        {
                            case 0:
                                window.location = './MainPage.jsp';
                                break;
                            default:
                                window.location = './MainPage.jsp';
                                break;
                        }
                    }else
                    {
                        Ext.MessageBox.alert("Warning",LoginReport);
                        Reset();
                    }
                }catch(err)
                {
                    Ext.MessageBox.alert("Error","CheckLoginReport() "+err);
                }          
            }
            //檢查使用者是否按下Enter鍵
            function CheckEnter(txtField,e) {
                e = e || event;   //在IE隱藏變量為event,FireFox或Opera隱藏變量為e
                if(e.getKey() == e.ENTER) 
                {
                    LoginCheck();
                }
            }
            //重置欄位內容
            function Reset() {
                Ext.getCmp("formLogin").form.reset();
            }
            //檢查使用者的登入資訊，並進行登入
            function LoginCheck() {
                var UserID = "";
                var Password = "";
                var Language = "";
                try {
                    if (Ext.getCmp("txtUserID") && Ext.getCmp("txtUserID").isValid() == false) 
                    {
                        Ext.MessageBox.alert("Warning","使用者編號是空的");
                        return;
                    }
                    if (Ext.getCmp("txtPassword") && Ext.getCmp("txtPassword").isValid() == false) 
                    {
                        Ext.MessageBox.alert("Warning","密碼是空的");
                        return;
                    }
                    UserID = Ext.getCmp("txtUserID").getValue();
                    Password = Ext.getCmp("txtPassword").getValue();
                    if(CheckEnString(UserID) == false)
                    {
                        Ext.MessageBox.alert("Warning","使用者編號格式錯誤");
                        return;
                    }
                    if(CheckEnString(Password) == false)
                    {
                        Ext.MessageBox.alert("Warning","密碼格式錯誤");
                        return;
                    }
                    if(Ext.getCmp("Language").getValue())
                    {
                        Language = 'Default';
                    }else
                    {
                        Language = 'Local';
                    }
                    SendRequestLogin(UserID,Password,Language);
                }catch(err)
                {
                    Ext.MessageBox.alert("Error","LoginCheck() "+err);
                }
            }
            function ShowLoadMask() {
                try{
                    loadMarsk = new Ext.LoadMask(document.body,{msg : '登入驗證中..',
                        removeMask : true
                    });
                    loadMarsk.show();
                }catch(err) {
                    Ext.MessageBox.alert("Error","ShowLoadMask() "+err);
                }
            }
            function HideLoadMask() {
                try{
                    if(typeof(loadMarsk) != "undefined" && loadMarsk != null)
                    {
                        loadMarsk.hide();
                    }
                }catch(err) {
                    Ext.MessageBox.alert("Error","HideLoadMask() "+err);
                }
            }
            document.oncontextmenu=function() {//停止開啟滑鼠右鍵選單
                return false;
            }
            document.onselectstart=function() {
                return false;
            }
        </SCRIPT>
    </HEAD>
    <BODY>
       <CENTER>
            <DIV id ="MainForm"></DIV>
        </CENTER>
    </BODY>
</HTML>