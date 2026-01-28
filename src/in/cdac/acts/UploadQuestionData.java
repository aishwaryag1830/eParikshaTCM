package in.cdac.acts;

import in.cdac.acts.connection.DBConnector;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.OfficeXmlFileException;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;

public class UploadQuestionData extends HttpServlet {
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
		StringBuilder strPageToRedirect = new StringBuilder();
		this.session = request.getSession(false);
		if (this.session != null && !this.session.equals("")) {
			this.strFilename = this.session.getAttribute("CourseId") + "Question_Data.xls";
			this.uploadFile(request, response);
			if (!this.bInvalidFileType) {
				this.saveToDatabase(request, response);
				if (!this.bInvalidFileData) {
					strUploadMsg = "Question data saved to the Database successfully.";
				} else {
					switch (this.iErrorCodeDataSave) {
						case 1 :
							strUploadMsg = "Invalid file contents, Please upload the data in specified format.";
							break;
						case 2 :
							strUploadMsg = "Some Questions already exist,.";
							break;
						case 3 :
							strUploadMsg = "Error occured while saving data into database.";
							break;
						case 4 :
							strUploadMsg = "No data found, Please upload a correct file.";
							break;
						case 5 :
							strUploadMsg = "Invalid file data, Please upload the correct data file.";
							break;
						case 6 :
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

			this.session.setAttribute("snMsgQuestionUpload", strUploadMsg);
			strPageToRedirect.append("/Questions.jsp");
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
		boolean bGetAllData = false;
		int iQuestionNotInserted = 0;
		int iOptionRepeated = 0;
		int noOfQuestion = 0;
		int iBlankQuestions = 0;
		int iCourseId = Integer.parseInt(this.session.getAttribute("CourseId").toString());
		long lUserId = Long.parseLong(this.session.getAttribute("UserId").toString());
		long lModuleId = Long.parseLong(this.session.getAttribute("snSelectedModuleIdForQuestions").toString());
		String strRepetedInExcel = "";
		String uploadDirectory = this.context.getRealPath("/") + "UserDocs" + File.separator;
		DBConnector dbConnector = null;
		Connection connection = null;
		FileInputStream inputStream = null;

		try {
			inputStream = new FileInputStream(uploadDirectory + File.separator + this.strFilename);
		} catch (FileNotFoundException var54) {
			System.out.println("File not found in the specified path. ");
			var54.printStackTrace();
		}

		try {
			POIFSFileSystem fileSystem = null;

			try {
				fileSystem = new POIFSFileSystem(inputStream);
				HSSFWorkbook workBook = new HSSFWorkbook(fileSystem);
				HSSFSheet sheet = workBook.getSheetAt(0);
				Iterator<Row> rows = sheet.rowIterator();
				Set<Question> QuesSet = new LinkedHashSet<>();
				String strBlankInExcel = "";
				String strQuestionStat = null;
				String strOpt1 = null;
				String strOpt2 = null;
				String strOpt3 = null;
				String strOpt4 = null;
				byte correctAnswer = 0;

				String strCorrectAnswer;
				label397 : while (true) {
					HSSFRow row;
					do {
						if (!rows.hasNext()) {
							break label397;
						}

						row = (HSSFRow) rows.next();
					} while (row.getRowNum() < 1);

					int iCountCell = 0;
					Iterator<Cell> cells = row.cellIterator();

					Question Ques;
					for (Ques = new Question(); cells.hasNext() && iCountCell < 7; ++iCountCell) {
						HSSFCell cell = (HSSFCell) cells.next();
						switch (iCountCell) {
							case 0 :
								cell.setCellType(1);
								if (cell.getRichStringCellValue().toString().trim().equalsIgnoreCase("") || cell
										.getRichStringCellValue().toString().trim().equalsIgnoreCase((String) null)
										|| cell.getRichStringCellValue().length() == 0) {
									bGetAllData = true;
								}
								break;
							case 1 :
								cell.setCellType(1);
								if (!cell.getRichStringCellValue().toString().trim().equalsIgnoreCase("")
										&& !cell.getRichStringCellValue().toString().trim()
												.equalsIgnoreCase((String) null)
										&& cell.getRichStringCellValue().length() != 0) {
									strQuestionStat = cell.getRichStringCellValue().toString().trim();
									break;
								}

								bGetAllData = true;
								break;
							case 2 :
								cell.setCellType(1);
								if (!cell.getStringCellValue().toString().trim().equalsIgnoreCase("")
										&& !cell.getStringCellValue().toString().trim().equalsIgnoreCase((String) null)
										&& cell.getRichStringCellValue().length() != 0) {
									strOpt1 = cell.getRichStringCellValue().toString().trim();
									break;
								}

								bGetAllData = true;
								break;
							case 3 :
								cell.setCellType(1);
								if (!cell.getStringCellValue().toString().trim().equalsIgnoreCase("")
										&& !cell.getStringCellValue().toString().trim().equalsIgnoreCase((String) null)
										&& cell.getRichStringCellValue().length() != 0) {
									strOpt2 = cell.getRichStringCellValue().toString().trim();
									break;
								}

								bGetAllData = true;
								break;
							case 4 :
								cell.setCellType(1);
								if (!cell.getStringCellValue().toString().trim().equalsIgnoreCase("")
										&& !cell.getStringCellValue().toString().trim().equalsIgnoreCase((String) null)
										&& cell.getRichStringCellValue().length() != 0) {
									strOpt3 = cell.getRichStringCellValue().toString().trim();
									break;
								}

								bGetAllData = true;
								break;
							case 5 :
								cell.setCellType(1);
								if (!cell.getStringCellValue().toString().trim().equalsIgnoreCase("")
										&& !cell.getStringCellValue().toString().trim().equalsIgnoreCase((String) null)
										&& cell.getRichStringCellValue().length() != 0) {
									strOpt4 = cell.getRichStringCellValue().toString().trim();
									break;
								}

								bGetAllData = true;
								break;
							case 6 :
								cell.setCellType(1);
								if (!cell.getStringCellValue().toString().trim().equalsIgnoreCase("")
										&& !cell.getStringCellValue().toString().trim().equalsIgnoreCase((String) null)
										&& cell.getRichStringCellValue().length() != 0) {
									strCorrectAnswer = cell.getStringCellValue().toString().trim();
									if (strCorrectAnswer.equalsIgnoreCase("Choice 1")) {
										correctAnswer = 1;
									} else if (strCorrectAnswer.equalsIgnoreCase("Choice 2")) {
										correctAnswer = 2;
									} else if (strCorrectAnswer.equalsIgnoreCase("Choice 3")) {
										correctAnswer = 3;
									} else if (strCorrectAnswer.equalsIgnoreCase("Choice 4")) {
										correctAnswer = 4;
									} else {
										System.out.println("Wrong Select Choice value");
									}
									break;
								}

								bGetAllData = true;
								break;
							default :
								System.out.println("Type not supported. ");
						}

						if (bGetAllData) {
							break;
						}
					}

					try {
						if (bGetAllData) {
							break;
						}

						if (iCountCell == 7) {
//							strQuestionStat = Converter.toHTML(strQuestionStat.trim());
//							strOpt1 = Converter.toHTML(strOpt1.trim());
//							strOpt2 = Converter.toHTML(strOpt2.trim());
//							strOpt3 = Converter.toHTML(strOpt3.trim());
//							strOpt4 = Converter.toHTML(strOpt4.trim());
							strQuestionStat = strQuestionStat.trim();
							strOpt1 = strOpt1.trim();
							strOpt2 = strOpt2.trim();
							strOpt3 = strOpt3.trim();
							strOpt4 = strOpt4.trim();
							Ques.QuestionText = strQuestionStat;
							Ques.Option1 = strOpt1;
							Ques.Option2 = strOpt2;
							Ques.Option3 = strOpt3;
							Ques.Option4 = strOpt4;
							Ques.QuestionNo = noOfQuestion + 1;
							Ques.CorrectAnswer = correctAnswer;
							if (!strOpt1.replaceAll("\\s+", "")
									.equalsIgnoreCase(strOpt2.replaceAll("\\s+", "").toString())
									&& !strOpt1.replaceAll("\\s+", "")
											.equalsIgnoreCase(strOpt3.replaceAll("\\s+", "").toString())
									&& !strOpt1.replaceAll("\\s+", "")
											.equalsIgnoreCase(strOpt4.replaceAll("\\s+", "").toString())
									&& !strOpt2.replaceAll("\\s+", "")
											.equalsIgnoreCase(strOpt3.replaceAll("\\s+", "").toString())
									&& !strOpt2.replaceAll("\\s+", "")
											.equalsIgnoreCase(strOpt4.replaceAll("\\s+", "").toString())
									&& !strOpt3.replaceAll("\\s+", "")
											.equalsIgnoreCase(strOpt4.replaceAll("\\s+", "").toString())) {
								if (!QuesSet.add(Ques)) {
									strRepetedInExcel = strRepetedInExcel
											.concat(String.valueOf(noOfQuestion + 1).concat(","));
									++iQuestionNotInserted;
								}
							} else {
								++iOptionRepeated;
								this.session.setAttribute("QuestionQptionsRepeated", Ques.QuestionNo);
							}
						} else {
							++iBlankQuestions;
							strBlankInExcel = strBlankInExcel + String.valueOf(noOfQuestion + 1) + ",";
						}

						++noOfQuestion;
					} catch (Exception var55) {
						System.out.println("Unable to convert to HTML");
						var55.printStackTrace();
					}
				}

				if (!strBlankInExcel.equalsIgnoreCase("")) {
					strBlankInExcel = strBlankInExcel.substring(0, strBlankInExcel.length() - 1);
					this.session.setAttribute("BlankQuestionInExcel", strBlankInExcel);
				}

				if (!strRepetedInExcel.equalsIgnoreCase((String) null) && !strRepetedInExcel.trim().equalsIgnoreCase("")
						&& strRepetedInExcel.length() != 0) {
					if (strRepetedInExcel.length() == 1) {
						strRepetedInExcel = strRepetedInExcel.substring(0, strRepetedInExcel.length());
					} else {
						strRepetedInExcel = strRepetedInExcel.substring(0, strRepetedInExcel.length() - 1);
					}

					this.session.setAttribute("QuestionInExcel", strRepetedInExcel);
				}

				Question[] ArrayQuestion = new Question[QuesSet.size()];
				QuesSet.toArray(ArrayQuestion);
				String strDBDriverClass = this.session.getAttribute("DBDriverClass").toString();
				String strDBConnectionURL = this.session.getAttribute("DBConnectionURL").toString();
				String strDBDataBaseName = this.session.getAttribute("DBDataBaseName").toString();
				String strDBUserName = this.session.getAttribute("DBUserName").toString();
				strCorrectAnswer = this.session.getAttribute("DBUserPass").toString();
				dbConnector = new DBConnector();
				connection = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName,
						strDBUserName, strCorrectAnswer);
				SearchInsertQuestion dbQuery = new SearchInsertQuestion();
				ArrayList<Question> alques = dbQuery.getQuestion(lModuleId, connection);
				String strQuestionExistInDatabase = null;
				int start = 0;
				int end = ArrayQuestion.length;
				int middle = end / 2;
				Thread thread1 = new ThreadForSearch(ArrayQuestion, start, middle, connection, alques, lModuleId,
						iCourseId, lUserId);
				Thread thread2 = new ThreadForSearch(ArrayQuestion, middle, end, connection, alques, lModuleId,
						iCourseId, lUserId);
				thread1.start();
				thread2.start();
				thread1.join();
				thread2.join();
				TreeSet<Integer> setQuestionExist = ThreadForSearch.getQuestionExist();
				TreeSet<Integer> blankData = new TreeSet<>();
				if (!setQuestionExist.isEmpty()) {
					iQuestionNotInserted += setQuestionExist.size();
					strQuestionExistInDatabase = setQuestionExist.toString();
					this.session.setAttribute("QuestionInDatabase",
							strQuestionExistInDatabase.substring(1, strQuestionExistInDatabase.length() - 1));
					ThreadForSearch.setQuestionExist(blankData);
				}

				iQuestionNotInserted = noOfQuestion - iQuestionNotInserted - iBlankQuestions - iOptionRepeated;
				this.session.setAttribute("totalQuestionUploaded", iQuestionNotInserted);
			} catch (IOException var56) {
				this.iErrorCodeDataSave = 5;
				this.bInvalidFileData = true;
			} catch (OfficeXmlFileException var57) {
				this.iErrorCodeDataSave = 6;
				this.bInvalidFileData = true;
			} catch (Exception var58) {
				var58.printStackTrace();
			}
		} catch (Exception var59) {
			this.iErrorCodeDataSave = 5;
			this.bInvalidFileData = true;
		} finally {
			if (dbConnector != null) {
				dbConnector.closeConnection(connection);
				dbConnector = null;
				connection = null;
			}

		}

	}
}