using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MutiUpFile
{
    public partial class index : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            this.XVZ_UpFilesNoData1.Process_Status = "true";
            this.XVZ_UpFilesNoData1.IsCancel = "true";
            this.XVZ_UpFilesNoData1.IsStop = "true";
        }
    }
}