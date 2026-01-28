package in.cdac.acts;

import in.cdac.acts.connection.DBConnector;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class UpdateProfile extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void init(ServletConfig config) throws ServletException {
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		StringBuilder strPageToRedirect = new StringBuilder();
		HttpSession session = request.getSession(false);
		if (session != null && !session.equals("")) {
			String strUserId = null;
			String strEMailId = null;
			String strMNumber = null;
			if (session.getAttribute("UserId") != null) {
				strUserId = session.getAttribute("UserId").toString();
			}

			if (request.getParameter("txtEMail") != null) {
				strEMailId = request.getParameter("txtEMail");
			}

			if (request.getParameter("txtMNumber") != null) {
				strMNumber = request.getParameter("txtMNumber");
			}

			if (strUserId != null && strEMailId != null && strMNumber != null) {
				strPageToRedirect.append("/CCHome.jsp");
				DBConnector dbConnector = null;
				Connection connection = null;
				PreparedStatement statement = null;

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
							"update ePariksha_User_Master set user_Email_Id =TRIM(?),user_M_Number =TRIM(?) where user_Id=?");
					statement.setString(1, strEMailId);
					statement.setString(2, strMNumber);
					statement.setLong(3, Long.parseLong(strUserId));
					statement.executeUpdate();
					if (statement != null) {
						statement.close();
					}
				} catch (SQLException var19) {
					var19.printStackTrace();
				} finally {
					if (dbConnector != null) {
						dbConnector.closeConnection(connection);
						dbConnector = null;
						connection = null;
					}

				}
			} else {
				strPageToRedirect.append("/index.jsp?lgn=2");
			}
		} else {
			strPageToRedirect.append("/index.jsp?lgn=2");
		}

		response.sendRedirect(request.getContextPath() + strPageToRedirect);
	}
}