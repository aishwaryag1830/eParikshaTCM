package in.cdac.acts;

import in.cdac.acts.connection.DBConnector;
import in.cdac.acts.connection.DBReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class ModuleExamFinder extends HttpServlet {
	private static final long serialVersionUID = 1L;
	ServletContext context = null;

	public void init(ServletConfig config) throws ServletException {
		super.init(config);
		this.context = config.getServletContext();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session != null && !session.equals("")) {
			if (request.getParameter("idr") != null) {
				String strDate = request.getParameter("idr").trim();
				String strCourseID = session.getAttribute("CourseId").toString();
				String strExamModID = null;
				String strExamID = null;
				String strExamDATE = null;
				boolean bIfExamRunning = false;
				int iExamDuration = 0;
				int iExamQuestion = 0;
				boolean iResultId = false;
				int iMinPassingMarks = 0;
				String strExamModNAME = null;
				String strFeedbackMSG = "ACTS";
				String strTodayDate = null;
				String bExamStatus = "Inactive";
				String bExamResult = "No";
				DateFormat df = new SimpleDateFormat("dd-MM-yyyy");
				Date today = Calendar.getInstance().getTime();
				strTodayDate = df.format(today);
				DBReader dbReader = new DBReader(this.context.getRealPath("Property/DataBase.properties"));
				String strDBDriverClass = dbReader.getDriverClass();
				String strDBConnectionURL = dbReader.getConnectionURL();
				String strDBDataBaseName = dbReader.getDataBaseName();
				String strDBUserName = dbReader.getUserName();
				String strDBUserPass = dbReader.getUserPassword();
				DBConnector dbConnector = null;
				dbConnector = new DBConnector();
				ResultSet resCount = null;
				PreparedStatement stateCount = null;
				Connection connection = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL,
						strDBDataBaseName, strDBUserName, strDBUserPass);
				String strQuery = "SELECT exam_Schedule_Id,exam_Module_Id, to_char(exam_date, 'DD-MM-YYYY'), exam_Time_Duration,exam_No_Of_Ques,module_Name,exam_Status,exam_ShowResult,exam_Min_Passing_Marks FROM ePariksha_Exam_Schedule,ePariksha_Modules where to_char(exam_date, 'DD-MM-YYYY') like to_char(?::date, 'DD-MM-YYYY') and exam_Course_Id=? and ePariksha_Exam_Schedule.exam_Module_Id =ePariksha_Modules.module_Id ";

				try {
					PreparedStatement statement = connection.prepareStatement(strQuery, 1005, 1007);
					statement.setString(1, strDate);
					statement.setInt(2, Integer.parseInt(strCourseID));
					ResultSet result = statement.executeQuery();

					while (true) {
						while (result.next()) {
							strExamID = result.getString(1);
							strExamModID = result.getString(2);
							strExamDATE = result.getString(3);
							iExamDuration = result.getInt(4);
							iExamQuestion = result.getInt(5);
							strExamModNAME = result.getString(6);
							iMinPassingMarks = result.getInt("exam_Min_Passing_Marks");
							if (result.getBoolean("exam_Status")) {
								bExamStatus = "Active";
							} else {
								bExamStatus = "Inactive";
							}

							if (result.getBoolean("exam_ShowResult")) {
								bExamResult = "Yes";
							} else {
								bExamResult = "No";
							}

							if (strFeedbackMSG.equals("ACTS")) {
								strFeedbackMSG = strExamModNAME.concat("@" + strExamDATE);
								strFeedbackMSG = strFeedbackMSG.concat("@" + iExamDuration);
								strFeedbackMSG = strFeedbackMSG.concat("@" + iExamQuestion);
								strFeedbackMSG = strFeedbackMSG.concat("@" + bExamStatus);
								strFeedbackMSG = strFeedbackMSG.concat("@" + bExamResult);
								strFeedbackMSG = strFeedbackMSG.concat("@" + iMinPassingMarks);
								strFeedbackMSG = strFeedbackMSG.concat("@" + strExamModID);
								strFeedbackMSG = strFeedbackMSG.concat("@" + strExamID);
							} else {
								strFeedbackMSG = strFeedbackMSG.concat("@" + strExamModNAME);
								strFeedbackMSG = strFeedbackMSG.concat("@" + strExamDATE);
								strFeedbackMSG = strFeedbackMSG.concat("@" + iExamDuration);
								strFeedbackMSG = strFeedbackMSG.concat("@" + iExamQuestion);
								strFeedbackMSG = strFeedbackMSG.concat("@" + bExamStatus);
								strFeedbackMSG = strFeedbackMSG.concat("@" + bExamResult);
								strFeedbackMSG = strFeedbackMSG.concat("@" + iMinPassingMarks);
								strFeedbackMSG = strFeedbackMSG.concat("@" + strExamModID);
								strFeedbackMSG = strFeedbackMSG.concat("@" + strExamID);
							}

							stateCount = connection.prepareStatement(
									"select result_Stud_PRN from   ePariksha_Results where result_Module_Id=? and result_Course_Id=? and to_char(result_Exam_Date, 'DD-MM-YYYY') like to_char(?::date, 'DD-MM-YYYY') LIMIT 1",
									1005, 1007);
							stateCount.setLong(1, Long.parseLong(strExamModID));
							stateCount.setInt(2, Integer.parseInt(strCourseID));
							stateCount.setString(3, strDate);
							resCount = stateCount.executeQuery();
							if (resCount.next()) {
								iResultId = true;
							} else {
								iResultId = false;
							}

							if (stateCount != null) {
								stateCount.close();
							}

							stateCount = connection.prepareStatement(
									"select exam_Stud_PRN from   ePariksha_Exam_Paper where exam_Module_Id=? and exam_Course_Id=? and to_char(exam_Date, 'DD-MM-YYYY') like to_char(?::date, 'DD-MM-YYYY') LIMIT 1",
									1005, 1007);
							stateCount.setLong(1, Long.parseLong(strExamModID));
							stateCount.setInt(2, Integer.parseInt(strCourseID));
							stateCount.setString(3, strDate);
							resCount = stateCount.executeQuery();
							if (resCount.next()) {
								bIfExamRunning = true;
							} else {
								bIfExamRunning = false;
							}

							if (stateCount != null) {
								stateCount.close();
							}

							if (strTodayDate.equals(strExamDATE) && bIfExamRunning) {
								strFeedbackMSG = strFeedbackMSG.concat("@1");
							} else if (strTodayDate.equals(strExamDATE) && !iResultId) {
								strFeedbackMSG = strFeedbackMSG.concat("@0");
							} else if (strTodayDate != strExamDATE && !iResultId) {
								strFeedbackMSG = strFeedbackMSG.concat("@2");
							} else if (strTodayDate.equals(strExamDATE) && iResultId) {
								strFeedbackMSG = strFeedbackMSG.concat("@1");
							} else if (strTodayDate.equals(strExamDATE) && iResultId) {
								strFeedbackMSG = strFeedbackMSG.concat("@1");
							} else {
								strFeedbackMSG = strFeedbackMSG.concat("@3");
							}
						}

						if (statement != null) {
							statement.close();
						}
						break;
					}
				} catch (SQLException var37) {
					var37.printStackTrace();
					System.out.println("Module exam finder ---strFeedbackMSG"+strFeedbackMSG);
				} finally {
					if (dbConnector != null) {
						dbConnector.closeConnection(connection);
						dbConnector = null;
						connection = null;
						dbReader = null;
					}

				}

				response.setHeader("Pragma", "no-cache");
				response.setHeader("Cache-Control", "no-cache");
				response.setDateHeader("Expires", 0L);
				response.getWriter().write(strFeedbackMSG);
			}
		} else {
			session = request.getSession(true);
		}

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	}
}