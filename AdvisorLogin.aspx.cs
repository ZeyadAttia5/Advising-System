using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Windows.Input;

namespace project
{
    public partial class AdvisorLogin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void login(object sender, EventArgs e)
        {

            string connstr = WebConfigurationManager.ConnectionStrings["project"].ToString();
            SqlConnection conn = new SqlConnection(connstr);
            int id = Int16.Parse(username.Text);
            String pass = password.Text;
            conn.Open();

            SqlCommand cmd = new SqlCommand("FN_AdvisorLogin", conn);
            cmd.CommandType = CommandType.StoredProcedure;



            cmd.Parameters.AddWithValue("@advisor_id", id);
            cmd.Parameters.AddWithValue("@password", pass);




            cmd.ExecuteNonQuery();
            Session["ID"] = id;
            Response.Redirect("advisor_WebForm2.aspx");
            conn.Close();


        }


        protected void advisorregistration(object sender, EventArgs e)
        {
            Response.Redirect("advisor_WebForm3.aspx");
        }


    }




}