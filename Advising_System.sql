--drop database Advising_system;
Create Database project;
go
Use project


-------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////////////////////////////////////////////////
Go

CREATE PROC [CreateAllTables]
     AS  
create table Advisor (
advisor_id int primary key identity, 
advisor_name varchar(40),
email varchar(40),
office varchar(40),
password varchar(40) not null
) 
-----------------------Student Table--------------------------------------

     Create Table Student (
     student_id int primary Key Identity(1,1), 
     f_name Varchar(40),
     l_name Varchar(40),
     password Varchar(40), 
     gpa decimal(10,2),
     faculty Varchar(40),
     email Varchar(40),
     major Varchar(40),
     financial_status bit,
     semester int, 
     acquired_hours int, 
     assigned_hours int, 
     advisor_id int Foreign key references Advisor(advisor_id) on update cascade on delete cascade
   )
 ---------------------------Student_Phone----------------------------------
     Create Table Student_Phone (
     student_id int Foreign key references Student(student_id),
     phone_number varchar(40),
     primary key(student_id, phone_number)
     )

----------------------------------Graduation_Plan-----------------------------------------------
create table Graduation_Plan (
plan_id int not null identity(1,1),
semester_code varchar(40) not null, 
semester_credit_hours int,
expected_grad_date date,
advisor_id int Foreign key references Advisor(advisor_id)  on update cascade  on delete cascade,
student_id int Foreign key references Student(student_id),
primary key(plan_id, semester_code)
)
----------------------------Course--------------------------------------------
     Create Table Course (
     course_id int primary key identity, 
     name varchar(40),
     major varchar(40), 
     is_offered bit, 
     credit_hours int,
     semester int
     )
---------------------------------PreqCourse_course-------------------------------------
     Create Table PreqCourse_course(
     prerequisite_course_id int Foreign key references course(course_id)  on update cascade on delete cascade,
     course_id int Foreign key references course(course_id),
     primary key(prerequisite_course_id,course_id)
     )
---------------------------Instructor------------------------------------
create table Instructor (
instructor_id int primary key,
name varchar(40),
email varchar(40), 
faculty varchar(40), 
office varchar(40)
)
--------------------------------Instructor_Course-----------------------------------
create table Instructor_Course (
course_id int Foreign key references course(course_id)  on update cascade on delete cascade, 
instructor_id int Foreign key references Instructor(instructor_id)  on update cascade on delete cascade,
primary key(course_id, instructor_id)
)
----------------------------Student_Instructor_Course_take-------------------------
create table Student_Instructor_Course_take (
student_id int Foreign key references Student(student_id)  on update cascade on delete cascade,
course_id int Foreign key references course(course_id)  on update cascade on delete cascade, 
instructor_id int Foreign key references Instructor(instructor_id)  on update cascade on delete cascade, 
semester_code varchar(40), 
exam_type varchar(40) Default 'Normal', 
grade varchar(40),
primary key(student_id, course_id, semester_code)
)     
------------------------Semester----------------------------------

create table Semester (
semester_code varchar(40) primary key,
start_date date, 
end_date date
)
------------------------Course_Semester-------------------------------------
create table Course_Semester (
course_id int Foreign key references course(course_id)  on update cascade on delete cascade , 
semester_code varchar(40) references Semester(semester_code)  on update cascade on delete cascade,
primary key(course_id, semester_code)
)

------------------------GradPlan_Course_(include)-------------------------------------

create table GradPlan_Course (
plan_id int,
semester_code varchar(40),
course_id int Foreign key references course(course_id) on update cascade on delete cascade,
constraint FK_Grad  foreign key (plan_id,semester_code) references Graduation_Plan (plan_id, semester_code),
primary key (course_id,plan_id, semester_code)
)
-------------------------------------------------------------
------------------------Slot-------------------------------------

create table Slot (
slot_id int primary key, 
day varchar(40),
time varchar(40), 
location varchar(40), 
course_id int Foreign key references course(course_id)  on update cascade on delete cascade,
instructor_id int Foreign key references Instructor(instructor_id) on update cascade on delete cascade
)

---------------------------Request-----------------------------------------
create table Request (
request_id int primary key identity(1,1), 
type varchar(40), 
comment varchar(40), 
status varchar(40) default 'Pending', 
credit_hours int,
course_id int,
student_id int Foreign key references Student(student_id)  on update cascade on delete cascade, 
advisor_id int Foreign key references Advisor(advisor_id)  /*on update cascade on delete cascade*/
)
--------------------------------------------------------------

-------------------------------MakeUp_Exam---------------------------------
create table MakeUp_Exam (
exam_id int primary key identity,
date date,
type varchar(40), 
course_id int Foreign key references course(course_id)  on update cascade on delete cascade
)
-------------------------------Exam_Student-------------------------------

create table Exam_Student (
exam_id int Foreign key references MakeUp_Exam(exam_id)  on update cascade on delete cascade,
student_id int Foreign key references Student(student_id),
course_id int,
primary key(exam_id, student_id)
)
---------------------------Payment-----------------------------------

create table Payment(
payment_id int primary key,
amount int,
startdate datetime,
deadline datetime,
n_installments int,
fund_percentage decimal(10,2),
status varchar(40) default 'notPaid',
student_id int Foreign key references Student(student_id)  on update cascade on delete cascade,
semester_code varchar(40) Foreign key references Semester(semester_code) on update cascade on delete cascade
)
----------------------------Installment-------------------------------------
Create table Installment (
payment_id int not null Foreign key references Payment(payment_id) on update cascade on delete cascade,
startdate datetime,
deadline datetime not null,
amount int,
status varchar(40) default 'notPaid',
primary key(payment_id,deadline)
)
  GO
--/////////////////////////////////////////////////////////////////////////////////////------------------------------------------------------------------------------

EXEC CreateAllTables

--///////////////////////////////////////////////////////////

--------------------------Active Students with accepted financial_status-----------------------------------------------------
go
CREATE  VIEW  view_Students AS
Select * from Student where financial_status = 1

---------------------------------courses with their prerequisites--------------------------------------------------------------
go
CREATE  VIEW  view_Course_prerequisites AS
Select C1.*, C2.course_id as preRequsite_course_id, C2.name as preRequsite_course_name 
from Course C1 inner join PreqCourse_course On C1.course_id = PreqCourse_course.course_id
inner join course C2 on PreqCourse_course.prerequisite_course_id = c2.course_id
go
-----------------------------------all Instructors along with their assigned courses------------------------------------------------------

CREATE  VIEW  Instructors_AssignedCourses AS
Select Instructor.instructor_id, Instructor.name as Instructor, Course.course_id, Course.name As Course
from Instructor inner join Student_Instructor_Course_take t on Instructor.instructor_id = t.instructor_id
inner join Course On Course.course_id = t.course_id 

-----------------------------------all payments along with their corresponding student--------------------------------------------------
go

CREATE  VIEW  Student_Payment AS
Select Student.student_id as studentID , Student.f_name, Student.l_name, Payment.* 
from Payment Inner join Student on Payment.student_id = Student.student_id

----------------------------all courses along with their corresponding slots’ details and Instructor----------------------------------------------------------
go
CREATE  VIEW  Courses_Slots_Instructor AS
Select Course.course_id as CourseID , Course.name As Course, Slot.*, Instructor.name as Instructor
from Course inner join Slot on Course.course_id = Slot.course_id
inner join Instructor on Slot.instructor_id = Instructor.instructor_id

go
----------------------all courses along with their exams’ details-----------------------------------------------------------------
CREATE  VIEW  Courses_MakeupExams AS
Select MakeUp_Exam.*, Course.name, Course.semester
from MakeUp_Exam inner join Course on MakeUp_Exam.course_id = Course.course_id 

------------------------All students along with their taken courses details--------------------------------------------------------------------
go
CREATE  VIEW  Students_Courses_transcript AS
Select Student.student_id, student.f_name,student.l_name, t.course_id,Course.name , t.exam_type,t.grade, t.semester_code
from Student inner join Student_Instructor_Course_take t on Student.student_id = t.student_id
inner join Course On Course.course_id = t.course_id
go
--------------------------semesters along with their offered courses-----------------------------------------------------
CREATE  VIEW  Semster_offered_Courses AS
Select Course.course_id, Course.name, Semester.semester_code
from Course inner join Course_Semester on Course.course_id = Course_Semester.course_id
inner join Semester on Course_Semester.semester_code = semester.semester_code
go
-----------------------------graduation plans along with their initiated advisors-----------------------------------------------------

CREATE  VIEW  Advisors_Graduation_Plan AS
Select Graduation_Plan.*, Advisor.advisor_id as AdvisorID, Advisor.advisor_name
from Graduation_Plan inner join Advisor on Graduation_Plan.advisor_id = Advisor.advisor_id

------------------------------------------------------------------------------------

