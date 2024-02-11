using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Drawing;
using System.Drawing.Printing;
using System.Linq;
using System.Runtime.InteropServices.ComTypes;
using System.Runtime.Remoting.Contexts;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using static System.Net.Mime.MediaTypeNames;

namespace project
{
    public partial class adminPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void TextBox1_TextChanged(object sender, EventArgs e)
        {

        }

        protected void btn_show_Advisors_Click(object sender, EventArgs e)
        {
            ClearGridView();

            // Connection string
            string connStr = WebConfigurationManager.ConnectionStrings["project"].ToString();
            // Create a SqlConnection
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Open the connection
                conn.Open();

                // Create a SqlCommand with the stored procedure
                using (SqlCommand ListAdvisors = new SqlCommand("Procedures_AdminListAdvisors", conn))
                {
                    // Specify that it's a stored procedure
                    ListAdvisors.CommandType = CommandType.StoredProcedure;

                    // Create a DataTable to hold the result set
                    DataTable dt = new DataTable();

                    // Create a SqlDataAdapter to fill the DataTable
                    using (SqlDataAdapter adapter = new SqlDataAdapter(ListAdvisors))
                    {
                        // Fill the DataTable with the result set from the stored procedure
                        adapter.Fill(dt);
                    }

                    // Check if the DataTable has any rows
                    if (dt.Rows.Count > 0)
                    {
                        // Bind the DataTable to the GridView
                        AdminGridView.DataSource = dt;
                        AdminGridView.DataBind();
                    }
                    else
                    {
                        // If no data is returned, display a message to the user
                        ShowMessage("There are no advisors. Please add advisors first.");
                    }
                }

            }
        }

        protected void btn_show_StuAdv_Click(object sender, EventArgs e)
        {
            ClearGridView();
            // Connection string
            string connStr = WebConfigurationManager.ConnectionStrings["project"].ToString();
            // Create a SqlConnection
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Open the connection
                conn.Open();

                // Create a SqlCommand with the stored procedure
                using (SqlCommand ListAdvisors = new SqlCommand("AdminListStudentsWithAdvisors", conn))
                {
                    // Specify that it's a stored procedure
                    ListAdvisors.CommandType = CommandType.StoredProcedure;

                    // Create a DataTable to hold the result set
                    DataTable dt = new DataTable();

                    // Create a SqlDataAdapter to fill the DataTable
                    using (SqlDataAdapter adapter = new SqlDataAdapter(ListAdvisors))
                    {
                        // Fill the DataTable with the result set from the stored procedure
                        adapter.Fill(dt);
                    }

                    // Check if the DataTable has any rows
                    if (dt.Rows.Count > 0)
                    {
                        // Bind the DataTable to the GridView
                        AdminGridView.DataSource = dt;
                        AdminGridView.DataBind();
                    }
                    else
                    {
                        // If no data is returned, display a message to the user
                        ShowMessage("There are no students linked to advisors. Please link students to advisors first.");
                    }
                }

            }
        }

        protected void btn_show_PendReq_Click(object sender, EventArgs e)
        {
            ClearGridView();
            // Connection string
            string connStr = WebConfigurationManager.ConnectionStrings["project"].ToString();
            // Create a SqlConnection
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Open the connection
                conn.Open();

                // Create a SqlCommand with the stored procedure
                using (SqlCommand ListAdvisors = new SqlCommand("select * from all_Pending_Requests", conn))
                {
                    // Specify that it's a stored procedure

                    // Create a DataTable to hold the result set
                    DataTable dt = new DataTable();

                    // Create a SqlDataAdapter to fill the DataTable
                    using (SqlDataAdapter adapter = new SqlDataAdapter(ListAdvisors))
                    {
                        // Fill the DataTable with the result set from the stored procedure
                        adapter.Fill(dt);
                    }

                    // Check if the DataTable has any rows
                    if (dt.Rows.Count > 0)
                    {
                        // Bind the DataTable to the GridView
                        AdminGridView.DataSource = dt;
                        AdminGridView.DataBind();
                    }
                    else
                    {
                        // If no data is returned, display a message to the user
                        ShowMessage("There are no pending requests.");
                    }
                }

            }
        }

        protected void btn_show_SemCour_Click(object sender, EventArgs e)
        {
            ClearGridView();
            // Connection string
            string connStr = WebConfigurationManager.ConnectionStrings["project"].ToString();
            // Create a SqlConnection
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Open the connection
                conn.Open();

                // Create a SqlCommand with the stored procedure
                using (SqlCommand ListAdvisors = new SqlCommand("SELECT * FROM Semster_offered_Courses", conn))
                {
                    // Create a DataTable to hold the result set
                    DataTable dt = new DataTable();

                    // Create a SqlDataAdapter to fill the DataTable
                    using (SqlDataAdapter adapter = new SqlDataAdapter(ListAdvisors))
                    {
                        // Fill the DataTable with the result set from the stored procedure
                        adapter.Fill(dt);
                    }

                    // Check if the DataTable has any rows
                    if (dt.Rows.Count > 0)
                    {
                        // Bind the DataTable to the GridView
                        AdminGridView.DataSource = dt;
                        AdminGridView.DataBind();
                    }
                    else
                    {
                        // If no data is returned, display a message to the user
                        ShowMessage("There are no courses in the current semester. Please add courses first.");
                    }
                }

            }
        }

        protected void btn_show_InstCour_Click(object sender, EventArgs e)
        {
            ClearGridView();
            // Connection string
            string connStr = WebConfigurationManager.ConnectionStrings["project"].ToString();
            // Create a SqlConnection
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Open the connection
                conn.Open();

                // Create a SqlCommand with the stored procedure
                using (SqlCommand ListAdvisors = new SqlCommand("SELECT * FROM Instructors_AssignedCourses", conn))
                {

                    // Create a DataTable to hold the result set
                    DataTable dt = new DataTable();

                    // Create a SqlDataAdapter to fill the DataTable
                    using (SqlDataAdapter adapter = new SqlDataAdapter(ListAdvisors))
                    {
                        // Fill the DataTable with the result set from the stored procedure
                        adapter.Fill(dt);
                    }

                    // Check if the DataTable has any rows
                    if (dt.Rows.Count > 0)
                    {
                        // Bind the DataTable to the GridView
                        AdminGridView.DataSource = dt;
                        AdminGridView.DataBind();
                    }
                    else
                    {
                        // If no data is returned, display a message to the user
                        ShowMessage("There are no instructors or they are assigned no courses. Assign courses to instructors first.");
                    }
                }

            }
        }


        protected void Clear_Table_Click(object sender, EventArgs e)
        {
            ClearGridView();
        }
        protected void ClearGridView()
        {
            AdminGridView.DataSource = null; // Replace GridView1 with the ID of your GridView
            AdminGridView.DataBind();
        }

        // Method to display a message when no data is available
        protected void ShowMessage(string msg)
        {
            // Create a new Label control
            Label lblMessage = new Label();
            lblMessage.Text = msg;

            // Set a unique ID for the label (e.g., using a timestamp)
            lblMessage.ID = "lblMessage_" + DateTime.Now.Ticks;

            // Add the label to a container (e.g., a Panel or a placeholder in your ASP.NET markup)
            // Here, I'm assuming you have a Panel with ID "pnlMessages" on your page
            viewMessages.Controls.Add(lblMessage);

            // Register a script to remove the label after 5 seconds
            string script = $"setTimeout(function(){{document.getElementById('{lblMessage.ClientID}').remove();}}, 5000);";
            ClientScript.RegisterStartupScript(this.GetType(), "RemoveMessageScript", script, true);
        }

        protected void ShowMessage(string msg, int delay)
        {
            // Create a new Label control
            Label lblMessage = new Label();
            lblMessage.Text = msg;

            // Set a unique ID for the label (e.g., using a timestamp)
            lblMessage.ID = "lblMessage_" + DateTime.Now.Ticks;

            // Add the label to a container (e.g., a Panel or a placeholder in your ASP.NET markup)
            // Here, I'm assuming you have a Panel with ID "pnlMessages" on your page
            viewMessages.Controls.Add(lblMessage);

            // Register a script to remove the label after 5 seconds
            string script = $"setTimeout(function(){{document.getElementById('{lblMessage.ClientID}').remove();}}, ${delay});";
            ClientScript.RegisterStartupScript(this.GetType(), "RemoveMessageScript", script, true);
        }

        protected void btn_link_student_advisor(object sender, EventArgs e)
        {
            hide_input_fields();
            studentID.Visible = true;
            advisorID.Visible = true;
            // Connection string

            int studentID_int;
            int advisorID_int;

            if (int.TryParse(studentID.Text, out studentID_int) && int.TryParse(advisorID.Text, out advisorID_int))
            {

                string connStr = WebConfigurationManager.ConnectionStrings["project"].ToString();
                // Create a SqlConnection
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    // Open the connection
                    conn.Open();

                    // Create a SqlCommand with the stored procedure
                    using (SqlCommand LinkStuAdvisor = new SqlCommand("Procedures_AdminLinkStudentToAdvisor", conn))
                    {
                        // Specify that it's a stored procedure
                        LinkStuAdvisor.CommandType = CommandType.StoredProcedure;

                        LinkStuAdvisor.Parameters.Add("@studentID", SqlDbType.Int).Value = studentID_int;
                        LinkStuAdvisor.Parameters.Add("@advisorID", SqlDbType.Int).Value = advisorID_int;

                        try
                        {
                            // Execute the stored procedure
                            int num_rows_affected = LinkStuAdvisor.ExecuteNonQuery();
                            if (num_rows_affected > 0)
                                ShowMessage("The student was linked successfully");
                            else
                                ShowMessage("Either the advisor id or the student id is incorrect");
                        }
                        catch (System.Data.SqlClient.SqlException ex)
                        {
                            ShowMessage(ex.Message + "\nthis record already exists in the database", 10);
                        }



                    }
                }
            }
            else
            {
                ShowMessage("Both inputs should be integers and cannot be empty");
            }
        }

        protected void btn_link_instr_cour_slot(object sender, EventArgs e)
        {
            hide_input_fields();
            courseID.Visible = true;
            instructorID.Visible = true;
            slotID.Visible = true;
            // Connection string

            int courseID_int;
            int instructorID_int;
            int slotID_int;

            if (int.TryParse(courseID.Text, out courseID_int) && int.TryParse(instructorID.Text, out instructorID_int) && int.TryParse(slotID.Text, out slotID_int))
            {

                string connStr = WebConfigurationManager.ConnectionStrings["project"].ToString();
                // Create a SqlConnection
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    // Open the connection
                    conn.Open();

                    // Create a SqlCommand with the stored procedure
                    using (SqlCommand LinkInstCourSlot = new SqlCommand("Procedures_AdminLinkInstructor", conn))
                    {
                        // Specify that it's a stored procedure
                        LinkInstCourSlot.CommandType = CommandType.StoredProcedure;

                        LinkInstCourSlot.Parameters.Add("@cours_id", SqlDbType.Int).Value = courseID_int;
                        LinkInstCourSlot.Parameters.Add("@instructor_id", SqlDbType.Int).Value = instructorID_int;
                        LinkInstCourSlot.Parameters.Add("@slot_id", SqlDbType.Int).Value = slotID_int;
                        try
                        {
                            // Execute the stored procedure
                            int num_rows_affected = LinkInstCourSlot.ExecuteNonQuery();
                            if (num_rows_affected > 0)
                                ShowMessage("The instructor was linked successfully");
                            else
                                ShowMessage("Either the course_id, instructor_id, or slot_id is incorrect");
                        }
                        catch (System.Data.SqlClient.SqlException ex)
                        {
                            ShowMessage(ex.Message + "\nthis record already exists in the database", 10);
                        }
                    }
                }
            }
            else
            {
                ShowMessage("All inputs should be Numeric and not empty");
            }
        }

        protected void btn_link_stud_cour_instr(object sender, EventArgs e)
        {
            hide_input_fields();
            courseID.Visible = true;
            instructorID.Visible = true;
            studentID.Visible = true;
            semesterCode.Visible = true;
            // Connection string

            int courseID_int;
            int instructorID_int;
            int studentID_int;
            string semester_code_string;

            if (int.TryParse(courseID.Text, out courseID_int) && int.TryParse(instructorID.Text, out instructorID_int) && int.TryParse(studentID.Text, out studentID_int))
            {
                semester_code_string = semesterCode.Text.ToString().ToUpper();
                string connStr = WebConfigurationManager.ConnectionStrings["project"].ToString();
                // Create a SqlConnection
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    // Open the connection
                    conn.Open();

                    // Create a SqlCommand with the stored procedure
                    using (SqlCommand LinkInstCourSlot = new SqlCommand("Procedures_AdminLinkStudent", conn))
                    {
                        // Specify that it's a stored procedure
                        LinkInstCourSlot.CommandType = CommandType.StoredProcedure;

                        LinkInstCourSlot.Parameters.Add("@cours_id", SqlDbType.Int).Value = courseID_int;
                        LinkInstCourSlot.Parameters.Add("@instructor_id", SqlDbType.Int).Value = instructorID_int;
                        LinkInstCourSlot.Parameters.Add("@studentID", SqlDbType.Int).Value = studentID_int;
                        LinkInstCourSlot.Parameters.Add("@semester_code", SqlDbType.VarChar, 40).Value = semester_code_string;

                        // Execute the stored procedure
                        try
                        {
                            int num_rows_affected = LinkInstCourSlot.ExecuteNonQuery();
                            if (num_rows_affected > 0)
                                ShowMessage("The instructor was linked successfully");
                            else
                                ShowMessage("Either the course_id, instructor_id, or student_id is incorrect");
                        }
                        catch (System.Data.SqlClient.SqlException ex)
                        {
                            ShowMessage(ex.Message + "\nthis record already exists in the database", 10);
                        }

                    }
                }
            }
            else
            {
                ShowMessage("All inputs should be Numeric and not empty");
            }
        }


        protected void btn_add_semester(object sender, EventArgs e)
        {
            hide_input_fields();

            semesterCode.Visible = true;
            endDate.Visible = true;
            startDate.Visible = true;

            string semesterCodeValue = semesterCode.Text;
            DateTime startDateValue;
            DateTime endDateValue;


            if (DateTime.TryParse(startDate.Text, out startDateValue) && DateTime.TryParse(endDate.Text, out endDateValue))
            {

                // Connection string
                string connStr = WebConfigurationManager.ConnectionStrings["project"].ToString();

                // Create a SqlConnection
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    // Open the connection
                    conn.Open();

                    // Create a SqlCommand with the stored procedure
                    using (SqlCommand addSemester = new SqlCommand("AdminAddingSemester", conn))
                    {
                        // Specify that it's a stored procedure
                        addSemester.CommandType = CommandType.StoredProcedure;

                        addSemester.Parameters.Add("@start_date", SqlDbType.Date).Value = startDateValue;
                        addSemester.Parameters.Add("@end_date", SqlDbType.Date).Value = endDateValue;
                        addSemester.Parameters.Add("@semester_code", SqlDbType.VarChar, 40).Value = semesterCodeValue;

                        try
                        {
                            // Execute the stored procedure
                            int num_rows_affected = addSemester.ExecuteNonQuery();
                            if (num_rows_affected > 0)
                                ShowMessage("The semester was linked successfully");
                            else
                                ShowMessage("one of the inputs is incorrect");
                        }
                        catch (System.Data.SqlClient.SqlException ex)
                        {
                            ShowMessage(ex.Message, 10);
                        }
                    }
                }
            }
            else
            {
                ShowMessage("All inputs cannot be empty");
            }

        }

        protected void btn_manage_courses(object sender, EventArgs e)
        {
            hide_input_fields();
            Response.Redirect("login.aspx");
        }
        protected void hide_input_fields()
        {
            studentID.Visible = false;
            advisorID.Visible = false;
            courseID.Visible = false;
            instructorID.Visible = false;
            slotID.Visible = false;
            semesterCode.Visible = false;
            endDate.Visible = false;
            startDate.Visible = false;
        }

        protected void btn_manage_finances(object sender, EventArgs e)
        {
            hide_input_fields();
            Response.Redirect("Payment.aspx");
        }

        protected void btn_manage_students(object sender, EventArgs e)
        {
            hide_input_fields();
            Response.Redirect("StudentViews.aspx");
        }

        protected void btn_logout(object sender, EventArgs e)
        {
            hide_input_fields();
            Response.Redirect("main_page.aspx");
        }
    }

}


