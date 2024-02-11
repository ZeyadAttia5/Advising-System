<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdvisorLogin.aspx.cs" Inherits="project.AdvisorLogin" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            Please Log In
        </div>
        <p>
            Username:</p>
        <p>
            <asp:TextBox ID="username" runat="server" ></asp:TextBox>
        </p>
        <p>
            Password:</p>
        <p>
            <asp:TextBox ID="password" runat="server" ></asp:TextBox>
        </p>
        <p>
            <asp:Button ID="signin" runat="server" onClick="login" Text="Log In" />
            <asp:Button ID="registration" runat="server" OnClick="advisorregistration" Text="Register" />
        </p>
    </form>
</body>
</html>

