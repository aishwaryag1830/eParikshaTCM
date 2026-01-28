package in.cdac.coursemgmt;

import in.cdac.acts.connection.DBConnector;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.sql.Connection;
import java.util.HashMap;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import net.sf.jasperreports.engine.JasperRunManager;

public class DisplayReports extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private String sReportPath = null;
	private String sReportIdentifier = null;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (request.getParameter("txtRequestIdentifier") != null) {
			this.sReportIdentifier = request.getParameter("txtRequestIdentifier");
		}

		if (this.sReportIdentifier.equals("1")) {
			this.sReportPath = "ReportsBase/Courses_Modules.jasper";
		}

		if (this.sReportIdentifier.equals("2")) {
			this.sReportPath = "ReportsBase/UserInformation.jasper";
		}

		if (this.sReportIdentifier.equals("3")) {
			this.sReportPath = "ReportsBase/ExamSchedules.jasper";
		}

		if (this.sReportIdentifier.equals("4")) {
			this.sReportPath = "ReportsBase/CandidatesInformation.jasper";
		}

		if (this.sReportIdentifier.equals("5")) {
			this.sReportPath = "ReportsBase/ResultsDetails.jasper";
		}

		session.setAttribute("snSelectedReportOptionId", this.sReportIdentifier);
		if (this.sReportPath != null) {
			this.doGet(request, response);
		}

	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		String sShowTrueFalse = null;
		if (session.getAttribute("snSelectedReportOptionId") != null) {
			sShowTrueFalse = session.getAttribute("snSelectedReportOptionId").toString();
			session.removeAttribute("snSelectedReportOptionId");
		}

		if (sShowTrueFalse != null) {
			String strDBDriverClass = null;
			String strDBConnectionURL = null;
			String strDBDataBaseName = null;
			String strDBUserName = null;
			String strDBUserPass = null;
			ServletOutputStream servletOutputStream = response.getOutputStream();
			InputStream reportStream = this.getServletConfig().getServletContext()
					.getResourceAsStream(this.sReportPath);
			Connection con = null;
			DBConnector dbConnector = null;
			strDBDriverClass = session.getAttribute("DBDriverClass").toString();
			strDBConnectionURL = session.getAttribute("DBConnectionURL").toString();
			strDBDataBaseName = session.getAttribute("DBDataBaseName").toString();
			strDBUserName = session.getAttribute("DBUserName").toString();
			strDBUserPass = session.getAttribute("DBUserPass").toString();

			try {
				dbConnector = new DBConnector();
				con = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName, strDBUserName,
						strDBUserPass);
				JasperRunManager.runReportToPdfStream(reportStream, servletOutputStream, new HashMap<>(), con);
				response.setContentType("application/pdf");
				response.setHeader("Cache-Control", "no-cache");
				servletOutputStream.flush();
				servletOutputStream.close();
			} catch (Exception var20) {
				var20.printStackTrace();
				StringWriter stringWriter = new StringWriter();
				PrintWriter printWriter = new PrintWriter(stringWriter);
				var20.printStackTrace(printWriter);
				response.setContentType("text/html");
				response.getOutputStream().print(
						"<div align=\"center\" style=\"color:#83cdff;font-size: 15pt;font-family: Tahoma;margin:170px 0px 0px 90px;\"><img style='width:40px;hieght:40px;' src='images/ajaxLoader.gif'><br>Please wait while report loads or try again.</div>");
			} finally {
				if (dbConnector != null) {
					dbConnector.closeConnection(con);
					dbConnector = null;
					con = null;
				}

			}
		}

	}
}