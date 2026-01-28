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

public class CreateModule extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session != null && !session.equals("")) {
			PreparedStatement pst = null;
			Connection connection = null;
			ResultSet result = null;
			boolean iForSameName = true;
			PrintWriter out = response.getWriter();
			StringBuffer strBuffer = new StringBuffer();
			DBConnector dbConnector = new DBConnector();
			response.setContentType("text/xml");
			response.setHeader("Cache-Control", "no-cache");
			strBuffer.append("<?xml version=\"1.0\"?>\n");
			strBuffer.append("<newmodule>");
			String strDBDriverClass = session.getAttribute("DBDriverClass").toString();
			String strDBConnectionURL = session.getAttribute("DBConnectionURL").toString();
			String strDBDataBaseName = session.getAttribute("DBDataBaseName").toString();
			String strDBUserName = session.getAttribute("DBUserName").toString();
			String strDBUserPass = session.getAttribute("DBUserPass").toString();
			connection = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName,
					strDBUserName, strDBUserPass);
			long lModule_Id = 0L;
			String strModule_Name = null;
			int iCourseId = 0;
			int iModuleCreated = 0;
			if (request.getParameter("txtModuleName") != null) {
				strModule_Name = request.getParameter("txtModuleName").trim();
			}

			if (request.getParameter("txtCourseId") != null) {
				iCourseId = Integer.parseInt(request.getParameter("txtCourseId").trim().toString());
			}

			try {
				pst = connection
						.prepareStatement("SELECT module_Name from ePariksha_Modules where module_Course_Id = ?");
				pst.setInt(1, iCourseId);
				result = pst.executeQuery();

				while (result.next()) {
					if (strModule_Name.equalsIgnoreCase(result.getString("module_Name"))) {
						iForSameName = true;
					}
				}

				if (result != null) {
					result.close();
				}

				if (pst != null) {
					pst.close();
				}

				if (!iForSameName) {
					strBuffer.append("<message>Data already exist</message>");
				} else {
					String strModuleId = null;
					pst = connection.prepareStatement(
							"SELECT max(module_Id) as module_Id from ePariksha_Modules where module_Course_Id = ?");
					pst.setInt(1, iCourseId);
					result = pst.executeQuery();

					while (result.next()) {
						lModule_Id = result.getLong("module_Id");
						if (lModule_Id == 0L) {
							strModuleId = String.valueOf(iCourseId) + "10";
							lModule_Id = Long.parseLong(strModuleId);
						} else {
							++lModule_Id;
						}
					}

					String Query = "Insert into ePariksha_Modules values(DEFAULT, ?,?,?)";
					pst = connection.prepareStatement(Query);
					pst.setLong(1, lModule_Id);
					pst.setInt(2, iCourseId);
					pst.setString(3, strModule_Name);
					iModuleCreated = pst.executeUpdate();
					if (pst != null) {
						pst.close();
					}

					strBuffer.append("<Module>");
					strBuffer.append("<id>" + lModule_Id + "</id>");
					strBuffer.append("<name>" + strModule_Name + "</name>");
					strBuffer.append("</Module>");
					if (iModuleCreated == 1) {
						strBuffer.append("<message>Module is created successfully</message>");
					} else {
						strBuffer.append("<message>Module is not created successfully</message>");
					}
				}
			} catch (SQLException var33) {
				var33.printStackTrace();
			} catch (Exception var34) {
				var34.getMessage();
			} finally {
				try {
					result.close();
					pst.close();
					if (dbConnector != null) {
						dbConnector.closeConnection(connection);
						dbConnector = null;
						connection = null;
					}
				} catch (SQLException var32) {
					var32.printStackTrace();
				}

			}

			strBuffer.append("</newmodule>");
			out.println(strBuffer.toString());
			out.flush();
			out.close();
		} else {
			session = request.getSession(true);
		}

	}
}