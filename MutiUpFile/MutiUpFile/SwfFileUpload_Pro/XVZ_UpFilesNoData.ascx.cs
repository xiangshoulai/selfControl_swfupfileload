using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.Data;
using System.IO;
using System.Web.Hosting;
using System.Text;

namespace UpFile.SwfFileUpload
{
    public class SortModel : IComparer<FileModel>
    {

        public int Compare(FileModel x, FileModel y)
        {
            return y.CreateTime.CompareTo(x.CreateTime);
        }
    }
    public partial class XVZ_UpFilesNoData : System.Web.UI.UserControl
    {
        public XVZ_UpFilesNoData()
        {
            this.IsLookFile = "false";
            this.IsCancel = "false";
            this.IsDel = "false";
            this.IsLookFile = "false";
            this.IsStop = "false";
            this.Process_Status = "false";
            this.HasShowList = "false";
            this.ActionType = "0";
            this.HasModuleName = "false";
            this.RoleLevel = "0";
            this.Member_ID = "000";
            this.Member_NAME = "匿名上传";
            this.FilePathName = ",其他";
            this.hasFilePathName = "false";
            this.IsReLoad = "true";
            this.FilePath = "upFile/";

        }
        private string urls;
        /// <summary>
        /// 后台处理程序的路径
        /// 空的时候表示请求默认的后台处理程序，已完成
        /// 如果自定义值，需要配置后台处理程序
        /// </summary>
        public string url { get { return urls; } set { urls = value; } }

        private string process_Statuss;
        /// <summary>
        /// 是否显示进度
        /// true表示显示进度
        /// 其他表示不显示进度
        /// </summary>
        public string Process_Status { get { return process_Statuss; } set { process_Statuss = value; } }

        private string isCancels;
        /// <summary>
        /// 是否实现取消按钮
        /// true表示实现取消功能
        /// 其他表示没有取消功能
        /// </summary>
        public string IsCancel { get { return isCancels; } set { isCancels = value; } }

        private string isStops;
        /// <summary>
        /// 是否实现暂停按钮
        /// true表示实现暂停功能
        /// 其他表示没有
        /// </summary>
        public string IsStop { get { return isStops; } set { isStops = value; } }

        private string fileType;
        /// <summary>
        /// 文件类型
        /// 可以限制文件上传的类型
        /// 空的时候表示只能上传jpg图片
        /// </summary>
        public string FileType { get { return fileType; } set { fileType = value; } }

        private string fileDiscraptions;
        /// <summary>
        /// 附件类型描述
        /// </summary>
        public string FileDiscraption { get { return fileDiscraptions; } set { fileDiscraptions = value; } }

        private string hasShowLists;
        /// <summary>
        /// 是否显示列表
        /// true表示显示列表信息
        /// 其他不显示
        /// </summary>
        public string HasShowList { get { return hasShowLists; } set { hasShowLists = value; } }

        private string actionTypes;
        /// <summary>
        /// 是否显示操作类型
        /// 0或空表示不能进行修改
        /// 1表示可以进行附件的修改
        /// </summary>
        public string ActionType { get { return actionTypes; } set { actionTypes = value; } }

        private string roleNumss;
        /// <summary>
        /// 设置一定的权限控制
        /// </summary>
        public string RoleNums { get { return roleNumss; } set { roleNumss = value; } }

        private string member_ID;
        /// <summary>
        /// 会员编号
        /// </summary>
        public string Member_ID { get { return member_ID; } set { member_ID = value; } }

