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

public class StudentPRN extends HttpServlet {
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
		StringBuilder strStudentPRN = null;
		if (session != null && !session.equals("") && session.getAttribute("CourseId") != null
				&& !session.getAttribute("CourseId").equals("")) {
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
						"select stud_PRN from ePariksha_Student_Login where stud_Course_Id=? order by stud_PRN");
				statement.setInt(1, Integer.parseInt(strCourseID));
				result = statement.executeQuery();
				strStudentPRN = new StringBuilder(
						"<select name='selectPRN' title='Select Student PRN' style='width: 147px;'>\n");
				strStudentPRN.append("<option vlaue='000'>----Select----</option>\n");

				while (result.next()) {
					String strTemp = result.getString("stud_PRN");
					strStudentPRN.append("<option vlaue='" + strTemp + "' >" + strTemp + "</option>\n");
					strTemp = null;
				}

				strStudentPRN.append("<option vlaue='999' > All </option>\n</select>");
			} catch (SQLException var19) {
				strStudentPRN = null;
				System.out.println(var19.getLocalizedMessage());
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

		if (strStudentPRN != null) {
			response.setContentType("text/html");
			response.setHeader("Cache-Control", "no-cache");
			response.getWriter().write(strStudentPRN.toString());
		} else {
			response.setStatus(204);
		}

	}
}