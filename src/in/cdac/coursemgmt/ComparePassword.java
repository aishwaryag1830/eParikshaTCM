package in.cdac.coursemgmt;

import in.cdac.acts.connection.DBConnector;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.JSONObject;

@WebServlet({"/ComparePassword"})
public class ComparePassword extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		DBConnector dbConnector = null;
		Connection con = null;
		if (session == null) {
			response.sendRedirect(request.getContextPath() + "/error.jsp");
		} else {
			String strDBDriverClass = session.getAttribute("DBDriverClass").toString();
			String strDBConnectionURL = session.getAttribute("DBConnectionURL").toString();
			String strDBDataBaseName = session.getAttribute("DBDataBaseName").toString();
			String strDBUserName = session.getAttribute("DBUserName").toString();
			String strDBUserPass = session.getAttribute("DBUserPass").toString();
			String strUserId = session.getAttribute("UserId").toString();
			String sExistingPassword = null;
			String sEnteredPassword = null;
			boolean isPasswordSame = false;
			dbConnector = new DBConnector();

			try {
				con = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName, strDBUserName,
						strDBUserPass);
				PreparedStatement pstmt = con
						.prepareStatement("select user_Password from ePariksha_User_Master where user_Id=?");
				pstmt.setLong(1, Long.parseLong(strUserId));
				ResultSet rs = pstmt.executeQuery();
				if (rs.next()) {
					sExistingPassword = rs.getString("user_Password");
				}

				sEnteredPassword = request.getParameter("existingPd");
				if (sExistingPassword.equals(sEnteredPassword)) {
					isPasswordSame = true;
				}

				response.setHeader("Pragma", "no-cache");
				response.setHeader("Cache-Control", "no-cache");
				response.setDateHeader("Expires", 0L);
				response.setContentType("application/json");
				String JSONString = "{\"msg\":" + isPasswordSame + "}";
				JSONObject jsonObject = new JSONObject(JSONString);
				response.getWriter().write(jsonObject.toString());
			} catch (Exception var19) {
				var19.printStackTrace();
			}
		}

	}
}