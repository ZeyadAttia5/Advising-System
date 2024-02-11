<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="course.aspx.cs" Inherits="WebApplication4.course" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div class="Container">
            <h1>Requests Page</h1>
            <div>
                <asp:DropDownList ID="DropDownList1" runat="server" OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged" AutoPostBack="true">
                </asp:DropDownList>
            </div>
            <div>&nbsp;</div>
            <div>&nbsp;</div>
            <div>&nbsp;<asp:Label ID="credit_course" runat="server" Text="label" Visible="False"></asp:Label></div>
            <div>&nbsp;<asp:TextBox ID="value" runat="server" Visible="False"></asp:TextBox></div>
            <div>
                <asp:Label ID="comment_label" runat="server" Text="Comment" Visible="False"></asp:Label>
            </div>
            <div>&nbsp;<asp:TextBox ID="comment" runat="server" Visible="False"></asp:TextBox></div>
            <div>&nbsp;</div>
            <div>&nbsp;<asp:Button ID="Button1" runat="server" Text="Submit Request" Visible="False" OnClick="submit" /></div>
        </div>
    </form>
</body>
</html>
