package in.cdac.acts;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class Results extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = null;
		session = request.getSession(true);
		if (session == null) {
			response.sendRedirect(request.getContextPath() + "/error.jsp");
		} else {
			try {
				new HashMap<>();
				new ArrayList<>();
				ArrayList<String> arrlst = (ArrayList) session.getAttribute("snarrlst");
				Map<Integer, String> mapmodulelist = (Map) session.getAttribute("snModuleMap");
				String ExamDate = null;
				if (request.getParameter("selectExamDate") != null) {
					ExamDate = request.getParameter("selectExamDate");
					session.setAttribute("snExamDateSelected", ExamDate);
				}

				if (session.getAttribute("snExamDateSelected") != null) {
					ExamDate = session.getAttribute("snExamDateSelected").toString();
				}

				request.setAttribute("reqmapmodulelist", mapmodulelist);
				request.setAttribute("reqarrlstexamdatelist", arrlst);
				request.setAttribute("reqstrExamDate", ExamDate);
				RequestDispatcher dispather = request.getRequestDispatcher("Results.jsp");
				dispather.forward(request, response);
			} catch (Exception var8) {
				var8.printStackTrace();
			}
		}

	}
}