package com.Reports.Excel;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SendExcelFile extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("application/vnd.ms-excel");
		response.addHeader("Content-Disposition", "attachment; filename=Result.xls");
		ServletOutputStream stream = response.getOutputStream();
		File excel = new File(request.getServletContext().getRealPath("/") + "/files/result.xls");
		response.setContentLength((int) excel.length());
		FileInputStream input = new FileInputStream(excel);
		BufferedInputStream buf = null;
		buf = new BufferedInputStream(input);
		boolean var7 = false;

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

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	}
}