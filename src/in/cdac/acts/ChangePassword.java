package in.cdac.acts;

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

public class ChangePassword extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = null;
		session = request.getSession(true);
		if (session == null) {
			response.sendRedirect(request.getContextPath() + "/error.jsp");
		} else {
			StringBuffer strBuffer = new StringBuffer();
			PreparedStatement pst = null;
			ResultSet rst = null;
			Connection connection = null;
			String sCourseId = null;
			PrintWriter out = response.getWriter();
			response.setContentType("text/xml");
			response.setHeader("Cache-Control", "no-cache");
			strBuffer.append("<?xml version=\"1.0\"?>\n");
			strBuffer.append("<StudentInfo>");
			if (session.getAttribute("CourseId") != null) {
				sCourseId = session.getAttribute("CourseId").toString();
			}

			String strDBDriverClass = session.getAttribute("DBDriverClass").toString();
			String strDBConnectionURL = session.getAttribute("DBConnectionURL").toString();
			String strDBDataBaseName = session.getAttribute("DBDataBaseName").toString();
			String strDBUserName = session.getAttribute("DBUserName").toString();
			String strDBUserPass = session.getAttribute("DBUserPass").toString();
			DBConnector dbConnector = new DBConnector();

			try {
				connection = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName,
						strDBUserName, strDBUserPass);
				pst = connection.prepareStatement(
						"Select stud_PRN,stud_Password,stud_F_Name,stud_M_Name,stud_L_Name from ePariksha_Student_Login where stud_Course_Id = ? ");
				pst.setInt(1, Integer.parseInt(sCourseId));

				for (rst = pst.executeQuery(); rst.next(); strBuffer.append("</Student>")) {
					strBuffer.append("<Student>");
					strBuffer.append("<stud_PRN>" + rst.getString("stud_PRN") + "</stud_PRN>");
					strBuffer.append("<stud_Pass>" + rst.getString("stud_Password") + "</stud_Pass>");
					strBuffer.append("<stud_F_Name>" + rst.getString("stud_F_Name") + "</stud_F_Name>");
					if (!rst.getString("stud_M_Name").toString().equalsIgnoreCase((String) null)
							&& !rst.getString("stud_M_Name").toString().equalsIgnoreCase("")
							&& !rst.getString("stud_M_Name").toString().equalsIgnoreCase(" ")) {
						strBuffer.append("<stud_M_Name>" + rst.getString("stud_M_Name") + "</stud_M_Name>");
					} else {
						strBuffer.append("<stud_M_Name>@</stud_M_Name>");
					}

					if (!rst.getString("stud_L_Name").toString().equalsIgnoreCase((String) null)
							&& !rst.getString("stud_L_Name").toString().equalsIgnoreCase("")
							&& !rst.getString("stud_M_Name").toString().equalsIgnoreCase(" ")) {
						strBuffer.append("<stud_L_Name>" + rst.getString("stud_L_Name") + "</stud_L_Name>");
					} else {
						strBuffer.append("<stud_L_Name>@</stud_L_Name>");
					}
				}

				if (rst != null) {
					rst.close();
				}

				if (pst != null) {
					pst.close();
				}
			} catch (SQLException var21) {
				var21.printStackTrace();
			} catch (Exception var22) {
				var22.getMessage();
			} finally {
				if (dbConnector != null) {
					dbConnector.closeConnection(connection);
					dbConnector = null;
					connection = null;
				}

			}

			strBuffer.append("</StudentInfo>");
			out.println(strBuffer.toString());
			out.flush();
			out.close();
		}

	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	}
}