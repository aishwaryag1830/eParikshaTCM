package in.cdac.acts;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import javax.servlet.http.HttpSession;

public class SearchInsertQuestion {
	HttpSession session = null;
	PreparedStatement stmt = null;

	public ArrayList<Question> getQuestion(long lModuleId, Connection conn) {
		PreparedStatement pstmt = null;
		ResultSet rst = null;
		ArrayList al = new ArrayList();

		try {
			pstmt = conn.prepareStatement(
					"select exam_Ques_Text,exam_Option1,exam_Option2,exam_Option3,exam_Option4 from ePariksha_Exam_Questions where exam_Module_Id = ?");
			pstmt.setLong(1, lModuleId);
			rst = pstmt.executeQuery();

			while (rst.next()) {
				Question ques = new Question();
				ques.QuestionText = rst.getString("exam_Ques_Text");
				ques.Option1 = rst.getString("exam_Option1");
				ques.Option2 = rst.getString("exam_Option2");
				ques.Option3 = rst.getString("exam_Option3");
				ques.Option4 = rst.getString("exam_Option4");
				al.add(ques);
			}
		} catch (Exception var16) {
			var16.printStackTrace();
		} finally {
			try {
				if (pstmt != null) {
					pstmt.close();
				}

				if (rst != null) {
					rst.close();
				}
			} catch (SQLException var15) {
				var15.printStackTrace();
			}

		}

		return al;
	}

	public int insertQuestion(Question ques, long lModuleId, int iCourseId, long iUserId, Connection conn) {
		int iInserted = 0;

		try {
			this.stmt = conn.prepareStatement("Insert into ePariksha_Exam_Questions values (DEFAULT, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
			this.stmt.setString(1, ques.QuestionText);
			this.stmt.setString(2, ques.Option1);
			this.stmt.setString(3, ques.Option2);
			this.stmt.setString(4, ques.Option3);
			this.stmt.setString(5, ques.Option4);
			this.stmt.setInt(6, ques.CorrectAnswer);
			this.stmt.setLong(7, lModuleId);
			this.stmt.setInt(8, iCourseId);
			this.stmt.setLong(9, iUserId);
			iInserted = this.stmt.executeUpdate();
		} catch (Exception var18) {
			var18.printStackTrace();
		} finally {
			try {
				if (this.stmt != null) {
					this.stmt.close();
				}
			} catch (SQLException var17) {
				var17.printStackTrace();
			}

		}

		return iInserted;
	}
}