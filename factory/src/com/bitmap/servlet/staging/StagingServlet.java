package com.bitmap.servlet.staging;

import java.sql.Connection;

import javax.servlet.ServletException;

import com.bitmap.bean.staging.Staging;
import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;

public class StagingServlet extends ServletUtils {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	
	public StagingServlet() {
		super();
		// TODO Auto-generated constructor stub
	}


	@Override
	public void doPost(ReqRes rr) throws ServletException {
		try {

			if (isAction(rr)) {
				if (checkAction(rr, "create_staging")) {
					Staging entity = new Staging();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					Connection conn = DBPool.getConnection();
					conn.setAutoCommit(false);
					
					Staging.createStaging(entity, conn);
					
					conn.commit();
					conn.close();
					kson.setSuccess();
					kson.setData("stg_no", entity.getStg_no());
					rr.out(kson.getJson());
				}
				else if(checkAction(rr, "update_staging_to_print_picking_list")){
					Staging entity = new Staging();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					Connection conn = DBPool.getConnection();
					conn.setAutoCommit(false);
					
					Staging.updateStatustoPrintPickinglist(entity, conn);
					
					conn.commit();
					conn.close();
					kson.setSuccess();
					kson.setData("stg_no", entity.getStg_no());
					rr.out(kson.getJson());
				}
				else if(checkAction(rr, "update_staging_to_packed")){
					Staging entity = new Staging();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					Connection conn = DBPool.getConnection();
					conn.setAutoCommit(false);
					
					Staging.updateStatustoPacked(entity, conn);
					
					conn.commit();
					conn.close();
					kson.setSuccess();
					kson.setData("stg_no", entity.getStg_no());
					rr.out(kson.getJson());
				}

			}

		} catch (Exception e) {
			e.printStackTrace();
		}

	}

}
