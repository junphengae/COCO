package com.bitmap.servlet.inventory;

import java.sql.Connection;

import javax.servlet.ServletException;

import com.bitmap.bean.inventory.InventoryLot;
import com.bitmap.bean.inventory.InventoryLotControl;
import com.bitmap.bean.inventory.InventoryMaster;
import com.bitmap.bean.logistic.Detail_send;
import com.bitmap.bean.logistic.LogisSend;
import com.bitmap.bean.production.Production;
import com.bitmap.bean.sale.SaleOrderItem;
import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.utils.Money;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;

/**
 * Servlet implementation class OutletManagement
 */
public class OutletManagement extends ServletUtils {
	private static final long serialVersionUID = 1L;
       
    public OutletManagement() {
        super();
    }

	public void doPost(ReqRes rr) throws ServletException {
		try {
			if (getAction(rr).length() > 0) {
				if (checkAction(rr, "check_code")) {
					InventoryMaster entity = new InventoryMaster();
					WebUtils.bindReqToEntity(entity, rr.getRequest());
					
					String pro_id = getParam(rr,"pro_id");
					if (InventoryMaster.select(entity)){
						
						boolean check = false;
						if(!(pro_id.equalsIgnoreCase(""))){
							check = Production.checkMatcodeNProid2(pro_id,entity.getMat_code(),entity.getGroup_id());
						}
						
						kson.setSuccess();
						kson.setGson("material", gson.toJson(entity));
						kson.setData("type",entity.getGroup_id());
						kson.setData("check",check);
						setSession(rr, "invMaster", entity);
						setSession(rr, "pro_id", pro_id);
					} else {
						kson.setError("รหัสสินค้าไม่ถูกต้อง กรุณาตรวจสอบใหม่อีกครั้ง!");
					}
					rr.out(WebUtils.getResponseString(kson.getJson()));
				}
				
				if (checkAction(rr, "check_fifo")) {
					InventoryLot lot = new InventoryLot();
					WebUtils.bindReqToEntity(lot, rr.getRequest());
					InventoryLot lot_select = InventoryLot.checkFifo(lot);
					
					
					if (lot.getLot_no().equalsIgnoreCase(lot_select.getLot_no())) {
						kson.setSuccess();
						kson.setGson("lot", gson.toJson(lot_select));
					} else {
						kson.setError("Lot ที่ระบุไม่ใช่ Lot ที่เก่าที่สุด");
					}
					rr.out(WebUtils.getResponseString(kson.getJson()));
				}
				
				if (checkAction(rr, "check_inventory")) {
					InventoryLot lot = new InventoryLot();
					WebUtils.bindReqToEntity(lot, rr.getRequest());
					if(InventoryLot.select(lot)){
						kson.setSuccess();
						kson.setGson("lot", gson.toJson(lot));
					}else{
						kson.setError("Lot สินค้าไม่ถูกต้อง");						
					}																		
					rr.out(WebUtils.getResponseString(kson.getJson()));
				}
				
				if (checkAction(rr, "withdraw")) {
					InventoryLotControl entity =  new InventoryLotControl();
					WebUtils.bindReqToEntity(entity, rr.getRequest());
					
					InventoryMaster master = new InventoryMaster();
					WebUtils.bindReqToEntity(master, rr.getRequest());
					
					InventoryLotControl.withdraw(entity, master);

					kson.setSuccess();
					rr.out(WebUtils.getResponseString(kson.getJson()));
				}
				
				if (checkAction(rr, "withdraw_ss_fg")) {
					InventoryLotControl entity =  new InventoryLotControl();
					WebUtils.bindReqToEntity(entity, rr.getRequest());
					
					InventoryMaster master = new InventoryMaster();
					WebUtils.bindReqToEntity(master, rr.getRequest());
			
					master = InventoryMaster.select(master.getMat_code());
					
					String[] check = Production.checkMatcodeNProid(entity.getRequest_no(),master.getMat_code(),master.getGroup_id());
						
					if(check[2].equalsIgnoreCase("true")){
						
						 boolean check2 = Detail_send.selectEmptyByInv(check[0],"10");
						 boolean check3 = Detail_send.selectEmptyByInv(check[1],"20");
						
						 if(master.getGroup_id().equalsIgnoreCase("FG")){
							 if(check2 == true || check3 == true){
								if(master.getGroup_id().equalsIgnoreCase("SS")){
										entity.setRequest_type("PD");
								}else{
									entity.setRequest_type("IV");
								}
								
								InventoryLotControl.withdraw(entity, master);
								
								//TODO whan EDIT
								Production pro = new Production();
								pro.setItem_id(master.getMat_code());
								pro.setPro_id(entity.getRequest_no());
								pro.setUpdate_by(entity.getUpdate_by());
								if(master.getGroup_id().equalsIgnoreCase("SS")){
									Production.OutletPD(pro,entity.getRequest_qty());
								}else{
									Production.OutletIV(pro,entity.getRequest_qty());
								}	
				
								kson.setSuccess(); 
							 }else{
								 kson.setError("สินค้ายังไม่ได้มีการจัดส่ง ไม่สามารถเบิกออกได้!");
							 }
						}else{
							
							//case ss
							if(master.getGroup_id().equalsIgnoreCase("SS")){
									entity.setRequest_type("PD");
							}else{
								entity.setRequest_type("IV");
							}
							
							InventoryLotControl.withdraw(entity, master);
							
							//TODO whan EDIT
							Production pro = new Production();
							pro.setItem_id(master.getMat_code());
							pro.setPro_id(entity.getRequest_no());
							pro.setUpdate_by(entity.getUpdate_by());
							if(master.getGroup_id().equalsIgnoreCase("SS")){
								Production.OutletPD(pro,entity.getRequest_qty());
							}else{
								Production.OutletIV(pro,entity.getRequest_qty());
							}
							kson.setSuccess(); 
						}
					}else{
						kson.setError("สินค้ายังไม่ได้ออก invoice ไม่สามารถเบิกออกได้!");
					}
					rr.out(WebUtils.getResponseString(kson.getJson()));
				}
				if (checkAction(rr, "check_code_lotno")) {
					String qty  = rr.getParam("qty");
					
					InventoryLot entity = new InventoryLot();
					WebUtils.bindReqToEntity(entity, rr.getRequest());
					if (InventoryLot.selectMatANDLotno(entity.getLot_no(),entity.getMat_code())){
						
						Connection conn = DBPool.getConnection();
						InventoryLot.selectMatANDLotno(entity,conn);
						//search lot_no in inventorylotcontrol
						InventoryLotControl lotcontrol = new InventoryLotControl();
						lotcontrol = InventoryLotControl.selectMaxLotid(entity.getLot_no(), conn);
						
						//String sumQtyStr = Money.add(lotcontrol.getLot_balance(), qty);
						Double lotQty = WebUtils.getDouble(entity.getLot_qty());
						Double sumQty = WebUtils.getDouble(qty);
						
						//System.out.println(lotQty +"_"+sumQty + "_" + sumQtyStr);
						if (sumQty.compareTo(lotQty) <= 0) {
							if(lotcontrol.getControl_status().equalsIgnoreCase("A")){
								lotcontrol.setLot_balance(Money.add(qty,lotcontrol.getLot_balance()));
								InventoryLotControl.updateStatus2A(conn, lotcontrol);
							}else if(lotcontrol.getControl_status().equalsIgnoreCase("I")){
								//System.out.println(lotcontrol.getControl_status());
								InventoryLotControl.updateStatus2I(conn, lotcontrol);
					
								lotcontrol.setLot_balance(qty);
								lotcontrol.setCreate_date(DBUtility.getDBCurrentDateTime());
								InventoryLotControl.insertAfterWithdraw(conn,lotcontrol);
							}
							// sum all balance
							InventoryMaster master = new InventoryMaster();
							master.setMat_code(entity.getMat_code());
							master.setBalance(InventoryLot.selectActiveSum(master.getMat_code(), conn));
							InventoryMaster.updateBalance(master, conn);
							kson.setSuccess();
						} else {
							kson.setError("จำนวนที่คืนใน Lot นี้ไม่ถูกต้อง กรุณาตรวจสอบใหม่!");
						}
						conn.close();
					}else{
						kson.setError("รหัสสินค้าไม่ถูกต้อง กรุณาตรวจสอบใหม่อีกครั้ง!");
					}
					rr.outTH(kson.getJson());
				}
				if (checkAction(rr, "withdraw_for_sell")) {
					InventoryLotControl entity =  new InventoryLotControl();
					WebUtils.bindReqToEntity(entity, rr.getRequest());
					entity.setRequest_type("IV");
					
					InventoryMaster master = new InventoryMaster();
					WebUtils.bindReqToEntity(master, rr.getRequest());
			
					master = InventoryMaster.select(master.getMat_code());
					InventoryLotControl.withdraw(entity, master);
					
					//update status ในตารางการจัดส่ง
					LogisSend logis = new LogisSend();
					WebUtils.bindReqToEntity(logis, rr.getRequest());
					
					
					int val = InventoryLotControl.sumTakelot(entity.getRequest_no());
					String vals = val+"";
					//System.out.println(logis.getQty_all() + "____" + vals);
					if(logis.getQty().equalsIgnoreCase(vals)){
						logis.setStatus(LogisSend.STATUS_TAKE);
						LogisSend.updateStatus(logis);
					}
					
					SaleOrderItem item = new SaleOrderItem();
					item.setItem_run(logis.getItem_run());
					item = SaleOrderItem.selectOrder(item.getItem_run());
					
					if(item.getItem_type().equalsIgnoreCase("s")){
						if(val == DBUtility.getDouble(item.getItem_qty())){	
							item.setStatus(SaleOrderItem.STATUS_OUTLET);
							item.setDelivery_flag("1");
							SaleOrderItem.updateTakeProduct(item);
						}
					}else{
						//สำหรับโปรโมชั่น
					}	
					kson.setSuccess(); 
					rr.out(WebUtils.getResponseString(kson.getJson()));
				}
			} else {

			}
		} catch (Exception e) {
			kson.setError(e);
			rr.out(kson.getJson());
		}
	}
}