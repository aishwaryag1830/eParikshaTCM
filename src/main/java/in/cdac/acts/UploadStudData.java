package in.cdac.acts;

import in.cdac.acts.connection.DBConnector;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Iterator;
import java.util.List;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import jxl.Cell;
import jxl.CellType;
import jxl.Sheet;
import jxl.Workbook;
import jxl.read.biff.BiffException;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

public class UploadStudData extends HttpServlet {
	private static final long serialVersionUID = 1L;
	ServletContext context = null;
	HttpSession session = null;
	String strFilename = null;
	boolean bInvalidFileType = false;
	boolean bInvalidFileData = true;
	int iErrorCodeFileUpload = 0;
	int iErrorCodeDataSave = 0;

	public void init(ServletConfig config) throws ServletException {
		super.init(config);
		this.context = config.getServletContext();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String strUploadMsg = null;
		String strUploadMsgColor = null;
		StringBuilder strPageToRedirect = new StringBuilder();
		this.session = request.getSession(false);
		if (this.session != null && !this.session.equals("")) {
			this.strFilename = this.session.getAttribute("CourseId") + "Student_Login_Data.xls";
			System.out.println("filename"+this.strFilename);
			this.uploadFile(request, response);
			if (!this.bInvalidFileType) {
				this.saveToDatabase(request, response);
				if (!this.bInvalidFileData) {
					strUploadMsg = "Student data saved to the Database successfully.";
				} else {
					switch (this.iErrorCodeDataSave) {
						case 1 :
							strUploadMsg = "Invalid file contents, Please upload the data in specified format.";
							break;
						case 2 :
							strUploadMsg = "PRN already exist, Please clean the database.";
							break;
						case 3 :
							strUploadMsg = "Error occured while saving data into database.";
							break;
						case 4 :
							strUploadMsg = "No data found, Please upload a correct file.";
							break;
						case 5 :
							strUploadMsg = "Invalid file data, Please upload the correct data file.";
					}
				}
			} else {
				switch (this.iErrorCodeFileUpload) {
					case 1 :
						strUploadMsg = "Some Error has occured while uploading file.";
						break;
					case 2 :
						strUploadMsg = "Invalid file type/Please upload Excel file only.";
						break;
					case 3 :
						strUploadMsg = "The File  you are trying to upload does not exist.";
				}
			}

			this.session.setAttribute("snMsgCandidateUnBlock", strUploadMsg);
			strPageToRedirect.append("/UnBlockUser.jsp");
		} else {
			strPageToRedirect.append("/index.jsp");
		}

		response.sendRedirect(request.getContextPath() + strPageToRedirect);
	}

	protected void uploadFile(HttpServletRequest request, HttpServletResponse response) {
		String uploadDirectory = this.context.getRealPath("/") + "UserDocs" + File.separator;
		FileItemFactory fileFactory = new DiskFileItemFactory(100, new File(uploadDirectory));
		ServletFileUpload serFileUpload = new ServletFileUpload(fileFactory);

		try {
			List<File> fileItem = serFileUpload.parseRequest(request);
			Iterator<File> iter = fileItem.iterator();
			if (iter.hasNext()) {
				FileItem item = (FileItem) iter.next();
				if (item.getName() == null) {
					this.iErrorCodeFileUpload = 3;
					this.bInvalidFileType = true;
				} else if (item == null || !item.getContentType().equalsIgnoreCase("application/vnd.ms-excel")
						&& !item.getContentType().equalsIgnoreCase("application/octet-stream")) {
					this.iErrorCodeFileUpload = 2;
					this.bInvalidFileType = true;
				} else {
					File tempdel = new File(uploadDirectory + File.separator + "*.tmp");
					File fPrevFiledel = new File(uploadDirectory + File.separator + this.strFilename);

					try {
						if (fPrevFiledel.exists()) {
							fPrevFiledel.delete();
						}

						item.write(new File(uploadDirectory + File.separator + this.strFilename));
						this.bInvalidFileType = false;
						tempdel.delete();
					} catch (Exception var12) {
						this.iErrorCodeFileUpload = 1;
						this.bInvalidFileType = true;
						var12.printStackTrace();
					}
				}
			}

			fileItem.clear();
		} catch (FileUploadException var13) {
			var13.printStackTrace();
		}

		fileFactory = null;
		response.setHeader("Cache-Control", "no-cache");
	}

