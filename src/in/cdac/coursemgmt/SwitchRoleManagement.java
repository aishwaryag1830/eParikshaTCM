package in.cdac.coursemgmt;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class SwitchRoleManagement extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session == null) {
			response.sendRedirect(request.getContextPath() + "/error.jsp");
		} else {
			String sCourseId = null;
			String strUserName = null;
			String sUserIdSuperAdmin = null;
			String sUserIdExaminerSel = null;
			if (request.getParameter("txtCourseId") != null) {
				sCourseId = request.getParameter("txtCourseId").toString();
			}

			if (request.getParameter("txtExaminerUserId") != null) {
				sUserIdExaminerSel = request.getParameter("txtExaminerUserId").toString();
			}

			if (request.getParameter("txtSuperAdminId") != null) {
				sUserIdSuperAdmin = request.getParameter("txtSuperAdminId").toString();
			}

			if (request.getParameter("txtSuperAdminName") != null) {
				strUserName = request.getParameter("txtSuperAdminName").toString();
			}

			session.setAttribute("UserId", sUserIdSuperAdmin);
			if (session.getAttribute("UserRoleId") != null) {
				session.setAttribute("ActualAdminRoleId", session.getAttribute("UserRoleId").toString());
			}

			session.setAttribute("UserRoleId", "001");
			session.setAttribute("CourseId", sCourseId);
			session.setAttribute("sActualExaminerId", sUserIdExaminerSel);
			response.sendRedirect(request.getContextPath() + "/ExaminerHome.jsp");
		}

	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		super.doPost(request, response);
	}
}