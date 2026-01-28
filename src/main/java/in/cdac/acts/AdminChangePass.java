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

public class AdminChangePass
extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && !session.equals("")) {
            String strMessage;
            block13: {
                String strUserId = session.getAttribute("UserId").toString();
                String strOldPass = null;
                String strNewPass = null;
                strMessage = "Unable To Update Data";
                if (request.getParameter("oldpass") != null) {
                    strOldPass = request.getParameter("oldpass").trim();
                }
                if (request.getParameter("newpass") != null) {
                    strNewPass = request.getParameter("newpass").trim();
                }
                if (request.getParameter("oldpass") != null) {
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
                            statement = connection.prepareStatement("UPDATE ePariksha_User_Master  SET user_Password =TRIM(?) where user_Password =TRIM(?) and user_Id=?");
                            statement.setString(1, strNewPass);
                            statement.setString(2, strOldPass);
                            statement.setLong(3, Long.parseLong(strUserId));
                            intErrorFlag = statement.executeUpdate();
                            if (statement != null) {
                                statement.close();
                            }
                            strMessage = (intErrorFlag == 1) ? ("Info. Updated Successfully") : ("Unable To Update Data");
                        }
                        catch (SQLException e) {
                            e.printStackTrace();
                            if (dbConnector != null) {
                                dbConnector.closeConnection(connection);
                                dbConnector = null;
                                connection = null;
                            }
                            break block13;
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