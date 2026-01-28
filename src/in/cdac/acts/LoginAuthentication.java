package in.cdac.acts;

import in.cdac.acts.connection.DBConnector;
import in.cdac.acts.connection.DBReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LoginAuthentication extends HttpServlet {
	private static final long serialVersionUID = 1L;
	ServletContext context = null;

	public void init(ServletConfig config) throws ServletException {
		super.init(config);
		this.context = config.getServletContext();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session != null && !session.equals("")) {
			session.invalidate();
			session = request.getSession(true);
		} else {
			session = request.getSession(true);
		}

		String strUserId = null;
		String strUserPassword = null;
		String strUserRoleId = null;
		String strUserName = null;
		boolean bLoginFlag = false;
		String strPageToRedirect = null;
		String strCourseId = null;
		String strQuery = null;
		if (request.getParameter("txtUserId") != null) {
			strUserId = request.getParameter("txtUserId").trim();
		}

		if (request.getParameter("txtPassword") != null) {
			strUserPassword = request.getParameter("txtPassword").trim();
		}

		if (strUserId != null) {
			for (int iTemp = 0; iTemp < strUserId.length(); ++iTemp) {
				if (!Character.isDigit(strUserId.charAt(iTemp))) {
					bLoginFlag = true;
				}
			}
		}

		if (!bLoginFlag && strUserId != null && strUserPassword != null && strUserId.length() != 0
				&& strUserPassword.length() != 0) {
			bLoginFlag = false;
			DBReader dbReader = new DBReader(this.context.getRealPath("Property/DataBase.properties"));
			String strDBDriverClass = dbReader.getDriverClass();
			String strDBConnectionURL = dbReader.getConnectionURL();
			String strDBDataBaseName = dbReader.getDataBaseName();
			String strDBUserName = dbReader.getUserName();
			String strDBUserPass = dbReader.getUserPassword();
			
			  strDBConnectionURL = strDBConnectionURL.substring(0,
			  strDBConnectionURL.length() - 1); strDBConnectionURL = strDBConnectionURL +  "/";
			 
			 
			session.setAttribute("DBDriverClass", strDBDriverClass);
			session.setAttribute("DBConnectionURL", strDBConnectionURL);
			session.setAttribute("DBDataBaseName", strDBDataBaseName);
			session.setAttribute("DBUserName", strDBUserName);
			session.setAttribute("DBUserPass", strDBUserPass);
			DBConnector dbConnector = null;
			Connection connection = null;
			PreparedStatement statementUpdateLogin = null;
			ResultSet result = null;

			try {
				dbConnector = new DBConnector();
				connection = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName,
						strDBUserName, strDBUserPass);
				strQuery = "select stud_F_Name,stud_M_Name,stud_L_Name,stud_Login_Flag,stud_Course_Id from ePariksha_Student_Login where stud_PRN=? and stud_Password=?";
				PreparedStatement statement = connection.prepareStatement(strQuery, 1005, 1007);
				statement.setString(1, strUserId);
				statement.setString(2, strUserPassword);
				result = statement.executeQuery();
				if (result.next()) {
					strUserName = result.getString("stud_F_Name");
					if (result.getString("stud_M_Name") != null) {
						strUserName = strUserName + " " + result.getString("stud_M_Name");
					}

					if (result.getString("stud_L_Name") != null) {
						strUserName = strUserName + " " + result.getString("stud_L_Name");
					}

					bLoginFlag = result.getBoolean("stud_Login_Flag");
					strCourseId = result.getString("stud_Course_Id");
					if (bLoginFlag) {
						strPageToRedirect = "/index.jsp";
						session.setAttribute("sLoginFlag", "3");
					} else {
						strPageToRedirect = "/StudentHome.jsp";
						statementUpdateLogin = connection.prepareStatement(
								"update ePariksha_Student_Login set stud_Login_Flag=true where stud_PRN=? and stud_Password=?",
								1005, 1007);
						statementUpdateLogin.setString(1, strUserId);
						statementUpdateLogin.setString(2, strUserPassword);
						statementUpdateLogin.executeUpdate();
						if (statementUpdateLogin != null) {
							statementUpdateLogin.close();
						}

						session.setAttribute("UserId", strUserId);
						session.setAttribute("UserName", strUserName);
						session.setAttribute("CourseId", strCourseId);
					}
				} else {
					if (statement != null) {
						statement.close();
					}

					strQuery = "select user_F_Name,user_M_Name,user_L_Name,user_Role_Id,user_Course_Id from ePariksha_User_Master where user_Id=?  and user_Password=?";
					statement = connection.prepareStatement(strQuery, 1005, 1007);
					statement.setLong(1, Long.parseLong(strUserId));
					statement.setString(2, strUserPassword);
					result = statement.executeQuery();
					if (result.next()) {
						strUserName = result.getString("user_F_Name");
						if (result.getString("user_M_Name") != null) {
							strUserName = strUserName + " " + result.getString("user_M_Name");
						}

						if (result.getString("user_L_Name") != null) {
							strUserName = strUserName + " " + result.getString("user_L_Name");
						}

						strUserRoleId = result.getString("user_Role_Id");
						strCourseId = result.getString("user_Course_Id");
						if (strUserRoleId.equalsIgnoreCase("999")) {
							strPageToRedirect = "/AdminHome.jsp";
						}

						if (strUserRoleId.equalsIgnoreCase("001")) {
							strPageToRedirect = "/ExaminerHome.jsp";
							if (strCourseId.equals("0")) {
								strPageToRedirect = "/index.jsp";
								session.setAttribute("sLoginFlag", "4");
							}
						}

						session.setAttribute("UserId", strUserId);
						session.setAttribute("UserName", strUserName);
						session.setAttribute("UserRoleId", strUserRoleId);
						session.setAttribute("CourseId", strCourseId);
					} else {
						strPageToRedirect = "/index.jsp";
						session.setAttribute("sLoginFlag", "1");
					}
				}
			} catch (SQLException var27) {
				var27.printStackTrace();
			} finally {
				if (dbConnector != null) {
					dbConnector.closeConnection(connection);
					dbConnector = null;
					connection = null;
					dbReader = null;
				}

			}
		} else {
			strPageToRedirect = "/index.jsp";
			session.setAttribute("sLoginFlag", "2");
		}

		response.sendRedirect(request.getContextPath() + strPageToRedirect);
	}

	/*protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session != null && !session.equals("")) {
			session.invalidate();
			session = request.getSession(true);
		} else {
			session = request.getSession(true);
		}

		String strUserId = null;
		String strUserPassword = null;
		String strUserRoleId = null;
		String strUserName = null;
		boolean bLoginFlag = false;
		String strPageToRedirect = null;
		String strCourseId = null;
		String strQuery = null;
		if (request.getParameter("txtUserId") != null) {
			strUserId = request.getParameter("txtUserId").trim();
		}

		if (request.getParameter("txtPassword") != null) {
			strUserPassword = request.getParameter("txtPassword").trim();
		}

		if (strUserId != null) {
			for (int iTemp = 0; iTemp < strUserId.length(); ++iTemp) {
				if (!Character.isDigit(strUserId.charAt(iTemp))) {
					bLoginFlag = true;
				}
			}
		}

		if (!bLoginFlag && strUserId != null && strUserPassword != null && strUserId.length() != 0
				&& strUserPassword.length() != 0) {
			bLoginFlag = false;
			DBReader dbReader = new DBReader(this.context.getRealPath("Property/DataBase.properties"));
			String strDBDriverClass = dbReader.getDriverClass();
			String strDBConnectionURL = dbReader.getConnectionURL();
			String strDBDataBaseName = dbReader.getDataBaseName();
			String strDBUserName = dbReader.getUserName();
			String strDBUserPass = dbReader.getUserPassword();
			session.setAttribute("DBDriverClass", strDBDriverClass);
			session.setAttribute("DBConnectionURL", strDBConnectionURL);
			session.setAttribute("DBDataBaseName", strDBDataBaseName);
			session.setAttribute("DBUserName", strDBUserName);
			session.setAttribute("DBUserPass", strDBUserPass);
			DBConnector dbConnector = null;
			Connection connection = null;
			PreparedStatement statementUpdateLogin = null;
			ResultSet result = null;

			try {
				dbConnector = new DBConnector();
				
				System.out.println("strDBDriverClass"+ strDBDriverClass);
				System.out.println("strDBConnectionURL"+ strDBConnectionURL);
				System.out.println("strDBDataBaseName"+ strDBDataBaseName);
				System.out.println("strDBUserName"+ strDBUserName);
				System.out.println("strDBUserPass"+ strDBUserPass);
				
						
				connection = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName,
						strDBUserName, strDBUserPass);
				strQuery = "select stud_F_Name,stud_M_Name,stud_L_Name,stud_Login_Flag,stud_Course_Id from ePariksha_Student_Login where stud_PRN=? and stud_Password=?";
				PreparedStatement statement = connection.prepareStatement(strQuery, 1005, 1007);
				statement.setString(1, strUserId);
				statement.setString(2, strUserPassword);
				result = statement.executeQuery();
				if (result.next()) {
					strUserName = result.getString("stud_F_Name");
					if (result.getString("stud_M_Name") != null) {
						strUserName = strUserName + " " + result.getString("stud_M_Name");
					}

					if (result.getString("stud_L_Name") != null) {
						strUserName = strUserName + " " + result.getString("stud_L_Name");
					}

					bLoginFlag = result.getBoolean("stud_Login_Flag");
					strCourseId = result.getString("stud_Course_Id");
					if (bLoginFlag) {
						strPageToRedirect = "/index.jsp";
						session.setAttribute("sLoginFlag", "3");
					} else {
						strPageToRedirect = "/StudentHome.jsp";
						statementUpdateLogin = connection.prepareStatement(
								"update ePariksha_Student_Login set stud_Login_Flag=1 where stud_PRN=? and stud_Password=?",
								1005, 1007);
						statementUpdateLogin.setString(1, strUserId);
						statementUpdateLogin.setString(2, strUserPassword);
						statementUpdateLogin.executeUpdate();
						if (statementUpdateLogin != null) {
							statementUpdateLogin.close();
						}

						session.setAttribute("UserId", strUserId);
						session.setAttribute("UserName", strUserName);
						session.setAttribute("CourseId", strCourseId);
					}
				} else {
					if (statement != null) {
						statement.close();
					}

					strQuery = "select user_F_Name,user_M_Name,user_L_Name,user_Role_Id,user_Course_Id from ePariksha_User_Master where user_Id=?  and user_Password=?";
					statement = connection.prepareStatement(strQuery, 1005, 1007);
					statement.setLong(1, Long.parseLong(strUserId));
					statement.setString(2, strUserPassword);
					result = statement.executeQuery();
					if (result.next()) {
						strUserName = result.getString("user_F_Name");
						if (result.getString("user_M_Name") != null) {
							strUserName = strUserName + " " + result.getString("user_M_Name");
						}

						if (result.getString("user_L_Name") != null) {
							strUserName = strUserName + " " + result.getString("user_L_Name");
						}

						strUserRoleId = result.getString("user_Role_Id");
						strCourseId = result.getString("user_Course_Id");
						if (strUserRoleId.equalsIgnoreCase("999")) {
							strPageToRedirect = "/AdminHome.jsp";
						}

						if (strUserRoleId.equalsIgnoreCase("001")) {
							strPageToRedirect = "/ExaminerHome.jsp";
							if (strCourseId.equals("0")) {
								strPageToRedirect = "/index.jsp";
								session.setAttribute("sLoginFlag", "4");
							}
						}

						session.setAttribute("UserId", strUserId);
						session.setAttribute("UserName", strUserName);
						session.setAttribute("UserRoleId", strUserRoleId);
						session.setAttribute("CourseId", strCourseId);
					} else {
						strPageToRedirect = "/index.jsp";
						session.setAttribute("sLoginFlag", "1");
					}
				}
			} catch (SQLException var27) {
				var27.printStackTrace();
			} finally {
				if (dbConnector != null) {
					dbConnector.closeConnection(connection);
					dbConnector = null;
					connection = null;
					dbReader = null;
				}

			}
		} else {
			strPageToRedirect = "/index.jsp";
			session.setAttribute("sLoginFlag", "2");
		}

		response.sendRedirect(request.getContextPath() + strPageToRedirect);
	} */
}