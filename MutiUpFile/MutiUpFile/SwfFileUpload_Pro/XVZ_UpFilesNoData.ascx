<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="XVZ_UpFilesNoData.ascx.cs"
    Inherits="UpFile.SwfFileUpload.XVZ_UpFilesNoData" %>
<script type="text/javascript">
    var swfu1; //定义图对象
    //var swfu2;
    var swfus=new Array();
    // var pageUrl = <%=url %>;
    var pageUrl = '';
    var IsCancel = '';
    var Process_Status = '';
    var fileType = "";
    var fileDiscraption = "";
    var IsStop = "";
    var HasShowList = "";
    var ActionType = 0;
    var memberID = "";
    var isDels="";
    var isUpFile = "";
    var relatePaths="";
    var memberName="";
    var filePathID="";
    var hostUrl="";
    var fileName;
    var hasModuleDisID="";
    var hasFilePathType="";
    var isReloads="";
    var counts=1;//上传按钮个数
    var fileNums=0;//标识是否选择了上传的文件

    var stopFlags=false;
    $(function () {
        
        IsCancel = <%=IsCancel %>;
        Process_Status =<%=Process_Status %>;
        IsStop = <%=IsStop %>;
        HasShowList = <%=HasShowList %>;
        isDels=<%=IsDel %>
        hasModuleDisID = <%=HasModuleName %>;
        hasFilePathType=<%=HasFilePathName %>
        isReloads=<%=IsReLoad %>
        
        pageUrl = document.getElementById("<%=pageUrlID.ClientID%>").value;
        memberID = document.getElementById("<%=sessionMemberID.ClientID%>").value;
        fileType = document.getElementById("<%=fileTypesID.ClientID%>").value;
        fileDiscraption = document.getElementById("<%=discraptionID.ClientID%>").value;
        relatePaths = document.getElementById("<%=relatePathsID.ClientID%>").value;
        memberName = document.getElementById("<%=member_NameID.ClientID%>").value;
        filePathID = document.getElementById("<%=filePathID.ClientID%>").value;
        hostUrl = document.getElementById("<%=hostUrlID.ClientID%>").value;      
        
        if (IsCancel == 'false' || IsCancel == "") {
            $("#cancelID").addClass('isVisible');
        }
        if (Process_Status == 'false' || Process_Status == "") {
            $("#spanFileProgressContainer").addClass('isVisible');
            $(".processCls").css('display','none');
        }
        if (IsStop == 'false' || IsStop == "") {
            $("#stopID").addClass('isVisible');
        }
        if (ActionType == '0' || ActionType == "") {
            $("#divActionTypeID").addClass('isVisible');
            isUpFile = "0";
        }
        if (HasShowList == 'false' || HasShowList == "") {
            $("#showListID").addClass('isVisible');
        }
        if(isDels=='false'||isDels=="")
        {
            $("#deleteID").attr("disabled", "false");
        }

        if (fileType == "") {
            //swfu.setFileTypes(fileType, fileDiscraption);
            fileType = "*.jpg;*.pdf;*.rar";
        }
        
        if(hasModuleDisID==""||hasModuleDisID=="false"){
             $("#miaoshuID").addClass('isVisible');
        }
        
        if(hasFilePathType==""||hasFilePathType=="false"){
            $("#divFileTypeID").addClass('isVisible');
        }

        fileName = $('#fileNameID1');
        swfu1= GetSwfu(pageUrl,"spanButtonPlaceholder1","#fileNameID1","1");
        //swfu2= GetSwfu(pageUrl,"spanButtonPlaceholder2","#fileNameID2")
        swfus.push(swfu1);
        //swfus.push(swfu2);
    });

    function GetSwfu(str,btnID,fileNameID,statusID) {
        return  new SWFUpload({
            // Backend Settings
            upload_url: str,
            post_params: {
                "ASPSESSID": "<%=Session.SessionID %>"
            },

            // File Upload Settings
            file_size_limit: "0",
            file_types: fileType,
            file_types_description: fileDiscraption,
            file_upload_limit: 0,    // Zero means unlimited

            swfupload_preload_handler: preLoad,
            swfupload_load_failed_handler: loadFailed,
            file_queue_error_handler: fileQueueError,
            file_dialog_complete_handler: DialogComplete,
            upload_progress_handler: uploadProgress_new,
            upload_error_handler: uploadError,
            upload_success_handler: upFileSuccess, //上传成功后所执行的函数
            upload_complete_handler: FileUpOk, //上传结束后执行的函数
            mouse_over_handler: test, //鼠标滑过的时候触发的事件
            file_queued_handler: fileQueued,
            upload_start_handler: uploadStart,

            //progressBarText: ' 正在上传：{0}，{1}%完成 ',

            // Button settings
            button_image_url: relatePaths+"SwfFileUpload_Pro/images/XPButtonNoText_160x22.png",
            button_placeholder_id: btnID,
            button_width: 60,
            button_height: 22,
            button_text: '<span class="button">选择</span>',
            button_text_style: '.button { font-family: Helvetica, Arial, sans-serif; font-size: 12pt;margin-left:12px;} .buttonSmall { font-size: 10pt; }',
            button_text_top_padding: 1,
            button_text_left_padding: 2,
            button_cursor: -2, //鼠标的形状
            button_action: -100, //对话框中是否可以多选，此时不能被多选
            window_mode:"transparent",

            // Flash Settings
            flash_url:  relatePaths+"SwfFileUpload_Pro/swfupload.swf", // Relative to this file
            flash9_url:  relatePaths+"SwfFileUpload_Pro/swfupload_FP9.swf", // Relative to this file

            custom_settings: {
                upload_target: "spanFileProgressContainer", //将上传成功后的信息保存在id文件
                file_IDs: [], //记录当前选择文件的ID
                file_Names: "",
                file_Nums: 0,
                fileName:fileNameID,
                statusID:statusID
            },
            // Debug Settings
            debug: false
        });

    }
    function uploadProgress_new(file, bytesLoaded) {
        try {
            var percent = Math.ceil((bytesLoaded / file.size) * 100);

            var progress = new FileProgress(file, this.customSettings.upload_target);
            progress.setProgress(percent);
            var dt = new Date();
            var dt1 = dt.getTime();
            var result = 0;
            if (percent > 100) {
                setProcess(this.customSettings.statusID,100);
                progress.setStatus("上传完成");
                progress.toggleCancel(false, this);
            } else {
                if (flag != 0 && num != bytesLoaded) {
                    result = Math.round((bytesLoaded - num) / ((dt1 - flag) * 1.24) * 100) / 100;
                    num = bytesLoaded;
                    if (result > 1024) {
                        result = Math.round(result / 1024 * 100) / 100 + "mb/s";
                    } else {
                        result = result + "kb/s";
                    }
                }
                setProcess(this.customSettings.statusID,percent);
                progress.setStatus("完成" + percent + "%,计" + bytesLoaded + "个字节,文件大小" + file.size + "个字节,传输速率是" + result);
                progress.toggleCancel(true, this);
                flag = dt1;
            }
        } catch (ex) {
            this.debug(ex);
        }
    }
    function setProcess(processbarID,Mywidth){
        if (Mywidth==0) {
            Mywidth=100;
        }
         var obj,Mywidth,objNum;  
            obj = document.getElementById("processbar"+processbarID);  
            objNum = $("#processNums"+processbarID);  
            //Mywidth = obj.style.width; Mywidth = Mywidth.replace("px", ""); Mywidth = parseInt(Mywidth);Mywidth++;  
            objNum.text(Mywidth+"/100");
            obj.style.width = Mywidth + "px";  
    }
    function uploadStart(files) {
        var file = files;
        //alert(file.name);
    }
    //文件选择后排列到队列上去
    //将当前文件的ID记录下来
    function fileQueued(file) {
        var file = file;
       // if (this.customSettings.file_Names.indexOf(file.name) == -1) {
            this.customSettings.file_IDs.push(file.id);
            this.customSettings.file_Names += file.name + "|";
        //}
        //swfu.customSettings.file_ID = file.id;
        this.customSettings.file_Nums = this.customSettings.file_IDs.length;
    }
    function test() {
        //alert("鼠标移上来了");
    }
    //获取文件在服务器所在的位置
    //serverData:是服务端返回的图片上传的路径
    function FileUpOk(file, serverData) {
        $("#startID").attr("disabled","");
        //alert(isOk);
        if(!stopFlags){
             fileNums--;
            if (isOk) {
                //alert("上传成功！");
                $("#statusID"+this.customSettings.statusID).text('上传成功...');
                $("#statusID"+this.customSettings.statusID).css('display','');
            } else {
                //alert("上传失败
                 $("#statusID"+this.customSettings.statusID).text('上传失败...');
                $("#statusID"+this.customSettings.statusID).css('display','');
            }
            if(isReloads==true){
                //$('#<%=search.ClientID %>').trigger("click");//上传完成后刷新列表
                 $(this.customSettings.fileName).val("");
            }
        }else{
            alert("已经暂停上传！")
        }
        isOk = true;
        stopFlags=false;       
    }
    function upFileSuccess(file,serverData)
    {
        if(serverData==0){
            isOk=false;
            alert("您选择替换的附件类型不相同！请重新选择！")
        }else{
            //alert(serverData);
            $("#<%=pathValuesID.ClientID %>").val(serverData);
        }
    }
    //选择对话框结束时触发的事件
    function DialogComplete(numFilesSelected, numFilesQueued) {
        try {
            if (numFilesQueued > 0) {
                $(".StatusCls").css('display','none');
                var selectfileName = "";
                selectfileName = this.getQueueFile(this.customSettings.file_IDs[this.customSettings.file_Nums - 1]).name;
                $(this.customSettings.fileName).val(selectfileName);
                fileNums++;
                $("#startID").attr("disabled","");
            }
        } catch (ex) {
            this.debug(ex);
        }
    }
    function Cancel_new(swfu) {        
        swfu.cancelUpload(swfu.customSettings.file_IDs[swfu.customSettings.file_Nums - 1]);
        swfu.customSettings.file_ID = "";
        fileName.val("");
        $("#startID").attr("disabled","");
        if(isReloads==true){
             $('#<%=search.ClientID %>').trigger("click");//上传完成后刷新列表
        }
    }
    //取消上传当前的文件
    function Cancel() {        
         if (swfus!=null) {
            for(i=0;i<swfus.length;i++){
                Cancel_new(swfus[i]);
            }
        }
        fileNums=0;
    }
    function Stop_new(swfu) {
        swfu.stopUpload(swfu.customSettings.file_IDs[swfu.customSettings.file_Nums - 1]);
        swfu.customSettings.file_IDs.push(swfu.customSettings.file_Nums - 1);
        stopFlags=true;
        $("#startID").attr("disabled","");
    }
    //停止上传当前的文件
    function Stop() {
       if (fileNums!=0) {
            if($("#stopID").val()=="暂停"){
                for(i=0;i<swfus.length;i++){
                    Stop_new(swfus[i]);
                }
                $("#stopID").val("继续");
            }else{
                for(i=0;i<swfus.length;i++){
                    Start_new(swfus[i]);
                }
                $("#stopID").val("暂停");
                //fileNums=0;
            }
        }
        //fileNums=0;
    }
    //开始上传文件
    function Start() {
        if (fileNums==0) {
            alert("您还没有选择要上传的文件！")
            return;
        }
        if (swfus!=null) {
            for(i=0;i<swfus.length;i++){
                Start_new(swfus[i]);
            }
        }
        //fileNums=0;
    }
    function Start_new(swfu) {
          if (ActionType == '0' || ActionType == "") {
            $("#divActionTypeID").addClass('isVisible');
            isUpFile = "0";
        } else {
            isUpFile = document.getElementById("<%=actionTypeID.ClientID%>").value;
        }
        var isFalse= GetSelectValue();
        if(isFalse==false){
            return;
        }
        var selectNames = $.trim($(swfu.customSettings.fileName).val());
        if (selectNames == "" || selectNames == undefined) {
            selectedID=0;
            //alert("请先选择要上传的文件！");
            return;
        }
        isOk = true;
        if (swfu.customSettings.file_IDs != "") {
            if(!CheckedURL()){
                if (pageUrl == '') {
                    swfu.setUploadURL(relatePaths+"SwfFileUpload_Pro/UpFiles.ashx");
                } else {
                    swfu.setUploadURL(relatePaths+"SwfFileUpload_Pro/"+pageUrl);
                }
            }else{
                if (pageUrl == '') {
                    swfu.setUploadURL("UpFiles.ashx");
                } else {
                    swfu.setUploadURL(pageUrl);
                }
            }
            var remark=$("#discraptionsID").val();
            var moduleName=document.getElementById("<%=fileTypeListID.ClientID%>").value;
            if(moduleName==null||moduleName==""){
                alert("请选择要上传的附件类别！");
                return;
            }
            swfu.addPostParam("member_ID", memberID);
            swfu.addPostParam("member_NAME", memberName);
            swfu.addPostParam("filePath",filePathID);
            swfu.addPostParam("hostUrl",hostUrl);
            swfu.addPostParam("moduleName",moduleName);
            swfu.startUpload(swfu.customSettings.file_IDs[swfu.customSettings.file_Nums - 1]);
            swfu.customSettings.file_ID = "";
            selectedID=0;
            $("#startID").attr("disabled","false");
            //fileName.val("");

        }
    }
    function CheckedURL() {
             var url = false;
            //alert(navigator.userAgent);
            if (navigator.userAgent.indexOf("Chrome") != -1) {
                url = true;
            }
            if (navigator.userAgent.indexOf("Firefox") != -1) {
                url = true;
            }
            if (navigator.appName.indexOf("Opera") != -1) {
                url = true;
            }
            if (navigator.userAgent.indexOf("Safari") != -1) {
                url = true;
            }
            return url;
    }
    function DeleteControl(controlID) {
        if (swfus.length==1) {
            alert("不能全部删除");
            return;
        }
         if(controlID!=null){
            var index=controlID.substring(7,9);
            //swfus.splice(parseInt(index)-1,1);
            for (var i = 0; i < swfus.length; i++) {
                var nums= swfus[i].movieName.split('_')[1];
                if (parseInt(nums)==index-1) {
                    swfus.splice(i,1);
                }
            }
        }
        //swfus.pop();
        var control=$("#"+controlID);
        control.remove();
    }
    function addFile() {
        
        var list= $("#controlListID");
        var len=counts+1;
        list.append('<tr id="control'+len+'"><td><input type="text" name="name" value=" " id="fileNameID'+len+'" disabled="disabled" /></td><td align="left"><span id="spanButtonPlaceholder'+len+'" style="float: left;"></span></td><td><input type="button" name="del" value="删除" onclick="DeleteControl(\'control'+len+'\');" /><span id="statusID'+len+'" class="StatusCls" style=" display:none; color:Red;">上传成功！</span></td><td><div  class="processCls" style="padding: 1px; background-color: #E6E6E6; border: 1px solid #C0C0C0; width: 100px;height: 2px;"><div id="processbar'+len+'" style="background-color: #00CC00; height: 1px; width: 1px;"></div></div><span id="processNums'+len+'" class="processCls" style=" font-size:10px;color:Gray;">0/100</span></td></tr>');
        swfus.push(GetSwfu(pageUrl,"spanButtonPlaceholder"+len,"#fileNameID"+len,len));
        counts++;
    }
    var selectedID=0;
    //产检替换的数据
    function GetSelectValue(){
        var flags=true;
        if(isUpFile=="1"){
            var objs=$("input");
            for(var k=0;k<objs.length;k++){
                if(objs[k].type.toLowerCase() == "checkbox"){
                    if(objs[k].checked){
                        if(selectedID==0){
                            selectedID=objs[k].value;
                        }else{
                            alert("一次只能选择一项，请核查！");
                            flags=false;
                            selectedID=0;
                            break;
                        }
                    }
                }
            }
            if(selectedID==0){
                flags=false;
                alert("请选择要替换的附件！");
            }
        }
        return flags;
    }
    //实现删除   
    function DeleteRows(){
        var ids="";
        var objs=$("input");
        for(var k=0;k<objs.length;k++){
            if(objs[k].type.toLowerCase() == "checkbox"){
                if(objs[k].checked){
                    ids+=objs[k].value+"|";
                }
            }
        }
        if(ids==""){
            alert("你还没有选择要回收的项！")
            return;
        }
        if(!confirm("你确定要回收？")){
            return;
        }
        var strUrl=window.location.href;
        var arrUrl=strUrl.split("/");
        var strPage=arrUrl[arrUrl.length-1];
        $.ajax({
            type:"POST",
            url:strPage,
            dataType:"text",
            data:"action=del&IDS="+ids,
            success:function(msg){
                alert("回收成功！");
                $('#<%=search.ClientID %>').trigger("click");
            }
        })
    }
    function IsLook(href,title){
        if(href.indexOf(title)==-1)
        {
            alert("您没有下载的权限！");
            return false;
        }
    }
    function changes(){
        alert($("#<%=pathValuesID.ClientID %>").val())
    }
