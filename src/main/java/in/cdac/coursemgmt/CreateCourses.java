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

public class CreateCourses extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session != null && !session.equals("")) {
			int iCourseCreated = 0;
			int iForSameName = 0;
			StringBuffer strBuffer = new StringBuffer();
			PreparedStatement pst = null;
			Connection connection = null;
			ResultSet result = null;
			PrintWriter out = response.getWriter();
			response.setContentType("text/xml");
			response.setHeader("Cache-Control", "no-cache");
			strBuffer.append("<?xml version=\"1.0\"?>\n");
			strBuffer.append("<newcourse>");
			String strDBDriverClass = session.getAttribute("DBDriverClass").toString();
			String strDBConnectionURL = session.getAttribute("DBConnectionURL").toString();
			String strDBDataBaseName = session.getAttribute("DBDataBaseName").toString();
			String strDBUserName = session.getAttribute("DBUserName").toString();
			String strDBUserPass = session.getAttribute("DBUserPass").toString();
			DBConnector dbConnector = new DBConnector();

			try {
				connection = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName,
						strDBUserName, strDBUserPass);
				int iCourse_Id = 0;
				long lCourse_Created_By = 0L;
				long lcourse_CC_Id = 0L;
				String strCourse_Name = null;
				String real_Course = null;
				String strCourse_Short_Name = null;
				String strDate = null;
				if (session.getAttribute("UserId") != null) {
					lCourse_Created_By = Long.parseLong(session.getAttribute("UserId").toString().trim());
				}

				if (request.getParameter("txtCourseName") != null) {
					strCourse_Name = request.getParameter("txtCourseName").trim();
					if (strCourse_Name.length() > 100) {
						real_Course = strCourse_Name.substring(0, 100) + "...";
					} else {
						real_Course = strCourse_Name;
					}
				}

				if (request.getParameter("txtCourseShortName") != null) {
					strCourse_Short_Name = request.getParameter("txtCourseShortName").trim();
				}

				if (request.getParameter("txtDate") != null) {
					strDate = request.getParameter("txtDate").trim();
				}

				pst = connection.prepareStatement(
						"select module_Id from ePariksha_Modules where to_char(now(), 'DD-MM-YYYY') > to_char(?::date, 'DD-MM-YYYY')",
						1004, 1007);
				pst.setString(1, strDate);
				result = pst.executeQuery();
				if (result.first()) {
					iForSameName = 2;
					result.beforeFirst();
				}

				if (result != null) {
					result.close();
				}

				if (pst != null) {
					pst.close();
				}

				if (iForSameName != 2) {
					pst = connection.prepareStatement("SELECT Course_Name,Course_Short_Name from ePariksha_Courses");
					result = pst.executeQuery();

					label266 : while (true) {
						do {
							if (!result.next()) {
								if (result != null) {
									result.close();
								}

								if (pst != null) {
									pst.close();
								}
								break label266;
							}
						} while (!strCourse_Name.equalsIgnoreCase(result.getString("course_Name"))
								&& !strCourse_Short_Name.equalsIgnoreCase(result.getString("course_Short_Name")));

						iForSameName = 1;
					}
				}

				if (iForSameName == 0) {
					String Query = "Insert into ePariksha_Courses values(DEFAULT,TRIM(?),TRIM(?),?,?,?::date)";
					pst = connection.prepareStatement(Query);
					pst.setString(1, strCourse_Name);
					pst.setString(2, strCourse_Short_Name);
					pst.setLong(3, lcourse_CC_Id);
					pst.setLong(4, lCourse_Created_By);
					pst.setString(5, strDate);
					iCourseCreated = pst.executeUpdate();
					if (pst != null) {
						pst.close();
					}

					pst = connection.prepareStatement("select max(course_Id) as course_Id from ePariksha_Courses");
					result = pst.executeQuery();
					if (result.next()) {
						iCourse_Id = result.getInt("course_Id");
					}

					strBuffer.append("<course>");
					strBuffer.append("<id>" + iCourse_Id + "</id>");
					strBuffer.append("<title>" + strCourse_Name + "</title>");
					strBuffer.append("<name>" + real_Course + "</name>");
					strBuffer.append("<shortname>" + strCourse_Short_Name + "</shortname>");
					strBuffer.append("<date>" + strDate + "</date>");
					strBuffer.append("</course>");
				}

				if (iForSameName == 0) {
					if (iCourseCreated == 1) {
						strBuffer.append("<message>Course is created successfully</message>");
					} else {
						strBuffer.append("<message>Course is not created successfully</message>");
					}
				} else if (iForSameName == 1) {
					strBuffer.append("<message>Data already exist</message>");
				} else {
					strBuffer.append("<message>Date must be greater than today's date </message>");
				}

				strBuffer.append("</newcourse>");
			} catch (SQLException var37) {
				var37.printStackTrace();
			} catch (Exception var38) {
				var38.getMessage();
			} finally {
				try {
					result.close();
					pst.close();
					if (dbConnector != null) {
						dbConnector.closeConnection(connection);
						dbConnector = null;
						connection = null;
					}
				} catch (SQLException var36) {
					var36.printStackTrace();
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