--///////////////////////////////////////////////////////////////////////////////////////////////

--///////////////////////////////As an unregistered user I should be able to////////////////////////////////////////////////

GO
--drop procedure Procedures_StudentRegistration
--------------------------[Procedures_StudentRegistration]---------------------------------------------------
CREATE PROC [Procedures_StudentRegistration]
     @first_name varchar(20), 
     @last_name varchar(20), 
     @password varchar(20), 
     @faculty varchar(20), 
     @email varchar(50), 
     @major varchar(20),
     @Semester int,
     @Student_id int OUTPUT
     AS 
     insert into Student  (f_name,l_name,password, faculty, email, major, semester) 
     values (@first_name, @last_name, @password, @faculty, @email, @major, @Semester)
    
    Select @Student_id =  student_id from Student 
     where f_name = @first_name and
     l_name= @last_name and
     password = @password  and
     email = @email 
    
     Go

   ------------------------------------Advisor Registration----------------------------------------------------

Go
CREATE PROC [Procedures_AdvisorRegistration]
     @advisor_name varchar(20), 
     @password varchar(20), 
     @email varchar(50), 
     @office varchar(20),
     @Advisor_id int OUTPUT
     AS 
     insert into Advisor(advisor_name,password, email, office) 
     values (@advisor_name, @password, @email, @office)
    
    Select @Advisor_id =  advisor_id from Advisor 
     where advisor_name = @advisor_name and
     password = @password  and
     email = @email 
    
     Go

--/////////////////////////////////////////////////////////////////////////////////

--//////////////////////////////As an admin I should be able to://////////////////////////////////////////////////

-----------------------List all advising students--------------------------------------
Go
CREATE PROC [Procedures_AdminListStudents]
As
Select * from Student

-----------------------List all advisors--------------------------------------
Go
CREATE PROC [Procedures_AdminListAdvisors]
As
Select * from Advisor

-----------------------List all Students with their Advisors--------------------------------------
go
Create Proc [AdminListStudentsWithAdvisors] AS
Select Student.student_id, Student.f_name, Student.l_name, Advisor.advisor_id, Advisor.advisor_name
from Student inner join Advisor on Student.advisor_id = Advisor.advisor_id
go

----------------------------Add new Semester-------------------------------------------
Go
CREATE PROC [AdminAddingSemester]

    @start_date date,
    @end_date date, 
    @semester_code Varchar(40)

     AS 
     IF @start_date IS NULL or @end_date IS NULL or @semester_code IS NULL 
    print 'One of the inputs is null'
    Else
     insert into Semester(start_date, end_date, semester_code) 
     values (@start_date, @end_date, @semester_code)
     
Go


-----------------------------Add new Course---------------------------------------

Go

CREATE PROC [Procedures_AdminAddingCourse]

    @major varchar(20),
    @semester int, 
    @credit_hours int, 
    @name varchar(30),
    @is_offered bit


     AS 
     IF @major IS NULL or @semester IS NULL or @name IS NULL or @credit_hours is Null or
     @is_offered is Null
    print 'One of the inputs is null'
    Else
     insert into Course(name, major,semester,credit_hours,is_offered) 
     values (@name, @major, @semester,@credit_hours,@is_offered)
     
Go

-----------------------------------------------------------------------
--------------------- Link instructor to course on specific slot-----------------------

Go

CREATE PROC [Procedures_AdminLinkInstructor]
@cours_id int,
@instructor_id int, 
@slot_id int
As

IF @cours_id IS NULL or @instructor_id IS NULL or @slot_id IS NULL 
    print 'One of the inputs is null'

Else
update Slot 
set course_id =@cours_id,
instructor_id =@instructor_id 
where slot_id = @slot_id;

Go

---------------------------------------------------------------------------------------------
------------------ Link student to course and instructor -----------------------------

Go
CREATE PROC [Procedures_AdminLinkStudent]
@cours_id int,
@instructor_id int, 
@studentID int,
@semester_code varchar(40)
As

IF @cours_id IS NULL or @instructor_id IS NULL or @studentID IS NULL or @semester_code IS NULL
    print 'One of the inputs is null'

Else
insert into Student_Instructor_Course_take ( instructor_id, course_id,student_id, semester_code) values (@instructor_id,@cours_id,@studentID,@semester_code) 

Go

----------------------------------------------------------------------------------
-------------------------Link student to advisor-----------------------------------------------------------
/*

Link student to advisor
Name: AdminLinkStudentToAdvisor
Input: studentID int, advisorID int

*/
Go

CREATE PROC [Procedures_AdminLinkStudentToAdvisor]

@studentID int, 
@advisorID int

As
IF @studentID IS NULL or @advisorID IS NULL 
    print 'One of the inputs is null'

Else
update Student 
set advisor_id = @advisorID
where student_id = @studentID
Go

--------------------------------AdminAddExam---------------------------------------------------------------
/*
Admin add exam
Name: AdminAddExam
Input: Type varchar(30), date datetime, courseID int
*/
Go

CREATE PROC [Procedures_AdminAddExam]

@Type varchar(40), 
@date datetime,
@courseID int

As
IF @Type IS NULL or @date IS NULL  or @courseID IS Null
    print 'One of the inputs is null'

Else
insert into MakeUp_Exam values (@date, @Type, @courseID)
Go

------------------------Issue installments as per the number of installments for a certain payment---------------------------------------------------------
/*
Issue installments as per the number of installments for a certain payment
Name: AdminIssueInstallment 
Input: paymentID int
Output: Nothing 

 */
 
Go
CREATE PROC [Procedures_AdminIssueInstallment]
@payment_id int

As
Declare 
@payment_amount int,
@startdate datetime,
@deadline datetime,
@num_of_installment int,

@installment_amount int,
@num_of_insertions int,
@install_start_date date,
@install_deadline date,
@add_month int

Select @payment_amount = amount from Payment where payment_id = @payment_id
Select @startdate = payment.startdate from Payment where payment_id = @payment_id
Select @deadline = deadline from Payment where payment_id = @payment_id
Select @num_of_installment = n_installments from Payment where payment_id = @payment_id
-------
set @installment_amount = @payment_amount/ @num_of_installment
set @num_of_insertions = @num_of_installment
set @install_start_date =  @startdate
set @add_month =1

while @num_of_insertions > 0
Begin

Set @install_deadline = DATEADD(month, 1, @install_start_date)  

insert into Installment values (@payment_id, @install_start_date,@install_deadline,@installment_amount,'NotPaid')

set @install_start_date = DATEADD(month, 1, @install_start_date) --@install_start_date  +1 
set @num_of_insertions = @num_of_insertions -1

End 


GO

------------------------------------------------------------------------------------
 -------------------------------Delete courses-----------------------------------------------
Go

CREATE PROC [Procedures_AdminDeleteCourse]
@courseID int

As
Delete from Course where course_id = @courseID
update Slot 
set course_id = null
where course_id = @courseId

Go
-----------------------------------------------------------------------------------------
 ----------------------------------[FN_AdminCheckStudentStatus]-------------------------------------
/*
Un/Block student based on his/her financial status {
note that student has an attribute status which is updated based on his/her due payments. 
If the student is blocked, he/she can’t login to the system}
Name: AdminCheckStudentStatus
Input: StudentID int
 Output: bit
Type: Function

*/
Go
CREATE FUNCTION [FN_AdminCheckStudentStatus]
(@Student_id int)     --Define Function Input
Returns bit   	  --Define Function Output

AS
Begin
Declare
@status bit,
@install_status varchar(40)

Select @install_status = Installment.status 
from Installment inner join Payment on Payment.payment_id = Installment.payment_id
and Payment.student_id = @Student_id and Installment.deadline < current_timestamp

if @install_status = 'Paid'
set @status =1

Else if @install_status = 'NotPaid'
set @status =0

Return @status 	 --Return Function Output
END
Go

---------------------------------------Procedure_AdminUpdateStudentStatus-------------------------------------
go 
create proc [Procedure_AdminUpdateStudentStatus]
@student_id int
as
 update Student
 set financial_status = dbo.FN_AdminCheckStudentStatus(@student_id)
 where student_id = @student_id
 go
-----------------------------List all pending requests----------------------------------------------------------
/*List all pending requests
Name: AdminListPendingRequests
Input: Nothing
 Output: Table with all the pending requests details in addition to the related student name and advisor name
*/

Create View all_Pending_Requests As
Select * from Request where status = 'Pending';
-------------------------------------------------------------------
---Delete slots of certain courses if the course isn’t offered in the current semester----

Go
CREATE PROC [Procedures_AdminDeleteSlots]
@current_semester varchar(40)

As

Delete from slot where Slot.course_id In (Select Slot.course_id from Slot inner join Course_Semester on Slot.course_id = Course_Semester.course_id
and Course_Semester.semester_code = @current_semester)
Go

