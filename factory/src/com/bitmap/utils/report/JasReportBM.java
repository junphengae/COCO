package com.bitmap.utils.report;

import java.io.ByteArrayOutputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import net.sf.jasperreports.engine.JRExporterParameter;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.export.JRHtmlExporter;
import net.sf.jasperreports.engine.export.JRHtmlExporterParameter;
import net.sf.jasperreports.engine.export.JRPdfExporter;
import net.sf.jasperreports.engine.export.JRPdfExporterParameter;

public class JasReportBM {
	
    private static String strExcelName = "policy_motor.pdf";
    public static String strExcelName2 = "consider.pdf";
      
    public void PrintReportToPDF(Connection conn, String jasperFile_path ,Map param, HttpServletResponse response ,String filename) throws Exception{
    	
    	try{
    		
	   	 	String reportPath = "";
	   	 	reportPath = jasperFile_path;
	        ServletOutputStream outputStream;        
	        Map parameter = param;
	        JasperPrint jasperPrint = JasperFillManager.fillReport(reportPath, parameter, conn);
	        outputStream = response.getOutputStream();
	        response.setContentType("application/pdf");
	        response.setHeader("Content-Disposition", "inline;filename=" + filename);
	        JRPdfExporter exp =  new JRPdfExporter();
	        exp.setParameter(JRExporterParameter.JASPER_PRINT,  jasperPrint);
	        exp.setParameter(JRExporterParameter.OUTPUT_STREAM,  outputStream);
	        exp.setParameter(JRPdfExporterParameter.PDF_JAVASCRIPT,"this.print();");
	        exp.exportReport();
	         
	        outputStream.close();
    	}catch(Exception e){
    		e.printStackTrace();
    			if(conn != null){
    				 	conn.rollback();
    				 	conn.close();
    				 	throw new Exception(e.getMessage());
    			}
    	}
    
   }
   
    
    public void GenAndGoTempReport(Connection conn, String jasperFile_path ,Map param, HttpServletResponse response ,String filename) throws Exception{
    	try{
    		String reportPath = "";
	   	 	reportPath = jasperFile_path;
	        ServletOutputStream outputStream;        
	        Map parameter = param;
	        System.out.println();
	        JasperPrint jasperPrint = JasperFillManager.fillReport(reportPath, parameter, conn );
	        ByteArrayOutputStream output = new ByteArrayOutputStream();
	        
	        outputStream = response.getOutputStream();
	        response.setContentType("application/pdf");
	        response.setHeader("Content-Disposition", "inline;filename=" + filename);
	        JRPdfExporter exp =  new JRPdfExporter();
	        exp.setParameter(JRExporterParameter.JASPER_PRINT,  jasperPrint);
	        exp.setParameter(JRExporterParameter.OUTPUT_STREAM,  outputStream);
	       // exp.setParameter(JRPdfExporterParameter.PDF_JAVASCRIPT,"this.print(false);");
	        exp.exportReport();
	         
	        outputStream.close();
    	}catch(Exception e){
    			if(conn != null){
    				 	conn.rollback();
    				 	conn.close();
    				 	
    			}
    			throw new Exception(e.getMessage());
    	}
    

    	
   }
    
    public PrintWriter PrintReportToHTML2(Connection conn, String jasperFile_path ,Map param, HttpServletResponse response ) throws Exception{

    	 PrintWriter pr = null;
    	try{
	   	 	String reportPath = "";
	   	 	reportPath = jasperFile_path;
	        ServletOutputStream outputStream;        
	        Map parameter = param;
	       JasperPrint jasperPrint = JasperFillManager.fillReport(reportPath, parameter, conn);
	 
	          pr = response.getWriter();
	        JRHtmlExporter exportHTML = new JRHtmlExporter();
		      exportHTML.setParameter(JRHtmlExporterParameter.IS_USING_IMAGES_TO_ALIGN,false);
		      exportHTML.setParameter(JRExporterParameter.JASPER_PRINT	, jasperPrint);
		      exportHTML.setParameter(JRExporterParameter.CHARACTER_ENCODING, "UTF-8");
		      exportHTML.setParameter(JRExporterParameter.OUTPUT_WRITER,  pr);
		      exportHTML.exportReport();
		 
		      
	   
    	}catch(Exception e){
    			if(conn != null){
    				 	conn.rollback();
    				 	conn.close();
    				 	throw new Exception(e.getMessage());
    			}
    	}finally{
    		  return pr;
    	}
		
    }


    public  Map MapParameterPO(String PO_NO){
    	Map param = new HashMap<String,String>();
    	param.put("PO_NO",PO_NO);
    	return  param;
    }
    public  Map MapParameterJob(String job_id){
    	Map param = new HashMap<String,String>();
    	param.put("JOB_ID",job_id);
    	return  param;
    }
    public Map MapParamCheckStock(String CHECK_ID){
    	Map param = new HashMap<String,String>();
    	param.put("CHECK_ID",CHECK_ID);
    	return  param;
    }
      
    
}
