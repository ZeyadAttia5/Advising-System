<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="add_tel_numbers.aspx.cs" Inherits="WebApplication4.add_tel_numbers" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            ADD phone Number<br />
            <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox><br />
            <asp:Button ID="Button1" runat="server" Text="Add" OnClick="Button1_Click" Width="82px" />
        </div>
    </form>
</body>
</html>
