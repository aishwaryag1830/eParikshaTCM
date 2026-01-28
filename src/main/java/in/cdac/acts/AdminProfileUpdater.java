package in.cdac.acts;

import in.cdac.acts.connection.DBConnector;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AdminProfileUpdater
extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && !session.equals("")) {
            String strMessage;
            block18: {
                String strUserId = session.getAttribute("UserId").toString();
                String strEMailId = null;
                String strMNumber = null;
                String strName = null;
                String strGender = null;
                String strDOB = null;
                strMessage = "Unable To Update Data";
                if (request.getParameter("eid") != null) {
                    strEMailId = request.getParameter("eid").trim();
                }
                if (request.getParameter("txtContactNo") != null) {
                    strMNumber = request.getParameter("txtContactNo").trim();
                }
                if (request.getParameter("txtName") != null) {
                    strName = request.getParameter("txtName").trim();
                }
                if (request.getParameter("txtDOB") != null) {
                    strDOB = request.getParameter("txtDOB").trim();
                }
                if (request.getParameter("txtGender") != null) {
                    strGender = request.getParameter("txtGender").trim();
                }
                if (request.getParameter("eid") != null) {
                    DBConnector dbConnector = null;
                    Connection connection = null;
                    PreparedStatement statement = null;
                    try {
                        try {
                            int intErrorFlag = 0;
                            String strDBDriverClass = session.getAttribute("DBDriverClass").toString();
                            String strDBConnectionURL = session.getAttribute("DBConnectionURL").toString();
                            String strDBDataBaseName = session.getAttribute("DBDataBaseName").toString();
                            String strDBUserName = session.getAttribute("DBUserName").toString();
                            String strDBUserPass = session.getAttribute("DBUserPass").toString();
                            dbConnector = new DBConnector();
                            connection = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName, strDBUserName, strDBUserPass);
                            statement = connection.prepareStatement("update ePariksha_User_Master set user_F_Name=TRIM(?), user_DOB=TO_DATE(?, 'DD-MM-YYYY'), user_Gender=TRIM(?), user_Email_Id =TRIM(?), user_M_Number=? where user_Id=?");
                            statement.setString(1, strName);
                            statement.setString(2, strDOB);
                            statement.setString(3, strGender);
                            statement.setString(4, strEMailId);
                            statement.setLong(5, Long.parseLong(strMNumber));
                            statement.setLong(6, Long.parseLong(strUserId));
                            intErrorFlag = statement.executeUpdate();
                            if (statement != null) {
                                statement.close();
                            }
                            if (intErrorFlag == 1) {
                                strMessage = "Info. Updated Successfully";
                                session.removeAttribute("UserName");
                                session.setAttribute("UserName", (Object)strName);
                            } else {
                                strMessage = "Unable To Update Data";
                            }
                        }
                        catch (SQLException e) {
                            strMessage = "Date of Birth is incorrect";
                            e.printStackTrace();
                            if (dbConnector != null) {
                                dbConnector.closeConnection(connection);
                                dbConnector = null;
                                connection = null;
                            }
                            break block18;
                        }
                    }
                    catch (Throwable throwable) {
                        if (dbConnector != null) {
                            dbConnector.closeConnection(connection);
                            dbConnector = null;
                            connection = null;
                        }
                        throw throwable;
                    }
                    if (dbConnector != null) {
                        dbConnector.closeConnection(connection);
                        dbConnector = null;
                        connection = null;
                    }
                }
            }
            response.setContentType("text/xml");
            response.setHeader("Cache-Control", "no-cache");
            response.getWriter().write("<div id=\"tokill\"style=\"color:red\" >" + strMessage + "</div>");
        }
    }
}