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

public class UpdateModule extends HttpServlet {
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
		String strPageToRedirect = null;
		HttpSession session = request.getSession(false);
		if (session != null && !session.equals("")) {
			DBConnector dbConnector = null;
			Connection connection = null;
			PreparedStatement statement = null;
			ResultSet result = null;
			String strModuleName = null;
			long lModuleId = 0L;
			int iCourseId = 0;
			if (request.getParameter("txtModuleIndex") != null) {
				if (request.getParameter("optModule") != null) {
					lModuleId = Long.parseLong(request.getParameter("optModule"));
				}

				if (session != null && session.getAttribute("CourseId") != null) {
					iCourseId = Integer.parseInt(session.getAttribute("CourseId").toString());
				}

				if (request.getParameter("txtModule" + request.getParameter("txtModuleIndex")) != null) {
					strModuleName = request.getParameter("txtModule" + request.getParameter("txtModuleIndex"))
							.replaceAll("\\b\\s{2,}\\b", " ");
				}
			}

			if (strModuleName != null && !strModuleName.equals("") && lModuleId != 0L && iCourseId != 0) {
				strPageToRedirect = "/UpdateModule.jsp";

				try {
					String strDBDriverClass = session.getAttribute("DBDriverClass").toString();
					String strDBConnectionURL = session.getAttribute("DBConnectionURL").toString();
					String strDBDataBaseName = session.getAttribute("DBDataBaseName").toString();
					String strDBUserName = session.getAttribute("DBUserName").toString();
					String strDBUserPass = session.getAttribute("DBUserPass").toString();
					dbConnector = new DBConnector();
					connection = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName,
							strDBUserName, strDBUserPass);
					statement = connection.prepareStatement(
							"select module_Id from ePariksha_Modules where module_Name=TRIM(?) and module_Course_Id=?");
					statement.setString(1, strModuleName);
					statement.setInt(2, iCourseId);
					result = statement.executeQuery();
					if (result.next()) {
						session.setAttribute("ModuleUpdateMsg",
								"Error! Module with same name already in the course.Please try again.");
						session.setAttribute("UpdateColor", "#FF4500");
					} else {
						if (statement != null) {
							statement.close();
						}

						statement = connection.prepareStatement(
								"update ePariksha_Modules set module_Name=TRIM(?) where module_Id=? and module_Course_Id=?");
						statement.setString(1, strModuleName);
						statement.setLong(2, lModuleId);
						statement.setInt(3, iCourseId);
						int iRowEffected = statement.executeUpdate();
						if (iRowEffected > 0) {
							session.setAttribute("ModuleUpdateMsg", "Module updated Successfully.");
							session.setAttribute("UpdateColor", "#008B8B");
						} else {
							session.setAttribute("ModuleUpdateMsg", "Module update failed.Please try again.");
							session.setAttribute("UpdateColor", "#FF4500");
						}

						if (statement != null) {
							statement.close();
						}
					}
				} catch (SQLException var22) {
					var22.printStackTrace();
				} finally {
					if (dbConnector != null) {
						dbConnector.closeConnection(connection);
						dbConnector = null;
						connection = null;
					}

				}
			} else {
				strPageToRedirect = "/UpdateModule.jsp";
				session.setAttribute("ModuleUpdateMsg", "Module could not be updated due to invalid data provided.");
				session.setAttribute("UpdateColor", "#FF4500");
			}
		} else {
			strPageToRedirect = "/index.jsp?lgn=2";
		}

		response.sendRedirect(request.getContextPath() + strPageToRedirect);
	}
}