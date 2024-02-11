using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication4
{
    public partial class advisor_WebForm3 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void registeradvisor(object sender, EventArgs args)
        {
            string connectString = WebConfigurationManager.ConnectionStrings["project"].ToString();
            SqlConnection conn = new SqlConnection(connectString);


            String advisorname = advname.Text;
            String pass = password.Text;
            String advemail = email.Text;
            String advoffice = office.Text;

            int advisorId = 0;


            SqlCommand advregister = new SqlCommand("Procedures_AdvisorRegistration", conn);


            advregister.CommandType = System.Data.CommandType.StoredProcedure;

            advregister.Parameters.Add(new SqlParameter("@advisor_name", System.Data.SqlDbType.VarChar, 40)).Value = advisorname;
            advregister.Parameters.Add(new SqlParameter("@password", System.Data.SqlDbType.VarChar, 40)).Value = pass;
            advregister.Parameters.Add(new SqlParameter("@email", System.Data.SqlDbType.VarChar, 40)).Value = advemail;
            advregister.Parameters.Add(new SqlParameter("@office", System.Data.SqlDbType.VarChar, 40)).Value = advoffice;


            SqlParameter advid = advregister.Parameters.Add("@Advisor_id", System.Data.SqlDbType.Int);

            advid.Direction = System.Data.ParameterDirection.Output;

            conn.Open();
            int count = advregister.ExecuteNonQuery();
            conn.Close();
            if (count > 0)
            {
                advisorId = Convert.ToInt32(advid.Value);
                Response.Write("Account Created Successfully");

            }
            else
            {
                Response.Write("Something went wrong");
            }
            Response.Redirect("advisor_WebForm2.aspx");
        }




    }
}