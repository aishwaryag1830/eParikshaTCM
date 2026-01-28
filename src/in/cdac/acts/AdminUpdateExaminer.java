package in.cdac.acts;

import in.cdac.acts.connection.DBConnector;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AdminUpdateExaminer
extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        StringBuilder strPageToRedirect = new StringBuilder();
        PrintWriter writer = response.getWriter();
        String strUrlToRedirect = "/index.jsp";
        HttpSession session = request.getSession(false);
        if (session == null || session.equals("")) {
            strUrlToRedirect = "/index.jsp?lgn=2";
        } else {
            String strMessage;
            String strUserId;
            block14: {
                strUserId = null;
                String strFName = null;
                String strMName = null;
                String strLName = null;
                String strDOB = null;
                String strGender = null;
                String strEMailId = null;
                String strMNumber = null;
                strMessage = null;
                strUrlToRedirect = "/AdminUserMan.jsp";
                strUserId = request.getParameter("strUserId");
                strFName = request.getParameter("strFName");
                strMName = request.getParameter("strMName");
                strLName = request.getParameter("strLName");
                strDOB = request.getParameter("strDOB");
                strGender = request.getParameter("strGender");
                strEMailId = request.getParameter("strEMailId");
                strMNumber = request.getParameter("strMNumber");
                if (strUserId != null && strEMailId != null && strMNumber != null) {
                    strPageToRedirect.append("/AdminUserMan.jsp");
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
                            if (strMName.trim().equalsIgnoreCase("--")) {
                                strMName = "";
                            }
                            dbConnector = new DBConnector();
                            connection = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName, strDBUserName, strDBUserPass);
                            statement = connection.prepareStatement("update ePariksha_User_Master set user_F_Name=TRIM(?), user_M_Name=TRIM(?), user_L_Name=TRIM(?), user_Email_Id=TRIM(?), user_M_Number=?, user_DOB=TO_DATE(?, 'DD-MM-YYYY'), user_Gender= TRIM(?) where user_Id=?");
                            statement.setString(1, strFName);
                            statement.setString(2, strMName);
                            statement.setString(3, strLName);
                            statement.setString(4, strEMailId);
                            statement.setLong(5, Long.parseLong(strMNumber));
                            statement.setString(6, strDOB);
                            statement.setString(7, strGender);
                            statement.setLong(8, Long.parseLong(strUserId));
                            intErrorFlag = statement.executeUpdate();
                            if (statement != null) {
                                statement.close();
                            }
                            strMessage = intErrorFlag == 1 ? "Info. Updated Successfully" : "Unable To Update Data";
                        }
                        catch (SQLException e) {
                            e.printStackTrace();
                            if (dbConnector != null) {
                                dbConnector.closeConnection(connection);
                                dbConnector = null;
                                connection = null;
                            }
                            break block14;
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
                } else {
                    strPageToRedirect.append("/index.jsp?lgn=2");
                }
            }
            request.setAttribute("selCCID", (Object)strUserId);
            writer.print(strMessage);
        }
    }
}