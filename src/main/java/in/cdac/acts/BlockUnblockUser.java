package in.cdac.acts;

import in.cdac.acts.connection.DBConnector;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class BlockUnblockUser extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private static String ArrayToString(String[] sSelectedIds) {
		String sTempIds = "";
		String[] var5 = sSelectedIds;
		int var4 = sSelectedIds.length;

		for (int var3 = 0; var3 < var4; ++var3) {
			String sIterator = var5[var3];
			sTempIds = sIterator + "," + sTempIds;
		}

		return sTempIds.substring(0, sTempIds.length() - 1);
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		super.doGet(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session == null) {
			response.sendRedirect(request.getContextPath() + "/error.jsp");
		} else {
			String[] sSelctedCandidateIds = (String[]) null;
			if (request.getParameter("chkSelectCandidate") != null) {
				sSelctedCandidateIds = request.getParameterValues("chkSelectCandidate");
			}

			PreparedStatement pstmt = null;
			int iOperationSuccessRows = 0;
			if (sSelctedCandidateIds != null) {
				String sSqlUpdateCandidateStatus = "UPDATE ePariksha_Student_Login SET stud_Login_Flag=? where stud_PRN in (select * from GET_Selected_Candidate_Ids(TRIM(?)))";
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
					pstmt = con.prepareStatement(sSqlUpdateCandidateStatus, 1004, 1007);
					pstmt.setBoolean(1, false);
					pstmt.setString(2, ArrayToString(sSelctedCandidateIds));
					
					iOperationSuccessRows = pstmt.executeUpdate();
				} catch (Exception var19) {
					var19.printStackTrace();
				} finally {
					if (dbConnector != null) {
						dbConnector.closeConnection(con);
						dbConnector = null;
						con = null;
					}

				}

				if (iOperationSuccessRows >= 1) {
					msg = "Unblocking operation is  succeded.";
				} else if (iOperationSuccessRows == 0) {
					msg = "Unblocking operation is  failed.";
				}

				session.setAttribute("snMsgCandidateUnBlock", msg);
				response.sendRedirect(request.getContextPath() + "/UnBlockUser.jsp");
			}
		}

	}
}