        private string roleLevel;
        /// <summary>
        /// 会员级别
        /// 查看权限
        /// 1表示一般会员，只能查看自己上传的附件信息
        /// 其他表示没有对附件的限制查看
        /// </summary>
        public string RoleLevel { get { return roleLevel; } set { roleLevel = value; } }
        private string isDel;
        /// <summary>
        /// 是否有删除权限
        /// </summary>
        public string IsDel
        {
            get { return isDel; }
            set { isDel = value; }
        }
        private string relatePath;
        /// <summary>
        /// 相对路径
        /// 页面相对引用文件而言
        /// </summary>
        public string RelatePath
        {
            get { return relatePath; }
            set { relatePath = value; }
        }
        /// <summary>
        /// 会员名称
        /// </summary>
        private string member_NAME;
        public string Member_NAME { get { return member_NAME; } set { member_NAME = value; } }
        /// <summary>
        /// 文件保存的路径
        /// 相对一般处理程序而言的
        /// </summary>
        private string filePath;
        public string FilePath { get { return filePath; } set { filePath = value; } }
        /// <summary>
        /// 域名
        /// </summary>
        private string hostUrl;
        public string HostUrl { get { return hostUrl; } set { hostUrl = value; } }
        /// <summary>
        /// 附件是否有说明
        /// 属于哪个模块
        /// </summary>
        private string hasModuleName;
        public string HasModuleName { get { return hasModuleName; } set { hasModuleName = value; } }

        private string isLookFile;
        public string IsLookFile { get { return isLookFile; } set { isLookFile = value; } }
        /// <summary>
        /// 附件保存的文件夹名称
        /// </summary>
        private string filePathName;
        public string FilePathName { get { return filePathName; } set { filePathName = value; } }
        /// <summary>
        /// 是否有文件夹类型的选择
        /// </summary>
        private string hasFilePathName;
        public string HasFilePathName { get { return hasFilePathName; } set { hasFilePathName = value; } }
        /// <summary>
        /// 是否重新加载
        /// </summary>
        private string isReLoad;
        public string IsReLoad { get { return isReLoad; } set { isReLoad = value; } }

        private string pathValue;
        public string PathValue { get { return pathValue; } set { pathValue = value; } }

        /// <summary>
        /// 回收站的路径
        /// 相对当前页面
        /// </summary>
        private string callBackPath;
        public string CallBackPath { get { return callBackPath; } set { callBackPath = value; } }

