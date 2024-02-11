<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Available.aspx.cs" Inherits="WebApplication4.Available" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div class="Container">
            <h1>Available Courses Page</h1>
            <div>
                <asp:Label ID="Label1" runat="server" Text="Enter Your Semester Code:"></asp:Label>
            </div>
            <div>
                <asp:TextBox ID="sem_code" runat="server"></asp:TextBox>&nbsp;
            </div>
            <div>&nbsp;</div>
            <div>
                <asp:Button ID="Button1" runat="server" OnClick="viewAvailable" Text="View"  />
            </div>
            <div>&nbsp;</div>
            <div>
                <asp:GridView ID="GridView1" runat="server"></asp:GridView>
                &nbsp;
            </div>
        </div>
    </form>
</body>
</html>
