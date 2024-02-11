<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="advisor_WebForm3.aspx.cs" Inherits="WebApplication4.advisor_WebForm3" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Label ID="Label1" runat="server" Text="Register as Advisor"></asp:Label>
        </div>
        <asp:Label ID="Label2" runat="server" Text="Advisor name"></asp:Label>
        <asp:TextBox ID="advname" runat="server"></asp:TextBox>
        <p>
            <asp:Label ID="Label3" runat="server" Text="password:"></asp:Label>
            <asp:TextBox ID="password" runat="server"></asp:TextBox>
        </p>
        <p>
            <asp:Label ID="Label4" runat="server" Text="email"></asp:Label>
            <asp:TextBox ID="email" runat="server"></asp:TextBox>
        </p>
        <asp:Label ID="Label5" runat="server" Text="office"></asp:Label>
        <asp:TextBox ID="office" runat="server"></asp:TextBox>
        <p>
            <asp:Button ID="signup" runat="server" OnClick="registeradvisor" Text="Register" />
        </p>
    </form>
</body>
</html>