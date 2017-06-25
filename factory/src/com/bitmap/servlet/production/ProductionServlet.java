package com.bitmap.servlet.production;

import java.sql.Connection;

import javax.servlet.ServletException;

import com.bitmap.bean.production.Production;
import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;

/**
 * Servlet implementation class ProductionServlet
 */
public class ProductionServlet extends ServletUtils {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see ServletUtils#ServletUtils()
     */
    public ProductionServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	@Override
	public void doPost(ReqRes rr) throws ServletException {
		// TODO Auto-generated method stub
		try {
			
			if(isAction(rr)){
				if(checkAction(rr, "create_production")){
					Production entity = new Production();
					WebUtils.bindReqToEntity(entity, rr.req);
					Connection conn = DBPool.getConnection();
					conn.setAutoCommit(false);

					String item_id = entity.getItem_id();
					String status = getParam(rr, "status");
					entity.setSent_id(Production.STATUS_PRODUCE);
					
					Production.insert(entity, conn);
					
					conn.commit();
					conn.close();
					kson.setSuccess();
					boolean check = false;
					if (status.equalsIgnoreCase(Production.STATUS_PRODUCE)) {
						check = true;
					}
					kson.setData("check", check);
					kson.setData("item_id", item_id);
					kson.setData("item_run", entity.getItem_run());
					kson.setData("item_type", entity.getItem_type());
					kson.setData("pro_id", entity.getPro_id());
					kson.setData("type", entity.getStatus());
					rr.out(kson.getJson());
				}
				
				if(checkAction(rr, "update_production_to_staging")){
					Production entity = new Production();
					WebUtils.bindReqToEntity(entity, rr.req);
					Connection conn = DBPool.getConnection();
					conn.setAutoCommit(false);
					
					entity.setRef_stg_no(getParam(rr, "stg_no"));
					entity.setStatus(Production.STATUS_OUTLET);
					
					Production.updateProdToStaging(entity, conn);
					
					conn.commit();
					conn.close();
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if(checkAction(rr, "update_production_to_sto")){
					Production entity = new Production();
					WebUtils.bindReqToEntity(entity, rr.req);
					Connection conn = DBPool.getConnection();
					conn.setAutoCommit(false);
					
					entity.setRef_sto_no(getParam(rr, "sto_no"));
					entity.setStatus(Production.STATUS_MOVETO_STO);
					
					Production.updateProdToSTO(entity, conn);
					
					conn.commit();
					conn.close();
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
			}
			
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}

}