--/////////////////////////////////////////////////////////////////////////////////////
--/////////////////////////////////As an Advisor////////////////////////////////////////////////////

----------------------------------------------------------------------------
-----------------------------AdvisorLogin---------------------------------
/*
login using my username and password. 
Name: AdvisorLogin
Input: ID int, password varchar(20) 
Output: Success bit
Type: Function
*/
Go
CREATE FUNCTION [FN_AdvisorLogin]
(@advisor_Id int, @password varchar(40))     --Define Function Input
Returns bit   	  --Define Function Output

AS
Begin
Declare
@success bit,
@pass varchar(40)

if(@advisor_Id is null or @password is null)
return 0

select @pass = password from Advisor where advisor_id = @advisor_Id
if(@pass = @password)
set @success = 1 
else 
set @success = 0

Return @success
END
Go
----------------------------------------------------------------------------------------
--------------------------------Insert graduation plan ------------------------------------------------------

Go
CREATE PROC [Procedures_AdvisorCreateGP]

@Semester_code varchar(40), 
@expected_graduation_date date, 
@sem_credit_hours int,
@advisor_id int,
@student_id int

AS
declare @student_acquired int 
Select @student_acquired  =  Student.acquired_hours from  Student where Student.student_id = @student_id
If(@student_acquired >=157)
insert into Graduation_Plan values (@Semester_code, @sem_credit_hours, @expected_graduation_date, @advisor_id, @student_id) 
GO

---------------------------------------------------------------------
------------------------Add course inside certain plan for certin student ---------------------------------
Go
CREATE PROC [Procedures_AdvisorAddCourseGP]
 
@student_id int,
@Semester_code varchar(40),
@course_name varchar(40)
AS
declare 
@graduation_plan int,
@course_id int

select @graduation_plan = Graduation_Plan.plan_id from Graduation_Plan where Graduation_Plan.student_id = @student_id and Graduation_Plan.semester_code = @Semester_code
select @course_id = Course.course_id from Course where Course.name = @course_name

insert into GradPlan_Course values (@graduation_plan, @Semester_code, @course_id) 

GO

------------------------------------------------------------------------------
--------------------Update expected graduation date in a certain graduation plan----------------------
Go
CREATE PROC [Procedures_AdvisorUpdateGP]
@expected_grad_date date,
@studentID int

As 
Update Graduation_Plan
set expected_grad_date = @expected_grad_date
where student_id = @studentID
Go

-------------------------------------------------------------------
--------------------Delete certain course from certain graduation plan of certain student ------------

Go
Create PROC [Procedures_AdvisorDeleteFromGP]
@studentID int,
@sem_code varchar(40),
@courseID int


As
declare @gp_plan int
select @gp_plan = Graduation_Plan.plan_id from Graduation_Plan where Graduation_Plan.student_id = @studentID and Graduation_Plan.semester_code = @sem_code

delete from GradPlan_Course
where GradPlan_Course.plan_id = @gp_plan and GradPlan_Course.course_id= @courseID and GradPlan_Course.semester_code = @sem_code

Go
-----------------------------------------------------------------------------------------
------------------------retrieve requests for certain advisor---------------------------------

CREATE FUNCTION [FN_Advisors_Requests]
     (@advisor_id int)
   RETURNs table
   AS
   RETURN (SELECT R.* FROM Request R inner join Advisor A 
   on R.advisor_id = A.advisor_id and A.advisor_id = @advisor_id)
   
------------------------Accept/Reject Credit hours request ---------------------------------
--drop PROC Procedures_AdvisorApproveRejectCHRequest
Go
Create PROC [Procedures_AdvisorApproveRejectCHRequest]
@requestID int,
@current_sem_code varchar(40)

As 

declare 
@requestCreditHours int,
@type varchar(40),  -- 0 ch
@studentGPA decimal(10,2),
@studentCH  int,
@stat varchar(40),
@new_studentCH int,
@studentid int,
@paymentid int,
@nextinstalldate date

select @studentid = Request.student_id from Request where Request.request_id = @requestID
select @studentGPA = Student.gpa from Student where Student.student_id = @studentid
select @studentCH = Student.assigned_hours from Student where Student.student_id = @studentid
select @requestCreditHours = Request.credit_hours from Request where Request.request_id = @requestID
select @type = Request.type from Request where Request.request_id = @requestID
set @new_studentCH = @studentCH

if @type like '%credit%' and @studentCH + @requestCreditHours<=34 and @studentGPA < 3.7 and @requestCreditHours<=3
Begin
set @stat = 'Accept' 
set @new_studentCH = @studentCH + @requestCreditHours

update Student
set student.assigned_hours = @new_studentCH
where Student.student_id = @studentid

select @paymentid = payment.payment_id from Payment where payment.student_id = @studentid and semester_code = @current_sem_code
Select Top 1 @nextinstalldate =  Installment.startdate from Installment where installment.status = 'notPaid' order by Installment.startdate ASC 

update installment
set installment.amount = installment.amount + (1000*@requestCreditHours)
where payment_id = @paymentid and Installment.startdate =@nextinstalldate

update Payment
set payment.amount = payment.amount + (1000*@requestCreditHours)
where payment_id = @paymentid
END
Else
set @stat = 'Reject'

update Request
set request.status = @stat
where Request.request_id = @requestID




Go
----------------------------AdvisorViewAssignedStudents----------------------------------------------------------------
/*
View all students assigned to him/her from a certain major along with their current course
{current courses = courses taken by the student in the current semester}
Type: Stored Procedure
Name: AdvisorViewAssignedStudents
Input: AdvisorID int and major varchar(40)
Output: Table 
*/
Go
--drop proc Procedures_AdvisorViewAssignedStudents;
Create PROC [Procedures_AdvisorViewAssignedStudents]
@AdvisorID int,
@major varchar(40)
As

Select Student.student_id, Student.f_name+' ' + Student.l_name as Student_name, Student.major, Course.name as Course_name
from Student left outer join Student_Instructor_Course_take on Student.student_id = Student_Instructor_Course_take.student_id
left outer join Course on Student_Instructor_Course_take.course_id = Course.course_id
where Student.advisor_id = @AdvisorID and Student.major = @major
Go
-------------------------------------------------------------------------------------
------------------------FUNCTION [FN_FN_check_prerequiste]-------------------------
Go
CREATE FUNCTION [FN_check_prerequiste]
(@studentid int, @requestcourse_id varchar(40))
returns bit
Begin
declare 
@success bit,
@student_id_target int

set @student_id_target = -1

Select @student_id_target = Student.student_id
from Student 
where Student.student_id = @studentid AND  Student.student_id In(
SELECT Student.student_id
FROM Student
WHERE NOT EXISTS (
    (SELECT PreqCourse_course.prerequisite_course_id
    FROM PreqCourse_course
    WHERE PreqCourse_course.course_id = @requestcourse_id)

    EXCEPT

    (SELECT Student_Instructor_Course_take.course_id
    FROM Student_Instructor_Course_take
    INNER JOIN PreqCourse_course ON Student_Instructor_Course_take.course_id = PreqCourse_course.prerequisite_course_id
    where Student_Instructor_Course_take.student_id =  Student.student_id)
)
)
if @student_id_target = -1
set @success = 0
else
set @success = 1
return @success
End



-------------------------------Approve/Reject courses request based on the student’s assigned credit hours -------------------------------------------------------
/*
Name: AdvisorApproveRejectCourseRequest
Input: RequestID int
Output: nothing
*/

Go
Create PROC [Procedures_AdvisorApproveRejectCourseRequest]
@requestID int,
@current_semester_code varchar(40)

As 

declare 
@type varchar(40),  -- 1 course
@studentah  int,
@status varchar(40),
@studentid int,
@requestcourse_id int,
@course_hours int,
@new_studentah int,
@isoffered bit,
@prerequiste bit,
@instructor_id int

select @studentid = Request.student_id from Request where Request.request_id = @requestID
select @studentah = Student.assigned_hours from Student where Student.student_id = @studentid
select @requestcourse_id = Request.course_id from Request where Request.request_id = @requestID
select @type = Request.type from Request where Request.request_id = @requestID
select @course_hours = Course.credit_hours from course where Course.course_id = @requestcourse_id
select @isoffered = Course.is_offered from course where Course.course_id = @requestcourse_id

set @prerequiste = dbo.FN_check_prerequiste(@studentid,@requestcourse_id)
set @new_studentah = @studentah

if @type like '%course%' and @studentah >= @course_hours and @isoffered = 1 and @prerequiste = 1
Begin
set @status = 'Accept' 
set @new_studentah = @new_studentah - @course_hours
insert into Student_Instructor_Course_take (student_id, course_id,semester_code) values (@studentid,@requestcourse_id,@current_semester_code)
select *
from Student_Instructor_Course_take
END
Else
set @status = 'Reject'

