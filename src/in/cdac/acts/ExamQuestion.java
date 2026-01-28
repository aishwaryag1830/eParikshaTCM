package in.cdac.acts;

import in.cdac.acts.connection.DBConnector;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class ExamQuestion extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private int iNoOfQuestions = 0;
	private final int MINRANGE = 0;
	private int iMaxRange = 0;
	private int iRandomQID = 0;
	int[] arrTotalQuestions = null;
	String[] arrExamQuestions = null;

	public void init(ServletConfig config) throws ServletException {
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String strPageToRedirect = "";
		String strQuestionPaper = "";
		HttpSession session = request.getSession(false);
		if (session == null || session.equals("")) {
			strPageToRedirect = "/index.jsp?lgn=2";
		}

		String strFlag = null;
		if (request.getParameter("flag") != null) {
			strFlag = request.getParameter("flag");
		} else {
			strFlag = "0";
		}

		DBConnector dbConnector = null;
		Connection connection = null;
		PreparedStatement statement = null;
		ResultSet result = null;
		String strUserId = null;
		String strModuleId = null;
		String strModuleName = null;
		String strCourseId = null;
		String strTimeDuration = null;
		long lTimeDuration = 0L;
		if (request.getParameter("txtSelectedModuleId") != null) {
			strModuleId = request.getParameter("txtSelectedModuleId");
			session.setAttribute("ModuleId", strModuleId);
		}

		if (request.getParameter("txtSelectedModuleName") != null) {
			strModuleName = request.getParameter("txtSelectedModuleName");
			session.setAttribute("ModuleName", strModuleName);
		}

		if (request.getParameter("txtSubmitSelectedTotalQuestionCount") != null) {
			session.setAttribute("NumberOfQuestion",
					request.getParameter("txtSubmitSelectedTotalQuestionCount").toString());
		}

		if (request.getParameter("txtSubmitSelectedModuleExamDuration") != null) {
			int iDuration = 0;
			iDuration = Integer.parseInt(request.getParameter("txtSubmitSelectedModuleExamDuration").toString());
			session.setAttribute("TimeDuration", iDuration * 60 * 1000);
		}

		if (session.getAttribute("UserId") != null && session.getAttribute("CourseId") != null && strModuleId != null) {
			strPageToRedirect = "/ExamPage.jsp#Q";
			strUserId = session.getAttribute("UserId").toString();
			strCourseId = session.getAttribute("CourseId").toString();
			strModuleId = session.getAttribute("ModuleId").toString();
			if (session.getAttribute("NumberOfQuestion") != null) {
				this.iNoOfQuestions = Integer.parseInt(session.getAttribute("NumberOfQuestion").toString());
			} else {
				this.iNoOfQuestions = 25;
			}

			if (session.getAttribute("TimeDuration") != null) {
				strTimeDuration = session.getAttribute("TimeDuration").toString();
				lTimeDuration = Long.parseLong(strTimeDuration);
			} else {
				strTimeDuration = "";
				lTimeDuration = 0L;
			}

			try {
				String strDBDriverClass = session.getAttribute("DBDriverClass").toString();
				String strDBConnectionURL = session.getAttribute("DBConnectionURL").toString();
				String strDBDataBaseName = session.getAttribute("DBDataBaseName").toString();
				String strDBUserName = session.getAttribute("DBUserName").toString();
				String strDBUserPass = session.getAttribute("DBUserPass").toString();
				dbConnector = new DBConnector();
				connection = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName,
						strDBUserName, strDBUserPass);
				if (strFlag != null && strFlag.equals("2")) {
					long lTimeRemaining = 0L;
					session.removeAttribute("QuestionPaperStream");
					session.removeAttribute("QuestionNumber");
					session.removeAttribute("QuestionId");
					session.removeAttribute("CorrectAnswer");
					statement = connection.prepareStatement(
							"select exam_Paper_Stream,exam_Time_Remaining from ePariksha_Exam_Paper where exam_Stud_PRN =TRIM(?) and exam_Course_Id=? and exam_Module_Id=? and to_char(exam_Date, 'DD-MM-YYYY HH12:MI:SS') like to_char(CURRENT_TIMESTAMP, 'DD-MM-YYYY HH12:MI:SS')",
							1005, 1007);
					statement.setString(1, strUserId);
					statement.setInt(2, Integer.parseInt(strCourseId));
					statement.setLong(3, Long.parseLong(strModuleId));
					result = statement.executeQuery();
					if (result.next()) {
						strQuestionPaper = result.getString("exam_Paper_Stream");
						lTimeRemaining = result.getLong("exam_Time_Remaining");
					}

					if (statement != null) {
						statement.close();
					}

					session.setAttribute("QuestionPaperStream", strQuestionPaper);
					session.setAttribute("QuestionNumber", "1");
					session.setAttribute("TimeStamp", System.currentTimeMillis());
					session.setAttribute("TimeRemaining", lTimeRemaining);
				}

				if (strFlag != null && strFlag.equals("1")) {
					session.removeAttribute("QuestionPaperStream");
					session.removeAttribute("QuestionNumber");
					session.removeAttribute("QuestionId");
					session.removeAttribute("CorrectAnswer");
					statement = connection.prepareStatement(
							"delete from ePariksha_Exam_Paper where exam_Stud_PRN =TRIM(?) and exam_Course_Id=? and exam_Module_Id=?");
					statement.setString(1, strUserId);
					statement.setInt(2, Integer.parseInt(strCourseId));
					statement.setLong(3, Long.parseLong(strModuleId));
					statement.executeUpdate();
					if (statement != null) {
						statement.close();
					}

					statement = connection.prepareStatement(
							"delete from ePariksha_Exam_Mapping where exam_Stud_PRN =TRIM(?) and exam_Module_Id=?");
					statement.setString(1, strCourseId);
					statement.setLong(2, Long.parseLong(strModuleId));
					statement.executeUpdate();
					if (statement != null) {
						statement.close();
					}

					statement = connection.prepareStatement("select exam_Ques_Id from ePariksha_Exam_Questions where exam_Module_Id=? and exam_Course_Id=? order by exam_Ques_Id limit " + this.iNoOfQuestions, 1004, 1007);
					statement.setLong(1, Long.parseLong(strModuleId));
					statement.setInt(2, Integer.parseInt(strCourseId));
					result = statement.executeQuery();
					strQuestionPaper = "";

					for (int iTemp = 0; iTemp < this.iNoOfQuestions; ++iTemp) {
						result.next();
						strQuestionPaper = result.getString("exam_Ques_Id") + "," + strQuestionPaper;
					}

					strQuestionPaper = strQuestionPaper.substring(0, strQuestionPaper.length() - 1);
					strQuestionPaper = strQuestionPaper.trim();
					if (result != null) {
						result.close();
					}

					if (statement != null) {
						statement.close();
					}

					statement = connection.prepareStatement(
							"INSERT INTO ePariksha_Exam_Paper(exam_Stud_PRN, exam_Course_Id, exam_Module_Id, exam_Paper_Stream, exam_Time_Remaining, exam_Date) VALUES (TRIM(?), ?, ?, ?, ?, CURRENT_TIMESTAMP)");
					statement.setString(1, strUserId);
					statement.setInt(2, Integer.parseInt(strCourseId));
					statement.setLong(3, Long.parseLong(strModuleId));
					statement.setString(4, strQuestionPaper.trim());
					statement.setLong(5, lTimeDuration);
					statement.executeUpdate();
					session.setAttribute("QuestionPaperStream", strQuestionPaper);
					session.setAttribute("QuestionNumber", "1");
					session.setAttribute("TimeStamp", System.currentTimeMillis());
					session.setAttribute("TimeRemaining", lTimeDuration);
				}
			} catch (Exception var28) {
				var28.printStackTrace();
			} finally {
				if (dbConnector != null) {
					dbConnector.closeConnection(connection);
					dbConnector = null;
					connection = null;
				}

			}
		} else {
			strPageToRedirect = "/index.jsp?lgn=2";
		}

		response.sendRedirect(request.getContextPath() + strPageToRedirect);
	}
}