package in.cdac.acts;

import in.cdac.acts.connection.DBConnector;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class UpdateStudName extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void init(ServletConfig config) throws ServletException {
		super.init(config);
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		StringBuilder strStudentLoginMsg = null;
		if (session != null && !session.equals("") && request.getParameter("prn") != null
				&& request.getParameter("fname") != null && session.getAttribute("CourseId") != null
				&& !session.getAttribute("CourseId").equals("")) {
			String strStudPRN = request.getParameter("prn");
			String strFName = request.getParameter("fname");
			String strMName = request.getParameter("mname");
			String strLName = request.getParameter("lname");
			String strCourseID = session.getAttribute("CourseId").toString();
			DBConnector dbConnector = null;
			Connection connection = null;
			PreparedStatement statement = null;
			ResultSet result = null;
			String strDBDriverClass = session.getAttribute("DBDriverClass").toString();
			String strDBConnectionURL = session.getAttribute("DBConnectionURL").toString();
			String strDBDataBaseName = session.getAttribute("DBDataBaseName").toString();
			String strDBUserName = session.getAttribute("DBUserName").toString();
			String strDBUserPass = session.getAttribute("DBUserPass").toString();

			try {
				dbConnector = new DBConnector();
				connection = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName,
						strDBUserName, strDBUserPass);
				statement = connection.prepareStatement(
						"update ePariksha_Student_Login set stud_F_Name=TRIM(?) , stud_M_Name=TRIM(?), stud_L_Name=TRIM(?) where stud_PRN=TRIM(?) and stud_Course_Id=?");
				statement.setString(1, strFName.trim());
				statement.setString(2, strMName.trim());
				statement.setString(3, strLName.trim());
				statement.setString(4, strStudPRN.trim());
				statement.setInt(5, Integer.parseInt(strCourseID));
				int iRowAffected = statement.executeUpdate();
				strStudentLoginMsg = new StringBuilder();
				if (iRowAffected > 0) {
					strStudentLoginMsg.append(
							"<font style='color:green;' class='schedule_msg'> Name Changed successfully.</font>");
				} else {
					strStudentLoginMsg.append(
							"<font style='color:red;' class='schedule_msg'> Error occured, Please try again.</font>");
				}
			} catch (SQLException var23) {
				strStudentLoginMsg = null;
				System.out.println(var23.getLocalizedMessage());
			} finally {
				if (dbConnector != null) {
					dbConnector.closeConnection(connection);
					dbConnector = null;
					connection = null;
				}

			}
		} else {
			response.sendRedirect("index.jsp?lgn=2");
		}

		if (strStudentLoginMsg != null) {
			response.setContentType("text/html");
			response.setHeader("Cache-Control", "no-cache");
			response.getWriter().write(strStudentLoginMsg.toString());
		} else {
			response.setStatus(204);
		}

	}
}