<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="proccess.aspx.cs" Inherits="MutiUpFile.proccess" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <script language="javascript" type="text/javascript">
        function set() { //用来设置进度条的长度  
            var obj, Mywidth;
            obj = document.getElementById("processbar");
            Mywidth = obj.style.width; Mywidth = Mywidth.replace("px", ""); Mywidth = parseInt(Mywidth); Mywidth++;
            obj.style.width = Mywidth + "px";
        }
        function start() {
            setInterval("set", 1000);
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div style="padding: 1px; background-color: #E6E6E6; border: 1px solid #C0C0C0; width: 300px;
        height: 20px;">
        <div id="processbar" style="background-color: #00CC00; height: 18px; width: 1px;">
        </div>
    </div>
    <input type="button" name="name" value="click" onclick="start()" />
    </form>
</body>
</html>
