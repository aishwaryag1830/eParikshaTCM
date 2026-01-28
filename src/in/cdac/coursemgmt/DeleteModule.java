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

public class DeleteModule extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session != null && !session.equals("")) {
			PreparedStatement pst = null;
			Connection connection = null;
			PrintWriter out = response.getWriter();
			StringBuffer strBuffer = new StringBuffer();
			response.setContentType("text/xml");
			response.setHeader("Cache-Control", "no-cache");
			strBuffer.append("<?xml version=\"1.0\"?>\n");
			strBuffer.append("<Module>");
			ResultSet rst = null;
			DBConnector dbConnector = new DBConnector();
			String strDBDriverClass = session.getAttribute("DBDriverClass").toString();
			String strDBConnectionURL = session.getAttribute("DBConnectionURL").toString();
			String strDBDataBaseName = session.getAttribute("DBDataBaseName").toString();
			String strDBUserName = session.getAttribute("DBUserName").toString();
			String strDBUserPass = session.getAttribute("DBUserPass").toString();
			connection = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName,
					strDBUserName, strDBUserPass);
			long lmodule_Id = 0L;
			int iCourseId = 0;
			int iModuleDeleted = 0;
			if (request.getParameter("txtModuleId") != null) {
				lmodule_Id = Long.parseLong(request.getParameter("txtModuleId").trim());
			}

			if (request.getParameter("txtModuleId") != null) {
				iCourseId = Integer.parseInt(request.getParameter("txtCourseId").trim());
			}

			try {
				pst = connection.prepareStatement(
						"select exam_Schedule_Id from ePariksha_Exam_Schedule where exam_Module_Id = ? and to_char(exam_Date, 'DD-MM-YYYY') like to_char(now(), 'DD-MM-YYYY')",
						1005, 1007);
				pst.setLong(1, lmodule_Id);
				rst = pst.executeQuery();
				if (rst.first()) {
					iModuleDeleted = 3;
				}

				if (rst != null) {
					rst.close();
				}

				if (pst != null) {
					pst.close();
				}

				if (iModuleDeleted != 3) {
					pst = connection.prepareStatement(
							"select user_Id from ePariksha_User_Master where user_Course_Id = ?", 1005, 1007);
					pst.setInt(1, iCourseId);
					rst = pst.executeQuery();
					if (rst.first()) {
						iModuleDeleted = 2;
					}

					if (rst != null) {
						rst.close();
					}

					if (pst != null) {
						pst.close();
					}

					pst = connection.prepareStatement(
							"select user_Id from ePariksha_User_Master where user_Course_Id = ?", 1005, 1007);
					pst.setInt(1, iCourseId);
					rst = pst.executeQuery();
					if (rst.first()) {
						iModuleDeleted = 2;
					} else {
						if (rst != null) {
							rst.close();
						}

						if (pst != null) {
							pst.close();
						}

						pst = connection.prepareStatement(
								"select course_Name from ePariksha_Courses where course_Id = ? and to_char(course_Validtill_Date, 'DD-MM-YYYY')  < to_char(now(), 'DD-MM-YYYY')",
								1005, 1007);
						pst.setInt(1, iCourseId);
						rst = pst.executeQuery();
						if (rst.first()) {
							iModuleDeleted = 2;
						}
					}

					if (rst != null) {
						rst.close();
					}

					if (pst != null) {
						pst.close();
					}

					if (iModuleDeleted != 2) {
						pst = connection.prepareStatement("delete from ePariksha_Modules where module_Id = ?");
						pst.setLong(1, lmodule_Id);
						iModuleDeleted = pst.executeUpdate();
					}
				}

				switch (iModuleDeleted) {
					case 1 :
						strBuffer.append("<message>Module is deleted successfully</message>");
						break;
					case 2 :
						strBuffer.append("<message>User alloted or Course expired</message>");
						break;
					case 3 :
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
					pst.close();
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