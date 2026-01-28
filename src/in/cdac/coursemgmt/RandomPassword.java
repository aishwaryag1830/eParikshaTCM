package in.cdac.coursemgmt;

import in.cdac.acts.connection.DBConnector;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Random;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.poi.hssf.usermodel.HSSFHeader;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Header;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class RandomPassword
extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        this.doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String sCourseId = null;
        HttpSession session = request.getSession(false);
        StringBuilder msg = new StringBuilder("{ ");
        if (session == null || session.equals("") || session.getAttribute("DBDriverClass") == null) {
            msg.append("status : 'error'");
            msg.append("}");
        } else {
            if (session.getAttribute("CourseId") != null) {
                sCourseId = session.getAttribute("CourseId").toString();
            }
            String scheck = "";
            if (request.getParameter("id") != null) {
                scheck = request.getParameter("id").toString();
            }
            msg.append("status:true,");
            DBConnector dbConnector = null;
            Connection connection = null;
            String strDBDriverClass = session.getAttribute("DBDriverClass").toString();
            String strDBConnectionURL = session.getAttribute("DBConnectionURL").toString();
            String strDBDataBaseName = session.getAttribute("DBDataBaseName").toString();
            String strDBUserName = session.getAttribute("DBUserName").toString();
            String strDBUserPass = session.getAttribute("DBUserPass").toString();
            dbConnector = new DBConnector();
            connection = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName, strDBUserName, strDBUserPass);
            if (scheck.equals("download")) {
                this.downladpassword(connection, session, msg, sCourseId);
            } else {
                this.genearatePassword(connection, session, msg, sCourseId);
            }
            msg.append("}");
            response.getWriter().print(msg.toString());
        }
    }

    StringBuilder getRandomPassword() {
        StringBuilder strtempPassword = new StringBuilder();
        ArrayList<String> anArrayOfStrings = new ArrayList<String>();
        anArrayOfStrings.add("A");
        anArrayOfStrings.add("B");
        anArrayOfStrings.add("C");
        anArrayOfStrings.add("D");
        anArrayOfStrings.add("E");
        anArrayOfStrings.add("F");
        anArrayOfStrings.add("G");
        anArrayOfStrings.add("H");
        anArrayOfStrings.add("I");
        anArrayOfStrings.add("J");
        anArrayOfStrings.add("K");
        anArrayOfStrings.add("L");
        anArrayOfStrings.add("M");
        anArrayOfStrings.add("N");
        anArrayOfStrings.add("O");
        anArrayOfStrings.add("P");
        anArrayOfStrings.add("Q");
        anArrayOfStrings.add("R");
        anArrayOfStrings.add("U");
        anArrayOfStrings.add("V");
        anArrayOfStrings.add("W");
        anArrayOfStrings.add("X");
        anArrayOfStrings.add("Y");
        anArrayOfStrings.add("Z");
        Random randomGenerator = new Random();
        for (int idx = 0; idx < 6; ++idx) {
            Integer randomInt;
            if (idx < 2) {
                Collections.shuffle(anArrayOfStrings);
                randomInt = randomGenerator.nextInt(10);
                strtempPassword.append((String)anArrayOfStrings.get(randomInt));
                continue;
            }
            randomInt = randomGenerator.nextInt(10);
            strtempPassword.append(randomInt);
        }
        return strtempPassword;
    }

    void updateStudentPassword(String strPRN, StringBuilder strPassword, Connection connection) {
        PreparedStatement statement = null;
        int result = 0;
        try {
            statement = connection.prepareStatement("update ePariksha_Student_Login SET stud_Password=? , stud_Login_Flag='false' where stud_PRN=?");
            statement.setString(1, strPassword.toString());
            statement.setString(2, strPRN);
            result = statement.executeUpdate();
            if (statement != null) {
                statement.close();
            }
            statement = connection.prepareStatement("select * from  ePariksha_Student_Login  where stud_PRN=?");
            statement.setString(1, strPRN);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

    void downladpassword(Connection connection, HttpSession session, StringBuilder msg, String sCourseId) {
        PreparedStatement statement = null;
        ResultSet result = null;
        String strPRN = null;
        String strName = null;
        String strPassword = "AC1234";
        String strCourseName = null;
        String strCourseShortName = null;
        try {
            statement = connection.prepareStatement("select course_Name,course_Short_Name from ePariksha_Courses where course_Id=?");
            statement.setLong(1, Long.parseLong(sCourseId));
            result = statement.executeQuery();
            while (result.next()) {
                strCourseName = result.getString("course_Name");
                strCourseShortName = result.getString("course_Short_Name");
            }
            if (statement != null) {
                statement.close();
            }
            XSSFWorkbook wb = new XSSFWorkbook();
            StringBuilder strConShortName = null;
            Sheet sheet = null;
            String strmodule_Name = strCourseShortName;
            if (strmodule_Name.length() > 30) {
                String[] strShort = strmodule_Name.split(" ");
                strConShortName = new StringBuilder();
                for (int k = 0; k < strShort.length; ++k) {
                    strConShortName.append(strShort[k].charAt(0));
                }
                sheet = wb.createSheet(strConShortName.toString());
            } else {
                sheet = wb.createSheet(strmodule_Name);
            }
            Header header = sheet.getHeader();
            header.setLeft("CDAC's Advanced Computing Training School");
            header.setRight(String.valueOf(HSSFHeader.font((String)"Stencil-Normal", (String)"Calibri")) + HSSFHeader.fontSize((short)16));
            int i = 1;
            CellStyle style = wb.createCellStyle();
            style = wb.createCellStyle();
            style.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
            style.setFillPattern((short)1);
            style.setWrapText(true);
            CellStyle styleWrap = wb.createCellStyle();
            styleWrap.setBorderLeft((short)1);
            styleWrap.setBorderTop((short)1);
            styleWrap.setBorderBottom((short)1);
            styleWrap.setBorderRight((short)1);
            styleWrap = wb.createCellStyle();
            styleWrap.setWrapText(true);
            Row row = sheet.createRow(i++);
            Cell cell = row.createCell(0);
            row = sheet.createRow(i++);
            cell = row.createCell(0);
            cell.setCellValue("Course Name");
            cell.setCellStyle(style);
            cell = row.createCell(1);
            cell.setCellValue(String.valueOf(strCourseName) + "(" + strCourseShortName + ")");
            cell.setCellStyle(styleWrap);
            row = sheet.createRow(i++);
            style = wb.createCellStyle();
            style.setFillForegroundColor(IndexedColors.GREY_50_PERCENT.getIndex());
            style.setBorderLeft((short)1);
            style.setBorderTop((short)1);
            style.setBorderBottom((short)1);
            style.setBorderRight((short)1);
            style.setFillPattern((short)1);
            int n = ++i;
            ++i;
            row = sheet.createRow(n);
            cell = row.createCell(0);
            cell.setCellStyle(style);
            cell.setCellValue("PRN No.");
            cell = row.createCell(1);
            cell.setCellStyle(style);
            cell.setCellValue("Student Name");
            cell = row.createCell(2);
            cell.setCellStyle(style);
            cell.setCellValue("Password");
            CellStyle styleStudent = wb.createCellStyle();
            styleStudent = wb.createCellStyle();
            styleStudent.setBorderBottom((short)1);
            styleStudent.setBorderTop((short)1);
            styleStudent.setBorderLeft((short)1);
            styleStudent.setBorderRight((short)1);
            styleStudent.setWrapText(true);
            ArrayList<String> slist = new ArrayList<String>();
            statement = connection.prepareStatement("SELECT stud_PRN,stud_F_Name,stud_M_Name,stud_L_Name,stud_Password from ePariksha_Student_Login where stud_Course_Id=?");
            statement.setLong(1, Long.parseLong(sCourseId));
            result = statement.executeQuery();
            while (result.next()) {
                strPRN = result.getString("stud_PRN");
                strName = String.valueOf(result.getString("stud_F_Name")) + " " + result.getString("stud_M_Name") + " " + result.getString("stud_L_Name");
                strPassword = result.getString("stud_Password");
                slist.add(String.valueOf(strPRN) + "," + strName + "," + strPassword);
            }
            Collections.sort(slist);
            for (String s : slist) {
                row = sheet.createRow(i);
                cell = row.createCell(0);
                cell.setCellValue(s.split(",")[0]);
                cell.setCellStyle(styleStudent);
                cell = row.createCell(1);
                cell.setCellValue(s.split(",")[1]);
                cell.setCellStyle(styleStudent);
                cell = row.createCell(2);
                cell.setCellValue(s.split(",")[2]);
                cell.setCellStyle(styleStudent);
                ++i;
            }
            String filepath = String.valueOf(session.getServletContext().getRealPath("/")) + "Results" + File.separator;
            File folder = new File(filepath);
            if (!folder.exists()) {
                folder.mkdirs();
            }
            FileOutputStream fileOut = new FileOutputStream(String.valueOf(filepath) + strCourseName + '(' + strCourseShortName + ')' + ".xlsx");
            wb.write((OutputStream)fileOut);
            fileOut.close();
            msg.append("filepath:'Results/" + strCourseName + '(' + strCourseShortName + ')' + ".xlsx'");
            if (statement != null) {
                statement.close();
            }
            if (statement != null) {
                statement.close();
                statement = null;
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

    void genearatePassword(Connection connection, HttpSession session, StringBuilder msg, String sCourseId) {
        PreparedStatement statement = null;
        ResultSet result = null;
        String strPRN = null;
        String strName = null;
        StringBuilder strPassword = new StringBuilder("AC1234");
        String strCourseName = null;
        String strCourseShortName = null;
        try {
            statement = connection.prepareStatement("select course_Name,course_Short_Name from ePariksha_Courses where course_Id=?");
            statement.setLong(1, Long.parseLong(sCourseId));
            result = statement.executeQuery();
            while (result.next()) {
                strCourseName = result.getString("course_Name");
                strCourseShortName = result.getString("course_Short_Name");
            }
            if (statement != null) {
                statement.close();
            }
            XSSFWorkbook wb = new XSSFWorkbook();
            StringBuilder strConShortName = null;
            Sheet sheet = null;
            String strmodule_Name = strCourseShortName;
            if (strmodule_Name.length() > 30) {
                String[] strShort = strmodule_Name.split(" ");
                strConShortName = new StringBuilder();
                for (int k = 0; k < strShort.length; ++k) {
                    strConShortName.append(strShort[k].charAt(0));
                }
                sheet = wb.createSheet(strConShortName.toString());
            } else {
                sheet = wb.createSheet(strmodule_Name);
            }
            Header header = sheet.getHeader();
            header.setLeft("CDAC's Advanced Computing Training School");
            header.setRight(String.valueOf(HSSFHeader.font((String)"Stencil-Normal", (String)"Calibri")) + HSSFHeader.fontSize((short)16));
            int i = 1;
            CellStyle style = wb.createCellStyle();
            style = wb.createCellStyle();
            style.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
            style.setFillPattern((short)1);
            style.setWrapText(true);
            CellStyle styleWrap = wb.createCellStyle();
            styleWrap.setBorderLeft((short)1);
            styleWrap.setBorderTop((short)1);
            styleWrap.setBorderBottom((short)1);
            styleWrap.setBorderRight((short)1);
            styleWrap = wb.createCellStyle();
            styleWrap.setWrapText(true);
            Row row = sheet.createRow(i++);
            Cell cell = row.createCell(0);
            row = sheet.createRow(i++);
            cell = row.createCell(0);
            cell.setCellValue("Course Name");
            cell.setCellStyle(style);
            cell = row.createCell(1);
            cell.setCellValue(String.valueOf(strCourseName) + "(" + strCourseShortName + ")");
            cell.setCellStyle(styleWrap);
            row = sheet.createRow(i++);
            style = wb.createCellStyle();
            style.setFillForegroundColor(IndexedColors.GREY_50_PERCENT.getIndex());
            style.setBorderLeft((short)1);
            style.setBorderTop((short)1);
            style.setBorderBottom((short)1);
            style.setBorderRight((short)1);
            style.setFillPattern((short)1);
            int n = ++i;
            ++i;
            row = sheet.createRow(n);
            cell = row.createCell(0);
            cell.setCellStyle(style);
            cell.setCellValue("PRN No.");
            cell = row.createCell(1);
            cell.setCellStyle(style);
            cell.setCellValue("Student Name");
            cell = row.createCell(2);
            cell.setCellStyle(style);
            cell.setCellValue("Password");
            CellStyle styleStudent = wb.createCellStyle();
            styleStudent = wb.createCellStyle();
            styleStudent.setBorderBottom((short)1);
            styleStudent.setBorderTop((short)1);
            styleStudent.setBorderLeft((short)1);
            styleStudent.setBorderRight((short)1);
            styleStudent.setWrapText(true);
            ArrayList<String> slist = new ArrayList<String>();
            statement = connection.prepareStatement("SELECT stud_PRN,stud_F_Name,stud_M_Name,stud_L_Name from ePariksha_Student_Login where stud_Course_Id=?");
            statement.setInt(1, Integer.parseInt(sCourseId));
            result = statement.executeQuery();
            while (result.next()) {
                strPRN = result.getString("stud_PRN");
                strName = String.valueOf(result.getString("stud_F_Name")) + " " + result.getString("stud_M_Name") + " " + result.getString("stud_L_Name");
                strPassword = this.getRandomPassword();
                slist.add(String.valueOf(strPRN) + "," + strName + "," + strPassword);
                this.updateStudentPassword(strPRN, strPassword, connection);
            }
            Collections.sort(slist);
            for (String s : slist) {
                row = sheet.createRow(i);
                cell = row.createCell(0);
                cell.setCellValue(s.split(",")[0]);
                cell.setCellStyle(styleStudent);
                cell = row.createCell(1);
                cell.setCellValue(s.split(",")[1]);
                cell.setCellStyle(styleStudent);
                cell = row.createCell(2);
                cell.setCellValue(s.split(",")[2]);
                cell.setCellStyle(styleStudent);
                ++i;
            }
            String filepath = String.valueOf(session.getServletContext().getRealPath("/")) + "Results" + File.separator;
            File folder = new File(filepath);
            if (!folder.exists()) {
                folder.mkdirs();
            }
            FileOutputStream fileOut = new FileOutputStream(String.valueOf(filepath) + strCourseName + '(' + strCourseShortName + ')' + ".xlsx");
            wb.write((OutputStream)fileOut);
            System.out.println(filepath);
            fileOut.close();
            msg.append("filepath:'Results/" + strCourseName + '(' + strCourseShortName + ')' + ".xlsx'");
            if (statement != null) {
                statement.close();
            }
            if (statement != null) {
                statement.close();
                statement = null;
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
}