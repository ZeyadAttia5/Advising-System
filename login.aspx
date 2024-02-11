<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="project.login" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="True">
        </asp:GridView>
        <asp:DropDownList ID="ddlCourses" runat="server" AppendDataBoundItems="true" AutoPostBack="true" EnableViewState="true">
    <asp:ListItem Text="-- Select Course --" Value="" />
    </asp:DropDownList>
        <br/><br/>
        <asp:Button ID="btnAddNewCourse" runat="server" Text="Add New Course" OnClick="btnAddNewCourse_Click" />

<div id="divNewCourse" runat="server" visible="false">

    <label>Name:</label>
    <asp:TextBox ID="txtNewCourseName" runat="server"></asp:TextBox>
    <br />
    <label>Major:</label>
    <asp:TextBox ID="txtNewCourseMajor" runat="server"></asp:TextBox>
    <br />
    <label>Credit Hours:</label>
    <asp:TextBox ID="txtNewCourseCreditHours" runat="server"></asp:TextBox>
    <br />
    <label>Semester:</label>
    <asp:TextBox ID="txtNewCourseSemester" runat="server"></asp:TextBox>
    <br />
    <asp:Button ID="btnConfirmNewCourse" runat="server" Text="Confirm New Course" OnClick="btnConfirmNewCourse_Click" />
</div>


        <asp:Button ID="btn_back_to_homepage" runat="server" Text="Back to main page" OnClick="btnBackToHomepage_Click"/>


    </form>
</body>
</html>
