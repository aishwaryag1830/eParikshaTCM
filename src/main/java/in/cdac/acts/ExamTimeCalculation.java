package in.cdac.acts;

import in.cdac.acts.connection.DBConnector;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class ExamTimeCalculation extends HttpServlet {
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
		if (session != null && !session.equals("")) {
			long lRequestCounter = 0L;
			long lTimeStamp = 0L;
			long lTimeRemaining = 0L;
			long lCurrentTime = 0L;
			long SECOND = 1000L;
			long MINUTE = 60000L;
			long lTimeSpent = 0L;
			long lDifInHr = 0L;
			long lDifInMins = 0L;
			long lDifInSecs = 0L;
			String strTime = null;
			String strUserId = null;
			String strCourseId = null;
			String strModuleId = null;
			if (session.getAttribute("RequestCounter") != null) {
				lRequestCounter = Long.parseLong(session.getAttribute("RequestCounter").toString());
			} else {
				lRequestCounter = 0L;
			}

			if (session.getAttribute("TimeStamp") != null) {
				lTimeStamp = Long.parseLong(session.getAttribute("TimeStamp").toString());
			} else {
				lTimeStamp = 0L;
			}

			if (session.getAttribute("TimeRemaining") != null) {
				lTimeRemaining = Long.parseLong(session.getAttribute("TimeRemaining").toString());
			} else {
				lTimeRemaining = 0L;
			}

			strUserId = session.getAttribute("UserId").toString();
			strCourseId = session.getAttribute("CourseId").toString();
			strModuleId = session.getAttribute("ModuleId").toString();
			lCurrentTime = System.currentTimeMillis();
			if (lTimeStamp != 0L) {
				lTimeSpent = lCurrentTime - lTimeStamp;
				lTimeRemaining -= lTimeSpent;
				if (lTimeRemaining <= 0L) {
					lTimeRemaining = 0L;
				}

				lDifInMins = lTimeRemaining / 60000L;
				lDifInSecs = (lTimeRemaining - lDifInMins * 60000L) / 1000L;
				lDifInHr = lDifInMins / 60L;
				lDifInMins = (long) (((double) lDifInMins / 60.0D - (double) lDifInHr) * 60.0D);
			}

			if (lDifInHr < 10L) {
				strTime = " 0" + lDifInHr;
			} else {
				strTime = " " + lDifInHr;
			}

			if (lDifInMins < 10L) {
				strTime = strTime + ":0" + lDifInMins;
			} else {
				strTime = strTime + ":" + lDifInMins;
			}

			if (lDifInSecs < 10L) {
				strTime = strTime + ":0" + lDifInSecs;
			} else {
				strTime = strTime + ":" + lDifInSecs;
			}

			if (lTimeRemaining == 0L || lRequestCounter % 5L == 0L) {
				DBConnector dbConnector = null;
				Connection connection = null;
				PreparedStatement statement = null;

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
							"update ePariksha_Exam_Paper set exam_Time_Remaining=? where exam_Stud_PRN=TRIM(?) and exam_Course_Id=? and exam_Module_Id=?");
					statement.setLong(1, lTimeRemaining);
					statement.setString(2, strUserId);
					statement.setInt(3, Integer.parseInt(strCourseId));
					statement.setLong(4, Long.parseLong(strModuleId));
					statement.executeUpdate();
					if (statement != null) {
						statement.close();
					}
				} catch (SQLException var39) {
					var39.printStackTrace();
				} finally {
					if (dbConnector != null) {
						dbConnector.closeConnection(connection);
						dbConnector = null;
						connection = null;
					}

				}
			}

			session.setAttribute("RequestCounter", lRequestCounter + 1L);
			if (strTime != null) {
				response.setContentType("text/xml");
				response.setHeader("Cache-Control", "no-cache");
				response.getWriter().write("<message>" + strTime + "," + lTimeRemaining + "</message>");
			} else {
				response.setStatus(204);
			}
		} else {
			response.sendRedirect(request.getContextPath() + "/index.jsp");
		}

	}
}