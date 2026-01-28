package in.cdac.coursemgmt;

import in.cdac.acts.connection.DBConnector;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AddDatesAjax extends HttpServlet {
	private static final long serialVersionUID = 1L;
	DBConnector dbConnector = null;
	String strXML = new String();
	PrintWriter writer = null;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = null;
		Connection connection = null;
		PreparedStatement preStmt = null;
		ResultSet result = null;
		URL url = null;
		String strModuleIdForDate = null;
		String strUserId = null;
		String strCourseId = null;
		String strRoleId = null;
		String strUserRole = null;
		session = request.getSession(false);
		if (session == null) {
			response.sendRedirect(request.getContextPath() + "/error.jsp");
		} else {
			if (request.getParameter("strUserRole") != null) {
				strUserRole = request.getParameter("strUserRole");
				session.setAttribute("snstrUserRole", strUserRole);
			} else if (session.getAttribute("snstrUserRole") != null) {
				strUserRole = session.getAttribute("snstrUserRole").toString();
			}

			String strDBDriverClass = session.getAttribute("DBDriverClass").toString();
			String strDBConnectionURL = session.getAttribute("DBConnectionURL").toString();
			String strDBDataBaseName = session.getAttribute("DBDataBaseName").toString();
			String strDBUserName = session.getAttribute("DBUserName").toString();
			String strDBUserPass = session.getAttribute("DBUserPass").toString();
			this.dbConnector = new DBConnector();
			connection = this.dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName,
					strDBUserName, strDBUserPass);
			strUserId = session.getAttribute("UserId").toString();
			
			strCourseId = null;
			
			if (session.getAttribute("CourseId") != null) {
				strCourseId = session.getAttribute("CourseId").toString();
			}
			
			strRoleId = session.getAttribute("UserRoleId").toString();
			String statusFlag = null;
			int paramCourseId = 0;
			if (request.getParameter("strCourseId") != null) {
				paramCourseId = Integer.parseInt(request.getParameter("strCourseId").toString());
				session.setAttribute("paramCourseId", paramCourseId);
			} else if (session.getAttribute("paramCourseId") != null) {
				paramCourseId = Integer.parseInt(session.getAttribute("paramCourseId").toString());
			}

			if (request.getParameter("strModuleId") != null) {
				strModuleIdForDate = request.getParameter("strModuleId");
				session.setAttribute("adddattesajaxsnmoduleid", strModuleIdForDate);
			} else if (session.getAttribute("adddattesajaxsnmoduleid") != null) {
				strModuleIdForDate = (String) session.getAttribute("adddattesajaxsnmoduleid");
			}

			if (strModuleIdForDate != null && !strModuleIdForDate.equals("")) {
				strModuleIdForDate = strModuleIdForDate.trim();
			}

			if (request.getParameter("iFlag") != null) {
				statusFlag = request.getParameter("iFlag").toString();
			}

			this.writer = response.getWriter();
			url = this.getServletContext().getResource(this.strXML);
			response.setContentType("text/xml");
			if (statusFlag.equals("1")) {
				this.getModules((PreparedStatement) preStmt, connection, (ResultSet) result, strUserId, strRoleId,
						paramCourseId, session);
			} else if (statusFlag.equals("2")) {
				this.getExamDates((PreparedStatement) preStmt, connection, (ResultSet) result, strUserId,
						strModuleIdForDate, strCourseId, strRoleId, strUserRole, session);
			}
		}

	}

	protected void getModules(PreparedStatement preStmt, Connection connection, ResultSet result, String strUserId,
			String strRoleId, int paramCourseID, HttpSession session) {
		try {
			Map<Integer, String> map = new HashMap<>();
			preStmt = connection.prepareStatement(
					"SELECT distinct module_Id,module_Name FROM ePariksha_Results,ePariksha_Modules where ePariksha_Results.result_Module_Id=ePariksha_Modules.module_Id and ePariksha_Results.result_Course_Id=? ",
					1005, 1007);
			preStmt.setInt(1, paramCourseID);
			result = preStmt.executeQuery();

			for (this.strXML = "<?xml version='1.0' encoding='UTF-8'?><modules>"; result
					.next(); this.strXML = this.strXML + "<moduleSerialNo><moduleId>" + result.getInt("module_Id")
							+ "</moduleId><modulename>" + result.getString("module_Name").trim()
							+ "</modulename></moduleSerialNo>") {
				map.put(result.getInt("module_Id"), result.getString("module_Name").trim());
			}

			session.setAttribute("snModuleMap", map);
			this.strXML = this.strXML + "</modules>";
			this.writer.print(this.strXML);
		} catch (Exception var9) {
			var9.printStackTrace();
		}

	}

	protected void getExamDates(PreparedStatement preStmt, Connection connection, ResultSet result, String strUserId,
			String strModuleIdForDate, String strCourseId, String strRoleId, String strUserRole, HttpSession session) {
		try {
			ArrayList<String> arrlst = new ArrayList<>();
			if (strUserRole.equals("999")) {
				preStmt = connection.prepareStatement(
						"select distinct to_char(result_Exam_Date, 'DD-MM-YYYY') as result_Exam_Date from ePariksha_Results where result_Module_Id=? order by to_char(result_Exam_Date, 'DD-MM-YYYY')",
						1005, 1007);
				preStmt.setLong(1, Long.parseLong(strModuleIdForDate));
			} else if (strUserRole.equals("001")) {
				preStmt = connection.prepareStatement(
						"select distinct to_char(result_Exam_Date, 'DD-MM-YYYY') as result_Exam_Date from ePariksha_Results,ePariksha_Exam_Schedule where result_Module_Id=? and result_Course_Id=? order by to_char(result_Exam_Date, 'DD-MM-YYYY')",
						1005, 1007);
				preStmt.setLong(1, Long.parseLong(strModuleIdForDate));
				preStmt.setInt(2, Integer.parseInt(strCourseId));
			}

			result = preStmt.executeQuery();

			for (this.strXML = "<?xml version='1.0' encoding='UTF-8'?><examdates>"; result
					.next(); this.strXML = this.strXML + "<examdate>" + "<date>"
							+ result.getString("result_Exam_Date").trim() + "</date>" + "</examdate>") {
				arrlst.add(result.getString("result_Exam_Date").trim());
			}

			session.setAttribute("snarrlst", arrlst);
			this.strXML = this.strXML + "</examdates>";
			this.writer.print(this.strXML);
		} catch (Exception var11) {
			var11.printStackTrace();
		}

	}
}