	protected void saveToDatabase(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		DBConnector dbConnector = null;
		Connection connection = null;
		PreparedStatement statement = null;
		String strCourseId = null;
		if (this.session.getAttribute("CourseId") != null) {
			strCourseId = this.session.getAttribute("CourseId").toString();
		}

		int iNoOfRow = 0;
		int iNoOfColumn = 0;

		try {
			Workbook workbook = Workbook
					.getWorkbook(new File(this.context.getRealPath("/") + "UserDocs" + File.separator + this.strFilename));
			Sheet sheet = workbook.getSheet(0);

			Cell cellForColumn;
			while (true) {
				try {
					cellForColumn = sheet.getCell(0, iNoOfRow);
					System.out.println("row " + cellForColumn.getContents() + " " + iNoOfRow);
					if (cellForColumn.getContents() == "") {
						break;
					}

					++iNoOfRow;
				} catch (Exception var29) {
					var29.printStackTrace();
					break;
				}
			}

			while (true) {
				try {
					cellForColumn = sheet.getCell(iNoOfColumn, 0);
					System.out.println("col " + cellForColumn.getContents() + " " + iNoOfColumn);
					if (cellForColumn.getContents().equalsIgnoreCase("")) {
						break;
					}

					++iNoOfColumn;
				} catch (Exception var30) {
					var30.printStackTrace();
					break;
				}
			}

			if (iNoOfRow > 1 && iNoOfColumn >= 4) {
				for (int iRowIndex = 1; iRowIndex < iNoOfRow; ++iRowIndex) {
					StringBuilder strUserId = new StringBuilder();
					StringBuilder strPassword = new StringBuilder();
					StringBuilder strFName = new StringBuilder();
					StringBuilder strMName = new StringBuilder();
					StringBuilder strLName = new StringBuilder();
					int iColumnIndex = 0;

					while (iColumnIndex < iNoOfColumn) {
						Cell cell = sheet.getCell(iColumnIndex, iRowIndex);
						switch (iColumnIndex) {
							case 0 :
								if (cell.getType() == CellType.NUMBER) {
									strUserId.delete(0, strUserId.length());
									strUserId.append(cell.getContents());
								} else {
									strUserId.delete(0, strUserId.length());
								}
							case 1 :
								if (cell.getType() == CellType.LABEL) {
									strFName.delete(0, strFName.length());
									strFName.append(cell.getContents());
								} else {
									strFName.delete(0, strFName.length());
								}
							case 2 :
								if (cell.getType() == CellType.LABEL) {
									strMName.delete(0, strMName.length());
									strMName.append(cell.getContents());
								} else {
									strMName.delete(0, strMName.length());
								}
							case 3 :
								if (cell.getType() == CellType.LABEL) {
									strLName.delete(0, strLName.length());
									strLName.append(cell.getContents());
								} else {
									strLName.delete(0, strLName.length());
								}
							default :
								++iColumnIndex;
						}
					}

					if (strUserId != null && strUserId.length() > 6) {
						strPassword.append(strUserId.substring(strUserId.length() - 4, strUserId.length()));
					}

					try {
						if (strUserId.length() <= 6 || strFName.length() <= 0) {
							this.iErrorCodeDataSave = 1;
							this.bInvalidFileData = true;
							break;
						}

						//System.out.println("strUserId" + strUserId);
						if (statement != null) {
							statement.close();
						}

						String strDBDriverClass = this.session.getAttribute("DBDriverClass").toString();
						String strDBConnectionURL = this.session.getAttribute("DBConnectionURL").toString();
						String strDBDataBaseName = this.session.getAttribute("DBDataBaseName").toString();
						String strDBUserName = this.session.getAttribute("DBUserName").toString();
						String strDBUserPass = this.session.getAttribute("DBUserPass").toString();
						dbConnector = new DBConnector();
						connection = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName,
								strDBUserName, strDBUserPass);
						statement = connection.prepareStatement(
								"insert into ePariksha_Student_Login (stud_PRN, stud_Password, stud_F_Name, stud_M_Name, stud_L_Name, stud_Role_Id, stud_login_flag, stud_Course_Id) values(TRIM(?),TRIM(?),TRIM(?),TRIM(?),TRIM(?),TRIM(?), ?, ?)",
								1005, 1008);
						statement.setString(1, strUserId.toString());
						statement.setString(2, strPassword.toString());
						statement.setString(3, strFName.toString());
						statement.setString(4, strMName.toString());
						statement.setString(5, strLName.toString());
						statement.setString(6, "0");
						statement.setBoolean(7, false);
						statement.setInt(8, Integer.parseInt(strCourseId));
						statement.executeUpdate();
						if (statement != null) {
							statement.close();
						}

						this.bInvalidFileData = false;
					} catch (SQLException var28) {
						var28.printStackTrace();
						this.bInvalidFileData = true;
						if (var28.getErrorCode() == 2627) {
							this.iErrorCodeDataSave = 2;
						} else {
							this.iErrorCodeDataSave = 3;
						}
					}

					strUserId = null;
					strPassword = null;
				}
			} else {
				this.iErrorCodeDataSave = 4;
				this.bInvalidFileData = true;
			}

			if (workbook != null) {
				workbook.close();
			}
		} catch (BiffException var31) {
			this.iErrorCodeDataSave = 5;
			this.bInvalidFileData = true;
			var31.printStackTrace();
		} finally {
			if (dbConnector != null) {
				dbConnector.closeConnection(connection);
				dbConnector = null;
				connection = null;
			}

		}

	}
}