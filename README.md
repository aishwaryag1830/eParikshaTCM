# ePariksha Application

## Project Title
ePariksha - Exam Management Portal

## Description
The ePariksha portal is designed to streamline the process of conducting exams, with a specific focus on Multiple Choice Questions (MCQs). The application provides a user-friendly interface for examinees, examiners, and administrators, catering to the unique needs and responsibilities of each role. The use of HTML, jQuery, JavaScript, CSS, Java EE, Servlet, JSP, and MS SQL Server ensures a robust and efficient system for exam management.

## Installation
### Database Setup

1. Install PgAdmin on your system.
2. Create a new database for ePariksha.

### Backend Configuration

1. Open the backend project in your preferred Java EE development environment.


### Frontend Configuration

1. Open the frontend files in a text editor or integrated development environment.
2. Adjust any configuration parameters, such as API endpoints, if needed.

### Deployment

1. Deploy the backend on a Java EE server (e.g., Apache Tomcat).
2. Host the frontend files on a web server or integrate them with the backend deployment.
3. Set up the database connection after the application is up and running on server by running the Connection String in the format as specified : 
        
        http://<server-hostname>:8080/<warname>/WriteDBConData?dbip=<db-ip>&dbname=<dbname>&dbuser=postgres&dbpass=<dbpass>&dbport=<dbport>

For Ex:	http://acts-epariksha.pune.cdac.in:8080/ePariksha/WriteDBConData?dbip=10.208.39.205&dbname=ePariksha&dbuser=postgres&dbpass=abcdefgh&dbport=6549


## Usage
### Examinee
1. Log in using the unique ID and password.
2. View and attempt active exams within the specified time duration.

### Examiner

1. Log in using the assigned credentials.
2. Schedule exams for examinees based on modules.
3. Manage student information, modules, and associated questions.
4. Search for exam results based on module and date.
5. Change the password of examinees.

### Admin
1. Log in using admin credentials.
2. Manage course coordinators/users.
3. Add, edit, and reset passwords for course coordinators/users.
4. Manage courses, modules, and examiners.
5. View results for a specific module by selecting course, module, and exam date.
6. View and edit personal details.
7. Switch to the course coordinator/examiner role for a particular course.

## Features

- Role-based dashboards for examinee, examiner, and admin.
- Exam scheduling and management for examiners.
- User authentication with unique IDs and passwords.
- Detailed result analysis for administrators.
- Password management for all roles.
- Dynamic course and module management.

This ePariksha application is designed to enhance the efficiency and organization of the exam conduction process, providing a comprehensive solution for educational institutions and organizations.
