package in.cdac.coursemgmt;

import in.cdac.acts.connection.DBConnector;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class UpdateQuestion extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		HttpSession session = request.getSession();
		String strDBDriverClass = session.getAttribute("DBDriverClass").toString();
		String strDBConnectionURL = session.getAttribute("DBConnectionURL").toString();
		String strDBDataBaseName = session.getAttribute("DBDataBaseName").toString();
		String strDBUserName = session.getAttribute("DBUserName").toString();
		String strDBUserPass = session.getAttribute("DBUserPass").toString();
		String strQuestionStat = null;
		String strOpt1 = null;
		String strOpt2 = null;
		String strOpt3 = null;
		String strOpt4 = null;
		Integer iAns = 0;
		String strQID = null;
		String strQuery = null;
		String msg = null;
		Connection connection = null;
		PreparedStatement statement = null;
		DBConnector dbConnector = new DBConnector();
		strQuestionStat = request.getParameter("txtquestion").toString().trim();
		strOpt1 = request.getParameter("txtoption1").trim();
		strOpt2 = request.getParameter("txtoption2").trim();
		strOpt3 = request.getParameter("txtoption3").trim();
		strOpt4 = request.getParameter("txtoption4").trim();
		iAns = Integer.parseInt(request.getParameter("txt_ans").trim());
		strQID = request.getParameter("txt_q_id").trim();

		try {
//			strQuestionStat = Converter.toHTML(strQuestionStat);
//			strOpt1 = Converter.toHTML(strOpt1);
//			strOpt2 = Converter.toHTML(strOpt2);
//			strOpt3 = Converter.toHTML(strOpt3);
//			strOpt4 = Converter.toHTML(strOpt4);
			strQuestionStat =strQuestionStat;
			strOpt1 = strOpt1;
			strOpt2 = strOpt2;
			strOpt3 = strOpt3;
			strOpt4 = strOpt4;
		} catch (Exception var27) {
			System.out.println("Unable to convert to HTML");
			var27.printStackTrace();
		}

		try {
			connection = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName,
					strDBUserName, strDBUserPass);
			strQuery = "update ePariksha_Exam_Questions set exam_Ques_Text=TRIM(?), exam_Option1=TRIM(?), exam_Option2=TRIM(?), exam_Option3=TRIM(?), exam_Option4=TRIM(?), exam_Correct_Answer=? where exam_Ques_Id=?";
			statement = connection.prepareStatement(strQuery);
			statement.setString(1, strQuestionStat.trim());
			statement.setString(2, strOpt1.trim());
			statement.setString(3, strOpt2.trim());
			statement.setString(4, strOpt3.trim());
			statement.setString(5, strOpt4.trim());
			statement.setInt(6, iAns);
			statement.setLong(7, Long.parseLong(strQID));
			int exe = statement.executeUpdate();
			if (exe == 1) {
				msg = "Question updated.";
			} else {
				msg = "Question updating failed.";
			}
		} catch (SQLException var26) {
			var26.printStackTrace();
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