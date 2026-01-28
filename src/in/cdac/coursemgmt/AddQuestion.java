package in.cdac.coursemgmt;

import in.cdac.acts.connection.DBConnector;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AddQuestion extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		HttpSession session = request.getSession(false);
		if (session != null && !session.equals("")) {
			session.removeAttribute("snSelectedQuestionId");
			String strDBDriverClass = session.getAttribute("DBDriverClass").toString();
			String strDBConnectionURL = session.getAttribute("DBConnectionURL").toString();
			String strDBDataBaseName = session.getAttribute("DBDataBaseName").toString();
			String strDBUserName = session.getAttribute("DBUserName").toString();
			String strDBUserPass = session.getAttribute("DBUserPass").toString();
			String strCourseId = null;
			String strUserId = null;
			String strModuleID = null;
			String strTopicId = null;
			String strQuestionStat = null;
			String strOpt1 = null;
			String strOpt2 = null;
			String strOpt3 = null;
			String strOpt4 = null;
			Integer iAns = 0;
			String strQuery = null;
			String msg = null;
			Connection connection = null;
			PreparedStatement statement = null;
			DBConnector dbConnector = new DBConnector();
			if (session.getAttribute("UserId") != null) {
				strUserId = session.getAttribute("UserId").toString();
			}

			if (session.getAttribute("CourseId") != null) {
				strCourseId = session.getAttribute("CourseId").toString();
			}

			if (session.getAttribute("snSelectedModuleIdForQuestions") != null) {
				strModuleID = session.getAttribute("snSelectedModuleIdForQuestions").toString();
			}

			strQuestionStat = request.getParameter("txtquestion").trim();
			strOpt1 = request.getParameter("txtoption1").trim();
			strOpt2 = request.getParameter("txtoption2").trim();
			strOpt3 = request.getParameter("txtoption3").trim();
			strOpt4 = request.getParameter("txtoption4").trim();
			iAns = Integer.parseInt(request.getParameter("txt_ans").trim());

			try {
//				strQuestionStat = Converter.toHTML(strQuestionStat.trim());
//				strOpt1 = Converter.toHTML(strOpt1.trim());
//				strOpt2 = Converter.toHTML(strOpt2.trim());
//				strOpt3 = Converter.toHTML(strOpt3.trim());
//				strOpt4 = Converter.toHTML(strOpt4.trim());
				strQuestionStat = strQuestionStat.trim();
				strOpt1 = strOpt1.trim();
				strOpt2 = strOpt2.trim();
				strOpt3 = strOpt3.trim();
				strOpt4 = strOpt4.trim();
			} catch (Exception var30) {
				System.out.println("Unable to convert to HTML");
				var30.printStackTrace();
			}

			try {
				connection = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName,
						strDBUserName, strDBUserPass);
				strQuery = "insert into ePariksha_Exam_Questions (exam_ques_id, exam_Ques_Text,exam_Option1,exam_Option2,exam_Option3,exam_Option4, exam_Correct_Answer,exam_Module_Id,exam_Course_Id,exam_Ques_Uploaded_By) values(default, '"
						+ strQuestionStat + "','" + strOpt1 + "','" + strOpt2 + "','" + strOpt3 + "','" + strOpt4
						+ "', ?, ?, ?, ?)";
				statement = connection.prepareStatement(strQuery);
				statement.setInt(1, iAns);
				statement.setLong(2, Long.parseLong(strModuleID));
				statement.setInt(3, Integer.parseInt(strCourseId));
				statement.setLong(4, Long.parseLong(strUserId));
				int exe = statement.executeUpdate();
				if (exe == 1) {
					msg = "Question added";
					if (request.getParameter("txtScrollYPositionQuesDiv") != null) {
						session.setAttribute("snScrollMenuDivPosition",
								request.getParameter("txtScrollYPositionQuesDiv"));
					}

					session.setAttribute("snModeIdentifier", "Add");
				} else {
					msg = "Question adding failed.";
				}
			} catch (Exception var29) {
				var29.printStackTrace();
			} finally {
				if (dbConnector != null) {
					dbConnector.closeConnection(connection);
					dbConnector = null;
					connection = null;
				}

			}

			session.setAttribute("snMsgQuestions", msg);
			response.sendRedirect(this.getServletContext().getContextPath() + "/Questions.jsp");
		} else {
			response.sendRedirect(request.getContextPath() + "/error.jsp");
		}

	}
}