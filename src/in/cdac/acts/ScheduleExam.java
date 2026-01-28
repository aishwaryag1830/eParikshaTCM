package in.cdac.acts;

import in.cdac.acts.connection.DBConnector;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class ScheduleExam extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void init(ServletConfig config) throws ServletException {
		super.init(config);
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		String strRedirectionURL = null;
		if (session != null && !session.equals("")) {
			boolean bExamStatus = false;
			boolean bExamResult = false;
			int iTimeDuration = 0;
			int iNoOfQuestion = 0;
			int iQues = 0;
			int iPassingMarks = 0;
			String strUserId = null;
			String strCourseId = null;
			String strModuleId = null;
			String strExamDate = null;
			if (session.getAttribute("UserId") != null) {
				strUserId = session.getAttribute("UserId").toString();
			}

			if (session.getAttribute("CourseId") != null) {
				strCourseId = session.getAttribute("CourseId").toString();
			}

			if (request.getParameter("txtModule") != null) {
				strModuleId = request.getParameter("txtModule").trim();
			}

			strExamDate = request.getParameter("txtDate").trim();
			if (strExamDate.contains("-")) {
				strExamDate = strExamDate.replaceAll("-", "/");
			}

			iTimeDuration = Integer.parseInt(request.getParameter("txtExamDur").trim());
			iPassingMarks = Integer.parseInt(request.getParameter("hidPassingMark").trim());
			if (request.getParameter("txtExamQ") != null) {
				iNoOfQuestion = Integer.parseInt(request.getParameter("txtExamQ"));
			} else {
				iNoOfQuestion = 0;
			}

			if (request.getParameter("hidExamStatus").equalsIgnoreCase("Active")) {
				bExamStatus = true;
			}

			if (request.getParameter("hidExamResult").trim().equalsIgnoreCase("Yes")) {
				System.out.println(request.getParameter("hidExamResult").trim());
				bExamResult = true;
			}

			if (strUserId != null && strCourseId != null && strModuleId != null && strExamDate != null) {
				DBConnector dbConnector = null;
				Connection connection = null;
				PreparedStatement statement = null;
				ResultSet result = null;

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
							"select exam_Course_Id from ePariksha_Exam_Schedule where exam_Course_Id=? and exam_Module_Id=? and to_char(exam_Date, 'DD-MM-YYYY') like to_char(?::date, 'DD-MM-YYYY')",
							1005, 1007);
					statement.setInt(1, Integer.parseInt(strCourseId));
					statement.setLong(2, Long.parseLong(strModuleId));
					statement.setString(3, strExamDate);
					result = statement.executeQuery();
					if (result.next()) {
						strRedirectionURL = "/ScheduleExam.jsp";
						session.setAttribute("fg", "1");
					} else {
						if (statement != null) {
							statement.close();
						}

						statement = connection.prepareStatement(
								"SELECT count(exam_Ques_Id)FROM ePariksha_Exam_Questions where exam_Module_Id =? and exam_Course_Id=?");
						statement.setLong(1, Long.parseLong(strModuleId));
						statement.setInt(2, Integer.parseInt(strCourseId));

						for (result = statement.executeQuery(); result.next(); iQues = result.getInt(1)) {
							;
						}

						if (strCourseId != null && strModuleId != null && strExamDate != null && iNoOfQuestion != 0
								&& iTimeDuration != 0 && strUserId != null) {
							if (iQues >= iNoOfQuestion) {
								statement = connection.prepareStatement(
										"insert into ePariksha_Exam_Schedule(exam_Course_Id, exam_Module_Id, exam_Date, exam_No_Of_Ques, exam_Is_Time_Bound, exam_Time_Duration, exam_Scheduled_By, exam_Status, exam_ShowResult, exam_Min_Passing_Marks)values(?,?,?::date,?,?,?,?,?,?,?)");
								statement.setInt(1, Integer.parseInt(strCourseId));
								statement.setLong(2, Long.parseLong(strModuleId));
								statement.setString(3, strExamDate.trim());
								statement.setInt(4, iNoOfQuestion);
								statement.setBoolean(5, true);
								statement.setInt(6, iTimeDuration);
								statement.setLong(7, Long.parseLong(strUserId));
								statement.setBoolean(8, bExamStatus);
								statement.setBoolean(9, bExamResult);
								statement.setInt(10, iPassingMarks);
								statement.executeUpdate();
								strRedirectionURL = "/ScheduleExam.jsp";
								session.setAttribute("fg", "2");
							} else {
								strRedirectionURL = "/ScheduleExam.jsp";
								session.setAttribute("fg", "3");
							}
						}
					}

					if (statement != null) {
						statement.close();
					}
				} catch (SQLException var27) {
					var27.printStackTrace();
				} finally {
					if (dbConnector != null) {
						dbConnector.closeConnection(connection);
						dbConnector = null;
						connection = null;
					}

				}
			}
		}

		response.sendRedirect(request.getContextPath() + strRedirectionURL);
	}
}