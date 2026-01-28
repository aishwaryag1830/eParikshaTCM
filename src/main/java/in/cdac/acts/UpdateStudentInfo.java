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

public class UpdateStudentInfo extends HttpServlet {
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
			String strFirstName = null;
			String strMiddleName = null;
			String strLastName = null;
			String strPass = null;
			StringBuffer strBuffer = new StringBuffer();
			PreparedStatement pst = null;
			Connection connection = null;
			DBConnector dbConnector = null;
			PrintWriter out = response.getWriter();
			response.setHeader("Pragma", "no-cache");
			response.setHeader("Cache-Control", "no-cache");
			response.setDateHeader("Expires", 0L);
			response.setContentType("text/xml");
			if (request.getParameter("studId") != null) {
				strStudId = request.getParameter("studId").trim();
			}

			if (request.getParameter("firstName") != null) {
				strFirstName = request.getParameter("firstName").trim();
			}

			if (request.getParameter("middleName") != null) {
				strMiddleName = request.getParameter("middleName").trim();
			}

			if (request.getParameter("lastName") != null) {
				strLastName = request.getParameter("lastName").trim();
			}

			if (request.getParameter("studPass") != null) {
				strPass = request.getParameter("studPass").trim();
			}

			String strDBDriverClass = session.getAttribute("DBDriverClass").toString();
			String strDBConnectionURL = session.getAttribute("DBConnectionURL").toString();
			String strDBDataBaseName = session.getAttribute("DBDataBaseName").toString();
			String strDBUserName = session.getAttribute("DBUserName").toString();
			String strDBUserPass = session.getAttribute("DBUserPass").toString();
			strBuffer.append("<?xml version=\"1.0\"?>\n");
			strBuffer.append("<Student>");

			try {
				dbConnector = new DBConnector();
				connection = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName,
						strDBUserName, strDBUserPass);
				pst = connection.prepareStatement(
						"UPDATE ePariksha_Student_Login SET stud_F_Name = ? ,stud_M_Name =? ,stud_L_Name = ? ,stud_Password = ? where stud_PRN = ?");
				pst.setString(1, strFirstName);
				pst.setString(2, strMiddleName);
				pst.setString(3, strLastName);
				pst.setString(4, strPass);
				pst.setString(5, strStudId);
				iStudUpdated = pst.executeUpdate();
				switch (iStudUpdated) {
					case 0 :
						strBuffer.append("<message>Student Data is not updated successfully</message>");
						break;
					case 1 :
						strBuffer.append("<message>Student Data is updated successfully</message>");
				}

				strBuffer.append("</Student>");
				out.println(strBuffer.toString());
				out.flush();
				out.close();
			} catch (SQLException var31) {
				var31.printStackTrace();
			} catch (Exception var32) {
				var32.getMessage();
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
				} catch (SQLException var30) {
					var30.printStackTrace();
				}

			}
		}

	}
}