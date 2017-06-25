package com.bitmap.servlet.logistic;
import java.sql.Connection;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletException;

import com.bitmap.bean.logistic.Busstation;
import com.bitmap.bean.logistic.Detail_send;
import com.bitmap.bean.logistic.LogisSend;
import com.bitmap.bean.logistic.SendProduct;
import com.bitmap.bean.production.Production;
import com.bitmap.bean.sale.Detailinv;
import com.bitmap.bean.sale.SaleOrder;
import com.bitmap.bean.sale.SaleOrderItem;
import com.bitmap.bean.sale.SaleQt;
import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.utils.Money;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;
import com.sun.xml.internal.stream.Entity;

public class LogisManage extends ServletUtils {
	private static final long serialVersionUID = 1L;

    public LogisManage() {
        super();
    }

    public void doPost(ReqRes rr) throws ServletException {

		try {
			if (isAction(rr)) {
				if (checkAction(rr, "bus_add")) {
					Busstation bus = new Busstation();
					WebUtils.bindReqToEntity(bus, rr.req);
					
					Busstation.insert(bus);	
					
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "bus_edit")) {
					Busstation bus = new Busstation();
					WebUtils.bindReqToEntity(bus, rr.req);
					
					Busstation.update(bus);	
					
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "add_detail")) {
					Detail_send entity = new Detail_send();
					WebUtils.bindReqToEntity(entity, rr.req);					
				
					Detail_send.insert(entity);
	
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "del_send")) {
					Detail_send entity = new Detail_send();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					Detail_send.delete(entity);

					kson.setSuccess();
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "gen_send_product")) {
					SendProduct entity = new SendProduct();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					SendProduct.insert(entity);
					
					kson.setSuccess();
					kson.setData("run", entity.getRun());
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "update_send_product")) {
					SendProduct entity = new SendProduct();
					WebUtils.bindReqToEntity(entity, rr.req);

					SendProduct.update(entity);
					
					kson.setSuccess();
					kson.setData("run", entity.getRun());
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "ap_send")) {
					SendProduct send = new SendProduct();
					WebUtils.bindReqToEntity(send, rr.req);
					
					send.setStatus(SendProduct.STATUS_AP_SEND);
					SendProduct.updatestatus(send);	
					
					Detail_send.selectByrun(send.getRun(),send.getUpdate_by());
					
					kson.setSuccess();		
					rr.outTH(kson.getJson());	
					}
				if (checkAction(rr, "update_remark")) {
					SendProduct entity = new SendProduct();
					WebUtils.bindReqToEntity(entity, rr.req);

					SendProduct.updateRemark(entity);
					
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "update_plan_send")) {
					LogisSend entity = new LogisSend();
					WebUtils.bindReqToEntity(entity, rr.req);
					entity.setStatus(LogisSend.STATUS_PREPARE);
					LogisSend.update(entity);
					
					LogisSend.select(entity);
					
					String sum = LogisSend.sumQty(entity.getItem_run(),entity.getMat_code());
					int qty = Integer.parseInt(sum);
					int qty_all = Integer.parseInt(entity.getQty_all());
					
					//System.out.println("sum :" +sum);
					if(qty == qty_all){
						
					}else{
						LogisSend newLogis = new LogisSend();
						newLogis.setItem_run(entity.getItem_run());
						newLogis.setInv(entity.getInv());
						newLogis.setType_inv(entity.getType_inv());
						newLogis.setMat_code(entity.getMat_code());
						newLogis.setQty_all(entity.getQty_all());
						newLogis.setQty(Money.subtract(entity.getQty_all(),sum));
						if(entity.getStatus().equalsIgnoreCase(LogisSend.STATUS_WAIT)){
							newLogis.setStatus(LogisSend.STATUS_WAIT);
						}else{
							newLogis.setStatus(LogisSend.STATUS_RESEND);
						}
						newLogis.setCreate_by(entity.getUpdate_by());
						LogisSend.insert(newLogis);
					}
					kson.setSuccess();
					rr.out(kson.getJson());
				}

			}
		}catch (Exception e) {
			kson.setError(e);
			rr.out(kson.getJson());
		}
    }
}