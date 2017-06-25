package com.bitmap.servlet.report;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.util.Map;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.webutils.WebUtils;


public class ReportInvoiceServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public ReportInvoiceServlet() {
        super();
    }
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	doPost(request, response);
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection conn = null;
		try {
				conn = DBPool.getConnection();
				conn.setAutoCommit(false);
				
				
				
				String invoice = WebUtils.getReqString(request,"invoice");
				String cus_id  = WebUtils.getReqString(request,"cus_id");
				
				System.out.println(invoice);
				System.out.println(cus_id);
				
				
			
				//String reportByinvoice_path = request.getSession().getServletContext().getRealPath("/")+"report_source/reportbyinvoice/iReport_invoice.jasper";
				String reportByinvoice_path = "D:/VBI/report/reportbyinvoice/iReport_invoice.jasper";
				
				
				
				
				jasReport jr_report = new jasReport();
				Map param = jr_report.MapParameter(invoice , cus_id);
				jr_report.PrintReportToPDF(conn, reportByinvoice_path, param, response);
				conn.commit();
				conn.close();
				
				
		} catch (Exception e) {
			System.out.println(e.getMessage());
			PrintWriter out = response.getWriter();
			out.println(e.getMessage());
		}
	}

}
