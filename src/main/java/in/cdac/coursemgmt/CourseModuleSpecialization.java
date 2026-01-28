package in.cdac.coursemgmt;

import in.cdac.acts.connection.DBConnector;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class CourseModuleSpecialization extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	}

	private String getConcatedDataStrings(String sDrpText, String sDrpValue) {
		String sDrpOption = "";
		sDrpOption = sDrpText + "#" + sDrpValue + ";" + sDrpOption;
		return sDrpOption;
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session != null && !session.equals("")) {
			int iCourseId = Integer.parseInt(request.getParameter("sCourseId"));
			long lModuleId = 0L;
			String sModuleName = null;
			String sConcatedDrpOptions = "";
			Connection con = null;
			DBConnector dbConnector = new DBConnector();
			String strDBDriverClass = session.getAttribute("DBDriverClass").toString();
			String strDBConnectionURL = session.getAttribute("DBConnectionURL").toString();
			String strDBDataBaseName = session.getAttribute("DBDataBaseName").toString();
			String strDBUserName = session.getAttribute("DBUserName").toString();
			String strDBUserPass = session.getAttribute("DBUserPass").toString();
			response.setContentType("text/html");
			PrintWriter out = response.getWriter();

			try {
				con = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName, strDBUserName,
						strDBUserPass);
				PreparedStatement pst = con.prepareStatement(
						"Select module_Id , module_Name from ePariksha_Modules where module_Course_Id = ?", 1004, 1007);
				pst.setInt(1, iCourseId);
				ResultSet rs = pst.executeQuery();
				if (!rs.first()) {
					sConcatedDrpOptions = "No modules found";
				} else {
					rs.beforeFirst();

					while (rs.next()) {
						lModuleId = (long) rs.getInt("module_Id");
						sModuleName = rs.getString("module_Name");
						sConcatedDrpOptions = sConcatedDrpOptions
								+ this.getConcatedDataStrings(sModuleName, String.valueOf(lModuleId));
					}
				}

				out.print(sConcatedDrpOptions);
				if (rs != null) {
					rs.close();
				}

				if (pst != null) {
					pst.close();
				}
			} catch (Exception var22) {
				var22.printStackTrace();
			} finally {
				if (dbConnector != null) {
					dbConnector.closeConnection(con);
					dbConnector = null;
					con = null;
				}

			}
		} else {
			session = request.getSession(true);
		}

	}
}