</script>
<input type="hidden" name="name" value=" " runat="server" id="pageUrlID" />
<input type="hidden" name="name" value=" " runat="server" id="fileTypesID" />
<input type="hidden" name="name" value=" " runat="server" id="discraptionID" />
<input type="hidden" name="name" value=" " runat="server" id="sessionMemberID" />
<input type="hidden" name="name" value=" " runat="server" id="roleNumsID" />
<input type="hidden" name="name" value=" " runat="server" id="relatePathsID" />
<input type="hidden" name="name" value=" " runat="server" id="member_NameID" />
<input type="hidden" name="name" value=" " runat="server" id="filePathID" />
<input type="hidden" name="name" value=" " runat="server" id="hostUrlID" />
<input type="hidden" name="name" value=" " runat="server" id="pathValuesID" onserverchange="pathValues_ServerChanges" />
<input type="hidden" name="name" value=" " id="pathNameID" />
<%--<head id="Head1">
</head>--%>
<div id="swfu_container" style="margin: 0 0 0 0; float: left; width: 100%;">
    <div style="float: left; margin: 0 0 0 0; width: 100%;">
        <table border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td colspan="3">
                    <div id="divActionTypeID">
                        操作类型：
                        <asp:DropDownList ID="actionTypeID" runat="server">
                            <asp:ListItem Text="上传" Value="0" Selected="True" />
                            <asp:ListItem Text="替换" Value="1" />
                        </asp:DropDownList>
                    </div>
                    <div id="divFileTypeID">
                        附件类别：
                        <asp:DropDownList ID="fileTypeListID" runat="server">
                        </asp:DropDownList>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    <div id="miaoshuID">
                        描&nbsp;&nbsp;&nbsp;&nbsp;述：&nbsp;<input type="text" name="" value="" id="discraptionsID" /></div>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <div>
                        <table id="controlListID">
                            <tr id="control1">
                                <td>
                                    <input type="text" name="name" value=" " id="fileNameID1" disabled="disabled" />
                                </td>
                                <td align="left">
                                    <span id="spanButtonPlaceholder1" style="float: left;"></span>
                                </td>
                                <td>
                                    <input type="button" name="del" value="删除" onclick="DeleteControl('control1');" /><span
                                        id="statusID1" class="StatusCls" style="display: none; color: Red;">上传成功！</span>
                                </td>
                                <td>
                                      <div  class="processCls" style="padding: 1px; background-color: #E6E6E6; border: 1px solid #C0C0C0; width: 100px;height: 2px;"><div id="processbar1" style="background-color: #00CC00; height: 1px; width: 1px;"></div></div><span id="processNums1" class="processCls" style=" font-size:10px;color:Gray;">0/100</span>
                                </td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
            <tr>
                <td width="153px">
                    <input type="button" size="153px" onclick="addFile();" value="add File" />
                </td>
                <td align="right">
                    <input type="button" name="name" style="margin-left: 10px;" value="开始" onclick="Start();"
                        id="startID" />
                    <input type="button" name="name" value="暂停" id="stopID" onclick="Stop();" />
                    <input type="button" name="name" value="取消" id="cancelID" onclick="Cancel();" />
                </td>
            </tr>
        </table>
        <span id="spanFileProgressContainer" style="float: left; margin: 2px 0 0 0; display:none;"></span>
    </div>
    <div id="showListID">
        ---->附件列表
        <table width="560">
            <tr>
                <td>
                    <table class="OI" cellspacing="0" cellpadding="0" width="570" border="0">
                        <tr>
                            <td>
                                附件类别：
                                <asp:DropDownList ID="searchTypeID" runat="server">
                                </asp:DropDownList>
                            </td>
                            <td>
                                附件名称
                                <asp:TextBox class="bginput" ID="AnnexNameID" Style="cursor: hand" runat="server"
                                    Width="80"></asp:TextBox>
                            </td>
                            <td width="30%">
                                上传日期
                                <asp:TextBox class="bginput" ID="upFileDateID" Style="cursor: hand" runat="server"
                                    Width="80" onclick="(new system.web.forms.Calendar()).pickDate(this);"></asp:TextBox>
                            </td>
                            <td>
                                <asp:Button class="buttonDefault" ID="search" runat="server" Text="查询" OnClick="search_Click">
                                </asp:Button>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <table class="OI" id="Table2" cellspacing="0" cellpadding="0" width="570" border="0">
                        <tr>
                            <td>
                                <asp:DataGrid ID="DGShow" runat="server" Width="572px" PageSize="15" AutoGenerateColumns="False">
                                    <HeaderStyle BackColor="#82B5CC"></HeaderStyle>
                                    <Columns>
                                        <asp:TemplateColumn>
                                            <HeaderStyle Width="20px"></HeaderStyle>
                                            <ItemTemplate>
                                                <asp:CheckBox runat="server" ID="CheckBox1" Visible="false"></asp:CheckBox>
                                                <input type="checkbox" value="<%# Eval("Id") %>" />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="id" HeaderText="ID">
                                            <HeaderStyle Width="40px" Font-Size="Small"></HeaderStyle>
                                        </asp:BoundColumn>
                                        <asp:TemplateColumn HeaderText="附件名称" HeaderStyle-Font-Size="Small">
                                            <ItemTemplate>
                                                <a href='<%# IsLookFile=="true"?Eval("Paths"):"" %>' onclick="IsLook('<%# Eval("Paths")%>',this.title)"
                                                    target="_blank" title='<%# Eval("Name") %>'>
                                                    <%# CutStrs(Eval("Name"))%></a>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="FileType" HeaderText="附件类别">
                                            <HeaderStyle Width="100px" Font-Size="Small"></HeaderStyle>
                                        </asp:BoundColumn>
                                        <asp:BoundColumn DataField="CreateTime" HeaderText="上传日期" DataFormatString="{0:yyyy-M-d HH:mm:ss}"
                                            FooterStyle-Font-Size="Small">
                                            <HeaderStyle Width="100px" Font-Size="Small"></HeaderStyle>
                                        </asp:BoundColumn>
                                    </Columns>
                                    <PagerStyle NextPageText="下一页" PrevPageText="上一页" PageButtonCount="20" Mode="NumericPages">
                                    </PagerStyle>
                                </asp:DataGrid>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <table width="100%">
                        <tr bgcolor="#82b5cc">
                            <td width="20%">
                                <font face="宋体">
                                    <input type="button" value="附件回收" id="deleteID" onclick="DeleteRows()" /></font>
                            </td>
                            <td>
                                <asp:Label ID="lblCurrentIndex" runat="server" Font-Bold="True" Font-Size="9pt"></asp:Label>&nbsp;<asp:Label
                                    ID="lblPageCount" runat="server" Font-Bold="True" Font-Size="9pt"></asp:Label>&nbsp;&nbsp;&nbsp;
                                <asp:LinkButton ID="btnFirst" runat="server" CommandArgument="0" Font-Size="9pt"
                                    OnClick="btnFirst_Click">最首页</asp:LinkButton>&nbsp;
                                <asp:LinkButton ID="btnPrev" runat="server" CommandArgument="prev" Font-Size="9pt"
                                    OnClick="btnPrev_Click">前一页</asp:LinkButton>&nbsp;
                                <asp:LinkButton ID="btnNext" runat="server" CommandArgument="next" Font-Size="9pt"
                                    OnClick="btnNext_Click">下一页</asp:LinkButton>&nbsp;
                                <asp:LinkButton ID="btnLast" runat="server" CommandArgument="last" Font-Size="9pt"
                                    OnClick="btnLast_Click">最后页</asp:LinkButton>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </div>
</div>
