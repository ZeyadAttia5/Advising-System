using System;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Web.Configuration;
using System.Web.UI.WebControls;

namespace project   
{
    public partial class CourseDetails : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if the CourseID is present in the query string
                if (Request.QueryString["CourseID"] != null)
                {
                    // Retrieve the selected CourseID
                    string selectedCourseID = Request.QueryString["CourseID"];

                    // Fetch and display course details
                    DisplayCourseDetails(selectedCourseID);
                }
                txtMakeupDate.Attributes["placeholder"] = "MM/dd/yyyy";
            }
        }

        private void DisplayCourseDetails(string courseID)
        {
            string connectionString = WebConfigurationManager.ConnectionStrings["project"].ToString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM Course WHERE course_id = @CourseID";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@CourseID", courseID);
                    connection.Open();

                    SqlDataReader reader = command.ExecuteReader();

                    if (reader.Read())
                    {
                        lblCourseID.Text = $"Course ID: {reader["course_id"]}";
                        lblCourseName.Text = $"Course Name: {reader["name"]}";
                        lblMajor.Text = $"Major: {reader["major"]}";
                        lblIsOffered.Text = $"Is Offered: {(bool)reader["is_offered"]}";
                        lblCreditHours.Text = $"Credit Hours: {reader["credit_hours"]}";
                        lblSemester.Text = $"Semester: {reader["semester"]}";
                    }
                }
            }
        }



        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("Login.aspx");
        }

        protected void btnDeleteCourse_Click(object sender, EventArgs e)
        {
            string courseIDLabel = lblCourseID.Text;
            string selectedCourseID = GetNumericPart(courseIDLabel);

            string connectionString = WebConfigurationManager.ConnectionStrings["project"].ToString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                using (SqlCommand command = new SqlCommand("Procedures_AdminDeleteCourse", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add(new SqlParameter("@courseID", selectedCourseID));
                    try
                    {
                        command.ExecuteNonQuery();
                        lblSuccessMessage.Text = "Course Successfully Deleted";
                    }
                    catch (Exception ex)
                    {
                        lblSuccessMessage.Text = "This course has a prerequisite. Delete the prerequisite first";
                    }

                    
                    lblSuccessMessage.Visible = true;
                }
            }
        }

        private string GetNumericPart(string input)
        {
            
            string numericPart = new string(input.Reverse().TakeWhile(char.IsDigit).Reverse().ToArray());

            return numericPart;
        }

        protected void btnViewSlots_Click(object sender, EventArgs e)
        {
            string courseIDLabel = lblCourseID.Text;
            string selectedCourseID = GetNumericPart(courseIDLabel);

            
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["project"].ToString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                using (SqlCommand command = new SqlCommand("SELECT * FROM Slot WHERE course_id = @courseID", connection))
                {
                    command.Parameters.AddWithValue("@courseID", selectedCourseID);

                    connection.Open();

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        
                        GridView1.DataSource = reader;
                        GridView1.DataBind();
                    }
                }
            }
            GridView1.Visible = true;
        }
        protected void btnViewMakeups_Click(object sender, EventArgs e)
        {
            string courseIDLabel = lblCourseID.Text;
            string selectedCourseID = GetNumericPart(courseIDLabel);

            
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["project"].ToString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                using (SqlCommand command = new SqlCommand("SELECT * FROM MakeUp_Exam WHERE course_id = @courseID", connection))
                {
                    command.Parameters.AddWithValue("@courseID", selectedCourseID);

                    connection.Open();

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        
                        GridView2.DataSource = reader;
                        GridView2.DataBind();
                    }
                }
            }

            
            GridView2.Visible = true;
            btnAddMakeup.Visible = true;
            txtMakeupDate.Visible = true;
            ddlMakeupType.Visible = true;
        }

        protected void btnAddMakeup_Click(object sender, EventArgs e)
        {
            string courseIDLabel = lblCourseID.Text;
            string selectedCourseID = GetNumericPart(courseIDLabel);

            
            string makeupDateString = txtMakeupDate.Text;
            string makeupType = ddlMakeupType.SelectedValue;

            
            if (!DateTime.TryParseExact(makeupDateString, "MM/dd/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out DateTime makeupDate))
            {
                // Display error message for invalid date
                lblError.Text = "Invalid date. Please enter a valid date in MM/dd/yyyy format.";
                lblError.Visible = true;
                return;
            }

            // Check for existing makeup on the same day
            if (IsExistingMakeupOnSameDay(selectedCourseID, makeupDate))
            {
                // Display error message for existing makeup on the same day
                lblError.Text = $"A makeup already exists on {makeupDate.ToShortDateString()}.";
                lblError.Visible = true;
                return;
            }

            
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["project"].ToString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                using (SqlCommand command = new SqlCommand("INSERT INTO MakeUp_Exam (date, type, course_id) VALUES (@date, @type, @courseID)", connection))
                {
                    command.Parameters.AddWithValue("@date", makeupDate);
                    command.Parameters.AddWithValue("@type", makeupType);
                    command.Parameters.AddWithValue("@courseID", selectedCourseID);

                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }

            
            btnViewMakeups_Click(sender, e);
            lblError.Visible = false;
        }

        private bool IsExistingMakeupOnSameDay(string courseID, DateTime makeupDate)
        {
            
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["project"].ToString();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                using (SqlCommand command = new SqlCommand("SELECT COUNT(*) FROM MakeUp_Exam WHERE course_id = @courseID AND date = @date", connection))
                {
                    command.Parameters.AddWithValue("@courseID", courseID);
                    command.Parameters.AddWithValue("@date", makeupDate);

                    connection.Open();

                    int existingMakeupCount = (int)command.ExecuteScalar();

                    return existingMakeupCount > 0;
                }
            }
        }


        protected void btnDeleteSlots_Click(object sender, EventArgs e)
        {
            // Get the entered semester from the TextBox
            string currentSemester = txtSemester.Text.Trim();

            // Validate the entered semester
            if (string.IsNullOrEmpty(currentSemester))
            {
                lblDeleteSlotsResult.Text = "Please enter the current semester.";
                lblDeleteSlotsResult.Visible = true;
                return;
            }

            // Your existing logic to delete slots
            try
            {
                string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["project"].ToString();

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    using (SqlCommand command = new SqlCommand("Procedures_AdminDeleteSlots", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("@current_semester", currentSemester);

                        command.ExecuteNonQuery();
                    }
                }

                lblDeleteSlotsResult.Text = "Slots Successfully Deleted";
            }
            catch (Exception ex)
            {
                lblDeleteSlotsResult.Text = $"Error: {ex.Message}";
            }

            lblDeleteSlotsResult.Visible = true;
        }


    }
}
