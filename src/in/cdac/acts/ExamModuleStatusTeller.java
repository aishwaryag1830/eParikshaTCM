package in.cdac.acts;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ExamModuleStatusTeller {
	public boolean isExamScheduledToday(Connection con, String sModuleId) throws SQLException {
		boolean bFlag = false;
		PreparedStatement pstmt = con.prepareStatement(
				"select to_char(exam_Date, 'DD-MM-YYYY') examDate from ePariksha_Exam_Schedule where exam_Module_Id=? and to_char(exam_Date, 'DD-MM-YYYY') = to_char(now(), 'DD-MM-YYYY')",
				1005, 1007);
		pstmt.setLong(1, Long.parseLong(sModuleId));
		ResultSet rs = null;
		rs = pstmt.executeQuery();
		if (rs.next()) {
			bFlag = true;
		}

		if (rs != null) {
			rs.close();
		}

		if (pstmt != null) {
			pstmt.close();
		}

		return bFlag;
	}

	public boolean isResultFound(Connection con, String sModuleId, String sStudentId) throws SQLException {
		boolean bFlag = false;
		PreparedStatement pstmt = con.prepareStatement(
				"select result_Id from ePariksha_Student_Login,ePariksha_Results where ePariksha_Student_Login.stud_PRN=ePariksha_Results.result_Stud_PRN and ePariksha_Results.result_Module_Id=? and ePariksha_Student_Login.stud_PRN=TRIM(?) and to_char(result_Exam_Date, 'DD-MM-YYYY') = to_char(now(), 'DD-MM-YYYY')",
				1005, 1007);
		pstmt.setLong(1, Long.parseLong(sModuleId));
		pstmt.setString(2, sStudentId);
		ResultSet rs = null;
		rs = pstmt.executeQuery();
		if (rs.next()) {
			bFlag = true;
		}

		if (rs != null) {
			rs.close();
		}

		if (pstmt != null) {
			pstmt.close();
		}

		return bFlag;
	}

	public boolean isResultShown(Connection con, String sModuleId) throws SQLException {
		boolean bIsResultShown = false;
		PreparedStatement pstmt = con.prepareStatement(
				"select exam_ShowResult from epariksha_Exam_Schedule where exam_Module_Id=? and to_char(exam_Date, 'DD-MM-YYYY') = to_char(now(), 'DD-MM-YYYY')",
				1005, 1007);
		pstmt.setLong(1, Long.parseLong(sModuleId));
		ResultSet rs = null;
		rs = pstmt.executeQuery();
		if (rs.next()) {
			bIsResultShown = rs.getBoolean("exam_ShowResult");
		}

		return bIsResultShown;
	}

	public boolean isExamActive(Connection con, String sModuleId) throws SQLException {
		boolean bExamStatus = false;
		PreparedStatement pstmt = con.prepareStatement(
				"select exam_Status from epariksha_Exam_Schedule where exam_Module_Id=? and to_char(exam_Date, 'DD-MM-YYYY') = to_char(now(), 'DD-MM-YYYY')",
				1005, 1007);
		pstmt.setLong(1, Long.parseLong(sModuleId));
		ResultSet rs = null;
		rs = pstmt.executeQuery();
		if (rs.next()) {
			bExamStatus = rs.getBoolean("exam_Status");
		}

		if (rs != null) {
			rs.close();
		}

		if (pstmt != null) {
			pstmt.close();
		}

		return bExamStatus;
	}

	public String getQuestionPaperStream(Connection con, String strCourseId, String sModuleId, String sStudentId)
			throws SQLException {
		String strQuestionPaper = null;
		ResultSet result = null;
		PreparedStatement statement = con.prepareStatement(
				"select exam_Paper_Stream from ePariksha_Exam_Paper where exam_Stud_PRN =TRIM(?) and exam_Course_Id=? and exam_Module_Id=? and to_char(exam_Date, 'DD-MM-YYYY HH12:MI:SS') like to_char(CURRENT_TIMESTAMP, 'DD-MM-YYYY HH12:MI:SS')",
				1004, 1007);
		statement.setString(1, sStudentId);
		statement.setInt(2, Integer.parseInt(strCourseId));
		statement.setLong(3, Long.parseLong(sModuleId));
		result = statement.executeQuery();
		if (result.next()) {
			strQuestionPaper = result.getString("exam_Paper_Stream");
		}

		return strQuestionPaper;
	}

	public String getExamDurationOfModule(Connection con, String strCourseId, String sModuleId) throws SQLException {
		ResultSet result = null;
		String sExamDuration = null;
		PreparedStatement statement = con.prepareStatement(
				"select exam_Time_Duration from ePariksha_Exam_Schedule where exam_Module_Id\t=\t? and exam_Course_Id=? and to_char(exam_Date, 'DD-MM-YYYY') = to_char(now(), 'DD-MM-YYYY')",
				1004, 1007);
		statement.setLong(1, Long.parseLong(sModuleId));
		statement.setInt(2, Integer.parseInt(strCourseId));
		result = statement.executeQuery();
		if (result.next()) {
			sExamDuration = result.getString("exam_Time_Duration");
		}

		return sExamDuration;
	}

	public String getExamQuestionsOfModule(Connection con, String strCourseId, String sModuleId) throws SQLException {
		ResultSet result = null;
		String sExamNoOfQuestions = null;
		PreparedStatement statement = con.prepareStatement(
				"select exam_No_Of_Ques from ePariksha_Exam_Schedule where exam_Module_Id=? and exam_Course_Id=? and to_char(exam_Date, 'DD-MM-YYYY') = to_char(now(), 'DD-MM-YYYY')",
				1004, 1007);
		statement.setLong(1, Long.parseLong(sModuleId));
		statement.setInt(2, Integer.parseInt(strCourseId));
		result = statement.executeQuery();
		if (result.next()) {
			sExamNoOfQuestions = result.getString("exam_No_Of_Ques");
		}

		return sExamNoOfQuestions;
	}

	public String getTimeInHHMMSECFormat(long lTimeInMiliSec) {
		long SECOND = 1000L;
		long MINUTE = 60000L;
		long lDifInHr = 0L;
		long lDifInMins = 0L;
		long lDifInSecs = 0L;
		String strTime = null;
		lDifInMins = lTimeInMiliSec / 60000L;
		lDifInSecs = (lTimeInMiliSec - lDifInMins * 60000L) / 1000L;
		lDifInHr = lDifInMins / 60L;
		lDifInMins = (long) (((double) lDifInMins / 60.0D - (double) lDifInHr) * 60.0D);
		if (lDifInHr < 10L) {
			strTime = " 0" + lDifInHr;
		} else {
			strTime = " " + lDifInHr;
		}

		if (lDifInMins < 10L) {
			strTime = strTime + ":0" + lDifInMins;
		} else {
			strTime = strTime + ":" + lDifInMins;
		}

		if (lDifInSecs < 10L) {
			strTime = strTime + ":0" + lDifInSecs;
		} else {
			strTime = strTime + ":" + lDifInSecs;
		}

		return strTime;
	}
}