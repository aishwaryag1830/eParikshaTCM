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

public class UpdateStudPass extends HttpServlet {
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
				&& request.getParameter("pass") != null && session.getAttribute("CourseId") != null
				&& !session.getAttribute("CourseId").equals("")) {
			String strStudPRN = request.getParameter("prn");
			String strLoginPass = request.getParameter("pass");
			String strQuery = null;
			if (strStudPRN.equalsIgnoreCase("999")) {
				strQuery = "update ePariksha_Student_Login set stud_Password=TRIM(?) where stud_Course_Id=?";
			} else {
				strQuery = "update ePariksha_Student_Login set stud_Password=TRIM(?) where stud_Course_Id=? and stud_PRN=TRIM(?)";
			}

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
				statement = connection.prepareStatement(strQuery);
				statement.setString(1, strLoginPass);
				statement.setInt(2, Integer.parseInt(strCourseID));
				if (!strStudPRN.equalsIgnoreCase("999")) {
					statement.setString(3, strStudPRN);
				}

				int iRowAffected = statement.executeUpdate();
				strStudentLoginMsg = new StringBuilder();
				if (iRowAffected > 0) {
					strStudentLoginMsg.append(
							"<font style='color:green;' class='schedule_msg'> Password has been reset successfully.</font>");
				} else {
					strStudentLoginMsg.append(
							"<font style='color:red;' class='schedule_msg'> Error occured, Please try again.</font>");
				}
			} catch (SQLException var22) {
				strStudentLoginMsg = null;
				System.out.println(var22.getLocalizedMessage());
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