        int pageSize = 10;
        int total = 0;
        int pageIndexs = 1;
        protected void Page_Load(object sender, EventArgs e)
        {
            HtmlHead head = this.Page.Header;
            if (head != null)
            {
                //css文件的动态引用
                string cssUrl = this.Page.ClientScript.GetWebResourceUrl(typeof(XSL_HANDLER.LoadCss), "XSL_HANDLER.indexStyle.css");
                HtmlLink link = new HtmlLink();
                link.Href = cssUrl;
                link.Attributes.Add("rel", "stylesheet");
                link.Attributes.Add("type", "text/css");
                this.Page.Header.Controls.Add(link);

                // 引入js文件
                string jQueryUrl = this.Page.ClientScript.GetWebResourceUrl(typeof(XSL_HANDLER.JQuerys_Mini), "XSL_HANDLER.jquerys.js");
                HtmlGenericControl scriptControl0 = new HtmlGenericControl("script");
                scriptControl0.Attributes.Add("type", "text/javascript");
                scriptControl0.Attributes.Add("language", "JavaScript");
                scriptControl0.Attributes.Add("src", jQueryUrl);
                this.Page.Header.Controls.AddAt(0, scriptControl0);

                string swfUrl = this.Page.ClientScript.GetWebResourceUrl(typeof(XSL_HANDLER.Swfupload), "XSL_HANDLER.swfupload.js");
                HtmlGenericControl scriptControl1 = new HtmlGenericControl("script");
                scriptControl1.Attributes.Add("type", "text/javascript");
                scriptControl1.Attributes.Add("language", "JavaScript");
                scriptControl1.Attributes.Add("src", swfUrl);
                this.Page.Header.Controls.AddAt(1, scriptControl1);

                string handleUrl = this.Page.ClientScript.GetWebResourceUrl(typeof(XSL_HANDLER.Handler), "XSL_HANDLER.handler.js");
                HtmlGenericControl scriptControl = new HtmlGenericControl("script");
                scriptControl.Attributes.Add("type", "text/javascript");
                scriptControl.Attributes.Add("language", "JavaScript");
                scriptControl.Attributes.Add("src", handleUrl);
                this.Page.Header.Controls.AddAt(2, scriptControl);

                string libraryUrl = this.Page.ClientScript.GetWebResourceUrl(typeof(XSL_HANDLER.Library), "XSL_HANDLER.library.js");
                HtmlGenericControl scriptControl2 = new HtmlGenericControl("script");
                scriptControl2.Attributes.Add("type", "text/javascript");
                scriptControl2.Attributes.Add("language", "JavaScript");
                scriptControl2.Attributes.Add("src", libraryUrl);
                this.Page.Header.Controls.AddAt(3, scriptControl2);

                string calendarUrl = this.Page.ClientScript.GetWebResourceUrl(typeof(XSL_HANDLER.Calendar), "XSL_HANDLER.calendar.js");
                HtmlGenericControl scriptControl3 = new HtmlGenericControl("script");
                scriptControl3.Attributes.Add("type", "text/javascript");
                scriptControl3.Attributes.Add("language", "JavaScript");
                scriptControl3.Attributes.Add("src", calendarUrl);
                this.Page.Header.Controls.AddAt(4, scriptControl3);
            }

            this.pageUrlID.Value = url;
            this.fileTypesID.Value = FileType;
            this.discraptionID.Value = FileDiscraption;
            this.sessionMemberID.Value = Member_ID;
            this.relatePathsID.Value = RelatePath;
            this.member_NameID.Value = Member_NAME;
            this.filePathID.Value = FilePath;
            this.hostUrlID.Value = hostUrl;
            if (!IsPostBack)
            {
                dt = StringToTable(this.FilePathName);
                fileTypeListID.DataSource = dt;
                fileTypeListID.DataTextField = "Name";
                fileTypeListID.DataValueField = "Value";
                fileTypeListID.DataBind();

                this.searchTypeID.DataSource = dt;
                this.searchTypeID.DataTextField = "Name";
                this.searchTypeID.DataValueField = "Value";
                this.searchTypeID.DataBind();

                string action = Request.Params["action"];
                string ids = Request.Params["IDS"];
                if (action != null && ids != null)
                {
                    GetData(1);
                    DeleteData(ids);
                }
                else
                {
                    DataBindBase(1);
                }
            }
        }
        DataTable dt = null;
        private DataTable StringToTable(string p)
        {
            dt = new DataTable();
            dt.Columns.Add("Name");
            dt.Columns.Add("Value");
            if (this.HasFilePathName == "true")
            {
                dt.Rows.Add(new object[] { "请选择", "" });
            }
            if (!string.IsNullOrEmpty(p))
            {
                string[] keyWords = p.Split(';');
                for (int i = 0; i < keyWords.Length; i++)
                {
                    string[] keys = keyWords[i].Split(',');
                    dt.Rows.Add(new object[] { keys[1], keys[0] + "\\" + keys[1] });
                }
            }
            return dt;
        }
        /// <summary>
        /// 删除数据
        /// </summary>
        /// <param name="id"></param>
        private void DeleteData(string id)
        {
            if (id != "")
            {
                string[] ids = id.Split('|');
                if (fileList.Count > 0)
                {
                    for (int i = 0; i < ids.Length; i++)
                    {
                        FileModel model = fileList.Find(t => t.Id == ids[i]);
                        if (model != null)
                        {
                            string targetPath = "";
                            if (model.Paths.IndexOf(':') == -1)
                            {
                                targetPath = this.Page.Server.MapPath(model.Paths);
                            }
                            else
                            {
                                targetPath = model.Paths;
                            }
                            if (File.Exists(targetPath))
                            {
                                DeleteFiles(targetPath);

                            }
                        }
                    }
                }
                Response.Write("true");
            }
        }
        /// <summary>
        /// 将文件夹下的附件移到回收站中
        /// </summary>
        /// <param name="p"></param>
        private void DeleteFiles(string p)
        {
            if (File.Exists(p))
            {
                string targetPath = "";
                if (string.IsNullOrEmpty(this.CallBackPath))
                {
                    targetPath = this.Page.Server.MapPath(RelatePath + "SwfFileUpload_Pro/CallBackFiles/");
                }
                else
                {
                    targetPath = this.Page.Server.MapPath(this.CallBackPath + "CallBackFiles/");
                }
                Directory.CreateDirectory(targetPath);
                FileInfo fi = new FileInfo(p);

                fi.CopyTo(targetPath + Path.GetFileName(p), true);
                if (File.Exists(p))
                {
                    File.Delete(p);
                }
            }
        }
        /// <summary>
        /// 获取当前页面的数据
        /// </summary>
        /// <param name="pageIndex"></param>
        /// <returns></returns>
        public void GetData(int pageIndex)
        {

            string fileTypes = this.searchTypeID.SelectedValue.Trim();

            fileList = GetFileModelList(fileTypes);

            if (fileList.Count < pageIndex * pageSize)
            {
                for (int i = pageSize * (pageIndex - 1); i < fileList.Count; i++)
                {
                    targetList.Add(fileList[i]);
                }
            }
            else
            {
                for (int i = pageSize * (pageIndex - 1); i < pageSize * pageIndex; i++)
                {
                    targetList.Add(fileList[i]);
                }
            }
        }
        List<FileModel> fileList = new List<FileModel>();
        List<FileModel> targetList = new List<FileModel>();
        /// <summary>
        /// 绑定数据
        /// </summary>
        /// <param name="pageIndex"></param>
        public void DataBindBase(int pageIndex)
        {
            dt = null;
            StringToTable(this.FilePathName);
            GetData(pageIndex);
            total = fileList.Count;

            DGShow.DataSource = targetList;
            DGShow.DataBind();
            //ds.Clear();
            ShowStats(pageIndex);
        }
        /// <summary>
        /// 获取数据
        /// </summary>
        /// <param name="files"></param>
        /// <returns></returns>
        private List<FileModel> GetFileModelList(string selectValue)
        {
            if (string.IsNullOrEmpty(selectValue))
            {
                if (dt.Rows.Count > 0)
                {
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        if (string.IsNullOrEmpty(dt.Rows[i]["Value"].ToString()))
                        {
                            continue;
                        }
                        GetFileModel(dt.Rows[i]["Value"].ToString());
                    }
                }
            }
            else
            {
                GetFileModel(selectValue);
            }
            fileList.Sort(new SortModel());
            return fileList;
        }
        private void GetFileModel(string p)
        {
            string targetPath = "";
            if (p.IndexOf(':') == -1)
            {

                //targetPath = this.Page.Server.MapPath(this.RelatePath + "SwfFileUpload_Web/upFile" + p);
                targetPath = this.Page.Server.MapPath(p);

                if (!Directory.Exists(targetPath))
                {
                    Directory.CreateDirectory(targetPath);
                }
            }
            else
            {
                targetPath = p;
                if (!Directory.Exists(targetPath))
                {
                    Directory.CreateDirectory(targetPath);
                }
            }
            string[] namePaths = Directory.GetFiles(targetPath);
            string filterNames = this.AnnexNameID.Text;
            DateTime fileterDate = new DateTime();

            for (int j = 0; j < namePaths.Length; j++)
            {
                FileModel model = new FileModel();
                FileInfo fi = new FileInfo(namePaths[j]);
                string[] strs = fi.Name.Split('-');
                if (this.Member_ID == strs[0] || this.Member_NAME == "管理员")
                {
                    if (this.upFileDateID.Text.Trim() != "")
                        fileterDate = Convert.ToDateTime(this.upFileDateID.Text);

                    model.MemberName = this.Member_NAME;
                    model.MemberID = strs[0];
                    model.Id = strs[1];
                    model.CreateTime = fi.CreationTime;
                    model.Name = strs[2];
                    model.Paths = ConvertSpecifiedPathToRelativePath(namePaths[j]);
                    model.FileType = p.Split('\\')[p.Split('\\').Length - 1];

                    if (filterNames != "")
                    {
                        if (model.Name.ToLower().IndexOf(filterNames.ToLower()) == -1)
                        {
                            continue;
                        }
                    }
                    if (fileterDate > model.CreateTime)
                    {
                        continue;
                    }
                    fileList.Add(model);
                }
            }
        }
        /// <summary>
        /// 格式化日期格式的数据
        /// </summary>
        /// <param name="dt"></param>
        /// <returns></returns>
        static string FormatDates(string dt)
        {
            string[] times = dt.Split('-');
            string years = times[0];
            int months = Convert.ToInt32(times[1]);
            int days = Convert.ToInt32(times[2]);
            string targetTimes = years + "/";
            if (months < 10)
            {
                targetTimes += "0" + months + "/";
            }
            else
            {
                targetTimes += months + "/";
            }
            if (days < 10)
            {
                targetTimes += "0" + days;
            }
            else
            {
                targetTimes += days;
            }
            return targetTimes;
        }
        /// <summary>
        /// 处理显示过长的字段
        /// </summary>
        /// <param name="strs"></param>
        /// <returns></returns>
        public static string CutStrs(object strs)
        {
            string str = "";
            if (strs != null)
            {
                str = strs.ToString();
                if (str.Length > 20)
                {
                    str = str.Substring(0, 20) + "...";
                }
            }
            return str;
        }
        /// </summary>
        /// <param name="page">当前页面指针，一般为this</param>
        /// <param name="specifiedPath">绝对路径</param>
        /// <returns>虚拟路径, 型如: ~/</returns>
        public static string ConvertSpecifiedPathToRelativePath(string specifiedPath)
        {

            string virtualPath = HttpContext.Current.Request.ApplicationPath;
            string pathRooted = HostingEnvironment.MapPath(virtualPath);
            if (!Path.IsPathRooted(specifiedPath) || specifiedPath.IndexOf(pathRooted) == -1)
            {
                return specifiedPath;
            }
            if (pathRooted.Substring(pathRooted.Length - 1, 1) == "\\")
            {
                specifiedPath = specifiedPath.Replace(pathRooted, "");
            }
            else
            {
                specifiedPath = specifiedPath.Replace(pathRooted, "");
            }
            string relativePath = virtualPath + specifiedPath.Replace("\\", "/");
            return relativePath;
        }
        /// <summary>
        /// 显示分页条
        /// </summary>
        /// <param name="pageIndex"></param>
        private void ShowStats(int pageIndex)
        {
            lblCurrentIndex.Text = "第 " + (pageIndex).ToString() + " 页";
            int page = total / pageSize;
            int x = total % pageSize;
            if (x > 0)
            {
                page = page + 1;
            }

            lblPageCount.Text = "总共 " + page.ToString() + " 页";
        }
        /// <summary>
        /// 将上传的附件的路径值付给Values
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void pathValues_ServerChanges(object sender, EventArgs e)
        {
            this.PathValue = this.pathValuesID.Value;
        }
        protected void search_Click(object sender, EventArgs e)
        {
            DataBindBase(1);
        }

