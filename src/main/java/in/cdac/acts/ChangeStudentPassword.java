package in.cdac.acts;

import in.cdac.acts.connection.DBConnector;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class ChangeStudentPassword extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session != null && !session.equals("")) {
			int iStudUpdated = 0;
			String strStudId = null;
			String strPassword = null;
			StringBuffer strBuffer = new StringBuffer();
			PreparedStatement pst = null;
			Connection connection = null;
			PrintWriter out = response.getWriter();
			DBConnector dbConnector = null;
			response.setHeader("Pragma", "no-cache");
			response.setHeader("Cache-Control", "no-cache");
			response.setDateHeader("Expires", 0L);
			response.setContentType("text/xml");
			strBuffer.append("<?xml version=\"1.0\"?>\n");
			strBuffer.append("<StudentBlock>");
			String strDBDriverClass = session.getAttribute("DBDriverClass").toString();
			String strDBConnectionURL = session.getAttribute("DBConnectionURL").toString();
			String strDBDataBaseName = session.getAttribute("DBDataBaseName").toString();
			String strDBUserName = session.getAttribute("DBUserName").toString();
			String strDBUserPass = session.getAttribute("DBUserPass").toString();
			if (request.getParameter("StudentIds") != null) {
				strStudId = request.getParameter("StudentIds").toString();
				strStudId = strStudId.substring(0, strStudId.length() - 1);
			}

			if (request.getParameter("strPassword") != null) {
				strPassword = request.getParameter("strPassword").toString();
			}

			try {
				dbConnector = new DBConnector();
				connection = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName,
						strDBUserName, strDBUserPass);
				pst = connection.prepareStatement(
						"UPDATE ePariksha_Student_Login SET stud_Password = ?  where stud_PRN in (" + strStudId + ")");
				pst.setString(1, strPassword);
				iStudUpdated = pst.executeUpdate();
				strBuffer.append(iStudUpdated + "</StudentBlock>");
				out.println(strBuffer.toString());
				out.flush();
				out.close();
			} catch (Exception var26) {
				var26.printStackTrace();
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
				} catch (SQLException var25) {
					var25.printStackTrace();
				}

			}
		}

	}
}