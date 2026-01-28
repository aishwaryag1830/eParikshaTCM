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

public class AddModule extends HttpServlet {
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
		StringBuilder strSheduleMsg = new StringBuilder("<?xml version='1.0'?>");
		int iMessageCode = 10;
		int iModuleSNo = 0;
		String strModuleName = null;
		HttpSession session = request.getSession(false);
		if (session != null && !session.equals("") && session.getAttribute("DBDriverClass") != null) {
			DBConnector dbConnector = null;
			Connection connection = null;
			PreparedStatement statement = null;
			ResultSet result = null;
			if (request.getParameter("txtModuleName") != null) {
				strModuleName = request.getParameter("txtModuleName").replaceAll("\\b\\s{2,}\\b", " ");
			}

			String strCourseId = null;
			if (session.getAttribute("CourseId") != null) {
				strCourseId = session.getAttribute("CourseId").toString();
			}

			try {
				int iIsModuleFound = 0;
				String strDBDriverClass = session.getAttribute("DBDriverClass").toString();
				String strDBConnectionURL = session.getAttribute("DBConnectionURL").toString();
				String strDBDataBaseName = session.getAttribute("DBDataBaseName").toString();
				String strDBUserName = session.getAttribute("DBUserName").toString();
				String strDBUserPass = session.getAttribute("DBUserPass").toString();
				dbConnector = new DBConnector();
				connection = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName,
						strDBUserName, strDBUserPass);
				statement = connection.prepareStatement(
						"select count(module_Id) from ePariksha_Modules where module_Course_Id=?");
				statement.setInt(1, Integer.parseInt(strCourseId));
				result = statement.executeQuery();
				if (result.next()) {
					iIsModuleFound = result.getInt(1);
				}

				int iModuleInserted;
				if (iIsModuleFound > 0) {
					if (statement != null) {
						statement.close();
					}

					statement = connection.prepareStatement(
							"select module_Name from ePariksha_Modules where module_Name = TRIM(?) and module_Course_Id=?");
					statement.setString(1, strModuleName);
					statement.setInt(1, Integer.parseInt(strCourseId));
					result = statement.executeQuery();
					if (result.next()) {
						iMessageCode = 1;
					} else {
						if (statement != null) {
							statement.close();
						}

						statement = connection.prepareStatement(
								"insert into ePariksha_Modules (module_Id,module_Course_Id,module_Name) select max(cast (module_Id as bigint))+1, ?, TRIM(?) from ePariksha_Modules where module_Course_Id=?");
						statement.setInt(1, Integer.parseInt(strCourseId));
						statement.setString(2, strModuleName);
						statement.setInt(1, Integer.parseInt(strCourseId));
						iModuleInserted = statement.executeUpdate();
						if (statement != null) {
							statement.close();
						}

						if (iModuleInserted > 0) {
							iMessageCode = 0;
						} else {
							iMessageCode = 2;
						}

						statement = connection.prepareStatement(
								"select count(module_Id) from ePariksha_Modules where module_Course_Id=?");
						statement.setInt(1, Integer.parseInt(strCourseId));
						result = statement.executeQuery();
						if (result.next()) {
							iModuleSNo = result.getInt(1);
						}
					}
				} else {
					if (statement != null) {
						statement.close();
					}

					statement = connection.prepareStatement(
							"insert into ePariksha_Modules (module_Id,module_Course_Id,module_Name) values(?, ?, TRIM(?))");
					statement.setLong(1, Long.parseLong(strCourseId + "10"));
					statement.setInt(1, Integer.parseInt(strCourseId));
					statement.setString(3, strModuleName);
					iModuleInserted = statement.executeUpdate();
					if (statement != null) {
						statement.close();
					}

					if (iModuleInserted > 0) {
						iMessageCode = 0;
					} else {
						iMessageCode = 2;
					}

					iModuleSNo = 1;
				}
			} catch (SQLException var23) {
				var23.printStackTrace();
			} finally {
				if (dbConnector != null) {
					dbConnector.closeConnection(connection);
					dbConnector = null;
					connection = null;
				}

			}
		} else {
			iMessageCode = 11;
		}

		strSheduleMsg.append("<addModuleOutput>");
		strSheduleMsg.append("<message>" + iMessageCode + "</message>");
		strSheduleMsg.append("<moduleSNo>" + iModuleSNo + "</moduleSNo>");
		strSheduleMsg.append("<moduleName>" + strModuleName.replace("&", " #38; ") + "</moduleName>");
		strSheduleMsg.append("</addModuleOutput>");
		if (strSheduleMsg != null) {
			response.setContentType("text/xml");
			response.setHeader("Cache-Control", "no-cache");
			response.getWriter().write(strSheduleMsg.toString());
		} else {
			response.setStatus(204);
		}

	}
}