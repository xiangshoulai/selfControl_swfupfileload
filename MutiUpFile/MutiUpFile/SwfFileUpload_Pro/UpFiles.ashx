<%@ WebHandler Language="C#" Class="UpFiles" %>

using System;
using System.Web;

public class UpFiles : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        HttpPostedFile filePost = HttpContext.Current.Request.Files["Filedata"];//获取上传的文件

        string member_ID = HttpContext.Current.Request.Params["member_ID"];
        string member_Name = HttpContext.Current.Request.Params["member_NAME"];
        //string isUpFile = HttpContext.Current.Request.Params["isUpFile"];
        string filePath = HttpContext.Current.Request.Params["filePath"];//文件保存的路径
        string fileID = HttpContext.Current.Request.Params["fileID"];
        //string hostUrl = HttpContext.Current.Request.Params["hostUrl"];
        string moduleName = HttpContext.Current.Request.Params["moduleName"];
        //string remark = HttpContext.Current.Request.Params["remark"];

        string fileName = System.IO.Path.GetFileName(filePost.FileName);//获取上传文件的名称.
        //string fileExtions = Path.GetExtension(fileName);//获取文件的扩展名

        DateTime now = DateTime.Now;//获取当前日期时间
        string dirName = "";
        if (string.IsNullOrEmpty(moduleName))
        {
            moduleName = "其他";
            dirName = filePath + moduleName + "/";
        }
        else
        {
            dirName = moduleName + "/";
        }
        //string md5Name = CTG.Common.Commonfunction.GetStreamMD5(filePost.InputStream);
       
        string upFileName = dirName + member_ID+"-"+now.Ticks +"-"+ fileName;//对上传文件进行MD5计算，区分每个文件
        string fullPath = "";//获取文件的绝对路径
        if (upFileName.IndexOf(':') == -1)
        {
            fullPath = context.Server.MapPath(filePath+upFileName);
        }
        else
        {
            fullPath = upFileName;
        }

        System.IO.Directory.CreateDirectory(System.IO.Path.GetDirectoryName(fullPath));//创建目录
        filePost.SaveAs(fullPath);//保存文件
        context.Response.Write(fullPath);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}