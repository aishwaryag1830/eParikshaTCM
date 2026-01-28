package com.Reports.Excel;

public class RowClass {
    String question;
    String option1;
    String option2;
    String option3;
    String option4;

    public String toString() {
        return "RowClass [question=" + this.question + ", option1=" + this.option1 + ", option2=" + this.option2 + ", option3=" + this.option3 + ", option4=" + this.option4 + "]";
    }

    public RowClass() {
    }

    public RowClass(String question, String option1, String option2, String option3, String option4) {
        this.question = question.toLowerCase().trim();
        this.option1 = option1.toLowerCase().trim();
        this.option2 = option2.toLowerCase().trim();
        this.option3 = option3.toLowerCase().trim();
        this.option4 = option4.toLowerCase().trim();
    }

    public String getQuestion() {
        return this.question;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public String getOption1() {
        return this.option1;
    }

    public void setOption1(String option1) {
        this.option1 = option1;
    }

    public String getOption2() {
        return this.option2;
    }

    public void setOption2(String option2) {
        this.option2 = option2;
    }

    public String getOption3() {
        return this.option3;
    }

    public void setOption3(String option3) {
        this.option3 = option3;
    }

    public String getOption4() {
        return this.option4;
    }

    public void setOption4(String option4) {
        this.option4 = option4;
    }

    public int hashCode() {
        int prime = 31;
        int result = 1;
        result = 31 * result + (this.option1 == null ? 0 : this.option1.hashCode());
        result = 31 * result + (this.option2 == null ? 0 : this.option2.hashCode());
        result = 31 * result + (this.option3 == null ? 0 : this.option3.hashCode());
        result = 31 * result + (this.option4 == null ? 0 : this.option4.hashCode());
        result = 31 * result + (this.question == null ? 0 : this.question.hashCode());
        return result;
    }

    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null) {
            return false;
        }
        if (this.getClass() != obj.getClass()) {
            return false;
        }
        RowClass other = (RowClass)obj;
        if (this.option1 == null ? other.option1 != null : !this.option1.equals(other.option1)) {
            return false;
        }
        if (this.option2 == null ? other.option2 != null : !this.option2.equals(other.option2)) {
            return false;
        }
        if (this.option3 == null ? other.option3 != null : !this.option3.equals(other.option3)) {
            return false;
        }
        if (this.option4 == null ? other.option4 != null : !this.option4.equals(other.option4)) {
            return false;
        }
        return !(this.question == null ? other.question != null : !this.question.equals(other.question));
    }
}