update Request
set request.status = @status
where Request.request_id = @requestID

update Student
set student.assigned_hours = @new_studentah
where Student.student_id = @studentid
Go

------------------------------------------------------------------------------
---------View pending requests of his/her students--------------------------------------------------
/*View pending requests of his/her students
Name:AdvisorViewPendingRequests
Input: Advisor ID int {this advisor should be the one advising the student}
Output: Table of pending requests
*/
Go
Create PROC [Procedures_AdvisorViewPendingRequests]
@Advisor_ID int 
As 
select *
from Request where Request.advisor_id = @Advisor_ID and Request.status = 'Pending'
Go


--//////////////////////////////////////////////////////////////////////////////////////////////////////
--/////////////////////As a Student I should be able to /////////////////////////////////////////////////////////////////////////

------------login using my username and password. {refer to un/block students in the admin section-------- 
Go
CREATE FUNCTION [FN_StudentLogin]
(@Student_id int, @password varchar(40))     --Define Function Input
Returns bit   	  --Define Function Output

AS
Begin
Declare
@success bit,
@pass varchar(40)

if(@Student_id is null or @password is null)
return 0

select @pass = password from Student where Student.student_id = @Student_id and Student.financial_status = 1
if(@pass = @password)
set @success = 1 
else 
set @success = 0

Return @success
END
Go
----------------------------------------------------------------------------------------
--------------------------Student mobile number(s)---------------------------------------------------------------

Go
Create PROC [Procedures_StudentaddMobile]
@StudentID int, @mobile_number varchar(40)
As
Insert into Student_Phone values (@StudentID, @mobile_number)
Go

-----------------------------------------------------------------------------------
-------------------------- available courses in the current semester----------------------------
--Output: Table of available courses within the student’s current semester
Go
CREATE FUNCTION [FN_SemsterAvailableCourses]
     (@semstercode varchar(40))
   RETURNs table
   AS
   RETURN (
   Select Course.name, Course.course_id 
   from Course inner join Course_Semester 
   on Course.course_id = Course_Semester.course_id and Course_Semester.semester_code = @semstercode
   )

---------------------------------------------------------------------------
-----------------------------Sending course request-----------------

Go
Create PROC [Procedures_StudentSendingCourseRequest]
@courseID int, 
@StudentID int, 
@type varchar(40), 
@comment varchar(40)
AS
declare
@advisorID int

Select @advisorID = Student.advisor_id from student where Student.student_id = @StudentID

Insert into Request (type,comment,course_id, student_id,advisor_id) values (@type, @comment, @courseID, @StudentID, @advisorID)
Go
-----------------------------------------------------------------------------------------------------
-----------------------------Sending extra credit hours request-----------------

Go
Create PROC [Procedures_StudentSendingCHRequest]
@StudentID int, 
@credit_hours int, 
@type varchar(40), 
@comment varchar(40)
AS
declare
@advisorID int

Select @advisorID = Student.advisor_id from student where Student.student_id = @StudentID

Insert into Request (type,comment,credit_hours, student_id,advisor_id) values (@type, @comment, @credit_hours, @StudentID, @advisorID)
Go
--------------------------------------------------------------------
---------------------View graduation plan of certin student with the assigned courses --------------------------------------------------

--Output:  Complete Graduation plan details

CREATE FUNCTION [FN_StudentViewGP]
     (@student_ID int)
   RETURNs table
   AS
   RETURN (
   Select Student.f_name +' '+ Student.l_name as Student_name , Graduation_Plan.*, GradPlan_Course.course_id, Course.name
   from Student inner join Graduation_Plan on Student.student_id = Graduation_Plan.student_id and Student.student_id = @student_ID
   inner join GradPlan_Course on Graduation_Plan.plan_id = GradPlan_Course.plan_id and Graduation_Plan.semester_code = GradPlan_Course.semester_code
   inner join Course on Course.course_id = GradPlan_Course.course_id
   )
--------------------------------------------------------------------
---------------------View first upcoming installment deadline --------------------------------------------------
--Output: deadline date of first upcoming installment
go 
CREATE FUNCTION [FN_StudentUpcoming_installment]
     (@student_ID int)
   RETURNs date
  Begin
  declare @installdeadline date 
  Select top 1 @installdeadline = Installment.deadline from Installment inner join Payment
  on Payment.payment_id = Installment.payment_id and Payment.student_id = @student_ID and Installment.status='notpaid'
  where Installment.deadline > CURRENT_TIMESTAMP
 
  Order by Installment.deadline ASC

  return @installdeadline
  End

  -------------------------------------------------------------
  -----------View slot of certain course that is taught by a certain instructor--------------------

--Output: table of slots details (ID,location,time,day) with course name and Instructor name
go
CREATE FUNCTION [FN_StudentViewSlot]
     (@CourseID int, @InstructorID int)
   RETURNs table
   AS
   RETURN ( Select * from Courses_Slots_Instructor 
   where Courses_Slots_Instructor.course_id = @CourseID and Courses_Slots_Instructor.instructor_id = @InstructorID
   )
--------------------------------------------------------------------------------------------------
----------Register for first makeup exam {refer to eligibility section (2.4.1) in the description}-------

Go
Create PROC [Procedures_StudentRegisterFirstMakeup]
@StudentID int, @courseID int, @studentCurr_sem varchar(40)
AS
declare 
@exam_id int,
@instructor_id int


If(not exists( Select * from Student_Instructor_Course_take where Student_Instructor_Course_take.student_id = @StudentID and Student_Instructor_Course_take.course_id
= @courseID and Student_Instructor_Course_take.exam_type in ('First_makeup','Second_makeup')))
begin 
If(exists(Select * from Student_Instructor_Course_take where Student_Instructor_Course_take.student_id = @StudentID and Student_Instructor_Course_take.course_id
= @courseID  and Student_Instructor_Course_take.exam_type = 'Normal' and Student_Instructor_Course_take.grade in ('F','FF',null)))
begin 
Select @exam_id = MakeUp_Exam.exam_id from MakeUp_Exam where MakeUp_Exam.course_id = @courseID
Select @instructor_id = Student_Instructor_Course_take.instructor_id from Student_Instructor_Course_take 
where Student_Instructor_Course_take.student_id = @StudentID and Student_Instructor_Course_take.course_id = @courseID 
insert into Exam_Student values (@exam_id, @StudentID, @courseID)
Update Student_Instructor_Course_take 
Set exam_type = 'first_makeup' , grade= null
where  student_id = @StudentID and course_id = @courseID and
 semester_code = @studentCurr_sem
end
end
Go
---------------------------------------------------------------------------------
-----------------Second makeup Eligibility Check {refer to eligibility section (2.4.1) in the description}

CREATE FUNCTION [FN_SemesterCodeCheck]
     (@SemesterCode varchar(40))
   RETURNs varchar(40)
   begin
   declare @output varchar(40)
if @SemesterCode like '%R1%' or  @SemesterCode like '%W%'
set @output = 'Odd'
else 
set @output =  'Even'
return @output
end

--Output: Eligible bit {0 → not eligible, 1 → eligible }
go
CREATE FUNCTION [FN_StudentCheckSMEligibility]
     (@CourseID int, @StudentID int)
   RETURNs bit
Begin
declare 
@eligable bit,
@countOfRows int,
@Student_semester int,
@course_semester varchar(40),
@StudentSemesterCode varchar(40),
@failedGradesCount int

select @countOfRows = COUNT(*) 
from Student_Instructor_Course_take where Student_Instructor_Course_take.exam_type In ( 'First_Makeup', 'Normal') and
Student_Instructor_Course_take.grade in ('F','FF',NULL) 
AND Student_Instructor_Course_take.course_id = @CourseID
AND Student_Instructor_Course_take.student_id = @StudentID

if @countOfRows = 0
return 0

else

begin
select @Student_semester = Student.semester from Student where  Student.student_id = @StudentID

if (@Student_semester % 2) = 0
set @StudentSemesterCode = 'Even'
Else 
set @StudentSemesterCode = 'Odd'

select @failedGradesCount = count(*)
from Student_Instructor_Course_take
where dbo.FN_SemesterCodeCheck(Student_Instructor_Course_take.semester_code) = @StudentSemesterCode and 
Student_Instructor_Course_take.student_id = @StudentID and Student_Instructor_Course_take.grade in ('F','FF')
group by Student_Instructor_Course_take.grade

end

if @failedGradesCount <=2
begin
set @eligable = 1
end
else
set @eligable = 0

return @eligable
END

-------------------------------------------
----------Register for second makeup exam {refer to eligibility section (2.4.1) in the description}-------
Go
Create PROC [Procedures_StudentRegisterSecondMakeup]
@StudentID int, @courseID int, @studentCurr_sem varchar(40)
AS
declare 
@exam_id int,
@instructor_id int
if dbo.FN_StudentCheckSMEligibility(@StudentID, @courseID) = 0
Print 'Your are not eligible to take 2nd makeup'

else
begin
Select @exam_id = MakeUp_Exam.exam_id from MakeUp_Exam where MakeUp_Exam.course_id = @courseID
Select @instructor_id = Student_Instructor_Course_take.instructor_id from Student_Instructor_Course_take 
where Student_Instructor_Course_take.student_id = @StudentID and Student_Instructor_Course_take.course_id = @courseID
insert into Exam_Student values (@exam_id, @StudentID, @courseID)
Update Student_Instructor_Course_take 
Set exam_type = 'Second_makeup' , grade= null
where  student_id = @StudentID and course_id = @courseID and
 semester_code = @studentCurr_sem
end
Go

--------------------------------------------------------------------------------------
----------Function return table that have the courses ids that the student took and failed in them-------

CREATE FUNCTION [FN_StudentFailedAndNotEligibleCourse]
     (@StudentID int, @current_semester_code varchar(40))
   RETURNs table
   AS
   RETURN ( select Student_Instructor_Course_take.course_id
    from Student_Instructor_Course_take inner join Course_Semester on Student_Instructor_Course_take.course_id = Course_Semester.course_id
    where Student_Instructor_Course_take.student_id = @StudentID and 
    Student_Instructor_Course_take.grade in ('F','FF') and
    dbo.FN_StudentCheckSMEligibility(@StudentID,Student_Instructor_Course_take .course_id) = 0 
    and Course_Semester.semester_code = @current_semester_code
    )
---------------------------------------------------------------------------------------------
-----------------[FN_StudentUnattendedCourses]----------------------------------------------

go
CREATE FUNCTION [FN_StudentUnattendedCourses]
     (@StudentID int,@current_semester_code varchar(40),@student_semester int)
   RETURNs table
   AS
   RETURN ( select Course_Semester.course_id
from Course_Semester inner join Course on Course_Semester.course_id = Course.course_id 
inner join Student on Student.major = Course.major
where  Student.student_id= @StudentID and   Course_Semester.semester_code = @current_semester_code and course.semester < @student_semester and Course_Semester.course_id Not In (
select Student_Instructor_Course_take.course_id
from Student_Instructor_Course_take
where Student_Instructor_Course_take.student_id = @StudentID
   ) or Course_Semester.course_id
   In (select Student_Instructor_Course_take.course_id
from Student_Instructor_Course_take
where Student_Instructor_Course_take.student_id = @StudentID and Student_Instructor_Course_take.grade = 'FA' ))
------------------------------------------------------------------------------------------
----------View required courses  {refer to eligibility section (2.2) in the description}-------
go
Go
Create PROC [Procedures_ViewRequiredCourses]
@StudentID int,
@current_semester_code varchar(40)
As
declare @student_semester int

select @student_semester = Student.semester FROM Student where Student.student_id = @StudentID
select Course.name, Course.course_id
from Course 
where Course.course_id in (select * from dbo.FN_StudentFailedAndNotEligibleCourse(@StudentID,@current_semester_code)) 
or Course.course_id in (select * from dbo.FN_StudentUnattendedCourses(@StudentID,@current_semester_code,@student_semester))
GO

------------------------------------------------------------------------------------------
----------View optional courses  {refer to eligibility section (2.2) in the description}-------
Go
Create PROC [Procedures_ViewOptionalCourse]
@StudentID int,
@current_semester_code varchar(40)
As
declare @student_semester int
select @student_semester = Student.semester FROM Student where Student.student_id = @StudentID

select Course_Semester.course_id, Course.name
from Course_Semester inner join Course on Course_Semester.course_id = Course.course_id
where Course_Semester.semester_code = @current_semester_code AND  (Course.semester >= @student_semester and dbo.FN_check_prerequiste(@StudentID, Course_Semester.course_id) = 1 )
GO 
------------------------------------------------------------------------------------------
----------View missing/remaining courses to specific student-------
Go

Create PROC [Procedures_ViewMS]
@StudentID int
As
declare @student_major varchar(40)
Select @student_major = major from Student where student_id = @StudentID 
select Course.course_id, Course.name
from Course 
where  Course.major = @student_major and   Course.course_id not in (select Student_Instructor_Course_take.course_id
from Student_Instructor_Course_take
where Student_Instructor_Course_take.student_id = @StudentID) OR course.course_id in (select Student_Instructor_Course_take.course_id
from Student_Instructor_Course_take
where Student_Instructor_Course_take.student_id = @StudentID AND grade in ('F','FF'))
GO


------------------------------------------------------------------------------------------
----------choose instructor for certain course you already choose-------

Go
Create PROC [Procedures_Chooseinstructor]
@StudentID int,
@instrucorID int,
@CourseID int,
@current_semester_code varchar(40)
AS
update Student_Instructor_Course_take
set Student_Instructor_Course_take.instructor_id = @instrucorID
where Student_Instructor_Course_take.student_id = @StudentID and Student_Instructor_Course_take.course_id = @CourseID 
and Student_Instructor_Course_take.semester_code = @current_semester_code 
GO


--//////////////////////////////////////////////////////////////////////////////////////////////
--EXEC Procedures_CreateAllTables


go
Create Procedure insert_random_values AS
BEGIN

    -- Inserting advisors
    INSERT INTO Advisor (advisor_name, email, office, password)
    VALUES 
    ('John Smith', 'john.smith@example.com', 'C6.306', 'advisorpass1'),
    ('Jane Doe', 'jane.doe@example.com', 'C6.306', 'advisorpass2'),
    ('Michael Johnson', 'michael.johnson@example.com', 'C6.306', 'advisorpass3'),
    ('Emily Wilson', 'emily.wilson@example.com', 'C6.306', 'advisorpass4'),
    ('Daniel Smith', 'daniel.smith@example.com', 'C6.306', 'advisorpass5'),
    ('Olivia Brown', 'olivia.brown@example.com', 'C6.306', 'advisorpass6'),
    ('William Martin', 'william.martin@example.com', 'C6.306', 'advisorpass7'),
    ('Sophia Garcia', 'sophia.garcia@example.com', 'C6.306', 'advisorpass8'),
    ('Ava Taylor', 'ava.taylor@example.com', 'C6.306', 'advisorpass9'),
    ('Matthew Anderson', 'matthew.anderson@example.com', 'C6.306', 'advisorpass10');

    -- Inserting students with different faculties

    INSERT INTO Student (f_name, l_name, gpa, faculty, email, major, password, financial_status, semester, acquired_hours, assigned_hours)
    VALUES
    --('John', 'Doe', 3.8, 'Law and Legal Studies', 'john.doe@example.com', 'MET', 'securepass123', 1, 3, 45, 15, 1),
    --('Jane', 'Smith', 3.5, 'Applied Sciences and Arts', 'jane.smith@example.com', 'Biology', 'strongpass456', 0, 2, 34, 10, 2),
    --('Alice', 'Johnson', 3.9, 'Management Technology', 'alice.johnson@example.com', 'MET', 'topsecret789', 1, 4, 60, 20, 3),
    --('Bob', 'Anderson', 3.2, 'Engineering and Materials Science', 'bob.anderson@example.com', 'Mechanical Engineering', 'confidential101', 0, 3, 45, 18, 4),
    --('Eva', 'Martinez', 3.7, 'Engineering and Materials Science', 'eva.martinez@example.com', 'Electrical Engineering', 'secretcode202', 1, 4, 60, 22, 5),
    --('Michael', 'Johnson', 3.6, 'Pharmacy and Biotechnology', 'michael.johnson@example.com', 'Pharmacy', 'meds456', 1, 3, 45, 15, 6),
    --('Sophia', 'Garcia', 3.9, 'Media Engineering and Technology', 'sophia.garcia@example.com', 'Digital Media', 'creative789', 1, 4, 60, 20, 7),
    --('Daniel', 'Smith', 3.5, 'Information Engineering and Technology', 'daniel.smith@example.com', 'MET', 'codemaster101', 0, 2, 35, 10, 8),
    --('Olivia', 'Brown', 3.8, 'Law and Legal Studies', 'olivia.brown@example.com', 'Criminal Justice', 'justice123', 1, 3, 45, 15, 9),
    --('William', 'Martin', 3.7, 'Applied Sciences and Arts', 'william.martin@example.com', 'Chemistry', 'lab456', 1, 4, 60, 20, 10),
    --('Emily', 'Wilson', 3.2, 'Engineering and Materials Science', 'emily.wilson@example.com', 'Civil Engineering', 'structures789', 0, 3, 45, 18, 1),
    --('Matthew', 'Anderson', 3.9, 'Management Technology', 'matthew.anderson@example.com', 'Supply Chain Management', 'logistics101', 1, 4, 158, 34, 2),
    --('Ava', 'Taylor', 3.6, 'Pharmacy and Biotechnology', 'ava.taylor@example.com', 'Biotechnology', 'biolab789', 1, 3, 45, 15, 3),
    --('Jackson', 'Davis', 3.4, 'Media Engineering and Technology', 'jackson.davis@example.com', 'Broadcasting', 'broadcast456', 0, 2, 36, 10, 4),
    --('Scarlett', 'Hill', 3.8, 'Information Engineering and Technology', 'scarlett.hill@example.com', 'Information Technology', 'techwiz123', 1, 3, 45, 15, 5);
    ('John', 'Doe', 3.8, 'Law and Legal Studies', 'john.doe@example.com', 'MET', 'securepass123', 1, 3, 45, 15),
    ('Jane', 'Smith', 3.5, 'Applied Sciences and Arts', 'jane.smith@example.com', 'Biology', 'strongpass456', 0, 2, 34, 10),
    ('Alice', 'Johnson', 3.9, 'Management Technology', 'alice.johnson@example.com', 'MET', 'topsecret789', 1, 4, 60, 20),
    ('Bob', 'Anderson', 3.2, 'Engineering and Materials Science', 'bob.anderson@example.com', 'Mechanical Engineering', 'confidential101', 0, 3, 45, 18),
    ('Eva', 'Martinez', 3.7, 'Engineering and Materials Science', 'eva.martinez@example.com', 'Electrical Engineering', 'secretcode202', 1, 4, 60, 22),
    ('Michael', 'Johnson', 3.6, 'Pharmacy and Biotechnology', 'michael.johnson@example.com', 'Pharmacy', 'meds456', 1, 3, 45, 15),
    ('Sophia', 'Garcia', 3.9, 'Media Engineering and Technology', 'sophia.garcia@example.com', 'Digital Media', 'creative789', 1, 4, 60, 20),
    ('Daniel', 'Smith', 3.5, 'Information Engineering and Technology', 'daniel.smith@example.com', 'MET', 'codemaster101', 0, 2, 35, 10),
    ('Olivia', 'Brown', 3.8, 'Law and Legal Studies', 'olivia.brown@example.com', 'Criminal Justice', 'justice123', 1, 3, 45, 15),
    ('William', 'Martin', 3.7, 'Applied Sciences and Arts', 'william.martin@example.com', 'Chemistry', 'lab456', 1, 4, 60, 20),
    ('Emily', 'Wilson', 3.2, 'Engineering and Materials Science', 'emily.wilson@example.com', 'Civil Engineering', 'structures789', 0, 3, 45, 18),
    ('Matthew', 'Anderson', 3.9, 'Management Technology', 'matthew.anderson@example.com', 'Supply Chain Management', 'logistics101', 1, 4, 158, 34),
    ('Ava', 'Taylor', 3.6, 'Pharmacy and Biotechnology', 'ava.taylor@example.com', 'Biotechnology', 'biolab789', 1, 3, 45, 15),
    ('Jackson', 'Davis', 3.4, 'Media Engineering and Technology', 'jackson.davis@example.com', 'Broadcasting', 'broadcast456', 0, 2, 36, 10),
    ('Scarlett', 'Hill', 3.8, 'Information Engineering and Technology', 'scarlett.hill@example.com', 'Information Technology', 'techwiz123', 1, 3, 45, 15);
    
    -- Inserting the first 5 courses with major MET
    INSERT INTO Course ( name, major, is_offered, credit_hours, semester)
    VALUES 
    ('CSEN 102', 'MET', 1, 3, 1),
    ('CHEM 102', 'MET', 1, 3, 1),
    ('PHYS 101', 'MET', 1, 3, 1),
    ('HUMA 101', 'MET', 1, 3, 1),
    ('HUMA 102', 'MET', 1, 3, 1),
    ('MATH 103', 'MET', 1, 3, 1),
    ('MATH 203', 'MET', 1, 3, 2),
    ('PHYS 202', 'MET', 1, 3, 2),
    ('CSEN 202', 'MET', 1, 3, 2),
    ('ELCT 201', 'MET', 1, 3, 2),
    ('EDPT 201', 'MET', 1, 3, 2),
    ('HUMA 201', 'MET', 1, 3, 2),
    ('HUMA 103', 'MET', 1, 3, 1),
    ('MATH 301', 'MET', 1, 3, 3),
    ('ELCT 301', 'MET', 1, 3, 3),
    ('CSEN 301', 'MET', 1, 3, 3),
    ('HUMA 301', 'MET', 1, 3, 3),
    ('ENGD 301', 'MET', 1, 3, 3),
    ('PHYSp 301', 'MET', 1, 3, 3),
    ('PHYSt 301', 'MET', 1, 3, 3),
    ('HUMA 202', 'MET', 1, 3, 2),
    ('CSEN 403', 'MET', 1, 3, 4),
    ('CSIS 402', 'MET', 1, 3, 4),
    ('CSEN 401', 'MET', 1, 3, 4),
    ('ELCT 401', 'MET', 1, 3, 4),
    ('COMM 401', 'MET', 1, 3, 4),
    ('HUMA 401', 'MET', 1, 3, 4),
    ('HUMA 302', 'MET', 1, 3, 3),
    ('MATH 401', 'MET', 1, 3, 4),
    ('CSEN 601', 'MET', 1, 3, 6),
    ('CSEN 602', 'MET', 1, 3, 6),
    ('CSEN 605', 'MET', 1, 3, 6),
    ('MNGT 601', 'MET', 1, 3, 6),
    ('CSEN 603', 'MET', 1, 3, 6),
    ('CSEN 604', 'MET', 1, 3, 6),
    ('DMET 602', 'MET', 1, 3, 6),
    ('MATH 502', 'MET', 1, 3, 5),
    ('DMET 501', 'MET', 1, 3, 5),
    ('CSEN 501', 'MET', 1, 3, 5),
    ('CSEN 503', 'MET', 1, 3, 5),
    ('CSEN 502', 'MET', 1, 3, 5),
    ('HUMA 402', 'MET', 1, 3, 4),
    ('DMET 502', 'MET', 1, 3, 5),
    ('CSEN 701', 'MET', 1, 3, 7),
    ('CSEN 703', 'MET', 1, 3, 7),
    ('CSEN 702', 'MET', 1, 3, 7),
    ('CSEN 704', 'MET', 1, 3, 7),
    ('DMET 901', 'MET', 1, 3, 9),   
    ('CSEN 901', 'MET', 1, 3, 9),
    ('CSEN 903', 'MET', 1, 3, 9),   
    ('CSEN 905', 'MET', 1, 3, 9),
    ('CSEN 906', 'MET', 1, 3, 9),
    ('CSEN 907', 'MET', 1, 3, 9),
    ('CSEN 911', 'MET', 1, 3, 9),
    ('CSEN 910', 'MET', 1, 3, 9),
    ('CSEN 1003', 'MET', 1, 3, 10),
    ('HUMA 1001', 'MET', 1, 3, 10),
    ('CSEN 1001', 'MET', 1, 3, 10),
    ('CSEN 1002', 'MET', 1, 3, 10),
    ('CSEN 1004', 'MET', 1, 3, 10),
    ('CSEN 1005', 'MET', 1, 3, 10),
    ('CSEN 1016', 'MET', 1, 3, 10),
    ('CSEN 1001', 'MET', 1, 3, 10),
    ('CSEN 1002', 'MET', 1, 3, 10),
    ('CSEN 905', 'MET', 1, 3, 9),
    ('CSEN 906', 'MET', 1, 3, 9),
    ('CSEN 907', 'MET', 1, 3, 9),
    ('CSEN 911', 'MET', 1, 3, 9),
    ('CSEN 1004', 'MET', 1, 3, 10),
    ('CSEN 1005', 'MET', 1, 3, 10),
    ('CSEN 910', 'MET', 1, 3, 9),
    ('CSEN 1016', 'MET', 1, 3, 10),
    ('CSEN 1001', 'MET', 1, 3, 10),
    ('CSEN 1002', 'MET', 1, 3, 10),
    ('CSEN 905', 'MET', 1, 3, 9);

    INSERT INTO PreqCourse_course(prerequisite_course_id, course_id)
    VALUES 
    (1, 9),
    (3, 8),
    (8, 20),
    (8, 19),
    (9, 24),
    (14, 29),
    (7, 14),
    (6, 7),
    (39, 30),
    (31, 46),
    (6, 8);

    -- Inserting instructors
    INSERT INTO Instructor (instructor_id, name, email, faculty, office)
    VALUES 
    (1,'Sile Million','smillion0@paginegialle.it','IET','US-TN'),
    (2,'Osbourne Rodger','orodger1@telegraph.co.uk','PHARMACY','PG-MPL'),
    (3,'Phylys Filon','pfilon2@bing.com','BIOTECHNOLOGY','RU-YAN'),
    (4,'Chevy Blackstock','cblackstock3@behance.net','APPLIED ARTS','BR-SP'),
    (5,'Rita Dachey','rdachey4@elpais.com','MECHATRONICS','GB-ENG'),
    (6,'Nettle de Werk','nde5@infoseek.co.jp','BUSINESS INFORMATICS','RU-BA'),
    (7,'Teodorico Barling','tbarling6@feedburner.com','MET','US-AK'),
    (8,'Roseann Bulley','rbulley7@amazon.de','IET','SO-WO'),
    (9,'Clive Frary','cfrary8@boston.com','PHARMACY','TD-CB'),
    (10,'Hersh Duigenan','hduigenan9@squarespace.com','BIOTECHNOLOGY','MS-U-A'),
    (11,'Paule Ramsell','pramsella@amazonaws.com','APPLIED ARTS','CD-KA'),
    (12,'Kelwin Lydden','klyddenb@merriam-webster.com','MECHATRONICS','US-UT'),
    (13,'Giusto Pittle','gpittlec@illinois.edu','BUSINESS INFORMATICS','PY-16'),
    (14,'Grove Brockbank','gbrockbankd@yelp.com','MET','US-MS'),
    (15,'Hagan Kanwell','hkanwelle@ft.com','IET','MG-A'),
    (16,'Lolita Duckels','lduckelsf@studiopress.com','PHARMACY','VN-40'),
    (17,'Noreen Turban','nturbang@myspace.com','BIOTECHNOLOGY','IN-JK'),
    (18,'Myrwyn Furminger','mfurmingerh@networksolutions.com','APPLIED ARTS','TH-16'),
    (19,'Micky Sandeland','msandelandi@kickstarter.com','MECHATRONICS','IN-KA'),
    (20,'Corenda Donne','cdonnej@e-recht24.de','BUSINESS INFORMATICS','US-NE'),
    (21,'Norean Izod','nizodk@spotify.com','MET','PG-SHM'),
    (22,'Piper Shimman','pshimmanl@addthis.com','IET','MN-067'),
    (23,'Brig Lowell','blowellm@hugedomains.com','PHARMACY','US-AK'),
    (24,'Ethelind Bwye','ebwyen@theatlantic.com','BIOTECHNOLOGY','PG-MBA'),
    (25,'Bronson Housby','bhousbyo@odnoklassniki.ru','APPLIED ARTS','MY-13'),
    (26,'Parnell Slyvester','pslyvesterp@zimbio.com','MECHATRONICS','ID-KU'),
    (27,'Francklin Clutten','fcluttenq@com.com','BUSINESS INFORMATICS','BR-BA'),
    (28,'Rriocard Beran','rberanr@vimeo.com','MET','FR-T'),
    (29,'Tripp Dradey','tdradeys@boston.com','IET','VU-PAM'),
    (30,'Rebeca Habard','rhabardt@cisco.com','PHARMACY','MG-A'),
    (31,'Jorey Kohnert','jkohnertu@typepad.com','BIOTECHNOLOGY','US-MN'),
    (32,'Antoine Dugald','adugaldv@altervista.org','APPLIED ARTS','CN-34'),
    (33,'Ailsun Oldrey','aoldreyw@fastcompany.com','MECHATRONICS','AR-C'),
    (34,'Winston Bugdale','wbugdalex@scribd.com','BUSINESS INFORMATICS','AU-NT'),
    (35,'Davey Jamison','djamisony@adobe.com','MET','US-OR'),
    (36,'Ignace Gauson','igausonz@wufoo.com','IET','AR-Q'),
    (37,'Geoffrey Lorenc','glorenc10@wisc.edu','PHARMACY','ID-MU'),
    (38,'Betsey Chaster','bchaster11@rediff.com','BIOTECHNOLOGY','TH-63'),
    (39,'Frieda Northill','fnorthill12@ask.com','APPLIED ARTS','PG-MBA'),
    (40,'Danyette Cords','dcords13@nationalgeographic.com','MECHATRONICS','US-NE'),
    (41,'Carole Jurgenson','cjurgenson14@typepad.com','BUSINESS INFORMATICS','US-AK'),
    (42,'Hewett Ballach','hballach15@wikispaces.com','MET','ID-PA'),
    (43,'Sybyl Romaint','sromaint16@alexa.com','IET','NG-KD'),
    (44,'Yalonda Pidgeley','ypidgeley17@lycos.com','PHARMACY','NI-AS'),
    (45,'Fredra Capaldo','fcapaldo18@squidoo.com','BIOTECHNOLOGY','AU-WA'),
    (46,'Kimmy Witsey','kwitsey19@patch.com','APPLIED ARTS','MM-03'),
    (47,'Ade Dumphry','adumphry1a@accuweather.com','MECHATRONICS','US-AR'),
    (48,'Jeffy Jancso','jjancso1b@adobe.com','BUSINESS INFORMATICS','PG-EPW'),
    (49,'Manuel Dederick','mdederick1c@tinypic.com','MET','CA-BC'),
    (50,'Mycah Elford','melford1d@facebook.com','IET','AR-Y'),
    (51,'Kelcy Thirlwell','kthirlwell1e@oakley.com','PHARMACY','NC-U-A'),
    (52,'Robbi Okill','rokill1f@comcast.net','BIOTECHNOLOGY','MX-TAM'),
    (53,'Anabella Divall','adivall1g@yellowpages.com','APPLIED ARTS','PM-SP'),
    (54,'Meir Wavish','mwavish1h@hud.gov','MECHATRONICS','KI-G'),
    (55,'Rudd Nellies','rnellies1i@whitehouse.gov','BUSINESS INFORMATICS','AO-BGO'),
    (56,'Nata Drewes','ndrewes1j@ow.ly','MET','PG-NIK'),
    (57,'Velvet Hazelby','vhazelby1k@vimeo.com','IET','GB-SCT'),
    (58,'Geoffrey Wethered','gwethered1l@dion.ne.jp','PHARMACY','CA-BC'),
    (59,'Odele Skoyles','oskoyles1m@sbwire.com','BIOTECHNOLOGY','IN-RJ'),
    (60,'Lydia Meldrum','lmeldrum1n@nhs.uk','APPLIED ARTS','SO-BR'),
    (61,'Amelita Signoret','asignoret1o@wufoo.com','MECHATRONICS','IN-MM'),
    (62,'Kendall Crinion','kcrinion1p@goo.ne.jp','BUSINESS INFORMATICS','PG-SHM'),
    (63,'Briana Abramzon','babramzon1q@redcross.org','MET','PT-17'),
    (64,'Regen Gariff','rgariff1r@businesswire.com','IET','US-OR'),
    (65,'Kristos Kleen','kkleen1s@jugem.jp','PHARMACY','IR-19'),
    (66,'Giulia Skyner','gskyner1t@quantcast.com','BIOTECHNOLOGY','KE-900'),
    (67,'Margeaux Polon','mpolon1u@about.com','APPLIED ARTS','GB-SCT'),
    (68,'Benjy Scough','bscough1v@oakley.com','MECHATRONICS','RU-KGN'),
    (69,'Skipton Norcross','snorcross1w@technorati.com','BUSINESS INFORMATICS','NC-U-A'),
    (70,'Zacharias Owenson','zowenson1x@skyrock.com','MET','DE-BW'),
    (71,'Teddie De Blasio','tde1y@bbc.co.uk','IET','ZA-MP'),
    (72,'Elvera Harteley','eharteley1z@guardian.co.uk','PHARMACY','CN-63'),
    (73,'Stormie Gino','sgino20@craigslist.org','BIOTECHNOLOGY','CN-12'),
    (74,'Garrek Sheard','gsheard21@bloomberg.com','APPLIED ARTS','US-CA'),
    (75,'Heindrick Fonso','hfonso22@ask.com','MECHATRONICS','US-AK');

    -- Inserting entries into Instructor_Course
    INSERT INTO Instructor_Course (course_id, instructor_id)
    Values 
    (1,8),
    (2,17),
    (3,42),
    (4,63),
    (5,40),
    (6,3),
    (7,14),
    (8,9),
    (9,10),
    (10,20),
    (11,20),
    (12,65),
    (13,2),
    (14,57),
    (15,61),
    (16,48),
    (17,7),
    (18,47),
    (19,63),
    (20,1),
    (21,10),
    (22,72),
    (23,2),
    (24,14),
    (25,18),
    (26,11),
    (27,54),
    (28,2),
    (29,54),
    (30,50),
    (31,54),
    (32,75),
    (33,44),
    (34,28),
    (35,23),
    (36,31),
    (37,52),
    (38,66),
    (39,61),
    (40,40),
    (41,27),
    (42,48),
    (43,39),
    (44,71),
    (45,52),
    (46,31),
    (47,69),
    (48,63),
    (49,16),
    (50,52),
    (51,52),
    (52,41),
    (53,4),
    (54,71),
    (55,18),
    (56,54),
    (57,70),
    (58,69),
    (59,14),
    (60,18),
    (61,5),
    (62,49),
    (63,19),
    (64,14),
    (65,26),
    (66,24),
    (67,38),
    (68,18),
    (69,40),
    (70,67),
    (71,75),
    (72,69),
    (73,65),
    (74,44),
    (75,19);

    -- Inserting semesters
    INSERT INTO Semester (semester_code, start_date, end_date)
    VALUES
    ('WINTER2021', '2021-12-01', '2021-12-31'),
    ('SPRING2021', '2021-01-15', '2021-05-01'),
    ('SUMMER2021', '2021-06-01', '2021-08-15'),
    ('FALL2021', '2021-09-01', '2021-12-15'),
    ('WINTER2022', '2022-12-15', '2023-01-15'),
    ('SPRING2022', '2022-01-15', '2022-05-01'),
    ('SUMMER2022', '2022-06-01', '2022-08-15'),
    ('FALL2022', '2022-09-01', '2022-12-15'),
    ('WINTER2023', '2023-12-15', '2024-01-15'),
    ('SPRING2023', '2023-01-15', '2023-05-01'),
    ('SUMMER2023', '2023-06-01', '2023-08-15'),
    ('FALL2023', '2023-09-01', '2023-12-15'),
    ('WINTER2024', '2024-12-15', '2025-01-15'),
    ('SPRING2024', '2024-01-15', '2024-05-01'),
    ('SUMMER2024', '2024-06-01', '2024-08-15'),
    ('FALL2024', '2024-09-01', '2024-12-15'),
    ('WINTER2025', '2025-12-15', '2026-01-15'),
    ('SPRING2025', '2025-01-15', '2025-05-01'),
    ('SUMMER2025', '2025-06-01', '2025-08-15'),
    ('FALL2025', '2025-09-01', '2025-12-15'),
    ('WINTER2026', '2026-12-15', '2027-01-15'),
    ('SPRING2026', '2026-01-15', '2026-05-01'),
    ('SUMMER2026', '2026-06-01', '2026-08-15'),
    ('FALL2026', '2026-09-01', '2026-12-15');


    -- Inserting payments for Students
    INSERT INTO Payment (payment_id, amount, n_installments, status, fund_percentage, startdate, deadline, student_id, semester_code) VALUES
    (1, 5000,  1, 'Pending', 50.0,'2023-11-01', '2023-12-01', 01, 'FALL2023'),
    (2, 4800,  12, 'Paid', 40.0,   '2023-11-01', '2024-11-01', 02, 'FALL2023'),
    (3, 5500,  2, 'Pending', 55.0,'2023-09-01', '2023-11-01', 03, 'FALL2023'),
    (4, 6000,  1, 'Paid', 60.0,   '2023-10-25', '2023-11-25', 04, 'FALL2023'),
    (5, 5200,  3, 'Pending', 52.0,'2023-08-01', '2023-11-01', 05, 'FALL2023'),
    (6, 4800, 28, 'Paid', 48.0,   '2023-07-01', '2025-11-01', 06, 'FALL2023'),
    (7, 5300,  17, 'Pending', 53.0,'2023-06-01', '2024-11-01', 07, 'FALL2023'),
    (8, 5800,  22, 'Paid', 58.0,   '2023-01-01', '2024-11-01', 08, 'FALL2023'),
    (9, 5000,  8, 'Pending', 50.0,'2023-03-01', '2023-11-01', 09, 'FALL2023'), 
    (10, 5400, 8, 'Paid', 54.0,   '2023-03-01', '2023-11-01', 10, 'FALL2023'),
    (11, 5600, 8, 'Pending', 56.0,'2023-03-01', '2023-11-01', 11, 'FALL2023'),
    (12, 4900, 8, 'Paid', 49.0,   '2023-03-01', '2023-11-01', 12, 'FALL2023'),
    (13, 5200, 8, 'Pending', 52.0,'2023-03-01', '2023-11-01', 13, 'FALL2023'),
    (14, 5800, 8, 'Paid', 58.0,   '2023-03-01', '2023-11-01', 14, 'FALL2023'),
    (15, 5100, 8, 'Pending', 51.0,'2023-03-01', '2023-11-01', 15, 'FALL2023');

    INSERT INTO Slot (slot_id, day, time, location) VALUES
    (1, 'Monday', '09:00', 'Room A'),
    (2, 'Tuesday', '10:30', 'Room B'),
    (3, 'Wednesday', '13:45', 'Room C'),
    (4, 'Thursday', '15:00', 'Room D'),
    (5, 'Sunday', '11:15', 'Room E'),
    (6, 'Wednesday', '14:30', 'Room F'),
    (7, 'Tuesday', '12:00', 'Room G'),
    (8, 'Thursday', '16:30', 'Room H'),
    (9, 'Saturday', '14:45', 'Room I'),
    (10, 'Wednesday', '16:00', 'Room J'),
    (11, 'Monday', '10:30', 'Room K'),
    (12, 'Tuesday', '13:15', 'Room L'),
    (13, 'Wednesday', '11:45', 'Room M'),
    (14, 'Thursday', '14:00', 'Room N'),
    (15, 'Sunday', '15:30', 'Room O'),
    (16, 'Tuesday', '09:45', 'Room P'),
    (17, 'Thursday', '12:30', 'Room Q'),
    (18, 'Monday', '16:45', 'Room R'),
    (19, 'Saturday', '10:00', 'Room S'),
    (20, 'Wednesday', '15:15', 'Room T');

    INSERT INTO Student_Instructor_Course_Take (student_id, course_id, instructor_id, semester_code, exam_type, grade)
    VALUES
        (01, 01, 01, 'WINTER2023', 'Normal', 'F'),
        (03, 02, 02, 'SPRING2023', 'Normal', 'F'),
        (01, 03, 03, 'WINTER2024', 'Normal', 'F'),
        (03, 04, 04, 'SPRING2024', 'Normal', 'F'),
        (05, 01, 05, 'WINTER2023', 'Normal', 'B'),
        (06, 01, 06, 'WINTER2023', 'Normal', 'C+'),
        (07, 01, 07, 'SPRING2023', 'Normal', 'A'),
        (08, 01, 08, 'SPRING2023', 'Normal', 'B-'),
        (09, 01, 09, 'WINTER2023', 'Normal', 'D'),
        (10, 01, 10, 'WINTER2023', 'Normal', 'A');


    INSERT INTO MakeUp_Exam (date, type, course_id)
    VALUES
        ('2024-01-05 14:00:00', 'First_makeup', 1),
        ('2023-12-01 10:00:00', 'First_makeup', 2),
        ('2024-12-10 09:30:00', 'First_makeup', 3),
        ('2024-12-15 13:45:00', 'First_makeup', 4),
        ('2023-12-20 11:00:00', 'First_makeup', 5),
        ('2023-12-25 15:30:00', 'First_makeup', 6),
        ('2023-12-30 08:45:00', 'First_makeup', 7),
        ('2024-01-04 12:15:00', 'First_makeup', 8),
        ('2024-01-14 14:45:00', 'First_makeup', 10),
        ('2024-01-09 10:30:00', 'Second_makeup', 1),
        ('2023-12-01 10:00:00', 'Second_makeup', 2),
        ('2024-01-09 10:30:00', 'Second_makeup', 3),
        ('2024-01-09 10:30:00', 'Second_makeup', 4);


    Insert INTO Request (advisor_id, comment, course_id, credit_hours, status, student_id, type)
    Values (1, 'no comment, just a test', 3, 4,'pending', 1,'what?')

    END;
go



go
-- 2.1.3
CREATE PROCEDURE DropAllTables
AS
BEGIN

    -- Disable foreign key constraints
    EXEC sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'
   
    DROP TABLE Student_Phone;
    DROP TABLE PreqCourse_course;
    DROP TABLE Instructor_Course;
    DROP TABLE Student_Instructor_Course_Take;
    DROP TABLE Course_Semester;
    DROP TABLE GradPlan_Course;
    DROP TABLE Graduation_Plan;
    DROP TABLE Slot;
    DROP TABLE Request;
    DROP TABLE Exam_Student;
    DROP TABLE MakeUp_Exam;

    DROP TABLE Installment;
    DROP TABLE Payment;

    DROP TABLE Semester;
    DROP TABLE Student;
    DROP TABLE Advisor;
    DROP TABLE Instructor;
    DROP TABLE Course;

     -- Enable foreign key constraints
    EXEC sp_MSforeachtable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL';
END;
go

drop procedure insert_random_values;
exec DropAllTables;
exec CreateAllTables;
exec insert_random_values;

exec AdminAddingSemester
    '09/21/2023',
    '2023-12-30',
    'Fall2029';