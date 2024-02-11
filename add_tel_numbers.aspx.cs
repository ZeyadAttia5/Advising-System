using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication4
{
    public partial class add_tel_numbers : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            string connectString = WebConfigurationManager.ConnectionStrings["project"].ToString();
            SqlConnection conn = new SqlConnection(connectString);
            string number = TextBox1.Text;
            SqlCommand add = new SqlCommand("Procedures_StudentaddMobile", conn);
            add.CommandType = CommandType.StoredProcedure;
            add.Parameters.Add(new SqlParameter("@StudentID", SqlDbType.Int)).Value = Session["user"];
            add.Parameters.Add(new SqlParameter("@mobile_number", SqlDbType.VarChar, 40)).Value = number;
            conn.Open();
            try
            {
                add.ExecuteNonQuery();
                Response.Write("Student number: " + number);
            }
            catch (Exception ex)
            {
                Response.Write("This number already exists in the System");
            }
            conn.Close();

        }
    }
}