package in.cdac.acts;

import in.cdac.acts.connection.DBConnector;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class RemoveSchedule extends HttpServlet {
	private static final long serialVersionUID = 1L;
	ServletContext context = null;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		PrintWriter out = response.getWriter();
		StringBuffer strBuffer = new StringBuffer();
		response.setContentType("text/xml");
		response.setHeader("Cache-Control", "no-cache");
		strBuffer.append("<?xml version=\"1.0\"?>\n");
		strBuffer.append("<ResponseMessage>");
		if (session != null && !session.equals("")) {
			if (request.getParameter("reSche") != null) {
				String strDBDriverClass = session.getAttribute("DBDriverClass").toString();
				String strDBConnectionURL = session.getAttribute("DBConnectionURL").toString();
				String strDBDataBaseName = session.getAttribute("DBDataBaseName").toString();
				String strDBUserName = session.getAttribute("DBUserName").toString();
				String strDBUserPass = session.getAttribute("DBUserPass").toString();
				DBConnector dbConnector = null;
				dbConnector = new DBConnector();
				ResultSet result = null;
				PreparedStatement statement = null;
				String strModuleID = null;
				String iExamSchId = null;
				String tempExamModId = null;
				String[] strModuleAndExamId = new String[2];
				tempExamModId = request.getParameter("reSche").trim();
				strModuleAndExamId = tempExamModId.split(",");
				strModuleID = strModuleAndExamId[0];
				iExamSchId = strModuleAndExamId[1];
				Connection connection = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL,
						strDBDataBaseName, strDBUserName, strDBUserPass);

				try {
					statement = connection
							.prepareStatement("delete from ePariksha_Exam_Schedule where exam_Schedule_Id=?");
					statement.setLong(1, Long.parseLong(iExamSchId));
					statement.executeUpdate();
					if (statement != null) {
						statement.close();
					}

					strBuffer.append("<message>Exam is removed successfully</message>");
					strBuffer.append("</ResponseMessage>");
				} catch (SQLException var23) {
					var23.printStackTrace();
				} finally {
					if (dbConnector != null) {
						dbConnector.closeConnection(connection);
						dbConnector = null;
						connection = null;
					}

				}

				response.setHeader("Pragma", "no-cache");
				response.setHeader("Cache-Control", "no-cache");
				response.setDateHeader("Expires", 0L);
				out.println(strBuffer.toString());
				out.flush();
				out.close();
			}
		} else {
			session = request.getSession(true);
		}

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	}
}