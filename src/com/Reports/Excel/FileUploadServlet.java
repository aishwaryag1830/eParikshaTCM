package com.Reports.Excel;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Iterator;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

public class FileUploadServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String TMP_DIR_PATH = "c:\\sherinAppTemp";
	private File tmpDir;
	private static final String DESTINATION_DIR_PATH = "/files";
	private File destinationDir;

	public void init(ServletConfig config) throws ServletException {
		super.init(config);
		this.tmpDir = new File("c:\\sherinAppTemp");
		if (!this.tmpDir.isDirectory()) {
			this.tmpDir.mkdir();
		}

		String realPath = this.getServletContext().getRealPath("/files");
		this.destinationDir = new File(realPath);
		if (!this.destinationDir.isDirectory()) {
			this.destinationDir.mkdir();
		}

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		PrintWriter out = response.getWriter();
		response.setContentType("text/plain");
		HttpSession session = request.getSession(false);
		if (session != null) {
			session.equals("");
		}

		String returnmessage = null;
		DiskFileItemFactory fileItemFactory = new DiskFileItemFactory();
		fileItemFactory.setSizeThreshold(5242880);
		fileItemFactory.setRepository(this.tmpDir);
		ServletFileUpload uploadHandler = new ServletFileUpload(fileItemFactory);

		try {
			List<?> items = uploadHandler.parseRequest(request);
			Iterator itr = items.iterator();

			while (itr.hasNext()) {
				FileItem item = (FileItem) itr.next();
				if (!item.getContentType().equals("application/vnd.ms-excel")) {
					response.sendRedirect("Questions.jsp");
				} else if (item.getContentType().equals("application/vnd.ms-excel")) {
					if (item.isFormField()) {
						out.println("File Name = " + item.getFieldName() + ", Value = " + item.getString());
					} else {
						out.println("Field Name = " + item.getFieldName() + ", File Name = " + item.getName()
								+ ", Content type = " + item.getContentType() + ", File Size = " + item.getSize());
						FileValidation validfile = new FileValidation();
						returnmessage = validfile.validate(item.getInputStream());
						if (returnmessage.equals("success")) {
							File file = new File(this.destinationDir + "\\" + item.getName());
							item.write(file);
							request.setAttribute("filepath", this.destinationDir + "\\" + item.getName());
							RequestDispatcher dispatcher = request.getRequestDispatcher("ReadExcelFile");
							dispatcher.forward(request, response);
						} else {
							request.setAttribute("errormessage",
									"File is not uploaded as either file contains duplicate or some of the fields are blank");
							RequestDispatcher dispatcher = request.getRequestDispatcher("Questions.jsp");
							dispatcher.forward(request, response);
						}
					}

					out.close();
				}
			}
		} catch (FileUploadException var14) {
			this.log("Error encountered while parsing the request", var14);
		} catch (Exception var15) {
			this.log("Error encountered while uploading file", var15);
			var15.getMessage();
		}

	}
}