package in.cdac.acts;

public class Question {
	String QuestionText;
	String Option1;
	String Option2;
	String Option3;
	String Option4;
	int CorrectAnswer;
	int QuestionNo;

	public Question(String questionText, String option1, String option2, String option3, String option4,
			int correctAnswer, int iQuestion_No) {
		this.QuestionText = questionText;
		this.Option1 = option1;
		this.Option2 = option2;
		this.Option3 = option3;
		this.Option4 = option4;
		this.CorrectAnswer = correctAnswer;
		this.QuestionNo = iQuestion_No;
	}

	public Question() {
	}

	public int getQuestionNo() {
		return this.QuestionNo;
	}

	public void setQuestionNo(int QuestionNo) {
		this.QuestionNo = QuestionNo;
	}

	public String getQuestionText() {
		return this.QuestionText;
	}

	public void setQuestionText(String questionText) {
		this.QuestionText = questionText;
	}

	public String getOption1() {
		return this.Option1;
	}

	public void setOption1(String option1) {
		this.Option1 = option1;
	}

	public String getOption2() {
		return this.Option2;
	}

	public void setOption2(String option2) {
		this.Option2 = option2;
	}

	public String getOption3() {
		return this.Option3;
	}

	public void setOption3(String option3) {
		this.Option3 = option3;
	}

	public String getOption4() {
		return this.Option4;
	}

	public void setOption4(String option4) {
		this.Option4 = option4;
	}

	public int getCorrectAnswer() {
		return this.CorrectAnswer;
	}

	public void setCorrectAnswer(int correctAnswer) {
		this.CorrectAnswer = correctAnswer;
	}

	public boolean equals(Object arg) {
		Question obj = (Question) arg;
		if (obj == null) {
			return false;
		} else {
			return this.getQuestionText().replaceAll("\\s+", "")
					.equalsIgnoreCase(obj.getQuestionText().replaceAll("\\s+", ""))
					&& this.getOption1().replaceAll("\\s+", "")
							.equalsIgnoreCase(obj.getOption1().replaceAll("\\s+", ""))
					&& this.getOption2().replaceAll("\\s+", "")
							.equalsIgnoreCase(obj.getOption2().replaceAll("\\s+", ""))
					&& this.getOption3().replaceAll("\\s+", "")
							.equalsIgnoreCase(obj.getOption3().replaceAll("\\s+", ""))
					&& this.getOption4().replaceAll("\\s+", "")
							.equalsIgnoreCase(obj.getOption4().replaceAll("\\s+", ""));
		}
	}

	public int hashCode() {
        int prime = 31;
        int result = 1;
        result = 31 * result + (this.QuestionText == null ? 0 : this.QuestionText.replaceAll("\\s+", "").hashCode());
        result = 31 * result + (this.Option1 == null ? 0 : (int)this.Option1.trim().replaceAll("\\s+", "").charAt(0));
        return result;
    }
	
}