        protected void delete_Click(object sender, EventArgs e)
        {
            //DataBindBase(1);
        }

        protected void btnFirst_Click(object sender, EventArgs e)
        {
            DataBindBase(1);
        }

        protected void btnPrev_Click(object sender, EventArgs e)
        {
            pageIndexs = int.Parse(lblCurrentIndex.Text.Replace("第", "").Replace("页", ""));

            if (pageIndexs > 1)
            {
                pageIndexs = pageIndexs - 1;
            }
            else
            {
                pageIndexs = 1;
            }
            DataBindBase(pageIndexs);
        }

        protected void btnNext_Click(object sender, EventArgs e)
        {
            pageIndexs = int.Parse(lblCurrentIndex.Text.Replace("第", "").Replace("页", ""));
            int pageCount = int.Parse(lblPageCount.Text.Replace("总共", "").Replace("页", ""));
            if (pageIndexs < pageCount)
            {
                pageIndexs = pageIndexs + 1;
            }
            else
            {
                pageIndexs = pageCount;
            }
            DataBindBase(pageIndexs);
        }

        protected void btnLast_Click(object sender, EventArgs e)
        {
            int pageCount = int.Parse(lblPageCount.Text.Replace("总共", "").Replace("页", ""));
            DataBindBase(pageCount);
        }
    }
}