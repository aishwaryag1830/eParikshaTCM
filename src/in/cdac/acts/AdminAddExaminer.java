package in.cdac.acts;

import in.cdac.acts.connection.DBConnector;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Date;

public class AdminAddExaminer extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String strUrlToRedirect = "/index.jsp";
		HttpSession session = request.getSession(false);
		if (session != null && !session.equals("")) {
			strUrlToRedirect = "/AdminUserMan.jsp";
			if (request.getParameter("txtFName") != null) {
				String strDefaultPassword = "cdac123";
				String strFName = null;
				String strMName = null;
				String strLName = null;
				String strRoleId = "001";
				String strCourseID = "0";
				String strEMailId = null;
				String strMNumber = null;
				String strDOB = null;
				String strGender = null;
				strFName = request.getParameter("txtFName").trim();
				strMName = request.getParameter("txtMName").trim();
				strLName = request.getParameter("txtLName").trim();
				strEMailId = request.getParameter("txtEmailId").trim();
				strMNumber = request.getParameter("txtContactNo").trim();
				strDOB = request.getParameter("txtDOB").trim();
				strGender = request.getParameter("gender");
				String strDBDriverClass = session.getAttribute("DBDriverClass").toString();
				String strDBConnectionURL = session.getAttribute("DBConnectionURL").toString();
				String strDBDataBaseName = session.getAttribute("DBDataBaseName").toString();
				String strDBUserName = session.getAttribute("DBUserName").toString();
				String strDBUserPass = session.getAttribute("DBUserPass").toString();
				String strMsg = null;
					
				Date inputDate = null;
				try {
					inputDate = new SimpleDateFormat("dd/MM/yyyy").parse(strDOB);
				} catch (ParseException e) {
					e.printStackTrace();
				}
				
				Connection connection = null;
				PreparedStatement statement = null;
				DBConnector dbConnector = new DBConnector();
				String strQuery = null;

				try {
					connection = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName,
							strDBUserName, strDBUserPass);
					
					 strQuery = "INSERT INTO mytab (mydt)values (?)";
					 statement = connection.prepareStatement(strQuery);
			
					  strQuery =
					  "INSERT INTO ePariksha_User_Master(user_Password,user_F_Name,user_M_Name,user_L_Name,user_Role_Id,user_Course_Id,user_Email_Id,user_M_Number,user_DOB,user_Gender)"
					  +
					  "values(TRIM(?),TRIM(?),TRIM(?),TRIM(?),TRIM(?),?,TRIM(?),to_number(?,'9999999999'),?,TRIM(?))";
					
					  statement = connection.prepareStatement(strQuery); 
					  statement.setString(1,strDefaultPassword); 
					  statement.setString(2, strFName); 
					  statement.setString(3,strMName); 
					  statement.setString(4, strLName); 
					  statement.setString(5, strRoleId); 
					  statement.setInt(6, Integer.parseInt(strCourseID));
					  statement.setString(7, strEMailId); 
					  statement.setString(8, strMNumber);
					  
					  //System.out.println("new java.sql.Timestamp(new java.util.Date(strDOB).getTime())"+ new
					 // java.sql.Timestamp(new java.util.Date(strDOB).getTime()));
					  //statement.setTimestamp(9, new java.sql.Timestamp(new
					 // java.util.Date(strDOB).getTime())); System.out.println(new
					
					//  System.out.println("straing dtae"+newjava.sql.Timestamp(parsedDate.getTime()).toString().substring(0,19));
					  //statement.setObject(9, new java.sql.Timestamp(parsedDate)); Timestamp NOW =
					//  new Timestamp(0); System.out.println("NOW"+ NOW);
					  
					  statement.setObject(9, convertToLocalDateTimeViaSqlTimestamp(inputDate)); //local date time trial
					  
					  //statement.setObject(9, NOW); statement.setString(10, strGender);
					  statement.setString(10, strGender);
				
					int exe = statement.executeUpdate();
					if (exe == 1) {
						strMsg = "Examiner Added Successfully";
					} else {
						strMsg = "Unable To Create User";
					}

					if (connection != null) {
						connection.close();
					}
				} 
					  catch (Exception var26) {
					  var26.printStackTrace();
					  strMsg =
					  "Unable To Create User"; }
					 

				response.reset();
				session.setAttribute("seErrorMsg", strMsg);
			}

			response.sendRedirect(request.getContextPath() + strUrlToRedirect);
		} else {
			strUrlToRedirect = "/index.jsp?lgn=2";
		}

	}
	
	public LocalDateTime convertToLocalDateTimeViaSqlTimestamp(Date dateToConvert) {
		return new java.sql.Timestamp(dateToConvert.getTime()).toLocalDateTime();
	}
	
}