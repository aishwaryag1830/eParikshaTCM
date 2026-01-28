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

public class DeleteQuestions extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private static String ArrayToString(String[] sSelectedIds) {
		String sTempIds = "";
		String[] var5 = sSelectedIds;
		int var4 = sSelectedIds.length;

		for (int var3 = 0; var3 < var4; ++var3) {
			String sIterator = var5[var3];
			sTempIds = sIterator + "," + sTempIds;
		}

		return sTempIds.substring(0, sTempIds.length() - 1);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession();
		String strDBDriverClass = session.getAttribute("DBDriverClass").toString();
		String strDBConnectionURL = session.getAttribute("DBConnectionURL").toString();
		String strDBDataBaseName = session.getAttribute("DBDataBaseName").toString();
		String strDBUserName = session.getAttribute("DBUserName").toString();
		String strDBUserPass = session.getAttribute("DBUserPass").toString();
		String strCourseId = null;
		String strUserId = null;
		String strModuleID = null;
		String strQuery = null;
		String msg = null;
		Connection connection = null;
		PreparedStatement statement = null;
		DBConnector dbConnector = new DBConnector();
		String[] sSelectedQuestionsForDelete = (String[]) null;
		if (request.getParameter("UserId") != null) {
			strUserId = session.getAttribute("UserId").toString();
		}

		if (session.getAttribute("CourseId") != null) {
			strCourseId = session.getAttribute("CourseId").toString();
		}

		if (session.getAttribute("snSelectedModuleIdForQuestions") != null) {
			strModuleID = session.getAttribute("snSelectedModuleIdForQuestions").toString();
		}

		if (request.getParameter("chkQuestions") != null) {
			sSelectedQuestionsForDelete = request.getParameterValues("chkQuestions");
		}

		try {
			connection = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName,
					strDBUserName, strDBUserPass);
			strQuery = "delete from ePariksha_Exam_Questions where exam_Module_Id=? and  exam_Ques_Id in (select cast(get_selected_question_ids(?) as bigint))";
			statement = connection.prepareStatement(strQuery);
			statement.setLong(1, Long.parseLong(strModuleID));
			statement.setString(2, ArrayToString(sSelectedQuestionsForDelete));
			int exe = statement.executeUpdate();
			if (exe >= 1) {
				msg = "Question deleted.";
				if (session.getAttribute("snSelectedQuestionId") != null) {
					session.removeAttribute("snSelectedQuestionId");
				}

				if (request.getParameter("txtScrollYPositionQuesDiv") != null) {
					session.setAttribute("snScrollMenuDivPosition", request.getParameter("txtScrollYPositionQuesDiv"));
				}

				session.setAttribute("snModeIdentifier", "Add");
			} else {
				msg = "Question deletion failed.";
			}
		} catch (Exception var22) {
			msg = "Question deletion failed.";
			var22.printStackTrace();
		} finally {
			if (dbConnector != null) {
				dbConnector.closeConnection(connection);
				dbConnector = null;
				connection = null;
			}

		}

		session.setAttribute("snMsgQuestions", msg);
		response.sendRedirect(this.getServletContext().getContextPath() + "/Questions.jsp");
	}
}