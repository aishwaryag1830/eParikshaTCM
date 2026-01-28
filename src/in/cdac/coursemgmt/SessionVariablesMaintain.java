package in.cdac.coursemgmt;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class SessionVariablesMaintain extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		super.doGet(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		response.setContentType("text/plain");
		if (session == null) {
			response.sendRedirect(request.getContextPath() + "/error.jsp");
		} else {
			if (session.getAttribute("snSelectedQuestionId") != null) {
				session.removeAttribute("snSelectedQuestionId");
			}

			if (session.getAttribute("snScrollMenuDivPosition") != null) {
				session.removeAttribute("snScrollMenuDivPosition");
			}
		}

	}
}