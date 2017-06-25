package com.bmp.parts.check.stock;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletException;

import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;
import com.bmp.parts.master.bean.PartsMasterBean;
import com.bmp.parts.master.transaction.PartsMasterTS;


public class CheckStockHDServlet extends ServletUtils {
	private static final long serialVersionUID = 1L;
   
    public CheckStockHDServlet() {
        super();
    }

	@Override
	public void doPost(ReqRes rr) throws ServletException {
		Connection conn = null;
		try {
			if(checkAction(rr, "add_hd_stock")){
				conn = DBPool.getConnection();
				conn.setAutoCommit(false);
				
				actionAddHDStock(rr,conn);
				
				conn.commit();
				conn.close();
			}else if(checkAction(rr, "confirm_approve")){
				conn = DBPool.getConnection();
				conn.setAutoCommit(false);
				
				actionConfirm_Approve(rr,conn);
				
				conn.commit();
				conn.close();
			}else if(checkAction(rr, "edit_status_approve")){
				conn = DBPool.getConnection();
				conn.setAutoCommit(false);
				
				actionEditStatusApprove(rr,conn);
				
				conn.commit();
				conn.close();
			}else if(checkAction(rr, "edit_status_approve")){
				conn = DBPool.getConnection();
				conn.setAutoCommit(false);
				
				actionEditStatusApprove(rr,conn);
				
				conn.commit();
				conn.close();
			}else if(checkAction(rr, "close_stock")){
				conn = DBPool.getConnection();
				conn.setAutoCommit(false);
				
				actionClose_Stock(rr,conn);
				
				conn.commit();
				conn.close();

			}else if(checkAction(rr, "reject_stock")){
				conn = DBPool.getConnection();
				conn.setAutoCommit(false);
				
				actionReject_Stock(rr,conn);
				
				conn.commit();
				conn.close();
			}
		} catch (Exception e) {
			kson.setError(e);
			rr.out(kson.getJson());
		} 
	}
	private void actionAddHDStock(ReqRes rr,Connection conn) throws IllegalArgumentException, UnsupportedEncodingException, ParseException, IllegalAccessException, InvocationTargetException, SQLException{
		try {
			CheckStockHDBean entity = new CheckStockHDBean();
			WebUtils.bindReqToEntity(entity, rr.req);
			CheckStockHDTS.insert(conn, entity);
			kson.setData("check_id", entity.getCheck_id());
			kson.setSuccess("success");
			rr.outTH(kson.getJson());
		} catch (Exception e) {
			System.out.println(e);
			if( ! conn.isClosed() ){
			   conn.rollback();
			    conn.close();
			} 
		}
		
	}
	private void actionConfirm_Approve(ReqRes rr,Connection conn) throws SQLException{
		try {
			CheckStockHDBean entityHD = new CheckStockHDBean();
			entityHD.setCheck_id(WebUtils.getReqInt(rr.req, "check_id"));
			entityHD.setStatus("00");
			entityHD.setUpdate_by(WebUtils.getReqString(rr.req, "update_by"));
			CheckStockHDTS.update(conn, entityHD);
			kson.setSuccess("success");
			
			CheckStockTS.Make_stock(conn, entityHD.getCheck_id());
			
			rr.outTH(kson.getJson());
		} catch (Exception e) {
			System.out.println(e);
			if( ! conn.isClosed() ){
			   conn.rollback();
			    conn.close();
			} 
		}
	}
	private void actionEditStatusApprove(ReqRes rr,Connection conn) throws SQLException{
		try {
			CheckStockHDBean entityHD = new CheckStockHDBean();
			entityHD.setCheck_id(WebUtils.getReqInt(rr.req, "check_id"));
			entityHD.setUpdate_by(WebUtils.getReqString(rr.req, "update_by"));
			entityHD.setStatus("15");
			CheckStockHDTS.update(conn, entityHD);
			kson.setSuccess("success");
			rr.outTH(kson.getJson());
		} catch (Exception e) {
			System.out.println(e);
			if( ! conn.isClosed() ){
			   conn.rollback();
			    conn.close();
			} 
		}
	}
	private void actionClose_Stock(ReqRes rr,Connection conn) throws SQLException{
		try {
			String check_id   = WebUtils.getReqString(rr.req, "check_id");
			String approve_by = WebUtils.getReqString(rr.req, "approve_by");
			
			CheckStockBean entityCH = new CheckStockBean();
			
			WebUtils.bindReqToEntity(entityCH, rr.req);
			
			List lst = CheckStockTS.ListApprove(check_id);
			Iterator itr = lst.iterator();
			while(itr.hasNext()){
				CheckStockBean entity2 = (CheckStockBean) itr.next() ;
				
				int qty_diff = 0;
				/*if(entity2.getQty_new() > entity2.getQty_old()){
					qty_diff = entity2.getQty_new() -  entity2.getQty_old();
				}else{
					qty_diff = entity2.getQty_old() -  entity2.getQty_new();
				}*/
				qty_diff = entity2.getQty_new() -  entity2.getQty_old();
				entityCH.setCheck_id(entity2.getCheck_id());
				entityCH.setPn(entity2.getPn());
				entityCH.setSeq(entity2.getSeq());
				entityCH.setQty_diff(qty_diff);
				entityCH.setClose_by(approve_by);
				CheckStockTS.Close_stock(conn, entityCH);
				
				//update pa_part_master
				PartsMasterBean pm = new PartsMasterBean();
				pm.setPn(entity2.getPn());
				pm.setUpdate_by(entity2.getUpdate_by());
				pm.setQty(String.valueOf(entity2.getQty_new()));
				PartsMasterTS.updateQty(pm);
				
				CheckStockHDBean entityHD = new CheckStockHDBean();
				entityHD.setCheck_id(Integer.parseInt(check_id));
				entityHD.setApprove_by(approve_by);
				entityHD.setStatus("10");
				CheckStockHDTS.ApproveStock(conn, entityHD);
			}
			kson.setSuccess("success");
			rr.outTH(kson.getJson());
		} catch (Exception e) {
			System.out.println(e);
			if( ! conn.isClosed() ){
			   conn.rollback();
			    conn.close();
			} 
		}
	}
	private void actionReject_Stock(ReqRes rr,Connection conn) throws SQLException{
		try {
			CheckStockHDBean entityHD = new CheckStockHDBean();
			entityHD.setCheck_id(WebUtils.getReqInt(rr.req, "check_id"));
			entityHD.setStatus("15");
			entityHD.setApprove_by(WebUtils.getReqString(rr.req, "approve_by"));
			CheckStockHDTS.ApproveStock(conn, entityHD);
			
			kson.setSuccess("success");
			rr.outTH(kson.getJson());
		} catch (Exception e) {
			System.out.println(e);
			if( ! conn.isClosed() ){
			   conn.rollback();
			    conn.close();
			} 
		}
	}


}
