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

public class UpdateModule extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session != null && !session.equals("")) {
			int iModuleUpdated = 0;
			long lModuleId = 0L;
			String strModuleName = null;
			StringBuffer strBuffer = new StringBuffer();
			PreparedStatement pst = null;
			ResultSet rst = null;
			Connection connection = null;
			DBConnector dbConnector = null;
			PrintWriter out = response.getWriter();
			response.setHeader("Pragma", "no-cache");
			response.setHeader("Cache-Control", "no-cache");
			response.setDateHeader("Expires", 0L);
			response.setContentType("text/xml");
			if (request.getParameter("txtModuleName") != null) {
				strModuleName = request.getParameter("txtModuleName").trim();
			}

			if (request.getParameter("txtModuleId") != null) {
				lModuleId = Long.parseLong(request.getParameter("txtModuleId").trim());
			}

			String strDBDriverClass = session.getAttribute("DBDriverClass").toString();
			String strDBConnectionURL = session.getAttribute("DBConnectionURL").toString();
			String strDBDataBaseName = session.getAttribute("DBDataBaseName").toString();
			String strDBUserName = session.getAttribute("DBUserName").toString();
			String strDBUserPass = session.getAttribute("DBUserPass").toString();
			strBuffer.append("<?xml version=\"1.0\"?>\n");
			strBuffer.append("<Module>");

			try {
				dbConnector = new DBConnector();
				connection = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName,
						strDBUserName, strDBUserPass);
				pst = connection.prepareStatement(
						"select exam_Schedule_Id from ePariksha_Exam_Schedule where exam_Module_Id = ? and to_char(exam_Date, 'DD-MM-YYY') like to_char(now(), 'DD-MM-YYY')",
						1005, 1007);
				pst.setLong(1, lModuleId);
				rst = pst.executeQuery();
				if (rst.first()) {
					iModuleUpdated = 2;
				}

				if (rst != null) {
					rst.close();
				}

				if (pst != null) {
					pst.close();
				}

				if (iModuleUpdated != 2) {
					pst = connection
							.prepareStatement("UPDATE  ePariksha_Modules SET module_Name =? where module_Id = ?");
					pst.setString(1, strModuleName);
					pst.setLong(2, lModuleId);
					iModuleUpdated = pst.executeUpdate();
				}

				switch (iModuleUpdated) {
					case 0 :
						strBuffer.append("<message>Module is not updated successfully</message>");
						break;
					case 1 :
						strBuffer.append("<message>Module is updated successfully</message>");
						break;
					case 2 :
						strBuffer.append("<message>Exam schedule for this module</message>");
				}

				strBuffer.append("</Module>");
				out.println(strBuffer.toString());
				out.flush();
				out.close();
			} catch (SQLException var30) {
				var30.printStackTrace();
			} catch (Exception var31) {
				var31.getMessage();
			} finally {
				try {
					if (pst != null) {
						pst.close();
					}

					if (dbConnector != null) {
						dbConnector.closeConnection(connection);
						dbConnector = null;
						connection = null;
					}
				} catch (SQLException var29) {
					var29.printStackTrace();
				}

			}
		} else {
			session = request.getSession(true);
		}

	}
}