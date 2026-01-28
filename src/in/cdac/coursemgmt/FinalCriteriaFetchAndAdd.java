package in.cdac.coursemgmt;

import in.cdac.acts.connection.DBConnector;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Types;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class FinalCriteriaFetchAndAdd extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session != null && !session.equals("")) {
			CallableStatement callstmt = null;
			Connection connection = null;
			PrintWriter out = response.getWriter();
			String strModuleIds = null;
			StringBuffer strBuffer = new StringBuffer();
			response.setContentType("text/xml");
			response.setHeader("Cache-Control", "no-cache");
			strBuffer.append("<?xml version=\"1.0\"?>\n");
			strBuffer.append("<Modules>");
			strBuffer.append("<messages>");
			String strDBDriverClass = session.getAttribute("DBDriverClass").toString();
			String strDBConnectionURL = session.getAttribute("DBConnectionURL").toString();
			String strDBDataBaseName = session.getAttribute("DBDataBaseName").toString();
			String strDBUserName = session.getAttribute("DBUserName").toString();
			String strDBUserPass = session.getAttribute("DBUserPass").toString();
			DBConnector dbConnector = null;
			String strModule_Names = null;
			int iCourseId = 0;
			String strModule_Ids = null;
			String iModuleCreated = null;
			if (request.getParameter("strExistingModuleIds") != null) {
				strModule_Ids = request.getParameter("strExistingModuleIds").trim();
			}

			if (request.getParameter("strCourseId") != null) {
				iCourseId = Integer.parseInt(request.getParameter("strCourseId").trim().toString());
			}

			if (request.getParameter("strExistingModuleName") != null) {
				strModule_Names = request.getParameter("strExistingModuleName").trim();
			}

			try {
				dbConnector = new DBConnector();
				connection = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName,
						strDBUserName, strDBUserPass);
				
				callstmt = connection.prepareCall("call AddExisting(?,?,?,?,?)");
				callstmt.setString(1, strModule_Ids);
				callstmt.setString(2, strModule_Names);
				callstmt.setInt(3, iCourseId);
				callstmt.setString(4, iModuleCreated);
				callstmt.setString(5, strModuleIds);
				
				callstmt.registerOutParameter(4, Types.VARCHAR);
				callstmt.registerOutParameter(5, Types.VARCHAR);
				callstmt.execute();
				iModuleCreated = callstmt.getString(4);
				strModuleIds = callstmt.getString(5);
				strModuleIds = strModuleIds.substring(0, strModuleIds.length() - 1);
				
				if (callstmt != null) {
					callstmt.close();
				}
			} catch (SQLException var30) {
				var30.printStackTrace();
			} catch (Exception var31) {
				var31.getMessage();
			} finally {
				try {
					callstmt.close();
					if (dbConnector != null) {
						dbConnector.closeConnection(connection);
						dbConnector = null;
						connection = null;
					}
				} catch (SQLException var29) {
					var29.printStackTrace();
				}

			}

			strBuffer.append(iModuleCreated);
			strBuffer.append("</messages>");
			strBuffer.append("<Ids>");
			strBuffer.append(strModuleIds);
			strBuffer.append("</Ids>");
			strBuffer.append("</Modules>");
			out.println(strBuffer.toString());
			out.flush();
			out.close();
		} else {
			session = request.getSession(true);
		}

	}
}