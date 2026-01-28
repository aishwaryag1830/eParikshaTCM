package in.cdac.coursemgmt;

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

public class AddUserToCourse extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session != null && !session.equals("")) {
			StringBuffer strBuffer = new StringBuffer();
			PreparedStatement pst = null;
			Connection connection = null;
			PrintWriter out = response.getWriter();
			response.setContentType("text/xml");
			response.setHeader("Cache-Control", "no-cache");
			strBuffer.append("<?xml version=\"1.0\"?>\n");
			strBuffer.append("<newUser>");
			String strDBDriverClass = session.getAttribute("DBDriverClass").toString();
			String strDBConnectionURL = session.getAttribute("DBConnectionURL").toString();
			String strDBDataBaseName = session.getAttribute("DBDataBaseName").toString();
			String strDBUserName = session.getAttribute("DBUserName").toString();
			String strDBUserPass = session.getAttribute("DBUserPass").toString();
			DBConnector dbConnector = new DBConnector();

			try {
				connection = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName,
						strDBUserName, strDBUserPass);
				long lUserId = 0L;
				long lOldUserId = 0L;
				int iCourse_Id = 0;
				int iUpdated = 0;
				long lCourseId = 0L;
				if (request.getParameter("strCourse") != null) {
					iCourse_Id = Integer.parseInt(request.getParameter("strCourse").trim());
				}

				if (request.getParameter("strUserId") != null) {
					lUserId = Long.parseLong(request.getParameter("strUserId").trim());
				}

				if (request.getParameter("OldUserId") != null) {
					lOldUserId = Long.parseLong(request.getParameter("OldUserId").trim());
				}

				pst = connection
						.prepareStatement("Update ePariksha_User_Master SET user_Course_Id = ? where user_Id =?");
				pst.setInt(1, iCourse_Id);
				pst.setLong(2, lUserId);
				iUpdated = pst.executeUpdate();
				if (pst != null) {
					pst.close();
				}

				pst = connection.prepareStatement("Update ePariksha_Courses SET course_CC_Id = ? where course_Id =?");
				pst.setLong(1, lUserId);
				pst.setInt(2, iCourse_Id);
				iUpdated = pst.executeUpdate();
				if (pst != null) {
					pst.close();
				}

				if (lOldUserId != 0L) {
					pst = connection
							.prepareStatement("Update ePariksha_User_Master SET user_Course_Id = ? where user_Id =?");
					pst.setLong(1, lCourseId);
					pst.setLong(2, lOldUserId);
					iUpdated = pst.executeUpdate();
					if (pst != null) {
						pst.close();
					}
				}

				if (iUpdated == 1) {
					strBuffer.append("<message>User alloted</message>");
				} else {
					strBuffer.append("<message>User is not alloted</message>");
				}

				strBuffer.append("</newUser>");
			} catch (SQLException var26) {
				var26.printStackTrace();
			} catch (Exception var27) {
				var27.getMessage();
			} finally {
				if (dbConnector != null) {
					dbConnector.closeConnection(connection);
					dbConnector = null;
					connection = null;
				}

			}

			out.println(strBuffer.toString());
			out.flush();
			out.close();
		} else {
			session = request.getSession(true);
		}

	}
}