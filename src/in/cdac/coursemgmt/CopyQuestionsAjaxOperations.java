package in.cdac.coursemgmt;

import in.cdac.acts.connection.DBConnector;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Types;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class CopyQuestionsAjaxOperations extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private void getModulesAjax(Connection con, HttpServletResponse res, HttpSession sn, String sCourseId,
			String sDestModuleId) {
		res.setContentType("text/xml");
		PrintWriter out = null;
		ResultSet rs_dropdown = null;
		String moduleId = null;
		String moduleName = null;
		String shortModuleName = null;
		StringBuffer responseBuffer = new StringBuffer();

		try {
			out = res.getWriter();
			Statement stmt_dropdown = con.createStatement(1004, 1007);
			rs_dropdown = stmt_dropdown
					.executeQuery("select module_Id,module_Name from ePariksha_Modules where module_Course_Id = '"
							+ sCourseId + "' and module_Id!='" + sDestModuleId + "'  order by module_Id");
			responseBuffer.append("<?xml version='1.0'?>");
			responseBuffer.append("<Modules>");
			if (rs_dropdown.next()) {
				rs_dropdown.beforeFirst();

				while (rs_dropdown.next()) {
					moduleId = rs_dropdown.getString("module_Id");
					moduleName = rs_dropdown.getString("module_Name");
					if (moduleName.length() > 25) {
						shortModuleName = moduleName.substring(0, 25) + "...";
					} else {
						shortModuleName = moduleName;
					}

					responseBuffer.append("<moduleSerialId>");
					responseBuffer.append("<moduleId>" + moduleId + "</moduleId>");
					responseBuffer.append("<moduleShortName>" + shortModuleName + "</moduleShortName>");
					responseBuffer.append("<moduleName>" + moduleName + "</moduleName>");
					responseBuffer.append("</moduleSerialId>");
				}
			} else {
				rs_dropdown.beforeFirst();
			}

			responseBuffer.append("</Modules>");
		} catch (Exception var13) {
			var13.printStackTrace();
		}

		out.write(responseBuffer.toString());
		out.flush();
		out.close();
	}

	private String getXMLStringForQuestionCriteria(int iTotalQuestions) {
		StringBuffer sFormattedXMLString = new StringBuffer();
		sFormattedXMLString.append("<?xml version='1.0'?>");
		sFormattedXMLString.append("<Questions>");
		if (iTotalQuestions > 0) {
			int iRemainder = iTotalQuestions % 50;
			int iQuotient = iTotalQuestions / 50;
			int iStart = 0;
			int iEnd = 1;

			for (int i = 1; i <= iQuotient; ++i) {
				iStart = iEnd;
				iEnd += 49;
				sFormattedXMLString.append("<questionsSerialId>");
				sFormattedXMLString.append("<questionValue>" + iStart + "-" + iEnd + "</questionValue>");
				sFormattedXMLString.append("</questionsSerialId>");
				++iEnd;
			}

			if (iRemainder > 0) {
				sFormattedXMLString.append("<questionsSerialId>");
				sFormattedXMLString
						.append("<questionValue>" + iEnd + "-" + (iEnd - 1 + iRemainder) + "</questionValue>");
				sFormattedXMLString.append("</questionsSerialId>");
			}
		}

		sFormattedXMLString.append("</Questions>");
		return sFormattedXMLString.toString();
	}

	private void getQuestionsForModule(Connection con, HttpServletResponse res, HttpSession sn, String sModuleId) {
		res.setContentType("text/xml");
		PrintWriter out = null;
		String sFinalResponse = null;
		ResultSet rs_dropdown = null;
		int iTotalQuestions = 0;

		try {
			out = res.getWriter();
			Statement stmt_dropdown = con.createStatement(1004, 1007);
			rs_dropdown = stmt_dropdown.executeQuery(
					"select count(distinct exam_Ques_Id) totalQuestions from ePariksha_Exam_Questions where exam_Module_Id = '"
							+ sModuleId + "' ");
			if (rs_dropdown.next()) {
				iTotalQuestions = Integer.parseInt(rs_dropdown.getString("totalQuestions"));
			}

			sFinalResponse = this.getXMLStringForQuestionCriteria(iTotalQuestions);
		} catch (Exception var10) {
			var10.printStackTrace();
		}

		out.write(sFinalResponse);
		out.flush();
		out.close();
	}

	private void isSelectedQuestionExists(Connection con, HttpServletResponse res, HttpSession sn,
			String sActualQuestionId, String sSrcModuleId, String sDestinationModuleId) {
		res.setContentType("text/xml");
		PrintWriter out = null;
		StringBuilder sbFinalResponseXML = new StringBuilder("");

		try {
			out = res.getWriter();
			CallableStatement cstmtIsQuestionPresent = con.prepareCall("call IsQuestionExists(" + sActualQuestionId
					+ "," + sSrcModuleId + "," + sDestinationModuleId + ",?)");
			cstmtIsQuestionPresent.setBoolean(1, false);
			cstmtIsQuestionPresent.registerOutParameter(1, Types.BOOLEAN);
			cstmtIsQuestionPresent.execute();
			sbFinalResponseXML.append("<?xml version='1.0'?>");
			sbFinalResponseXML.append("<QuestionExistence>");
			sbFinalResponseXML
					.append("<isThisQuestExists>" + cstmtIsQuestionPresent.getBoolean(1) + "</isThisQuestExists>");
			sbFinalResponseXML.append("</QuestionExistence>");
		} catch (Exception var10) {
			var10.printStackTrace();
		}

		out.write(sbFinalResponseXML.toString());
		out.flush();
		out.close();
	}

	private void isQuestionExistsAddUpdate(Connection con, HttpServletResponse res, HttpSession sn, String sSrcModuleId,
			String sSelectedQuestionText, String sOption1, String sOption2, String sOption3, String sOption4,
			int iCorrectAns) {
		res.setContentType("text/xml");
		PrintWriter out = null;
		StringBuilder sbFinalResponseXML = new StringBuilder("");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean bIsQuesExists = false;

		try {
			out = res.getWriter();
			String sql = "select exam_Ques_Id from ePariksha_Exam_Questions where exam_Module_Id=? and LOWER(TRIM(exam_Ques_Text))=LOWER(TRIM(?)) and LOWER(TRIM(exam_Option1))=LOWER(TRIM(?)) and LOWER(TRIM(exam_Option2))=LOWER(TRIM(?)) and LOWER(TRIM(exam_Option3))=LOWER(TRIM(?)) and LOWER(TRIM(exam_Option4))=LOWER(TRIM(?)) and exam_Correct_Answer=?";
			pstmt = con.prepareStatement(sql, 1004, 1007);
			pstmt.setLong(1, Long.parseLong(sSrcModuleId));
//			pstmt.setString(2, Converter.toHTML(sSelectedQuestionText).trim());
//			pstmt.setString(3, Converter.toHTML(sOption1).trim());
//			pstmt.setString(4, Converter.toHTML(sOption2).trim());
//			pstmt.setString(5, Converter.toHTML(sOption3).trim());
//			pstmt.setString(6, Converter.toHTML(sOption4).trim());
			pstmt.setString(2, sSelectedQuestionText);
			pstmt.setString(3, sOption1);
			pstmt.setString(4, sOption2);
			pstmt.setString(5, sOption3);
			pstmt.setString(6, sOption4);
			
			pstmt.setInt(7, iCorrectAns);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				bIsQuesExists = true;
			}

			sbFinalResponseXML.append("<?xml version='1.0'?>");
			sbFinalResponseXML.append("<QuestionExistence>");
			sbFinalResponseXML.append("<isThisQuestExists>" + bIsQuesExists + "</isThisQuestExists>");
			sbFinalResponseXML.append("</QuestionExistence>");
		} catch (Exception var17) {
			var17.printStackTrace();
		}

		out.write(sbFinalResponseXML.toString());
		out.flush();
		out.close();
	}

	protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
	}

	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		HttpSession sn = req.getSession(false);
		String sSelectedCourseId = null;
		String sSelectedModuleId = null;
		String sSelectedQuestionId = null;
		String sModuleIdDestination = null;
		String sSelQuestionText = null;
		String sModuleId = null;
		String sOption1 = null;
		String sOption2 = null;
		String sOption3 = null;
		String sOption4 = null;
		int iCorrectAns = 0;
		String sSrcModuleIdQuestCopy = null;
		String sDestModuleIdQuestCopy = null;
		String sFunctionIdentifier = null;
		Connection con = null;
		DBConnector dbConnector = new DBConnector();
		if (sn != null && !sn.equals("")) {
			try {
				String strDBDriverClass = sn.getAttribute("DBDriverClass").toString();
				String strDBConnectionURL = sn.getAttribute("DBConnectionURL").toString();
				String strDBDataBaseName = sn.getAttribute("DBDataBaseName").toString();
				String strDBUserName = sn.getAttribute("DBUserName").toString();
				String strDBUserPass = sn.getAttribute("DBUserPass").toString();
				con = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName, strDBUserName,
						strDBUserPass);
				sFunctionIdentifier = req.getParameter("sfunctionIdentifier");
				if (sFunctionIdentifier.equalsIgnoreCase("1")) {
					sSelectedCourseId = req.getParameter("sCourseIdAjax");
					if (sn.getAttribute("snSelectedModuleIdForQuestions") != null) {
						sModuleIdDestination = sn.getAttribute("snSelectedModuleIdForQuestions").toString();
					}

					this.getModulesAjax(con, res, sn, sSelectedCourseId, sModuleIdDestination);
				}

				if (sFunctionIdentifier.equalsIgnoreCase("2")) {
					sSelectedModuleId = req.getParameter("sModuleIdAjax");
					sn.setAttribute("snSelectedModuleIdOfDrp", sSelectedModuleId);
					this.getQuestionsForModule(con, res, sn, sSelectedModuleId);
				}

				if (sFunctionIdentifier.equalsIgnoreCase("3")) {
					sSelectedQuestionId = req.getParameter("sSelectedQuestionId");
					if (sn.getAttribute("snSelectedModuleIdOfDrp") != null) {
						sSrcModuleIdQuestCopy = sn.getAttribute("snSelectedModuleIdOfDrp").toString();
					}

					if (sn.getAttribute("snSelectedModuleIdForQuestions") != null) {
						sDestModuleIdQuestCopy = sn.getAttribute("snSelectedModuleIdForQuestions").toString();
					}

					this.isSelectedQuestionExists(con, res, sn, sSelectedQuestionId, sSrcModuleIdQuestCopy,
							sDestModuleIdQuestCopy);
				}

				if (sFunctionIdentifier.equalsIgnoreCase("4")) {
					sModuleId = sn.getAttribute("snSelectedModuleIdForQuestions").toString();
					sSelQuestionText = req.getParameter("sQuestionText");
					sOption1 = req.getParameter("sOption1");
					sOption2 = req.getParameter("sOption2");
					sOption3 = req.getParameter("sOption3");
					sOption4 = req.getParameter("sOption4");
					iCorrectAns = Integer.parseInt(req.getParameter("iCorrectAns"));
					this.isQuestionExistsAddUpdate(con, res, sn, sModuleId, sSelQuestionText, sOption1, sOption2,
							sOption3, sOption4, iCorrectAns);
				}
			} catch (Exception var28) {
				var28.printStackTrace();
				res.sendRedirect(req.getContextPath() + "/error.jsp");
			} finally {
				if (dbConnector != null) {
					dbConnector.closeConnection(con);
					dbConnector = null;
					con = null;
				}

			}
		} else {
			res.sendRedirect(req.getContextPath() + "/error.jsp");
		}

	}
}