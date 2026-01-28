package in.cdac.coursemgmt;

import in.cdac.acts.connection.DBConnector;
import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Types;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class CopyQuestions extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session == null) {
			response.sendRedirect(request.getContextPath() + "/error.jsp");
		} else {
			String sSelctedQuestionIds = null;
			String sDestCourseId = null;
			String sDestModuleId = null;
			String sSrcModuleId = null;
			if (session.getAttribute("CourseId") != null) {
				sDestCourseId = session.getAttribute("CourseId").toString();
			}

			if (session.getAttribute("snSelectedModuleIdForQuestions") != null) {
				sDestModuleId = session.getAttribute("snSelectedModuleIdForQuestions").toString();
			}

			if (session.getAttribute("snSelectedModuleIdForQuestions") != null) {
				sSrcModuleId = session.getAttribute("snSelectedModuleIdOfDrp").toString();
			}

			if (request.getParameter("txtFinalSelQuestions") != null) {
				sSelctedQuestionIds = request.getParameter("txtFinalSelQuestions");
			}

			int iOperationSuccessRows = 0;
			if (sSelctedQuestionIds != null) {
				DBConnector dbConnector = null;
				Connection con = null;
				String msg = null;

				try {
					String strDBDriverClass = session.getAttribute("DBDriverClass").toString();
					String strDBConnectionURL = session.getAttribute("DBConnectionURL").toString();
					String strDBDataBaseName = session.getAttribute("DBDataBaseName").toString();
					String strDBUserName = session.getAttribute("DBUserName").toString();
					String strDBUserPass = session.getAttribute("DBUserPass").toString();
					dbConnector = new DBConnector();
					con = dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName,
							strDBUserName, strDBUserPass);
					CallableStatement cstmtCopyQuestions = con.prepareCall("call CopySelectedQuestions(?,?,?,?,?)");
					cstmtCopyQuestions.setInt(1, Integer.parseInt(sDestCourseId));
					cstmtCopyQuestions.setInt(2, Integer.parseInt(sDestModuleId));
					cstmtCopyQuestions.setInt(3, Integer.parseInt(sSrcModuleId));
					cstmtCopyQuestions.setString(4, sSelctedQuestionIds);
					
					cstmtCopyQuestions.setInt(5, iOperationSuccessRows);
					cstmtCopyQuestions.registerOutParameter(5, Types.INTEGER);
					
					cstmtCopyQuestions.execute();
					iOperationSuccessRows = cstmtCopyQuestions.getInt(5);
				} catch (Exception var21) {
					var21.printStackTrace();
				} finally {
					if (dbConnector != null) {
						dbConnector.closeConnection(con);
						dbConnector = null;
						con = null;
					}

				}

				if (iOperationSuccessRows == 0) {
					msg = "Copying operation failed";
				} else if (iOperationSuccessRows == 1) {
					msg = iOperationSuccessRows + " question is copied successfully";
				} else if (iOperationSuccessRows > 1) {
					msg = iOperationSuccessRows + " questions are copied successfully";
				}

				session.setAttribute("snMsgQuestions", msg);
				response.sendRedirect(request.getContextPath() + "/Questions.jsp");
			}
		}

	}
}