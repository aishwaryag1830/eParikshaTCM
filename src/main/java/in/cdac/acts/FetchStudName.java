package in.cdac.acts;

import in.cdac.acts.connection.DBConnector;
import java.io.IOException;
import java.io.PrintWriter;
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

public class FetchStudName extends HttpServlet {
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
		StringBuilder strStudentPRNmsg = null;
		if (session != null && !session.equals("") && request.getParameter("prn") != null
				&& session.getAttribute("CourseId") != null && !session.getAttribute("CourseId").equals("")) {
			String strCourseID = session.getAttribute("CourseId").toString();
			String strStudentPRN = request.getParameter("prn");
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
						"select stud_F_Name,stud_M_Name,stud_L_Name from ePariksha_Student_Login where stud_PRN=TRIM(?) and stud_Course_Id=?");
				statement.setString(1, strStudentPRN);
				statement.setInt(2, Integer.parseInt(strCourseID));
				result = statement.executeQuery();
				if (result.next()) {
					strStudentPRNmsg = new StringBuilder("<?xml version='1.0'?>\n");
					strStudentPRNmsg.append("<data>\n");
					String strFName = result.getString("stud_F_Name");
					String strMName = result.getString("stud_M_Name");
					String strLName = result.getString("stud_L_Name");
					if (strMName == null) {
						strMName = "";
					}

					if (strLName == null) {
						strLName = "";
					}

					strStudentPRNmsg.append("<fname>" + strFName + "</fname>\n");
					strStudentPRNmsg.append("<mname>" + strMName + "</mname>\n");
					strStudentPRNmsg.append("<lname>" + strLName + "</lname>\n");
					strStudentPRNmsg.append("</data>");
				}
			} catch (SQLException var22) {
				strStudentPRNmsg = null;
				System.out.println(var22.getLocalizedMessage());
			} finally {
				if (dbConnector != null) {
					dbConnector.closeConnection(connection);
					dbConnector = null;
					connection = null;
				}

			}
		} else {
			PrintWriter out = response.getWriter();
			out.write(
					"<html><body><center><div style='margin-top:200px;color:#4682B4;font-size:20pt;font-weight:bolder;'>Unauthorized Access<br/> Click <a href='index.jsp'>here </a> to go to home page.</center></body></html>");
		}

		if (strStudentPRNmsg != null) {
			response.setContentType("text/xml");
			response.setHeader("Cache-Control", "no-cache");
			response.getWriter().write(strStudentPRNmsg.toString());
		} else {
			response.setStatus(204);
		}

	}
}