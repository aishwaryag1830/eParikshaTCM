package in.cdac.acts;

import in.cdac.acts.connection.DBConnector;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class UpdateSchedule extends HttpServlet {
	private static final long serialVersionUID = 1L;
	ServletContext context = null;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		PrintWriter out = response.getWriter();
		StringBuffer strBuffer = new StringBuffer();
		response.setContentType("text/xml");
		response.setHeader("Cache-Control", "no-cache");
		strBuffer.append("<?xml version=\"1.0\"?>\n");
		strBuffer.append("<ResponseMessage>");
		System.out.println("hi" + request.getParameter("schdate"));
		if (session != null && !session.equals("")) {
			if (request.getParameter("schdate") != null) {
				System.out.println("hi" + request.getParameter("schdate"));
				String strDBDriverClass = session.getAttribute("DBDriverClass").toString();
				String strDBConnectionURL = session.getAttribute("DBConnectionURL").toString();
				String strDBDataBaseName = session.getAttribute("DBDataBaseName").toString();
				String strDBUserName = session.getAttribute("DBUserName").toString();
				String strDBUserPass = session.getAttribute("DBUserPass").toString();
				String strQuery = null;
				DBConnector dbConnector = null;
				Connection connection = null;
				PreparedStatement statementUpdate = null;
				PreparedStatement state = null;
				ResultSet res = null;
				String strDate = null;
				String[] strModuleAndExamId = new String[2];
				String tempExamModId = null;
				boolean bExamStatus = false;
				boolean bExamResult = false;
				int iExmDur = 0;
				int iExmQ = 0;
				int iTotalQ = 0;
				int iMinPassingMarks = 0;
				String strModuleID = null;
				String iExamSchId = null;
				String strCourseId = null;
				System.out.println(request.getParameter("ExamStatus"));
				System.out.println(request.getParameter("ExamResult"));
				String strUserID = session.getAttribute("UserId").toString();
				iExmDur = Integer.parseInt(request.getParameter("duration").trim());
				iExmQ = Integer.parseInt(request.getParameter("questions").trim());
				strDate = request.getParameter("schdate").trim();
				if (session.getAttribute("CourseId") != null) {
					strCourseId = session.getAttribute("CourseId").toString();
				}

				if (strDate.contains("-")) {
					strDate = strDate.replaceAll("-", "/");
				}

				if (request.getParameter("ExamStatus").equalsIgnoreCase("Active")) {
					bExamStatus = true;
				}

				if (request.getParameter("ExamResult").equalsIgnoreCase("Yes")) {
					bExamResult = true;
				}

				iMinPassingMarks = Integer.parseInt(request.getParameter("MinPassingMarks").trim());
				tempExamModId = request.getParameter("examAndmodID").trim();
				strModuleAndExamId = tempExamModId.split(",");
				strModuleID = strModuleAndExamId[0];
				iExamSchId = strModuleAndExamId[1];
				System.out.println(
						"iExmDur " + iExmDur + "iExmQ " + iExmQ + "strDate " + strDate + " iExamSchId " + iExamSchId);

				try {
					dbConnector = new DBConnector();
					connection = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName,
							strDBUserName, strDBUserPass);
					state = connection.prepareStatement(
							"SELECT count(exam_Ques_Id)FROM ePariksha_Exam_Questions where exam_Module_Id =? and exam_Course_Id=?");
					state.setLong(1, Long.parseLong(strModuleID));
					state.setInt(2, Integer.parseInt(strCourseId));

					for (res = state.executeQuery(); res.next(); iTotalQ = res.getInt(1)) {
						;
					}

					if (state != null) {
						state.close();
					}

					System.out.println("iTotalQ " + iTotalQ);
					if (iTotalQ >= iExmQ) {
						//strQuery = "update ePariksha_Exam_Schedule SET exam_Date=to_char(?::date, 'DD-MM-YYYY') ,exam_Time_Duration=TRIM(?),exam_No_Of_Ques=TRIM(?) ,exam_Status=TRIM(?),exam_ShowResult=TRIM(?), exam_Min_Passing_Marks=TRIM(?) where exam_Schedule_Id=?";
						strQuery = "update ePariksha_Exam_Schedule SET exam_Date=(?::date) ,exam_Time_Duration=?,exam_No_Of_Ques=?,exam_Status=?,exam_ShowResult=?, exam_Min_Passing_Marks=? where exam_Schedule_Id=?";
						statementUpdate = connection.prepareStatement(strQuery);
						statementUpdate.setString(1, strDate);
						statementUpdate.setInt(2, iExmDur);
						statementUpdate.setInt(3, iExmQ);
						statementUpdate.setBoolean(4, bExamStatus);
						statementUpdate.setBoolean(5, bExamResult);
						statementUpdate.setInt(6, iMinPassingMarks);
						statementUpdate.setLong(7, Long.parseLong(iExamSchId));
						statementUpdate.executeUpdate();
						strBuffer.append("<message>Exam is updated successfully</message>");
					} else {
						strBuffer.append("<message>Question Bank insufficient</message>");
					}

					strBuffer.append("</ResponseMessage>");
				} catch (SQLException var34) {
					var34.printStackTrace();
				} finally {
					if (dbConnector != null) {
						dbConnector.closeConnection(connection);
						dbConnector = null;
						connection = null;
					}

				}

				response.setHeader("Pragma", "no-cache");
				response.setHeader("Cache-Control", "no-cache");
				response.setDateHeader("Expires", 0L);
				out.println(strBuffer.toString());
				out.flush();
				out.close();
			}
		} else {
			session = request.getSession(true);
		}

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	}
}