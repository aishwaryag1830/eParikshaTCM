package in.cdac.coursemgmt;

import in.cdac.acts.connection.DBConnector;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class SetToDefault extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		StringBuilder msg = new StringBuilder("{ ");
		String sCourseId = null;
		DBConnector dbConnector = null;
		Connection connection = null;
		String strDBDriverClass = session.getAttribute("DBDriverClass").toString();
		String strDBConnectionURL = session.getAttribute("DBConnectionURL").toString();
		String strDBDataBaseName = session.getAttribute("DBDataBaseName").toString();
		String strDBUserName = session.getAttribute("DBUserName").toString();
		String strDBUserPass = session.getAttribute("DBUserPass").toString();
		dbConnector = new DBConnector();
		connection = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName, strDBUserName,
				strDBUserPass);
		if (session != null && !session.equals("") && session.getAttribute("DBDriverClass") != null) {
			if (session.getAttribute("CourseId") != null) {
				sCourseId = session.getAttribute("CourseId").toString();
			}

			System.out.println("course Id" + sCourseId);
			PreparedStatement selectStatement = null;
			ResultSet result = null;
			PrintWriter writer = response.getWriter();
			ArrayList<String> listOfPassword = new ArrayList<>();
			ArrayList<String> listOfRollNumbers = new ArrayList<>();
			String selectQuery = "Select stud_PRN from ePariksha_Student_Login where stud_Course_Id=?";

			try {
				selectStatement = connection.prepareStatement(selectQuery);
				selectStatement.setInt(1, Integer.parseInt(sCourseId));
				result = selectStatement.executeQuery();

				String updateQuery;
				int i;
				while (result.next()) {
					updateQuery = result.getString("stud_PRN");
					i = updateQuery.length();
					int startIndex = i - 4;
					String rollNumber = updateQuery.substring(startIndex, i);
					listOfRollNumbers.add(updateQuery);
					listOfPassword.add(rollNumber);
				}

				updateQuery = "Update ePariksha_Student_Login Set stud_Password = ? where stud_PRN = ? and stud_Course_Id=?";
				if (listOfPassword.size() == listOfRollNumbers.size() && listOfPassword.size() != 0
						&& listOfRollNumbers.size() != 0) {
					for (i = 0; i < listOfPassword.size(); ++i) {
						PreparedStatement insertStatement = connection.prepareStatement(updateQuery);
						insertStatement.setString(1, (String) listOfPassword.get(i));
						insertStatement.setString(2, (String) listOfRollNumbers.get(i));
						insertStatement.setInt(3, Integer.parseInt(sCourseId));
						insertStatement.executeUpdate();
						if (insertStatement != null) {
							insertStatement.close();
						}
					}
				}

				writer.write("Updated Successfully");
			} catch (Exception var32) {
				writer.write("Error occur's");
			} finally {
				try {
					if (result != null) {
						result.close();
					}

					if (selectStatement != null) {
						selectStatement.close();
					}

					if (connection != null) {
						connection.close();
					}

					if (listOfPassword.size() != 0) {
						listOfPassword.clear();
					}

					if (listOfRollNumbers.size() != 0) {
						listOfRollNumbers.clear();
					}
				} catch (SQLException var31) {
					writer.write("Error occur's");
				}

				if (writer != null) {
					writer.close();
				}

			}
		} else {
			msg.append("status : 'error'");
			msg.append("}");
		}

	}
}