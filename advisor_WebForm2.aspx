<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="advisor_WebForm2.aspx.cs" Inherits="WebApplication4.advisor_WebForm2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            Advisor Page</div>
        <p>
            <asp:Label ID="Label11" runat="server" Text="Major:"></asp:Label>
        <asp:TextBox ID="major" runat="server"></asp:TextBox>
        </p>
        <p>
            <asp:Button ID="view1" runat="server" OnClick ="viewadvisingstudents" Text="View your advising students" />
            <asp:Button ID="view13" runat="server" OnClick="advisingstudents" Text ="View all his/her advising students" />
            <asp:GridView ID="GridView1" runat="server">
            </asp:GridView>
            <asp:Button ID="view2" runat="server" OnClick="viewallrequests" Text="View all Requests" />
        <asp:Button ID="view3" runat="server" OnClick="viewallpendingrequests" Text="View all pending requests" />
        </p>
        <asp:Label ID="Label8" runat="server" Text="Requst ID:"></asp:Label>
        <asp:TextBox ID="requestid" runat="server"></asp:TextBox>
        <asp:Label ID="Label9" runat="server" Text="Semester Code"></asp:Label>
        <asp:TextBox ID="semestercode" runat="server" ></asp:TextBox>
        <p>
            <asp:Button ID="view8" runat="server" OnClick="accpectrejectCHR" Text="Approve reject extra credit hours request." />
            <asp:Button ID="view5" runat="server" OnClick="accecptrejectextracourserequest" Text="Approve reject extra courses request." />
        </p>
        <p>
            <asp:Label ID="Label4" runat="server" Text="Student ID:"></asp:Label>
            <asp:TextBox ID="studentid" runat="server" ></asp:TextBox>
            <asp:Label ID="Label5" runat="server" Text="Semester Code:"></asp:Label>
            <asp:TextBox ID="semcode" runat="server"></asp:TextBox>
            <asp:Label ID="Label6" runat="server" Text="Course ID:"></asp:Label>
            <asp:TextBox ID="courseid" runat="server"></asp:TextBox>
            <asp:Label ID="Label7" runat="server" Text="Course Name:"></asp:Label>
            <asp:TextBox ID="coursename" runat="server"></asp:TextBox>
        </p>
        <p>
            <asp:Button ID="view6" runat="server" OnClick="deletecourse" Text="Delete course from a certain graduation plan in a certain semester" />
            <asp:Button ID="view11" runat="server" OnClick="insertcourse" Text="Insert courses for a specific graduation plan" />
        </p>
        <p>
            <asp:Label ID="Label2" runat="server" Text="Expected Date:"></asp:Label>
            <asp:TextBox ID="expecteddate" runat="server"></asp:TextBox>
            <asp:Label ID="Label3" runat="server" Text="Student Id: "></asp:Label>
            <asp:TextBox ID="studentsid" runat="server"></asp:TextBox>
        </p>
        <p>
        <asp:Button ID="view9" runat="server" OnClick="updatedate" Text="Update expected graduation date in a certain graduation plan.
" />
        </p>
        <p>
            &nbsp;</p>
        <p>
            <asp:Label ID="Label12" runat="server" Text="Semester Code:"></asp:Label>
            <asp:TextBox ID="semcode1" runat="server"></asp:TextBox>
            <asp:Label ID="Label13" runat="server" Text="Expected Date:"></asp:Label>
            <asp:TextBox  ID="expdate" runat="server"></asp:TextBox>
            <asp:Label ID="Label14" runat="server" Text="Smester Credit Hours:"></asp:Label>
            <asp:TextBox ID="semch" runat="server"></asp:TextBox>
            <asp:Label ID="Label16" runat="server" Text="Student ID:"></asp:Label>
            <asp:TextBox ID="studentid2" runat="server"></asp:TextBox>
        </p>
        <p>
        <asp:Button ID="view12" runat="server" OnClick="insertGP" Text=" Insert graduation plan for a certain student" />
        </p>
    </form>
</body>
</html>