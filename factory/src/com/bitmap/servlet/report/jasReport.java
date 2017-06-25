package com.bitmap.servlet.report;

import java.io.ByteArrayOutputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import net.sf.jasperreports.engine.JRExporterParameter;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.export.JRPdfExporter;
import net.sf.jasperreports.engine.export.JRPdfExporterParameter;

public class jasReport {

	public jasReport(){}
	private static String strName = "report_invoice.pdf";
	
	public void PrintReportToPDF(Connection conn,String jasperFile_path,Map param,HttpServletResponse response ) throws Exception {
		try {
			String reportPath = "";
			reportPath = jasperFile_path;
			ServletOutputStream outputStream;
			Map parameter = param;
			JasperPrint jasperPrint = JasperFillManager.fillReport(reportPath, parameter, conn );
	        ByteArrayOutputStream output = new ByteArrayOutputStream();
	        
	        outputStream = response.getOutputStream();
	        response.setContentType("application/pdf");
	        response.setHeader("Content-Disposition", "inline;filename=" + strName);
	        JRPdfExporter exp =  new JRPdfExporter();
	        exp.setParameter(JRExporterParameter.JASPER_PRINT,  jasperPrint);
	        exp.setParameter(JRExporterParameter.OUTPUT_STREAM,  outputStream);
	        exp.setParameter(JRPdfExporterParameter.PDF_JAVASCRIPT,"this.print();");
	        exp.exportReport();
	         
	        outputStream.close();
	        
		} catch (Exception e) {
				if(conn != null){
				 	conn.rollback();
				 	conn.close();
				 	throw new Exception(e.getMessage());
				}
		}
	}
	
	public Map MapParameter(String invoice, String cus_id) {
		Map param = new HashMap<String, String>();
		param.put("invoice", invoice);
		param.put("cus_id", cus_id);
		return param;
	}
	
	
	
}
