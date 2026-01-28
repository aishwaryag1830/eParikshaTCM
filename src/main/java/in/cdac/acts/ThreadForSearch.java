package in.cdac.acts;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.TreeSet;

class ThreadForSearch extends Thread {
	String QuestionNoExist = null;
	Question[] ques;
	Connection conn;
	final ArrayList<Question> alques;
	static String strQuestionExist = "";
	static TreeSet<Integer> questionExist = new TreeSet<>();
	int end;
	int start;
	long lModuleId;
	long lUserId;
	int iCourseId;

	ThreadForSearch(Question[] ques, int start, int end, Connection conn, ArrayList<Question> alques, long lModuleId,
			int iCourseId, long lUserId) {
		this.ques = ques;
		this.end = end;
		this.start = start;
		this.alques = alques;
		this.conn = conn;
		this.lModuleId = lModuleId;
		this.iCourseId = iCourseId;
		this.lUserId = lUserId;
	}

	public void run() {
		this.search_Insert();
	}

	public synchronized void search_Insert() {
		SearchInsertQuestion dbQuery = new SearchInsertQuestion();

		try {
			new Question();

			for (int i = this.start; i < this.end; ++i) {
				boolean Question_exist = false;
				Iterator itrQuestion = this.alques.iterator();

				while (itrQuestion.hasNext()) {
					Question question1 = (Question) itrQuestion.next();
					if (this.ques[i].equals(question1)) {
						Question_exist = true;
						questionExist.add(this.ques[i].getQuestionNo());
						break;
					}
				}

				if (!Question_exist) {
					dbQuery.insertQuestion(this.ques[i], this.lModuleId, this.iCourseId, this.lUserId, this.conn);
				}
			}
		} catch (Exception var6) {
			var6.printStackTrace();
			System.out.println("Child interrupted.");
		}

	}

	public static void setQuestionExist(TreeSet<Integer> questionExist) {
		questionExist = questionExist;
	}

	public static TreeSet<Integer> getQuestionExist() {
		return questionExist;
	}
}