package com.Reports.Excel;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Iterator;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFPalette;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.util.CellRangeAddress;

public class ResultExcelExport extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		FileOutputStream fileOut = new FileOutputStream(
				request.getServletContext().getRealPath("/") + "/files/result.xls");
		HSSFWorkbook workbook = new HSSFWorkbook();
		HSSFSheet sheet = workbook.createSheet("test");
		HSSFCellStyle style = workbook.createCellStyle();
		style.setBorderTop((short) 6);
		style.setBorderBottom((short) 6);
		style.setBorderLeft((short) 6);
		style.setBorderRight((short) 6);
		style.setFillForegroundColor((short) 22);
		style.setAlignment((short) 2);
		style.setFillPattern((short) 1);
		HSSFPalette palette = workbook.getCustomPalette();
		palette.setColorAtIndex((short) 10, (byte) -89, (byte) 5, (byte) 5);
		palette.setColorAtIndex((short) 22, (byte) -14, (byte) -14, (byte) -14);
		HSSFCellStyle upperheadingstyle = workbook.createCellStyle();
		upperheadingstyle.setBorderTop((short) 6);
		upperheadingstyle.setBorderBottom((short) 6);
		upperheadingstyle.setBorderLeft((short) 6);
		upperheadingstyle.setBorderRight((short) 6);
		upperheadingstyle.setAlignment((short) 2);
		upperheadingstyle.setFillForegroundColor((short) 10);
		upperheadingstyle.setFillPattern((short) 1);
		upperheadingstyle.setAlignment((short) 2);
		HSSFCellStyle tablerowstyle = workbook.createCellStyle();
		tablerowstyle.setBorderTop((short) 6);
		tablerowstyle.setBorderLeft((short) 6);
		tablerowstyle.setBorderBottom((short) 6);
		tablerowstyle.setBorderRight((short) 6);
		tablerowstyle.setAlignment((short) 2);
		HSSFFont hSSFFont = workbook.createFont();
		hSSFFont.setFontName("Arial");
		hSSFFont.setFontHeightInPoints((short) 11);
		hSSFFont.setBoldweight((short) 700);
		hSSFFont.setColor((short) 8);
		style.setFont(hSSFFont);
		hSSFFont = workbook.createFont();
		hSSFFont.setFontName("Arial");
		hSSFFont.setFontHeightInPoints((short) 12);
		hSSFFont.setBoldweight((short) 700);
		hSSFFont.setColor((short) 9);
		upperheadingstyle.setFont(hSSFFont);
		sheet.setColumnWidth(2, 8000);
		sheet.setColumnWidth(1, 5000);
		sheet.setColumnWidth(4, 3500);
		sheet.autoSizeColumn(1);
		HSSFCellStyle resultsummarstyle = workbook.createCellStyle();
		resultsummarstyle.setFillForegroundColor((short) 22);
		resultsummarstyle.setFillPattern((short) 1);
		resultsummarstyle.setBorderTop((short) 6);
		resultsummarstyle.setBorderLeft((short) 6);
		resultsummarstyle.setBorderBottom((short) 6);
		resultsummarstyle.setBorderRight((short) 6);
		resultsummarstyle.setAlignment((short) 2);

		try {
			HSSFRow row = null;
			HSSFRow firstrow = null;
			HSSFCell firstrowcell = null;
			int count = 3;
			String CourseName = null;
			List<Result> lst = null;
			if (session.getAttribute("resultlist") != null) {
				lst = (List) session.getAttribute("resultlist");
			}

			if (session.getAttribute("snCourseName") != null) {
				CourseName = session.getAttribute("snCourseName").toString();
			}

			int numberofcells = 0;
			int passstudentcount = 0;
			if (session.getAttribute("passstudcount") != null) {
				passstudentcount = Integer.parseInt(session.getAttribute("passstudcount").toString());
			}

			firstrow = sheet.createRow(0);
			firstrowcell = firstrow.createCell(0);
			firstrowcell.setCellStyle(upperheadingstyle);
			firstrowcell.setCellValue(CourseName.toString().replaceFirst(CourseName.substring(0, 1),
					CourseName.substring(0, 1).toUpperCase()) + "  Result");
			sheet.addMergedRegion(new CellRangeAddress(0, 1, 0, 5));
			row = sheet.createRow(2);
			Cell[] cell = new Cell[6];

			for (int index = 0; index <= 5; ++index) {
				cell[index] = row.createCell(index);
				cell[index].setCellStyle(style);
			}

			cell[0].setCellValue("S.No");
			cell[1].setCellValue("PRN No");
			cell[2].setCellValue("User name");
			cell[3].setCellValue("Marks");
			cell[4].setCellValue("Percentage");
			cell[5].setCellValue("Result");
			HSSFCell[] cellarrofsummarydata;
			if (lst == null) {
				response.sendRedirect("index.jsp?lgn=2");
			} else {
				Iterator var25 = lst.iterator();

				while (true) {
					if (!var25.hasNext()) {
						int numberofrows = lst.size();
						HSSFRow summaryrowtitle = sheet.createRow(numberofrows + 6);
						HSSFCell summaryrowcell1 = summaryrowtitle.createCell(1);
						HSSFCell summaryrowcell2 = summaryrowtitle.createCell(2);
						cellarrofsummarydata = new HSSFCell[2];
						summaryrowcell1.setCellStyle(resultsummarstyle);
						summaryrowcell2.setCellStyle(resultsummarstyle);
						sheet.addMergedRegion(new CellRangeAddress(numberofrows + 6, numberofrows + 6, 1, 2));
						summaryrowcell1.setCellValue("Summary of Result");
						HSSFRow summaryrow = sheet.createRow(numberofrows + 7);
						HSSFRow summaryrow1 = sheet.createRow(numberofrows + 8);
						HSSFRow summaryrow2 = sheet.createRow(numberofrows + 9);

						int numofcells;
						for (numofcells = 0; numofcells < cellarrofsummarydata.length; ++numofcells) {
							cellarrofsummarydata[numofcells] = summaryrow.createCell(numofcells + 1);
							cellarrofsummarydata[numofcells].setCellStyle(tablerowstyle);
						}

						cellarrofsummarydata[0].setCellValue("Total Student");
						cellarrofsummarydata[1].setCellValue((double) numberofrows);

						for (numofcells = 0; numofcells < cellarrofsummarydata.length; ++numofcells) {
							cellarrofsummarydata[numofcells] = summaryrow1.createCell(numofcells + 1);
							cellarrofsummarydata[numofcells].setCellStyle(tablerowstyle);
						}

						cellarrofsummarydata[0].setCellValue("Pass Student");
						cellarrofsummarydata[1].setCellValue((double) passstudentcount);

						for (numofcells = 0; numofcells < cellarrofsummarydata.length; ++numofcells) {
							cellarrofsummarydata[numofcells] = summaryrow2.createCell(numofcells + 1);
							cellarrofsummarydata[numofcells].setCellStyle(tablerowstyle);
						}

						cellarrofsummarydata[0].setCellValue("Fail Student");
						cellarrofsummarydata[1].setCellValue((double) (numberofrows - passstudentcount));
						break;
					}

					Result result = (Result) var25.next();
					row = sheet.createRow(count);

					for (int number = 0; number <= 5; ++number) {
						cell[number] = row.createCell(number);
						cell[number].setCellStyle(tablerowstyle);
					}

					cell[numberofcells].setCellValue((double) result.getSerialNo());
					cell[numberofcells + 1].setCellValue(result.getPrnNo());
					cell[numberofcells + 2].setCellValue(result.getUserName());
					cell[numberofcells + 3].setCellValue((double) result.getMarks());
					cell[numberofcells + 4].setCellValue((double) result.getPercentage());
					cell[numberofcells + 5].setCellValue(result.isResult());
					++count;
				}
			}

			workbook.write(fileOut);
			response.setContentType("application/vnd.ms-excel");
			response.addHeader("Content-Disposition", "attachment; filename=Result.xls");
			ServletOutputStream stream = response.getOutputStream();
			File excel = new File(request.getServletContext().getRealPath("/") + "/files/result.xls");
			response.setContentLength((int) excel.length());
			FileInputStream input = new FileInputStream(excel);
			cellarrofsummarydata = null;
			BufferedInputStream buf = new BufferedInputStream(input);
			boolean var40 = false;

			int readBytes;
			while ((readBytes = buf.read()) != -1) {
				stream.write(readBytes);
			}

			if (stream != null) {
				stream.close();
			}

			if (buf != null) {
				buf.close();
			}
		} catch (Exception var32) {
			var32.printStackTrace();
		}

	}
}