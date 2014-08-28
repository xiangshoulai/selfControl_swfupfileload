using System;
using System.Collections.Generic;
using System.Web;

namespace UpFile.SwfFileUpload
{
    public class FileModel
    {
        private string id;
        private string name;
        private string paths;
        private string fileType;
        private DateTime createTime;
        private string memberID;
        private string memberName;

        public string MemberName
        {
            get { return memberName; }
            set { memberName = value; }
        }
        public string MemberID
        {
            get { return memberID; }
            set { memberID = value; }
        }
        public DateTime CreateTime
        {
            get { return createTime; }
            set { createTime = value; }
        }

        public string FileType
        {
            get { return fileType; }
            set { fileType = value; }
        }

        public string Paths
        {
            get { return paths; }
            set { paths = value; }
        }

        public string Name
        {
            get { return name; }
            set { name = value; }
        }

        public string Id
        {
            get { return id; }
            set { id = value; }
        }

    }
}