package props.servlet;

import in.cdac.acts.connection.DBConnect;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class WriteDBConData extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String strDBIp = null;
		String strDBPort = null;
		String strDBName = null;
		String strDBUser = null;
		String strDBPass = null;
		Boolean isDataWritten = false;
		if (request.getParameter("dbip") != null && !request.getParameter("dbip").equalsIgnoreCase("")) {
			strDBIp = request.getParameter("dbip");
		}

		if (request.getParameter("dbport") != null && !request.getParameter("dbport").equalsIgnoreCase("")) {
			strDBPort = request.getParameter("dbport");
		} else {
			strDBPort = "5432";
			//strDBPort = "5494";
		}

		if (request.getParameter("dbname") != null && !request.getParameter("dbname").equalsIgnoreCase("")) {
		
			strDBName = request.getParameter("dbname");
		
		} else {
			strDBName = "ePariksha";
		}

		if (request.getParameter("dbuser") != null && !request.getParameter("dbuser").equalsIgnoreCase("")) {
			strDBUser = request.getParameter("dbuser");
		}

		if (request.getParameter("dbpass") != null && !request.getParameter("dbpass").equalsIgnoreCase("")) {
			strDBPass = request.getParameter("dbpass");
		}

		if (strDBIp != null && strDBPort != null && strDBName != null && strDBUser != null && strDBPass != null) {
			DBConnect dbConnect = new DBConnect(this.getServletContext().getRealPath("/Property/DataBase.properties"));
			isDataWritten = dbConnect.writeDBData(strDBIp, strDBPort, strDBName, strDBUser, strDBPass);
			dbConnect = null;
			response.setHeader("db", isDataWritten.toString());
		} else {
			response.setHeader("db", isDataWritten.toString());
		}

	}
}