<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="adminPage.aspx.cs" Inherits="project.adminPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <p style="text-align: center; font-size: 50px">
                Admin Page
            </p>
        </div>

        <div style="margin-left: 40px; width: 621px; height: 353px;">
            <asp:Label ID="Label1" runat="server" Text="VIEW" Font-Size="30px"></asp:Label>

            <p style="margin-left: 40px">
                <asp:Button ID="btn_show_Advisors" runat="server" Text="Advisors" OnClick="btn_show_Advisors_Click" />
            </p>
            <p style="margin-left: 40px">
                <asp:Button ID="btn_show_StuAdv" runat="server" Text="Students Advisor" OnClick="btn_show_StuAdv_Click" />
            </p>
            <p style="margin-left: 40px">
                <asp:Button ID="btn_show_PendReq" runat="server" Text="Pending Requests" OnClick="btn_show_PendReq_Click" />
            </p>
            <p style="margin-left: 40px">
                <asp:Button ID="btn_show_SemCour" runat="server" Text="Semesters and Courses" OnClick="btn_show_SemCour_Click" />
            </p>
            <p style="margin-left: 40px">
                <asp:Button ID="btn_show_InstCour" runat="server" Text="Instructors and Their Assigned Courses" OnClick="btn_show_InstCour_Click" />
            </p>
            <p style="margin-left: 40px">
                <asp:Button ID="Clear_Table" runat="server" Text="Clear Table" OnClick="Clear_Table_Click" />
            </p>

        </div>

        <div style="margin-left: 40px; width: 79px; padding-top: 30px;">
            <asp:Label ID="Label2" runat="server" Text="ACTIONS" Font-Size="30px"></asp:Label>

            <p style="margin-left: 40px">
                <asp:Button ID="Button1" runat="server" Text=" Link a student to an advisor" OnClick="btn_link_student_advisor" Width="228px" />
            </p>
            <p style="margin-left: 40px">
                <asp:Button ID="Button2" runat="server" Text=" Link instructor to a course in a specific slot" OnClick="btn_link_instr_cour_slot" Width="328px" />
            </p>
            <p style="margin-left: 40px">
                <asp:Button ID="Button3" runat="server" Text=" Link a student to a course with a specific instructor" OnClick="btn_link_stud_cour_instr" Width="383px" />
            </p>
            <p style="margin-left: 40px">
                <asp:Button ID="Button4" runat="server" Text="Add a new semester" OnClick="btn_add_semester"/>
            </p>
            <p style="margin-left: 40px">
                <asp:Button ID="Button5" runat="server" Text="Manage courses" OnClick="btn_manage_courses"/>
            </p>
                
            <p style="margin-left: 40px">
                <asp:Button ID="Button6" runat="server" Text="Manage Finances" OnClick="btn_manage_finances"/>
            </p>
    
            <p style="margin-left: 40px">
                <asp:Button ID="Button7" runat="server" Text="Manage Students" OnClick="btn_manage_students"/>
            </p>
            <p style="margin-left: 40px">
               <asp:Button ID="Button10" runat="server" Text="Logout" OnClick="btn_logout"/>
            </p>

            <p style="margin-left: 40px">
                <asp:TextBox ID="studentID" runat="server" placeHolder="Enter student id" Visible="false"></asp:TextBox>
                <asp:TextBox ID="advisorID" runat="server" placeholder="Enter advisor id" Visible="false"></asp:TextBox>
                <asp:TextBox ID="courseID" runat="server" placeHolder="Enter course id" Visible="false"></asp:TextBox>
                <asp:TextBox ID="instructorID" runat="server" placeHolder="Enter instructor id" Visible="false"></asp:TextBox>
                <asp:TextBox ID="slotID" runat="server" placeHolder="Enter slot id" Visible="false"></asp:TextBox>
                <asp:TextBox ID="semesterCode" runat="server" placeHolder="Enter semester code" Visible="false"></asp:TextBox>
                <asp:TextBox ID="startDate" runat="server" placeholder="Enter start date" Visible="false" TextMode="Date"></asp:TextBox>
                <asp:TextBox ID="endDate" runat="server" placeholder="Enter end date" Visible="false" TextMode="Date"></asp:TextBox>
            </p>

        </div>
        <p style="height: 40px; width: 591px; margin-left: 80px; margin-bottom: 30px">
            <asp:PlaceHolder ID="viewMessages" runat="server"></asp:PlaceHolder>
        </p>
        <asp:GridView ID="AdminGridView" runat="server" CellPadding="4" ForeColor="#333333" GridLines="None" Style="text-align: center; display: table; margin-top: 30px; margin-left: auto; margin-right: auto; margin-bottom: 20px;">
            <AlternatingRowStyle BackColor="White" />
            <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
            <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="#FFCC66" ForeColor="#333333" HorizontalAlign="Center" />
            <RowStyle BackColor="#FFFBD6" ForeColor="#333333" />
            <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />
            <SortedAscendingCellStyle BackColor="#FDF5AC" />
            <SortedAscendingHeaderStyle BackColor="#4D0000" />
            <SortedDescendingCellStyle BackColor="#FCF6C0" />
            <SortedDescendingHeaderStyle BackColor="#820000" />
        </asp:GridView>
    </form>
</body>
</html>
