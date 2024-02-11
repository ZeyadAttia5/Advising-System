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
    public partial class course : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DropDownList1.Items.Add(new ListItem("Select an option", string.Empty));
                DropDownList1.Items.Add(new ListItem("Course Request", "1"));
                DropDownList1.Items.Add(new ListItem("Credit Hours Request", "2"));
            }
        }
        protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (DropDownList1.SelectedValue == "1")
            {
                credit_course.Text = "Course ID";
                credit_course.Visible = true;
                value.Visible = true;
                comment_label.Visible = true;
                comment.Visible = true;
                Button1.Visible = true;
            }
            else if (DropDownList1.SelectedValue == "2")
            {
                credit_course.Text = "Requested Hours";
                credit_course.Visible = true;
                value.Visible = true;
                comment_label.Visible = true;
                comment.Visible = true;
                Button1.Visible = true;
            }
            else
            {
                credit_course.Visible = false;
                value.Visible = false;
                comment_label.Visible = false;
                comment.Visible = false;
                Button1.Visible = false;
            }
        }

        protected void submit(object sender, EventArgs e)
        {
            string connectString = WebConfigurationManager.ConnectionStrings["project"].ToString();
            SqlConnection conn = new SqlConnection(connectString);
            if (DropDownList1.SelectedValue == "1")
            {
                int amount = Int16.Parse(value.Text);
                string type = DropDownList1.SelectedItem.ToString();
                string commenty = comment.Text;
                int student_id = Int16.Parse(Session["user"].ToString());
                SqlCommand requestProc = new SqlCommand("Procedures_StudentSendingCourseRequest", conn);
                requestProc.CommandType = CommandType.StoredProcedure;
                // Set parameters
                requestProc.Parameters.Add(new SqlParameter("@StudentID", SqlDbType.Int)).Value = student_id;
                requestProc.Parameters.Add(new SqlParameter("@courseID", SqlDbType.Int)).Value = amount;
                requestProc.Parameters.Add(new SqlParameter("@type", SqlDbType.VarChar, 40)).Value = type;
                requestProc.Parameters.Add(new SqlParameter("@comment", SqlDbType.VarChar, 40)).Value = commenty;

                // Open connection, execute stored procedure, and close connection
                conn.Open();
                int i = requestProc.ExecuteNonQuery();
                conn.Close();

                // Access the output parameter value
                if (i > 0)
                {
                    Response.Write("Success");
                }
                else
                {
                    Response.Write("error");
                }
            }
            if (DropDownList1.SelectedValue == "2")
            {
                int amount = Int16.Parse(value.Text);
                string type = DropDownList1.SelectedItem.ToString();
                string commenty = comment.Text;
                int student_id = Int16.Parse(Session["user"].ToString());
                SqlCommand requestProc = new SqlCommand("Procedures_StudentSendingCHRequest", conn);
                requestProc.CommandType = CommandType.StoredProcedure;
                // Set parameters
                requestProc.Parameters.Add(new SqlParameter("@StudentID", SqlDbType.Int)).Value = student_id;
                requestProc.Parameters.Add(new SqlParameter("@credit_hours", SqlDbType.Int)).Value = amount;
                requestProc.Parameters.Add(new SqlParameter("@type", SqlDbType.VarChar, 40)).Value = type;
                requestProc.Parameters.Add(new SqlParameter("@comment", SqlDbType.VarChar, 40)).Value = commenty;

                // Open connection, execute stored procedure, and close connection
                conn.Open();
                int i = requestProc.ExecuteNonQuery();
                conn.Close();

                // Access the output parameter value
                if (i > 0)
                {
                    Response.Write("Success");
                }
                else
                {
                    Response.Write("error");
                }
            }
        }
    }
}