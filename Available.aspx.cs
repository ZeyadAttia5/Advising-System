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
    public partial class Available : System.Web.UI.Page
    {
        protected void viewAvailable(object sender, EventArgs e)
        {
            string connectString = WebConfigurationManager.ConnectionStrings["project"].ToString();
            SqlConnection conn = new SqlConnection(connectString);

            string semesterCode = sem_code.Text;


            string returnValue = "SELECT * FROM dbo.FN_SemsterAvailableCourses(@Current_semester_code)";
            SqlDataAdapter adapter = new SqlDataAdapter(returnValue, conn);
            adapter.SelectCommand.Parameters.Add(new SqlParameter("@Current_semester_code", SqlDbType.VarChar, 40)).Value = semesterCode;

            DataTable dataTable = new DataTable();
            adapter.Fill(dataTable);

            GridView1.DataSource = dataTable;
            GridView1.DataBind();
        }
    }
}