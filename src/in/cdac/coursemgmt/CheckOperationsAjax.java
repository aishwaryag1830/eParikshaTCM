package in.cdac.coursemgmt;

import in.cdac.acts.connection.DBConnector;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class CheckOperationsAjax extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private void getExamScheduleToday(Connection con, HttpServletResponse res, HttpSession sn, String sModuleId) {
		res.setContentType("text/xml");
		res.setHeader("Cache-Control", "no-cache");
		res.setHeader("Pragma", "no-cache");
		res.setDateHeader("Expires", 0L);
		PrintWriter out = null;
		ResultSet rs_dropdown = null;

		try {
			out = res.getWriter();
		} catch (IOException var12) {
			var12.printStackTrace();
		}

		StringBuffer responseBuffer = new StringBuffer();
		String selectedExamScheduleId = null;
		String sCourseId = null;
		if (sn.getAttribute("CourseId") != null) {
			sCourseId = sn.getAttribute("CourseId").toString();
		}

		try {
			String sql = "select exam_Schedule_Id from ePariksha_Exam_Schedule where exam_Module_Id=" + sModuleId
					+ " and exam_Course_Id=" + sCourseId + " "
					+ " and to_char(ePariksha_Exam_Schedule.exam_Date, 'DD-MM-YYYY') = to_char(now(), 'DD-MM-YYYY')";
			Statement stmt_dropdown = con.createStatement(1004, 1007);
			rs_dropdown = stmt_dropdown.executeQuery(sql);
			responseBuffer.append("<?xml version='1.0'?>");
			responseBuffer.append("<ExamModuleScheduleIds>");
			if (rs_dropdown.next()) {
				rs_dropdown.beforeFirst();

				while (rs_dropdown.next()) {
					selectedExamScheduleId = String.valueOf(rs_dropdown.getLong("exam_Schedule_Id"));
					responseBuffer.append("<ExamSerialId>");
					responseBuffer.append("<ExamScheduleId>" + selectedExamScheduleId + "</ExamScheduleId>");
					responseBuffer.append("</ExamSerialId>");
				}
			} else {
				rs_dropdown.beforeFirst();
			}

			responseBuffer.append("</ExamModuleScheduleIds>");
			if (rs_dropdown != null) {
				rs_dropdown.close();
			}

			if (stmt_dropdown != null) {
				stmt_dropdown.close();
			}
		} catch (SQLException var13) {
			var13.printStackTrace();
		}

		out.write(responseBuffer.toString());
		out.flush();
		out.close();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		super.doGet(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession sn = request.getSession(false);
		String sSelectedModuleId = null;
		String sFunctionCallIdentifer = null;
		if (sn != null && !sn.equals("")) {
			Connection con = null;
			String strDBDriverClass = sn.getAttribute("DBDriverClass").toString();
			String strDBConnectionURL = sn.getAttribute("DBConnectionURL").toString();
			String strDBDataBaseName = sn.getAttribute("DBDataBaseName").toString();
			String strDBUserName = sn.getAttribute("DBUserName").toString();
			String strDBUserPass = sn.getAttribute("DBUserPass").toString();
			DBConnector dbConnector = new DBConnector();

			try {
				con = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName, strDBUserName,
						strDBUserPass);
				if (request.getParameter("callId") != null) {
					sFunctionCallIdentifer = request.getParameter("callId");
				}

				if (sFunctionCallIdentifer == "1" || sFunctionCallIdentifer.equals("1")) {
					if (request.getParameter("ajaxSelectedModuleId") != null) {
						sSelectedModuleId = request.getParameter("ajaxSelectedModuleId");
					}

					this.getExamScheduleToday(con, response, sn, sSelectedModuleId);
				}
			} catch (Exception var17) {
				;
			} finally {
				if (dbConnector != null) {
					dbConnector.closeConnection(con);
					dbConnector = null;
					con = null;
				}

			}
		} else {
			response.sendRedirect(request.getContextPath() + "/error.jsp");
		}

	}
}