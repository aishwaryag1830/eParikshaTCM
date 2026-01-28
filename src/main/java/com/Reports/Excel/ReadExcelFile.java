/*
 * Decompiled with CFR 0.150.
 * 
 * Could not load the following classes:
 *  in.cdac.acts.connection.DBConnector
 *  javax.servlet.RequestDispatcher
 *  javax.servlet.ServletException
 *  javax.servlet.ServletRequest
 *  javax.servlet.ServletResponse
 *  javax.servlet.http.HttpServlet
 *  javax.servlet.http.HttpServletRequest
 *  javax.servlet.http.HttpServletResponse
 *  javax.servlet.http.HttpSession
 *  org.apache.poi.hssf.usermodel.HSSFCell
 *  org.apache.poi.hssf.usermodel.HSSFRow
 *  org.apache.poi.hssf.usermodel.HSSFSheet
 *  org.apache.poi.hssf.usermodel.HSSFWorkbook
 *  org.apache.poi.ss.usermodel.Cell
 *  org.apache.poi.ss.usermodel.Row
 */
package com.Reports.Excel;

import in.cdac.acts.connection.DBConnector;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;

public class ReadExcelFile
extends HttpServlet {
    private static final long serialVersionUID = 1L;
    HttpSession session = null;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        this.doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        this.session = request.getSession(false);
        StringBuilder strPageToRedirect = new StringBuilder();
        if (this.session == null || this.session.equals("")) {
            strPageToRedirect.append("/index.jsp");
        } else {
            ArrayList cellDataList = new ArrayList();
            FileInputStream inputstream = null;
            int count = 0;
            int rowsaffected = 0;
            int rowcounter = 0;
            int notNullCount = 0;
            String filelocation = (String)request.getAttribute("filepath");
            inputstream = new FileInputStream(filelocation);
            HSSFWorkbook workbook = new HSSFWorkbook((InputStream)inputstream);
            HSSFSheet sheet = workbook.getSheetAt(0);
            Iterator iterator = sheet.rowIterator();
            block2: for (Row row : sheet) {
                for (Cell cell : row) {
                    if (cell.getCellType() == 3) continue;
                    ++notNullCount;
                    continue block2;
                }
            }
            while (rowcounter < notNullCount) {
                HSSFRow hssfRow = (HSSFRow)iterator.next();
                Iterator coliterator = hssfRow.cellIterator();
                ArrayList<HSSFCell> cellTempList = new ArrayList<HSSFCell>();
                while (coliterator.hasNext()) {
                    HSSFCell hssfCell = (HSSFCell)coliterator.next();
                    cellTempList.add(hssfCell);
                }
                cellDataList.add(cellTempList);
                ++rowcounter;
            }
            DBConnector dbConnector = null;
            Connection connection = null;
            String strCourseId = null;
            String strModuleId = null;
            int userId = 0;
            if (this.session.getAttribute("CourseId") != null) {
                strCourseId = this.session.getAttribute("CourseId").toString();
            }
            if (this.session.getAttribute("CourseId") != null) {
                strModuleId = this.session.getAttribute("snSelectedModuleIdForQuestions").toString();
            }
            if (this.session.getAttribute("UserId") != null) {
                userId = Integer.parseInt(this.session.getAttribute("snSelectedModuleIdForQuestions").toString());
            }
            for (int i = 1; i < cellDataList.size(); ++i) {
                ArrayList<String> cellvaluelist = null;
                List cellTempList = (List)cellDataList.get(i);
                int tempint = 0;
                cellvaluelist = new ArrayList<String>();
                for (int j = 0; j < cellTempList.size(); ++j) {
                    HSSFCell hssfCell = (HSSFCell)cellTempList.get(j);
                    String stringCellValue = hssfCell.toString();
                    if (hssfCell.getCellType() == 0) {
                        tempint = (int)Double.parseDouble(stringCellValue);
                    }
                    cellvaluelist.add(stringCellValue);
                }
                String question = (String)cellvaluelist.get(0);
                String option1 = (String)cellvaluelist.get(1);
                String option2 = (String)cellvaluelist.get(2);
                String option3 = (String)cellvaluelist.get(3);
                String option4 = (String)cellvaluelist.get(4);
                try {
                    String strDBDriverClass = this.session.getAttribute("DBDriverClass").toString();
                    String strDBConnectionURL = this.session.getAttribute("DBConnectionURL").toString();
                    String strDBDataBaseName = this.session.getAttribute("DBDataBaseName").toString();
                    String strDBUserName = this.session.getAttribute("DBUserName").toString();
                    String strDBUserPass = this.session.getAttribute("DBUserPass").toString();
                    dbConnector = new DBConnector();
                    connection = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName, strDBUserName, strDBUserPass);
                    CallableStatement callsatement = connection.prepareCall("call set_question_paper(?,?,?,?,?,?,?,?,?,?)");
                    callsatement.setString(1, question);
                    callsatement.setString(2, option1);
                    callsatement.setString(3, option2);
                    callsatement.setString(4, option3);
                    callsatement.setString(5, option4);
                    callsatement.setInt(6, tempint);
                    callsatement.setInt(7, Integer.parseInt(strModuleId));
                    callsatement.setInt(8, Integer.parseInt(strCourseId));
                    callsatement.setInt(9, userId);
                    callsatement.setInt(10, count);
                    callsatement.registerOutParameter(10, Types.INTEGER);
                    callsatement.executeUpdate();
                    count = callsatement.getInt(10);
                    rowsaffected += count;
                    continue;
                }
                catch (Exception e) {
                    e.printStackTrace();
                }
            }
            request.setAttribute("affectrow", (Object)rowsaffected);
            request.setAttribute("totalrows", (Object)(notNullCount - 1));
            RequestDispatcher dispatcher = request.getRequestDispatcher("Questions.jsp");
            dispatcher.forward((ServletRequest)request, (ServletResponse)response);
            request.setAttribute("affectedrow", (Object)count);
        }
    }
}