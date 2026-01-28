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

public class ExamSaveAnswer extends HttpServlet {
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
		String strPageToRedirect = null;
		HttpSession session = request.getSession(false);
		if (session != null && !session.equals("")) {
			String strUserId = null;
			String strModuleId = null;
			String strCourseId = null;
			String strQuestionId = null;
			String strAnswerGiven = null;
			String strCorrectAnswer = null;
			int iNoOfQuestions = 0;
			String strEndExam = null;
			if (session.getAttribute("UserId") != null && session.getAttribute("ModuleId") != null
					&& session.getAttribute("CourseId") != null) {
				strUserId = session.getAttribute("UserId").toString();
				strModuleId = session.getAttribute("ModuleId").toString();
				strCourseId = session.getAttribute("CourseId").toString();
				if (session.getAttribute("NumberOfQuestion") != null) {
					iNoOfQuestions = Integer.parseInt(session.getAttribute("NumberOfQuestion").toString());
				}

				strEndExam = request.getParameter("txtQNumber");
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
					boolean iQuestionNo;
					int iQuestionCorrected;
					int iQuestionAttempted;
					if (strEndExam != null && strEndExam.equalsIgnoreCase("end")) {
						iQuestionNo = false;
						iQuestionCorrected = 0;
						float fPercentage = 0.0F;
						long lTimeTaken = 0L;
						String sPaperStreamOfStudent = null;
						statement = connection.prepareStatement(
								"select exam_Paper_Stream,exam_Time_Remaining from ePariksha_Exam_Paper where exam_Stud_PRN=TRIM(?) and exam_Module_Id=? and exam_Course_Id=? and to_char(exam_Date, 'DD-MM-YYYY') = to_char(now(), 'DD-MM-YYYY')");
						statement.setString(1, strUserId);
						statement.setLong(2, Long.parseLong(strModuleId));
						statement.setInt(3, Integer.parseInt(strCourseId));
						result = statement.executeQuery();
						if (result.next()) {
							lTimeTaken = result.getLong("exam_Time_Remaining");
							sPaperStreamOfStudent = result.getString("exam_Paper_Stream");
						}

						//sPaperStreamOfStudent = result.getString("exam_Paper_Stream");
						if (result != null) {
							result.close();
						}

						if (statement != null) {
							statement.close();
						}

						statement = connection.prepareStatement(
								"Select tempTable.q_IDs sortedQuesID,exam_Correct_Answer,exam_Answer_Given from ePariksha_Exam_Mapping,(select q_IDs from GET_Selected_Question_Ids(TRIM(?)))tempTable where exam_Ques_Id=tempTable.q_IDs::bigint and exam_Stud_PRN=TRIM(?) and exam_Module_Id=?",
								1004, 1007);
						statement.setString(1, sPaperStreamOfStudent);
						statement.setString(2, strUserId);
						statement.setLong(3, Long.parseLong(strModuleId));
						result = statement.executeQuery();
						result.last();
						iQuestionAttempted = result.getRow();
						result.first();
						StringBuffer sbQuesPaper = new StringBuffer("");

						for (int iTemp = 0; iTemp < iQuestionAttempted; ++iTemp) {
							long lQuesId = result.getLong("sortedQuesID");
							int iCorrectAnswer = result.getInt("exam_Correct_Answer");
							int iAnswerGiven = result.getInt("exam_Answer_Given");
							sbQuesPaper.append(lQuesId + "-" + iAnswerGiven + "-" + iCorrectAnswer + ",");
							if (iCorrectAnswer == iAnswerGiven) {
								++iQuestionCorrected;
							}

							result.next();
						}

						if (iQuestionAttempted > 0) {
							sbQuesPaper.deleteCharAt(sbQuesPaper.length() - 1);
						}

						if (result != null) {
							result.close();
						}

						if (statement != null) {
							statement.close();
						}

						fPercentage = (float) (iQuestionCorrected * 100) / (float) iNoOfQuestions;
						statement = connection.prepareStatement(
								"insert into ePariksha_Results(result_id, result_Stud_PRN, result_Module_Id, result_Course_Id, result_Marks, result_Percentage, result_Exam_Date, result_Details, result_Time_Taken, result_Attempted_Questions) values(DEFAULT, TRIM(?), ?, ?, ?, ?, CURRENT_TIMESTAMP, TRIM(?), ?, ?)");
						statement.setString(1, strUserId);
						statement.setLong(2, Long.parseLong(strModuleId));
						statement.setInt(3, Integer.parseInt(strCourseId));
						statement.setInt(4, iQuestionCorrected);
						statement.setFloat(5, fPercentage);
						statement.setString(6, sbQuesPaper.toString());
						statement.setLong(7, lTimeTaken);
						statement.setLong(8, (long) iQuestionAttempted);
						statement.executeUpdate();
						if (statement != null) {
							statement.close();
						}

						statement = connection.prepareStatement(
								"delete from ePariksha_Exam_Paper where exam_Stud_PRN=TRIM(?) and exam_Module_Id=? and exam_Course_Id=?");
						statement.setString(1, strUserId);
						statement.setLong(2, Long.parseLong(strModuleId));
						statement.setInt(3, Integer.parseInt(strCourseId));
						statement.executeUpdate();
						statement.close();
						statement = connection.prepareStatement(
								"delete from ePariksha_Exam_Mapping where exam_Stud_PRN=TRIM(?) and exam_Module_Id=?");
						statement.setString(1, strUserId);
						statement.setLong(2, Long.parseLong(strModuleId));
						statement.executeUpdate();
						statement = connection.prepareStatement(
								"update ePariksha_Student_Login set stud_Login_Flag='false' where stud_PRN=?");
						statement.setString(1, strUserId);
						statement.executeUpdate();
						session.setAttribute("QuestionAttempet", iQuestionAttempted);
						session.setAttribute("QuestionCorrected", iQuestionCorrected);
						session.setAttribute("Percentage", fPercentage);
						session.removeAttribute("QuestionPaperStream");
						session.removeAttribute("QuestionNumber");
						session.removeAttribute("QuestionId");
						session.removeAttribute("CorrectAnswer");
						strPageToRedirect = "/StudExamResult.jsp";
					} else {
						iQuestionNo = false;
						strQuestionId = session.getAttribute("QuestionId").toString();
						strAnswerGiven = request.getParameter("optRad");
						if (strAnswerGiven != null && !strAnswerGiven.equals("")) {
							strCorrectAnswer = session.getAttribute("CorrectAnswer").toString();
							statement = connection.prepareStatement(
									"update ePariksha_Exam_Mapping set exam_Answer_Given=? where exam_Ques_Id=? and exam_Stud_PRN=TRIM(?) and exam_Module_Id=?");
							statement.setInt(1, Integer.parseInt(strAnswerGiven));
							statement.setLong(2, Long.parseLong(strQuestionId));
							statement.setString(3, strUserId);
							statement.setLong(4, Long.parseLong(strModuleId));
							iQuestionCorrected = statement.executeUpdate();
							if (statement != null) {
								statement.close();
							}

							if (iQuestionCorrected == 0) {
								statement = connection.prepareStatement(
										"insert into ePariksha_Exam_Mapping(exam_Ques_Id, exam_Stud_PRN, exam_Module_Id, exam_Correct_Answer,exam_Answer_Given) values(?,TRIM(?),?,?,?)");
								statement.setLong(1, Long.parseLong(strQuestionId));
								statement.setString(2, strUserId);
								statement.setLong(3, Long.parseLong(strModuleId));
								statement.setInt(4, Integer.parseInt(strCorrectAnswer));
								statement.setInt(5, Integer.parseInt(strAnswerGiven));
								statement.executeUpdate();
							}
						} else {
							System.out.println("Invalid option");
						}

						iQuestionAttempted = Integer.parseInt(session.getAttribute("QuestionNumber").toString());
						if (iQuestionAttempted != iNoOfQuestions) {
							session.setAttribute("QuestionNumber", iQuestionAttempted);
						} else {
							session.setAttribute("QuestionNumber", 1);
						}

						strPageToRedirect = "/ExamPage.jsp#Q";
					}
				} catch (Exception var37) {
					var37.printStackTrace();
					System.out.println("ExamSaveAnswer : "+strUserId +var37.getMessage());
				} finally {
					if (dbConnector != null) {
						dbConnector.closeConnection(connection);
						dbConnector = null;
						connection = null;
					}

				}
			} else {
				strPageToRedirect = "/index.jsp";
			}
		} else {
			strPageToRedirect = "/index.jsp";
		}

		response.sendRedirect(request.getContextPath() + strPageToRedirect);
	}
}