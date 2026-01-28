package in.cdac.acts;

import in.cdac.acts.connection.DBConnector;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AdminResetPass extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (request.getParameter("CCID") != null
				&& session.getAttribute("UserRoleId").toString().trim().equals("999")) {
			String strDBDriverClass = session.getAttribute("DBDriverClass").toString();
			String strDBConnectionURL = session.getAttribute("DBConnectionURL").toString();
			String strDBDataBaseName = session.getAttribute("DBDataBaseName").toString();
			String strDBUserName = session.getAttribute("DBUserName").toString();
			String strDBUserPass = session.getAttribute("DBUserPass").toString();
			String strMsg = null;
			String strMsgColor = null;
			Connection connection = null;
			PreparedStatement statement = null;
			DBConnector dbConnector = new DBConnector();
			String strQuery = null;
			String strCCID = request.getParameter("CCID").trim();
			String strDefaultPassword = "cdac123";

			try {
				connection = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName,
						strDBUserName, strDBUserPass);
				strQuery = "UPDATE ePariksha_User_Master SET user_Password = ? WHERE user_ID = ?";
				statement = connection.prepareStatement(strQuery);
				statement.setString(1, strDefaultPassword);
				statement.setLong(2, Long.parseLong(strCCID));
				int exe = statement.executeUpdate();
				if (exe == 1) {
					strMsg = "Done";
					strMsgColor = "green";
				} else {
					strMsg = "Error";
					strMsgColor = "red";
				}

				if (connection != null) {
					connection.close();
				}
			} catch (SQLException var19) {
				var19.printStackTrace();
			}

			response.setContentType("text/xml");
			response.setHeader("Cache-Control", "no-cache");
			response.getWriter().write("<div id=\"tokill\"style=\"color:" + strMsgColor + "\" >" + strMsg + "</div>");
		}

	}
}