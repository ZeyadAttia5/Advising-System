using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace project
{
    public partial class login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            BindCoursesData();

        }

        protected void TextBox1_TextChanged(object sender, EventArgs e)
        {

        }

        protected void Login(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["project"].ToString();
            SqlConnection conn = new SqlConnection(connStr);
        }

        private void BindCoursesData()
        {
            string connectionString = WebConfigurationManager.ConnectionStrings["project"].ToString();
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM Course";
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    connection.Open();
                    SqlDataAdapter adapter = new SqlDataAdapter(command);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);
                    GridView1.DataSource = dt;
                    GridView1.DataBind();
                    ddlCourses.DataSource = dt;
                    ddlCourses.DataTextField = "name";
                    ddlCourses.DataValueField = "course_id";
                    ddlCourses.DataBind();

                }
            }
            ddlCourses.SelectedIndexChanged += ddlCourses_SelectedIndexChanged;

            ddlCourses.AutoPostBack = true;

        }
        protected void ddlCourses_SelectedIndexChanged(object sender, EventArgs e)
        {
            
            string selectedCourseID = ddlCourses.SelectedValue;

            
            Response.Redirect($"CourseDetails.aspx?CourseID={selectedCourseID}");
        }

        protected void btnAddNewCourse_Click(object sender, EventArgs e)
        {
            
            divNewCourse.Visible = true;
        }

        protected void btnConfirmNewCourse_Click(object sender, EventArgs e)
        {
            
            string newName = txtNewCourseName.Text;
            string newMajor = txtNewCourseMajor.Text;
            int newCreditHours = Convert.ToInt32(txtNewCourseCreditHours.Text);
            int newSemester = Convert.ToInt32(txtNewCourseSemester.Text);

            
            string connectionString = WebConfigurationManager.ConnectionStrings["project"].ToString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                using (SqlCommand command = new SqlCommand("INSERT INTO Course (name, major, is_offered, credit_hours, semester) VALUES (@name, @major, 1, @creditHours, @semester)", connection))
                {
                    command.Parameters.AddWithValue("@name", newName);
                    command.Parameters.AddWithValue("@major", newMajor);
                    command.Parameters.AddWithValue("@creditHours", newCreditHours);
                    command.Parameters.AddWithValue("@semester", newSemester);

                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }

            
            divNewCourse.Visible = false;

            
        }

        protected void btnBackToHomepage_Click(object sender, EventArgs e)
        {
            Response.Redirect("adminPage.aspx");
        }
    }
}