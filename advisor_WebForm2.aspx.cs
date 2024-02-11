using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication4
{
    public partial class advisor_WebForm2 : System.Web.UI.Page
    {
        protected void advisingstudents(object sender, EventArgs e)
        {
            string connstr = WebConfigurationManager.ConnectionStrings["project"].ToString();
            SqlConnection conn = new SqlConnection(connstr);

            conn.Open();
            using (SqlCommand command = new SqlCommand("AdminListStudentsWithAdvisors", conn))
            {
                command.CommandType = CommandType.StoredProcedure;
                using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                {
                    DataTable dataTable = new DataTable();
                    adapter.Fill(dataTable);
                    GridView1.DataSource = dataTable;
                    GridView1.DataBind();

                    if (dataTable.Rows.Count < 1)
                    {
                        Response.Write("No advising students to show");
                    }
                }

            }

        }




        protected void insertGP(object sender, EventArgs e)
        {
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["project"].ConnectionString))
            {
                String semestercode = semcode.Text;
                String exptdate = expdate.Text;
                int semCH = Int16.Parse(semch.Text);
                int studid = Int16.Parse(studentid2.Text);
                int id = Int16.Parse(Session["ID"].ToString());


                connection.Open();

                using (SqlCommand command = new SqlCommand("Procedures_AdvisorCreateGP", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;

                    command.Parameters.AddWithValue("@Semester_code", semestercode);
                    command.Parameters.AddWithValue("@expected_graduation_date", exptdate);
                    command.Parameters.AddWithValue("@sem_credit_hours", semCH);
                    command.Parameters.AddWithValue("@advisor_id", id);
                    command.Parameters.AddWithValue("@student_id", studid);


                    int rowsaffected = command.ExecuteNonQuery();
                    if (rowsaffected > 0)
                    {
                        Response.Write("succes");
                    }
                    else
                    {
                        Response.Write("Something went wrong");
                    }


                }
            }
        }

        protected void insertcourse(object sender, EventArgs e)
        {
            SqlConnection connection = new SqlConnection(WebConfigurationManager.ConnectionStrings["project"].ConnectionString);


            int studid = Int16.Parse(studentid.Text);
            string semestercode = semcode.Text;
            String courname = coursename.Text;

            connection.Open();

            SqlCommand command = new SqlCommand("Procedures_AdvisorAddCourseGP", connection);






            command.CommandType = CommandType.StoredProcedure;

            command.Parameters.AddWithValue("@student_id", studid);
            command.Parameters.AddWithValue("@Semester_code", semestercode);
            command.Parameters.AddWithValue("@course_name", courname);

            int rowsaffected = command.ExecuteNonQuery();

            connection.Close();

            if (rowsaffected > 0)
            {
                Response.Write("insertion done successfully");
            }
            else
            {
                Response.Write("something went wrong");
            }

        }


        protected void updatedate(object sender, EventArgs e)
        {

            DateTime expdate = DateTime.Parse(expecteddate.Text);

            String studid = studentsid.Text;

            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["project"].ConnectionString))
            {
                connection.Open();

                using (SqlCommand command = new SqlCommand("Procedures_AdvisorUpdateGP", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@expected_grad_date", expdate);
                    command.Parameters.AddWithValue("@studentID", studid);


                    int rowsaffected = command.ExecuteNonQuery();

                    if (rowsaffected > 0)
                    {
                        Response.Write("Graduation plan date updated successfully");
                    }
                    else
                    {
                        Response.Write("Something went wrong");
                    }
                }
            }
        }







        protected void deletecourse(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["project"].ConnectionString))
            {
                int studid = Int16.Parse(studentid.Text);
                string semestercode = semcode.Text;
                int courid = Int16.Parse(courseid.Text);

                using (SqlCommand cmd = new SqlCommand("Procedures_AdvisorDeleteFromGP", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;


                    cmd.Parameters.AddWithValue("@studentID", studid);
                    cmd.Parameters.AddWithValue("@sem_code", semestercode);
                    cmd.Parameters.AddWithValue("@courseID", courid);

                    conn.Open();
                    int rowsaffected = cmd.ExecuteNonQuery();


                    if (rowsaffected > 0)
                    {
                        Response.Write("Course deleted successfully");
                    }
                    else
                    {
                        Response.Write("Something went wrong");
                    }
                }
            }
        }




        protected void viewadvisingstudents(object sender, EventArgs e)
        {
            string connstr = WebConfigurationManager.ConnectionStrings["project"].ToString();

            SqlConnection conn = new SqlConnection(connstr);

            int id = Int16.Parse(Session["ID"].ToString());
            string admajor = major.Text;




            using (SqlCommand command = new SqlCommand("Procedures_AdvisorViewAssignedStudents", conn))
            {
                command.CommandType = CommandType.StoredProcedure;


                command.CommandType = CommandType.StoredProcedure;

                command.Parameters.AddWithValue("@AdvisorID", id);
                command.Parameters.AddWithValue("@major", admajor);


                using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                {
                    conn.Open();
                    DataTable dataTable = new DataTable();
                    adapter.Fill(dataTable);
                    GridView1.DataSource = dataTable;
                    GridView1.DataBind();

                    if (dataTable.Rows.Count < 1)
                    {
                        Response.Write("No advising students to show");
                    }

                }
            }


        }
        protected void viewallrequests(object sender, EventArgs e)
        {
            string connstr = WebConfigurationManager.ConnectionStrings["project"].ToString();

            SqlConnection conn = new SqlConnection(connstr);

            conn.Open();
            using (SqlCommand command = new SqlCommand("SELECT * from Request", conn))
            {
                using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                {
                    DataTable dataTable = new DataTable();
                    adapter.Fill(dataTable);
                    GridView1.DataSource = dataTable;
                    GridView1.DataBind();
                }
            }

        }


        protected void viewallpendingrequests(object sender, EventArgs e)
        {
            string connstr = WebConfigurationManager.ConnectionStrings["project"].ToString();

            SqlConnection conn = new SqlConnection(connstr);

            conn.Open();
            using (SqlCommand command = new SqlCommand("SELECT * from all_Pending_Requests", conn))
            {
                using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                {
                    DataTable dataTable = new DataTable();
                    adapter.Fill(dataTable);
                    GridView1.DataSource = dataTable;
                    GridView1.DataBind();
                }
            }

        }

        private void BindData()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["WebApplicatio1"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT request_id, student_id, credit_hours, status FROM Request";
                SqlDataAdapter adapter = new SqlDataAdapter(query, connection);
                DataTable dataTable = new DataTable();
                adapter.Fill(dataTable);

                GridView1.DataSource = dataTable;
                GridView1.DataBind();
            }
        }




        protected void accpectrejectCHR(object sender, EventArgs e)
        {

            string connStr = WebConfigurationManager.ConnectionStrings["project"].ToString();



            SqlConnection connection = new SqlConnection(connStr);

            int reqid = Int16.Parse(requestid.Text);
            String semcode = semestercode.Text;

            connection.Open();
            SqlCommand cmd = new SqlCommand("Procedures_AdvisorApproveRejectCHRequest", connection);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("current_sem_code", semcode);
            cmd.Parameters.AddWithValue("@requestID", reqid);


            int rowsaffected = cmd.ExecuteNonQuery();
            if (rowsaffected > 0)
            {
                Response.Write("success");
            }

            else
            {
                Response.Write("something went wrong");
            }

            connection.Close();
        }







        protected void accecptrejectextracourserequest(object sender, EventArgs e)
        {

            string connStr = WebConfigurationManager.ConnectionStrings["project"].ToString();



            SqlConnection connection = new SqlConnection(connStr);



            int reqid = Int16.Parse(requestid.Text);
            String semcode = semestercode.Text;



            connection.Open();
            SqlCommand cmd = new SqlCommand("Procedures_AdvisorApproveRejectCourseRequest", connection);
            cmd.CommandType = CommandType.StoredProcedure;



            cmd.Parameters.AddWithValue("@current_semester_code", semcode);
            cmd.Parameters.AddWithValue("@requestID", reqid);


            int rowsaffected = cmd.ExecuteNonQuery();

            if (rowsaffected > 0)
            {
                Response.Write("success");
            }

            else
            {
                Response.Write("something went wrong");
            }

            connection.Close();
        }

    }
}