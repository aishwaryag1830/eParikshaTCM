package com.Reports.Excel;

import java.io.Serializable;

public class Result implements Serializable {
	private static final long serialVersionUID = 1L;
	int serialNo;
	String prnNo;
	String userName;
	int marks;
	float percentage;
	String result;

	public Result() {
		this(0, "", "", 0, 0.0F, "");
	}

	public Result(int serialNo, String prnNo, String userName, int marks, float percentage, String result) {
		this.serialNo = serialNo;
		this.prnNo = prnNo;
		this.userName = userName;
		this.marks = marks;
		this.percentage = percentage;
		this.result = result;
	}

	public int getSerialNo() {
		return this.serialNo;
	}

	public void setSerialNo(int serialNo) {
		this.serialNo = serialNo;
	}

	public String getPrnNo() {
		return this.prnNo;
	}

	public void setPrnNo(String prnNo) {
		this.prnNo = prnNo;
	}

	public String getUserName() {
		return this.userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public int getMarks() {
		return this.marks;
	}

	public void setMarks(int marks) {
		this.marks = marks;
	}

	public float getPercentage() {
		return this.percentage;
	}

	public void setPercentage(float percentage) {
		this.percentage = percentage;
	}

	public String isResult() {
		return this.result;
	}

	public void setResult(String result) {
		this.result = result;
	}

	public String toString() {
		return "Result [serialNo=" + this.serialNo + ", prnNo=" + this.prnNo + ", userName=" + this.userName
				+ ", marks=" + this.marks + ", percentage=" + this.percentage + ", result=" + this.result + "]";
	}
}