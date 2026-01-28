package in.cdac.coursemgmt;

import in.cdac.acts.connection.DBConnector;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class UpdateCourses
extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.equals("")) {
            response.sendRedirect(String.valueOf(request.getContextPath()) + "/index.jsp");
        } else {
            PrintWriter out;
            StringBuffer strBuffer;
            block32: {
                int iForSameName = 0;
                int iCourseUpdated = 0;
                strBuffer = new StringBuffer();
                String strCourse_Name = null;
                String strCourse_Short_Name = null;
                String strCourseId = null;
                String strDate = null;
                String Query = null;
                PreparedStatement pst = null;
                Connection connection = null;
                ResultSet result = null;
                out = response.getWriter();
                response.setHeader("Pragma", "no-cache");
                response.setHeader("Cache-Control", "no-cache");
                response.setDateHeader("Expires", 0L);
                response.setContentType("text/xml");
                if (request.getParameter("txtCourseName") != null) {
                    strCourse_Name = request.getParameter("txtCourseName").trim();
                }
                if (request.getParameter("txtCourseShortName") != null) {
                    strCourse_Short_Name = request.getParameter("txtCourseShortName").trim();
                }
                if (request.getParameter("txtCourseId") != null) {
                    strCourseId = request.getParameter("txtCourseId").trim();
                }
                if (request.getParameter("txtDate") != null) {
                    strDate = request.getParameter("txtDate").trim();
                }
                String strDBDriverClass = session.getAttribute("DBDriverClass").toString();
                String strDBConnectionURL = session.getAttribute("DBConnectionURL").toString();
                String strDBDataBaseName = session.getAttribute("DBDataBaseName").toString();
                String strDBUserName = session.getAttribute("DBUserName").toString();
                String strDBUserPass = session.getAttribute("DBUserPass").toString();
                strBuffer.append("<?xml version=\"1.0\"?>\n");
                DBConnector dbConnector = null;
                try {
                    dbConnector = new DBConnector();
                    connection = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName, strDBUserName, strDBUserPass);
                    pst = connection.prepareStatement("SELECT course_Name,course_Short_Name  from ePariksha_Courses where course_Id <> ?", 1005, 1007);
                    pst.setInt(1, Integer.parseInt(strCourseId));
                    result = pst.executeQuery();
                    while (result.next()) {
                        if (!strCourse_Name.equalsIgnoreCase(result.getString("course_Name")) && !strCourse_Short_Name.equalsIgnoreCase(result.getString("course_Short_Name"))) continue;
                        iForSameName = 1;
                    }
                    if (result != null) {
                        result.close();
                    }
                    if (pst != null) {
                        pst.close();
                    }
                    pst = connection.prepareStatement("SELECT course_Name from ePariksha_Courses where course_Id=? and course_Validtill_Date < now()", 1005, 1007);
                    pst.setInt(1, Integer.parseInt(strCourseId));
                    result = pst.executeQuery();
                    if (result.first()) {
                        iForSameName = 2;
                    }
                    if (result != null) {
                        result.close();
                    }
                    if (pst != null) {
                        pst.close();
                    }
                    pst = connection.prepareStatement("SELECT * from ePariksha_Courses where ?::date < now()", 1005, 1007);
                    pst.setString(1, strDate);
                    result = pst.executeQuery();
                    if (result.first()) {
                        iForSameName = 3;
                    }
                    if (result != null) {
                        result.close();
                    }
                    if (pst != null) {
                        pst.close();
                    }
                    strBuffer.append("<Course>");
                    switch (iForSameName) {
                        case 0: {
                            Query = "UPDATE ePariksha_Courses SET course_Name =?,course_Short_Name =?,course_Validtill_Date = ?::date  where course_Id = ?";
                            pst = connection.prepareStatement(Query);
                            pst.setString(1, strCourse_Name);
                            pst.setString(2, strCourse_Short_Name);
                            pst.setString(3, strDate);
                            pst.setInt(4, Integer.parseInt(strCourseId));
                            iCourseUpdated = pst.executeUpdate();
                            if (pst != null) {
                                pst.close();
                            }
                            session.setAttribute("CourseName", (Object)strCourse_Name);
                            session.setAttribute("CourseShortName", (Object)strCourse_Short_Name);
                            strBuffer.append("<CourseId>" + strCourseId + "</CourseId>");
                            if (iCourseUpdated == 1) {
                                strBuffer.append("<message>Courses is updated successfully</message>");
                                break;
                            }
                            strBuffer.append("<message>Courses does not updated successfully</message>");
                            break;
                        }
                        case 1: {
                            strBuffer.append("<message>Not updated, Data already exist</message>");
                            break;
                        }
                        case 2: {
                            strBuffer.append("<message>Course is expired</message>");
                            break;
                        }
                        case 3: {
                            strBuffer.append("<message>Date must be greater than today's date</message>");
                        }
                    }
                    strBuffer.append("</Course>");
                }
                catch (SQLException e) {
                    e.printStackTrace();
                    if (dbConnector != null) {
                        dbConnector.closeConnection(connection);
                        dbConnector = null;
                        connection = null;
                    }
                    break block32;
                }
                catch (Exception e) {
                    try {
                        e.getMessage();
                        break block32;
                    }
                    catch (Throwable throwable) {
                        throw throwable;
                    }
                    finally {
                        if (dbConnector != null) {
                            dbConnector.closeConnection(connection);
                            dbConnector = null;
                            connection = null;
                        }
                    }
                }
                if (dbConnector == null) break block32;
                dbConnector.closeConnection(connection);
                dbConnector = null;
                connection = null;
            }
            out.println(strBuffer.toString());
            out.flush();
            out.close();
        }
    }
}