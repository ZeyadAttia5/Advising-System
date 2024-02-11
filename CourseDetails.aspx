<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CourseDetails.aspx.cs" Inherits="project.CourseDetails" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
             <h2>Course Details</h2>
            <asp:Label ID="lblCourseID" runat="server" Text=""></asp:Label><br />
            <asp:Label ID="lblCourseName" runat="server" Text=""></asp:Label><br />
            <asp:Label ID="lblMajor" runat="server" Text=""></asp:Label><br />
            <asp:Label ID="lblIsOffered" runat="server" Text=""></asp:Label><br />
            <asp:Label ID="lblCreditHours" runat="server" Text=""></asp:Label><br />
            <asp:Label ID="lblSemester" runat="server" Text=""></asp:Label><br />
            <asp:Button ID="btnBack" runat="server" Text="Back to Courses" OnClick="btnBack_Click" />
            <asp:Button ID="btnDeleteCourse" runat="server" Text="Delete Course" OnClick="btnDeleteCourse_Click" />
            <asp:Button ID="btnViewSlots" runat="server" Text="View Slots" OnClick="btnViewSlots_Click" />
            <asp:Button ID="btnViewMakeups" runat="server" Text="View Makeups" OnClick="btnViewMakeups_Click" />


        </div>
        <p>
            <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="Green" Visible="false"></asp:Label>

        </p>
             <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="True" Visible="false">
            </asp:GridView>
    <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="True" Visible="false">
    </asp:GridView>
        
        <p>
    <asp:TextBox ID="txtMakeupDate" runat="server" Visible="false" />
    <asp:DropDownList ID="ddlMakeupType" runat="server" placeholder="MM/dd/yyyy" Visible="false">
    <asp:ListItem Text="First Makeup" Value="FirstMakeup" />
    <asp:ListItem Text="Second Makeup" Value="SecondMakeup" />
    </asp:DropDownList>

        </p>

        <p>
        <asp:Button ID="btnAddMakeup" runat="server" Text="Add Makeup" OnClick="btnAddMakeup_Click" Visible="false" />

        </p>

        <p>
        <asp:Label ID="lblError" runat="server" ForeColor="Red" Visible="false"></asp:Label>

        </p>
        <asp:Label ID="Label1" runat="server" Text=""></asp:Label>
            <asp:TextBox ID="txtSemester" runat="server" placeholder="Enter current semester" ValidationGroup="SemesterValidation"></asp:TextBox>
            <asp:Button ID="btnDeleteSlots" runat="server" Text="Delete Slots" OnClick="btnDeleteSlots_Click" ValidationGroup="SemesterValidation" />
        <p>

            <asp:Label ID="lblDeleteSlotsResult" runat="server" Text=""></asp:Label>

        </p>

    </form>
</body>
</html>
