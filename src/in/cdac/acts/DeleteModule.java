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

public class DeleteModule extends HttpServlet {
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
		String strPageToRedirect = null;
		HttpSession session = request.getSession(false);
		if (session != null && !session.equals("")) {
			DBConnector dbConnector = null;
			Connection connection = null;
			PreparedStatement statement = null;
			long lModuleId = 0L;
			int iCourseId = 0;
			if (request.getParameter("txtModuleIndex") != null) {
				if (request.getParameter("optModule") != null) {
					lModuleId = Long.parseLong(request.getParameter("optModule"));
				}

				if (session != null && session.getAttribute("CourseId") != null) {
					iCourseId = Integer.parseInt(session.getAttribute("CourseId").toString());
				}
			}

			if (lModuleId != 0L && iCourseId != 0) {
				strPageToRedirect = "/UpdateModule.jsp";

				try {
					String strDBDriverClass = session.getAttribute("DBDriverClass").toString();
					String strDBConnectionURL = session.getAttribute("DBConnectionURL").toString();
					String strDBDataBaseName = session.getAttribute("DBDataBaseName").toString();
					String strDBUserName = session.getAttribute("DBUserName").toString();
					String strDBUserPass = session.getAttribute("DBUserPass").toString();
					dbConnector = new DBConnector();
					connection = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName,
							strDBUserName, strDBUserPass);
					statement = connection
							.prepareStatement("delete from ePariksha_Modules where module_Id=? and module_Course_Id=?");
					statement.setLong(1, lModuleId);
					statement.setInt(2, iCourseId);
					int iRowEffected = statement.executeUpdate();
					if (iRowEffected > 0) {
						session.setAttribute("ModuleUpdateMsg", "Module deleted Successfully.");
						session.setAttribute("UpdateColor", "#008B8B");
					} else {
						session.setAttribute("ModuleUpdateMsg", "Module deletion failed.Please try again.");
						session.setAttribute("UpdateColor", "#FF4500");
					}
				} catch (SQLException var20) {
					var20.printStackTrace();
				} finally {
					if (dbConnector != null) {
						dbConnector.closeConnection(connection);
						dbConnector = null;
						connection = null;
					}

				}
			} else {
				strPageToRedirect = "/UpdateModule.jsp";
				session.setAttribute("ModuleUpdateMsg", "Module could not be deleted due to invalid data provided.");
				session.setAttribute("UpdateColor", "#FF4500");
			}
		} else {
			strPageToRedirect = "/index.jsp?lgn=2";
		}

		response.sendRedirect(request.getContextPath() + strPageToRedirect);
	}
}