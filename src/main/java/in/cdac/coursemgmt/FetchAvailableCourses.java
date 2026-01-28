package in.cdac.coursemgmt;

import in.cdac.acts.connection.DBConnector;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class FetchAvailableCourses extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session == null) {
			response.sendRedirect(request.getContextPath() + "/error.jsp");
		} else {
			DBConnector dbConnector = new DBConnector();
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet result = null;
			String strDBDriverClass = session.getAttribute("DBDriverClass").toString();
			String strDBConnectionURL = session.getAttribute("DBConnectionURL").toString();
			String strDBDataBaseName = session.getAttribute("DBDataBaseName").toString();
			String strDBUserName = session.getAttribute("DBUserName").toString();
			String strDBUserPass = session.getAttribute("DBUserPass").toString();
			String sql = "SELECT course_Id,course_Name,course_CC_Id as ExaminerId, (select concat(user_F_Name, ' ', user_L_Name) as userName from ePariksha_User_Master where user_Id=ePariksha_Courses.course_CC_Id and user_Role_Id!='999') as userName FROM ePariksha_Courses order by course_Id";
			response.setContentType("text/xml");
			PrintWriter out = response.getWriter();
			StringBuffer responseBuffer = new StringBuffer();

			try {
				con = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName, strDBUserName,
						strDBUserPass);
				pstmt = con.prepareStatement(sql, 1004, 1007);
				result = pstmt.executeQuery();
				responseBuffer.append("<?xml version='1.0'?>");
				responseBuffer.append("<AllCourses>");

				while (result.next()) {
					responseBuffer.append("<Course id=\"" + result.getRow() + "\">");
					responseBuffer.append("<CourseId>" + result.getString("course_Id") + "</CourseId>");
					responseBuffer.append("<CourseName>" + result.getString("course_Name") + "</CourseName>");
					responseBuffer.append("<ExaminerId>" + result.getString("ExaminerId") + "</ExaminerId>");
					responseBuffer.append("<ExaminerName>" + result.getString("userName") + "</ExaminerName>");
					responseBuffer.append("</Course>");
				}

				responseBuffer.append("</AllCourses>");
				out.write(responseBuffer.toString());
				out.flush();
				out.close();
				if (result != null) {
					result.close();
				}

				if (pstmt != null) {
					pstmt.close();
				}
			} catch (SQLException var20) {
				var20.printStackTrace();
			} finally {
				if (dbConnector != null) {
					dbConnector.closeConnection(con);
					dbConnector = null;
					con = null;
				}

			}
		}

	}
}