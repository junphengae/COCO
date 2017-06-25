package com.bitmap.servlet.sale;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Iterator;
import javax.servlet.ServletException;

import com.bitmap.bean.inventory.InventoryMaster;
import com.bitmap.bean.logistic.N_number;
import com.bitmap.bean.logistic.P_number;
import com.bitmap.bean.logistic.ProduceItemMat;
import com.bitmap.bean.production.Production;
import com.bitmap.bean.rd.MatTree;
import com.bitmap.bean.rd.RDFormular;
import com.bitmap.bean.sale.Customer;
import com.bitmap.bean.sale.Detailinv;
import com.bitmap.bean.sale.PackageItem;
import com.bitmap.bean.sale.Receive;
import com.bitmap.bean.sale.SaleOrder;
import com.bitmap.bean.sale.SaleOrderItem;
import com.bitmap.bean.sale.SaleOrderItemMat;
import com.bitmap.bean.sale.SaleQt;
import com.bitmap.bean.sale.Zipcode;
import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.utils.Money;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;

public class SaleManage extends ServletUtils  {
	private static final long serialVersionUID = 1L;
       
	public SaleManage() {
        super();
    }

	public void doPost(ReqRes rr) throws ServletException {
		try {
			if (isAction(rr)) {
				if (checkAction(rr, "gen_order_id")) {
					SaleOrder entity = new SaleOrder();
					WebUtils.bindReqToEntity(entity, rr.req);
					SaleOrder.insert(entity);
					
					kson.setSuccess();
					kson.setData("order_id", entity.getOrder_id());
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "update_order_end")) {
					Connection conn = DBPool.getConnection();
					conn.setAutoCommit(false);
					
					SaleOrder entity = new SaleOrder();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					entity.setStatus(SaleOrder.STATUS_END);
					SaleOrder.updateStatus(conn,entity);
					
					SaleOrderItem item = new SaleOrderItem();
					WebUtils.bindReqToEntity(item, rr.req);
					
					item.setStatus(SaleOrderItem.STATUS_END);
					SaleOrderItem.updateWaitPlan(conn,item);
					
					conn.commit();
					conn.close();
					kson.setSuccess();
					rr.out(kson.getJson());
				}	
				if (checkAction(rr, "delete_order")) {
					SaleOrder entity = new SaleOrder();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					SaleOrder.delete(entity);
					SaleOrderItem.delete(entity.getOrder_id());
					
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "update_info")) {
					SaleOrder entity = new SaleOrder();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					SaleOrder.update(entity);
							
					kson.setSuccess();
					kson.setData("order_id", entity.getOrder_id());
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "sale_fg_add")) {
					SaleOrderItem entity = new SaleOrderItem();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					SaleOrderItem.insertItem(entity);
					
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "sale_fg_update")) {
					SaleOrderItem entity = new SaleOrderItem();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					SaleOrderItem.update(entity);
					
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "sale_promotion_add")) {
					SaleOrderItem entity = new SaleOrderItem();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					SaleOrderItem.insertPromotion(entity);
					
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "sale_promotion_update")) {
					SaleOrderItem entity = new SaleOrderItem();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					SaleOrderItem.updatePromotion(entity);
					
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "sale_orderitem_del")) {
					SaleOrderItem entity = new SaleOrderItem();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					SaleOrderItem.delete(entity);
					
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "update_order_status")) {
					Connection conn = DBPool.getConnection();
					conn.setAutoCommit(false);
					
					SaleOrder entity = new SaleOrder();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					SaleOrderItem item  = new SaleOrderItem();
					WebUtils.bindReqToEntity(item, rr.req);
					
					if(entity.getOrder_type().equalsIgnoreCase(SaleOrder.TYPE_GHOST)){
						entity.setStatus(SaleOrder.STATUS_PLAN_SUBMIT);
						item.setStatus(SaleOrderItem.STATUS_PLAN_SUBMIT);
					} else if(entity.getOrder_type().equalsIgnoreCase(SaleOrder.TYPE_CHANGE) || entity.getOrder_type().equalsIgnoreCase(SaleOrder.TYPE_MODIFY)){
						//เด๋วมาว่ากันอีกที
						entity.setStatus(SaleOrder.STATUS_SALE_SUBMIT);
						item.setStatus(SaleOrderItem.STATUS_WAIT_PLAN_SUBMIT);		
					}else if(entity.getOrder_type().equalsIgnoreCase(SaleOrder.TYPE_BUFFER)){
						item.setStatus(SaleOrderItem.STATUS_PRODUCE);
						entity.setStatus(SaleOrder.STATUS_CLOSE_QT);				
					}else if (entity.getOrder_type().equalsIgnoreCase(SaleOrder.TYPE_SAMPLE)){
						item.setStatus(SaleOrderItem.STATUS_PRODUCE);
						entity.setStatus(SaleOrder.STATUS_CLOSE_QT);
					}else{
						entity.setStatus(SaleOrder.STATUS_SALE_SUBMIT);
						item.setStatus(SaleOrderItem.STATUS_WAIT_PLAN_SUBMIT);
					}
					
					SaleOrder.updateStatus(conn,entity);
					SaleOrderItem.updateWaitPlan(conn,item);
					
					conn.commit();
					conn.close();
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "update_order_qt")) {
					Connection conn = DBPool.getConnection();
					conn.setAutoCommit(false);
					
					SaleOrder order = new SaleOrder();
					WebUtils.bindReqToEntity(order, rr.req);
		
					/*
					 * ถ้าเบิกออกจาก store ได้เลย มันไม่มีการเก็บข้อมูลการผลิต???
					
					if(order.getOrder_type().equalsIgnoreCase(SaleOrder.TYPE_SALE)){
					List list = SaleOrderItem.select(order.getOrder_id());
					Iterator ite = list.iterator();
					while(ite.hasNext()){
						SaleOrderItem entity = (SaleOrderItem) ite.next();
						// "s" is fg , "p" is promotion
						String fin_vol = "1";
						
						
						if(entity.getItem_type().equalsIgnoreCase("s")){
							RDFormular formular = new RDFormular();
							formular.setMat_code(entity.getItem_id());
							RDFormular.select(formular);
												
							String volume = Money.multiple((formular.getVolume().length() > 0)?formular.getVolume():"0",entity.getItem_qty());
							String volume_fin = "";
							
							if(formular.getYield().length() > 0 && !(formular.getYield().equalsIgnoreCase("0"))){
								fin_vol = formular.getYield();
							}
							
							volume_fin= Money.divide(Money.multiple(volume,"100"),fin_vol);

							HashMap<String, MatTree> matMap = new HashMap<String, MatTree>();
							HashMap<String, MatTree> pkMap = new HashMap<String, MatTree>();
		
							RDFormular.MatTree(formular, matMap , pkMap);
		
							Iterator iteMap = matMap.keySet().iterator();
							Iterator itePk = pkMap.keySet().iterator();

							while(iteMap.hasNext()){				
								String mat_code = (String) iteMap.next();
								MatTree tree = matMap.get(mat_code);
								tree.setDescription("");
								SaleOrderItemMat.insert(tree, entity,volume_fin);
							}
							while(itePk.hasNext()){
								String mat_code = (String) itePk.next();
								MatTree treePk = pkMap.get(mat_code);
								treePk.setDescription("");
								SaleOrderItemMat.insertPk(treePk, entity,volume);
							}
						} else {
					
							PackageItem pk = new PackageItem();
							WebUtils.bindReqToEntity(pk, rr.req);
							
							String pk_id = entity.getItem_id();
							HashMap<String, PackageItem> map = PackageItem.SumItem(pk_id);
							Iterator itePK = map.keySet().iterator();
							while (itePK.hasNext()){
								PackageItem item = map.get((String)itePK.next()) ;
								
							}
							
							itePK = map.keySet().iterator();
							while (itePK.hasNext()){
								PackageItem item = map.get((String)itePK.next()) ;
								InventoryMaster mat = item.getUIMat();
								
								RDFormular formular = new RDFormular();
								formular.setMat_code(item.getMat_code());
								RDFormular.select(formular);
								
								String volume = item.getQty();
								
								if(formular.getYield().length() > 0 && !(formular.getYield().equalsIgnoreCase("0"))){
									fin_vol = formular.getYield();
								}
								
								String vol_true = "";
								if(formular.getVolume().length() > 0){
									vol_true = formular.getVolume();
								}else{
									vol_true = "1"; 
								}
								
								volume = Money.multiple(volume,vol_true);
								fin_vol = Money.divide(Money.multiple(volume,"100"),fin_vol);
								
								HashMap<String, MatTree> matMap = new HashMap<String, MatTree>();
								HashMap<String, MatTree> pkMap = new HashMap<String, MatTree>();
								RDFormular.MatTree(formular, matMap , pkMap);
								
								Iterator iteMap = matMap.keySet().iterator();
								Iterator itePk = pkMap.keySet().iterator();
								while(iteMap.hasNext()){
									String mat_code = (String) iteMap.next();
									MatTree tree = matMap.get(mat_code);
									tree.setDescription(mat.getMat_code());
									SaleOrderItemMat.insert(tree, entity,fin_vol);
								}
								while(itePk.hasNext()){
									String mat_code = (String) itePk.next();
									MatTree tree = pkMap.get(mat_code);
									tree.setDescription(mat.getMat_code());
									SaleOrderItemMat.insertPk(tree, entity,item.getQty());
								}
							}
						}
					}
					}// end if type_sale
*/					SaleOrderItem entity = new SaleOrderItem();
					if(order.getOrder_type().equalsIgnoreCase(SaleOrder.TYPE_GHOST)){
						//TODO เด๋วมาทำต่อจ้า
					} else if(order.getOrder_type().equalsIgnoreCase(SaleOrder.TYPE_CHANGE) || order.getOrder_type().equalsIgnoreCase(SaleOrder.TYPE_MODIFY)){
						//TODO เด๋วมาทำต่อจ้า
					}else if(order.getOrder_type().equalsIgnoreCase(SaleOrder.TYPE_BUFFER)){
						//TODO เด๋วมาทำต่อจ้า			
					}else if (order.getOrder_type().equalsIgnoreCase(SaleOrder.TYPE_SAMPLE)){
						//TODO เด๋วมาทำต่อจ้า
					}else{
						order.setStatus(SaleOrder.STATUS_PLAN_SUBMIT);
						entity.setStatus(SaleOrderItem.STATUS_PLAN_SUBMIT);
					}
					SaleOrder.updateStatus(conn,order);
					entity.setOrder_id(order.getOrder_id());
					entity.setUpdate_by(order.getUpdate_by());
					SaleOrderItem.updateWaitPlan(conn,entity);
					
					conn.commit();
					conn.close();
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "reject_sale")) {
					
					Connection conn = DBPool.getConnection();
					conn.setAutoCommit(false);
					
					SaleOrder entity = new SaleOrder();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					SaleOrderItem item = new SaleOrderItem();
					WebUtils.bindReqToEntity(item, rr.req);
					
					SaleOrderItemMat mat = new SaleOrderItemMat();
					WebUtils.bindReqToEntity(mat, rr.req);
					
					entity.setStatus(SaleOrder.STATUS_SALE_CREATE);
					SaleOrder.updateStatus(conn,entity);
					
					item.setStatus(SaleOrderItem.STATUS_SALE_CREATE);
					SaleOrderItem.updateStatusByInv(conn,item,"order_id");
					
					SaleOrderItemMat.delItem(conn,mat);
					
					conn.commit();
					conn.close();
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "confirm_add")) {
					SaleOrderItem entity = new SaleOrderItem();
					WebUtils.bindReqToEntity(entity, rr.req);

					SaleOrderItem.updateDate(entity);			
					SaleOrderItem.select(entity);
					
					// "s" is fg , "p" is promotion
					String fin_vol = "1";
					if(entity.getItem_type().equalsIgnoreCase("s")){
						RDFormular formular = new RDFormular();
						formular.setMat_code(entity.getItem_id());
						RDFormular.select(formular);
											
						String volume = Money.multiple((formular.getVolume().length() > 0)?formular.getVolume():"0",entity.getItem_qty());
						String volume_fin = "";
						
						if(formular.getYield().length() > 0 && !(formular.getYield().equalsIgnoreCase("0"))){
							fin_vol = formular.getYield();
						}
						
						volume_fin= Money.divide(Money.multiple(volume,"100"),fin_vol);

						HashMap<String, MatTree> matMap = new HashMap<String, MatTree>();
						HashMap<String, MatTree> pkMap = new HashMap<String, MatTree>();
	
						RDFormular.MatTree(formular, matMap , pkMap);
	
						Iterator iteMap = matMap.keySet().iterator();
						Iterator itePk = pkMap.keySet().iterator();

						while(iteMap.hasNext()){				
							String mat_code = (String) iteMap.next();
							MatTree tree = matMap.get(mat_code);
							tree.setDescription("");
							SaleOrderItemMat.insert(tree, entity,volume_fin);
						}
						while(itePk.hasNext()){
							String mat_code = (String) itePk.next();
							MatTree treePk = pkMap.get(mat_code);
							treePk.setDescription("");
							SaleOrderItemMat.insertPk(treePk, entity,volume);
						}
					} else {
				
						PackageItem pk = new PackageItem();
						WebUtils.bindReqToEntity(pk, rr.req);
						
						String pk_id = entity.getItem_id();
						HashMap<String, PackageItem> map = PackageItem.SumItem(pk_id);
						Iterator itePK = map.keySet().iterator();
						while (itePK.hasNext()){
							PackageItem item = map.get((String)itePK.next()) ;
						}
						
						itePK = map.keySet().iterator();
						while (itePK.hasNext()){
							PackageItem item = map.get((String)itePK.next()) ;
							InventoryMaster mat = item.getUIMat();
							
							RDFormular formular = new RDFormular();
							formular.setMat_code(item.getMat_code());
							RDFormular.select(formular);
							
							String volume = item.getQty();
							
							if(formular.getYield().length() > 0 && !(formular.getYield().equalsIgnoreCase("0"))){
								fin_vol = formular.getYield();
							}
							
							String vol_true = "";
							if(formular.getVolume().length() > 0){
								vol_true = formular.getVolume();
							}else{
								vol_true = "1"; 
							}
							
							volume = Money.multiple(volume,vol_true);
							fin_vol = Money.divide(Money.multiple(volume,"100"),fin_vol);
							
							HashMap<String, MatTree> matMap = new HashMap<String, MatTree>();
							HashMap<String, MatTree> pkMap = new HashMap<String, MatTree>();
							RDFormular.MatTree(formular, matMap , pkMap);
							
							Iterator iteMap = matMap.keySet().iterator();
							Iterator itePk = pkMap.keySet().iterator();
							while(iteMap.hasNext()){
								
								String mat_code = (String) iteMap.next();
								MatTree tree = matMap.get(mat_code);
								tree.setDescription(mat.getMat_code());
								SaleOrderItemMat.insert(tree, entity,fin_vol);
							}
							while(itePk.hasNext()){
								
								String mat_code = (String) itePk.next();
								MatTree tree = pkMap.get(mat_code);
								tree.setDescription(mat.getMat_code());
								SaleOrderItemMat.insertPk(tree, entity,item.getQty());
							}
						}
					}
					SaleOrder order = new SaleOrder();
					order = SaleOrder.selectByID(entity.getOrder_id());
					
					kson.setSuccess();
					kson.setData("order_id",order.getOrder_id());
					kson.setData("cus_id",order.getCus_id());
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "confirm_date_edit")) {
					SaleOrderItem entity = new SaleOrderItem();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					SaleOrderItem.editPlan(entity);
					
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "approve_qt")) {
					SaleOrderItem entity = new SaleOrderItem();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					SaleOrder order = new SaleOrder();
					WebUtils.bindReqToEntity(order, rr.req);
					
					SaleOrder.select(order);

					if(entity.getStatus().equalsIgnoreCase(SaleOrderItem.STATUS_IN_STORE)){
						if(!(getParam(rr, "due_date").equalsIgnoreCase(""))){
							order.setOrder_id(entity.getOrder_id());
							SaleOrder.updateDate(order);
						}	
						SaleOrderItem.approverToStore(entity);
					}else{
						if(entity.getStatus().equalsIgnoreCase(SaleOrderItem.STATUS_NO_PRODUCE)){
							entity.setStatus(SaleOrderItem.STATUS_NOT_AP_YET);
						}
						if(!(getParam(rr, "due_date").equalsIgnoreCase(""))){
							order.setOrder_id(entity.getOrder_id());
							SaleOrder.updateDate(order);
						}	
						SaleOrderItem.approverQt(entity);
					}
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "approve_qt_ghost")) {
					Connection conn = DBPool.getConnection();
					conn.setAutoCommit(false);
					//อนุมัติเสร็จไปออก inv ได้เลย
					SaleOrderItem entity = new SaleOrderItem();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					SaleOrder order = new SaleOrder();
					WebUtils.bindReqToEntity(order, rr.req);
					
					SaleOrder.select(order);

					entity.setStatus(SaleOrderItem.STATUS_PRE_SEND); //72
					SaleOrderItem.updateStatusByInv(conn,entity,"item_run");
					
					
					String count = SaleOrderItem.countItemrun(entity.getOrder_id(),SaleOrderItem.STATUS_PRE_SEND, conn); 
					String count2 = SaleOrderItem.countAllrun(entity.getOrder_id(), conn);
					if(count.equalsIgnoreCase(count2)){
						SaleQt qt = new SaleQt();
						qt.setQt_id(entity.getQt_id());
						qt.setOrder_id(entity.getOrder_id());
						qt.setUpdate_by(entity.getUpdate_by());
						qt.setStatus(SaleQt.STATUS_CLOSE_QT); //50
						SaleQt.updateQt(qt);
						
						order.setStatus(SaleOrder.STATUS_PREPARE_PD); //60
						SaleOrder.updateStatus(conn,order); 
					}
					
					conn.commit();
					conn.close();			
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "create_qt")) {
					SaleQt entity = new SaleQt();
					WebUtils.bindReqToEntity(entity, rr.req);
					entity.setStatus(SaleOrder.STATUS_SEND_QT);
					SaleQt.insert(entity);
					SaleQt.select(entity);
					String[] choose = rr.req.getParameterValues("choose");
					for (int i = 0; i < choose.length; i++) {
						String[] ch = choose[i].split("_");
									
						SaleOrderItem order = new SaleOrderItem();
						WebUtils.bindReqToEntity(order, rr.req);
												
						order.setQt_id(entity.getQt_id());
						order.setItem_id(ch[0]);
						order.setItem_run(ch[1]);						
						order.setStatus(SaleOrderItem.STATUS_CANCEL);
						SaleOrderItem.updateQt(order);
					}
					kson.setSuccess();
					kson.setData("qt_id",entity.getQt_id());
					kson.setData("cus_id",entity.getCus_id());
					kson.setData("order_id",entity.getOrder_id());
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "price_update")) {
					SaleOrderItem entity = new SaleOrderItem();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					SaleOrderItem.updatePrice(entity);
					
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "discount_update")) {
					SaleOrderItem entity = new SaleOrderItem();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					SaleOrderItem.updateDiscount(entity);
					
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "qt_update")) {
					SaleQt entity = new SaleQt();
					WebUtils.bindReqToEntity(entity, rr.req);
					entity.setStatus(SaleQt.STATUS_APPROVE);
					SaleQt.update(entity);
					
					SaleOrderItem order = new SaleOrderItem();
					WebUtils.bindReqToEntity(order, rr.req);	
					SaleOrderItem.selectItem(order);				
													
					kson.setSuccess();					
					kson.setData("qt_id",entity.getQt_id());
					kson.setData("cus_id",entity.getCus_id());
					kson.setData("order_id",entity.getOrder_id());
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "del_item_all")) {
					Connection conn = DBPool.getConnection();
					conn.setAutoCommit(false);
					
					SaleOrderItem entity = new SaleOrderItem();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					SaleOrderItemMat mat = new SaleOrderItemMat();
					WebUtils.bindReqToEntity(mat, rr.req);
					
					boolean status = SaleOrderItem.updateItem(entity);
					SaleOrderItemMat.delItem(conn,mat);
					
					conn.commit();
					conn.close();
					kson.setSuccess();
					kson.setData("cancel", status);
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "add_product")) {
					Production entity = new Production();
					WebUtils.bindReqToEntity(entity, rr.req);
					Connection conn = DBPool.getConnection();
					conn.setAutoCommit(false);
					
					String item_id = entity.getItem_id();
					String status = getParam(rr,"status");
					entity.setSent_id(status);

					if(entity.getItem_type().equalsIgnoreCase("SS")){
						if(status.equalsIgnoreCase(Production.STATUS_NO_PRODUCE)){
							if(entity.getItem_type().equalsIgnoreCase("FG")){
								entity.setStatus(Production.STATUS_FINNISH);
							}
						}
						
						Production.insert(entity, conn);
						if(!(entity.getItem_type().equalsIgnoreCase("PRO"))){
							RDFormular.keepMatProduce(entity.getPro_id(),item_id,entity.getItem_qty(),status);
						}
					}else{
						String[] choose = rr.req.getParameterValues("item_id_pk");
						String[] myList = new String [choose.length];

						for (int i = 0; i < choose.length; i++) {
							myList[i] = choose[i] + "_" + rr.getParam("take" + (i+1));
						}
						
						Production.insert(entity, conn);
						if(!(entity.getItem_type().equalsIgnoreCase("PRO"))){
							RDFormular.keepMatProduce(entity.getPro_id(),item_id,entity.getItem_qty(),status,myList);
						}
					}

					SaleOrderItem order =  SaleOrderItem.selectOrder(entity.getItem_run());
					//กรณี FG
					if(entity.getItem_type().equalsIgnoreCase("FG") && order.getItem_type().equalsIgnoreCase("s")){
						order.setUpdate_by(entity.getCreate_by());
						
						if(status.equalsIgnoreCase(Production.STATUS_NO_PRODUCE)){
						order.setStatus(SaleOrderItem.STATUS_PRE_SEND);
						}else{
						order.setStatus(SaleOrderItem.STATUS_CLOSE_QT);
						}
						SaleOrderItem.updateStatusByItemrun(order);	
					
					}
					//โปรโมชั่น
					if((order.getItem_type().equalsIgnoreCase("p") && entity.getItem_type().equalsIgnoreCase("FG")) || entity.getItem_type().equalsIgnoreCase("PRO")){
						String countFG = Production.countFG(order.getItem_run(), conn);
						String countitemrun = PackageItem.countPkItem(entity.getItem_id(), conn);
						
						////System.out.println("countFG");
						if(countFG.equalsIgnoreCase(countitemrun)){
							////System.out.println(countFG);
							////System.out.println(countitemrun);
							order.setUpdate_by(entity.getCreate_by());
							if(status.equalsIgnoreCase(Production.STATUS_NO_PRODUCE)){
								order.setStatus(SaleOrderItem.STATUS_PRE_SEND);
							}else{
								order.setStatus(SaleOrderItem.STATUS_CLOSE_QT);
							}
							SaleOrderItem.updateStatusByItemrun(order);	
						}
					}
					
					//ถ้าstatus เป็น 70 คือรอของเข้า storeทั้งหมด รายการขายจะเปลี่ยนสถานะ เป็นกำลังผลิต
					String row = SaleOrderItem.countItemrun(order.getOrder_id(),SaleOrderItem.STATUS_CLOSE_QT, conn);
					String count = SaleOrderItem.countAllrun(order.getOrder_id(), conn);
					if(row.equalsIgnoreCase(count)){
						SaleOrder saleorder = new SaleOrder();
						saleorder.setOrder_id(order.getOrder_id());
						saleorder.setUpdate_by(entity.getCreate_by());
						saleorder.setStatus(SaleOrder.STATUS_PREPARE_PD);
						SaleOrder.updateStatus(conn,saleorder);
					}	
					
					//ถ้าstatus เป็น 72 คือรอออก invoice รายการขายจะเปลี่ยนสถานะ 65 รอออก inv 
					row = SaleOrderItem.countItemrun(order.getOrder_id(),SaleOrderItem.STATUS_PRE_SEND, conn);
					count = SaleOrderItem.countAllrun(order.getOrder_id(), conn);
					if(row.equalsIgnoreCase(count)){
						SaleOrder saleorder = new SaleOrder();
						saleorder.setOrder_id(order.getOrder_id());
						saleorder.setUpdate_by(entity.getCreate_by());
						saleorder.setStatus(SaleOrder.STATUS_WAIT_INV);
						SaleOrder.updateStatus(conn,saleorder);
					}	
					
					conn.commit();
					conn.close();	
					kson.setSuccess();
					boolean check = false;
					if(status.equalsIgnoreCase(Production.STATUS_PRODUCE)){
						check = true;
					}		
					kson.setData("check", check);
					kson.setData("order_id",order.getOrder_id());
					kson.setData("item_id", item_id);
					kson.setData("item_run", entity.getItem_run());
					kson.setData("item_type", entity.getItem_type());
					kson.setData("pro_id", entity.getPro_id());
					kson.setData("type", entity.getStatus());
					rr.out(kson.getJson());
				}
				
				//ของ sale กรณีที่ไม่ต้องผลิต
				if (checkAction(rr,"not_produce")) {
					Production entity = new Production();
					WebUtils.bindReqToEntity(entity, rr.req);
					Connection conn = DBPool.getConnection();
					conn.setAutoCommit(false);
					
					String item_id = entity.getItem_id();	
					entity.setStatus(Production.STATUS_FINNISH);
					Production.insert(entity, conn);
					
					SaleOrderItem order =  SaleOrderItem.selectOrder(entity.getItem_run());
					//กรณี FG
					if(entity.getItem_type().equalsIgnoreCase("FG") && order.getItem_type().equalsIgnoreCase("s")){
						order.setUpdate_by(entity.getCreate_by());
						order.setStatus(SaleOrderItem.STATUS_PRE_SEND);
						SaleOrderItem.updateStatusByItemrun(order);	
					
					}
					//โปรโมชั่น
					if(order.getItem_type().equalsIgnoreCase("p") && (entity.getItem_type().equalsIgnoreCase("FG") || entity.getItem_type().equalsIgnoreCase("PRO"))){
						String countFG = Production.countFG(order.getItem_run(), conn);
						String countitemrun = PackageItem.countPkItem(entity.getItem_id(), conn);
						
						if(countFG.equalsIgnoreCase(countitemrun)){
							order.setUpdate_by(entity.getCreate_by());
							order.setStatus(SaleOrderItem.STATUS_PRE_SEND);
							SaleOrderItem.updateStatusByItemrun(order);	
						}
					}
					//status รอออก invoice รายการขายจะเปลี่ยนสถานะ 65 รอออก inv 
					String row = SaleOrderItem.countItemrun(order.getOrder_id(),SaleOrderItem.STATUS_PRE_SEND, conn);
					String count = SaleOrderItem.countAllrun(order.getOrder_id(), conn);
					if(row.equalsIgnoreCase(count)){
						SaleOrder saleorder = new SaleOrder();
						saleorder.setOrder_id(order.getOrder_id());
						saleorder.setUpdate_by(entity.getCreate_by());
						saleorder.setStatus(SaleOrder.STATUS_WAIT_INV);
						SaleOrder.updateStatus(conn,saleorder);
					}	
					
					conn.commit();
					conn.close();	
					kson.setSuccess();
					kson.setData("order_id",order.getOrder_id());
					kson.setData("item_id", item_id);
					kson.setData("item_run", entity.getItem_run());
					kson.setData("item_type", entity.getItem_type());
					kson.setData("pro_id", entity.getPro_id());
					kson.setData("type", entity.getStatus());
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "add_product_ghost_sgi")) {
					String order_type = getParam(rr, "order_type");
					
					Production entity = new Production();
					WebUtils.bindReqToEntity(entity, rr.req);
					Connection conn = DBPool.getConnection();
					conn.setAutoCommit(false);
					
					String item_id = entity.getItem_id();
					String status = getParam(rr,"status");
					
					entity.setSent_id(status);
					
					if(status.equalsIgnoreCase(Production.STATUS_NO_PRODUCE)){
						entity.setItem_qty(getParam(rr,"item_qty2"));
					}
					
					
					if(order_type.equalsIgnoreCase(SaleOrder.TYPE_GHOST)){
						entity.setSent_id(Production.STATUS_NO_PRODUCE);
						if(entity.getItem_type().equalsIgnoreCase("SS")){
							entity.setStatus(Production.STATUS_OUTLET_PD);
						}else{
							entity.setStatus(Production.STATUS_FINNISH);
						}
					}else{
						if(entity.getItem_type().equalsIgnoreCase("FG")){
							entity.setStatus(Production.STATUS_FINNISH);
							entity.setSent_id(Production.STATUS_PRODUCE);
						}
					}
					
					Production.insert(entity, conn);
					
					if(entity.getSent_id().equalsIgnoreCase(Production.STATUS_PRODUCE)){
						RDFormular.keepMatProduce(entity.getPro_id(),item_id,entity.getItem_qty(),Production.STATUS_PRODUCE);
					}
					
					SaleOrderItem order =  SaleOrderItem.selectOrder(entity.getItem_run());
					
					//กรณี FG
					if(entity.getItem_type().equalsIgnoreCase("FG")){
						order.setUpdate_by(entity.getCreate_by());
						order.setStatus(SaleOrderItem.STATUS_PRE_SEND);
						SaleOrderItem.updateStatusByItemrun(order);	
					}
					
					String row = SaleOrderItem.countItemrun(order.getOrder_id(),SaleOrderItem.STATUS_PRE_SEND, conn);
					String count = SaleOrderItem.countAllrun(order.getOrder_id(), conn);

					if(row.equalsIgnoreCase(count)){
						
						SaleOrder saleorder = new SaleOrder();
						saleorder.setOrder_id(order.getOrder_id());
						saleorder.setUpdate_by(entity.getCreate_by());
						saleorder.setStatus(SaleOrder.STATUS_PREPARE_PD);
						SaleOrder.updateStatus(conn,saleorder);
					}
					
					conn.commit();
					conn.close();	
					kson.setSuccess();
					boolean check = false;
					if(status.equalsIgnoreCase(Production.STATUS_PRODUCE)){
						check = true;
					}		
					kson.setData("check", check);
					kson.setData("order_id",order.getOrder_id());
					kson.setData("item_id", item_id);
					kson.setData("item_run", entity.getItem_run());
					kson.setData("item_type", entity.getItem_type());
					kson.setData("pro_id", entity.getPro_id());
					kson.setData("type", entity.getStatus());
					rr.out(kson.getJson());
				}

				if (checkAction(rr, "add_product_sample")) {
					
					Production entity = new Production();
					WebUtils.bindReqToEntity(entity, rr.req);
					Connection conn = DBPool.getConnection();
					String item_id = entity.getItem_id();
					String status = entity.getStatus();

					entity.setSent_id(status);
					
					if(entity.getItem_type().equalsIgnoreCase("SS")){
						entity.setStatus(Production.STATUS_OUTLET_PD);
					}else{
						entity.setStatus(Production.STATUS_OUTLET);
					}
					
					Production.insert(entity, conn);
					entity.setStatus(status);
					
					if(status.equalsIgnoreCase(Production.STATUS_PRODUCE)){
						RDFormular.keepMatProduce(entity.getPro_id(),item_id,entity.getItem_qty(),status);
					}
					
					SaleOrderItem order =  SaleOrderItem.selectOrder(entity.getItem_run());
					if(entity.getItem_type().equalsIgnoreCase("FG")){
						order.setUpdate_by(entity.getCreate_by());
						order.setStatus(SaleOrderItem.STATUS_END);
						SaleOrderItem.updateStatusByItemrun(order);
			
					}
					
					Connection connection = DBPool.getConnection();
					connection.setAutoCommit(false);
					String count = SaleOrderItem.countItemrun(order.getOrder_id(),SaleOrderItem.STATUS_END, connection);
					String row = SaleOrderItem.countAllrun(order.getOrder_id(), connection);

					if(row.equalsIgnoreCase(count)){
						SaleOrder saleorder = new SaleOrder();
						saleorder.setOrder_id(order.getOrder_id());
						saleorder.setUpdate_by(entity.getCreate_by());
						saleorder.setStatus(SaleOrder.STATUS_END);
						SaleOrder.updateStatus(connection,saleorder);
					}
					connection.commit();
					connection.close();	
					kson.setSuccess();
					rr.out(kson.getJson());
					}	
				
					if (checkAction(rr, "add_product_buffer")) {
					Production entity = new Production();
					WebUtils.bindReqToEntity(entity, rr.req);
					Connection conn = DBPool.getConnection();
					String item_id = entity.getItem_id();
					String status = entity.getStatus();
					entity.setSent_id(status);
					
					
					if(status.equalsIgnoreCase(Production.STATUS_PRODUCE)){
						Production.insert(entity, conn);
						RDFormular.keepMatProduce(entity.getPro_id(),item_id,entity.getItem_qty(),status);
					}

					SaleOrderItem order =  SaleOrderItem.selectOrder(entity.getItem_run());
					if(entity.getParent_id().equalsIgnoreCase("")){
						order.setUpdate_by(entity.getCreate_by());
						order.setStatus(SaleOrderItem.STATUS_CLOSE_QT);
						SaleOrderItem.updateStatusByItemrun(order);			
					}
					
					Connection connection = DBPool.getConnection();
					connection.setAutoCommit(false);
					String count = SaleOrderItem.countItemrun(order.getOrder_id(),SaleOrderItem.STATUS_CLOSE_QT, connection);
					String row = SaleOrderItem.countAllrun(order.getOrder_id(), connection);

					if(row.equalsIgnoreCase(count)){
						SaleOrder saleorder = new SaleOrder();
						saleorder.setOrder_id(order.getOrder_id());
						saleorder.setUpdate_by(entity.getCreate_by());
						saleorder.setStatus(SaleOrder.STATUS_PREPARE_PD);
						SaleOrder.updateStatus(connection,saleorder);
					}
					
					connection.commit();
					connection.close();	
					kson.setSuccess();
					boolean check = false;
					if(status.equalsIgnoreCase(Production.STATUS_PRODUCE)){
						check = true;
					}		
					kson.setData("check", check);
					kson.setData("order_id",order.getOrder_id());
					kson.setData("item_id", item_id);
					kson.setData("item_run", entity.getItem_run());
					kson.setData("item_type", entity.getItem_type());
					kson.setData("pro_id", entity.getPro_id());
					kson.setData("type", entity.getStatus());
					rr.out(kson.getJson());
				}	
				if (checkAction(rr, "get_zip")) {
					kson.setSuccess();
					kson.setGson("zip_code",gson.toJson(Zipcode.getComboList("th",WebUtils.getReqString(rr.req, "province_id"))));
					rr.outTH(kson.getJson());
				}
				if (checkAction(rr, "update_q")) {
					String sent_id = getParam(rr, "sent_id");
					Production pro = new Production();

					pro.setSent_id(sent_id);
					Production.update_q(pro);
					
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				if (checkAction(rr,"add_invoice")) {
					Connection conn = DBPool.getConnection();
					conn.setAutoCommit(false);
	
					SaleOrderItem entity = new SaleOrderItem();	
					WebUtils.bindReqToEntity(entity, rr.req);
					
					String type = getParam(rr, "b");
					String vat_novat = getParam(rr, "c");
					boolean repeat = false; 
					String[] choose1 = rr.req.getParameterValues("choose");	
					for (int i = 0; i < choose1.length; i++) {
						String[] ch = choose1[i].split("_");
						if(ch[1].equalsIgnoreCase(SaleOrderItem.STATUS_TMP_INVOICE) && type.equalsIgnoreCase("tmp")){
							repeat = true;
							break;
						}
					}
					if(repeat){
						kson.setError("สินค้าที่เลือกมีใบส่งของชั่วคราวอยู่แล้ว!");
					}else{	
						Detailinv detail = new Detailinv();
		
			            if (type.equalsIgnoreCase("inv"))
			            {
			              
			            //System.out.println("Inside INV case");
			              entity.setInvoice(SaleOrderItem.genInvoice(conn, "inv"));
			              detail.setNo(entity.getInvoice());
			              if (vat_novat.equalsIgnoreCase("vat"))
			                detail.setType_vat(Detailinv.STATUS_VAT);
			              else
			                detail.setType_vat(Detailinv.STATUS_NO_VAT);
			              
			              	detail.setType_inv(Detailinv.STATUS_VAT);
			              
			              ////System.out.println("New Inv id :"+entity.getInvoice());
			            }
			            else
			            {
			              entity.setInvoice(SaleOrderItem.genInvoice(conn, "tmp"));
			              detail.setNo(entity.getTemp_invoice());
			              detail.setType_inv(Detailinv.STATUS_TEMP);
			            }
						////System.out.println("No :"+detail.getNo());
						
						/*detail.setSum_inv(rr.getParameter("sum_inv"));
						detail.setSum_net_inv(rr.getParameter("sum_net_inv"));
						detail.setVat_inv(rr.getParameter("vat_inv"));*/
						detail.setCreate_by(entity.getUpdate_by());
						
						Detailinv.insert(conn,detail);
						////System.out.println("add_invoice :Insert to sale_invoice_detail Successfull");
						
						String[] choose = rr.req.getParameterValues("choose");	
						for (int i = 0; i < choose.length; i++) {
							////System.out.println("add_invoice : choose_1");
							String[] ch = choose1[i].split("_");
							////System.out.println("add_invoice : choose_2");
							entity.setItem_run(ch[0]);					
							////System.out.println("add_invoice : choose_3");
							//1.check ว่าตัวนี้ temp ว่าง รึเปล่า หรือ มี temp แล้วรึยัง
							
							SaleOrderItem.checktemp(conn,entity,type);
							////System.out.println("add_invoice :checktemp to sale_order_item  Successfull");
						
							//ประเภทหลอกขายและsgi
							SaleOrderItem item = SaleOrderItem.selectOrder(entity.getItem_run());
							////System.out.println("add_invoice : choose_4");
							SaleOrder order = new SaleOrder();
							////System.out.println("add_invoice : choose_5");
							order.setOrder_id(item.getOrder_id());
							////System.out.println("add_invoice : choose_6");
							SaleOrder.select(order);
							////System.out.println("add_invoice :select to sale_order  Successfull");
							if(order.getOrder_type().equalsIgnoreCase(SaleOrder.TYPE_GHOST) || order.getOrder_type().equalsIgnoreCase(SaleOrder.TYPE_SGI)){	
								////System.out.println("add_invoice : choose_7");
								item.setStatus(SaleOrderItem.STATUS_END); //100

								////System.out.println("add_invoice : choose_8");
								SaleOrderItem.updateInvoice(conn,item,type);
								
								////System.out.println("add_invoice :updateInvoice to sale_order_item  Successfull");
								
								String count = SaleOrderItem.countItemrun(item.getOrder_id(),SaleOrderItem.STATUS_END, conn); 
								////System.out.println("add_invoice : choose_9");
								String count2 = SaleOrderItem.countAllrun(item.getOrder_id(), conn);
								////System.out.println("add_invoice : choose_10");
								if(count.equalsIgnoreCase(count2)){
									////System.out.println("add_invoice : choose_11");
									order.setStatus(SaleOrder.STATUS_END); //100
									////System.out.println("add_invoice : choose_12");
									order.setUpdate_by(entity.getUpdate_by());
									////System.out.println("add_invoice : choose_13");
									SaleOrder.updateStatus(conn,order); 
									////System.out.println("add_invoice : choose_14");
								}		
							}else{
								//ถ้าออก invoice (73) ครบหมดจะเปลี่ยนสถานะรายการขายเป็น รอจัดของ (70)
								String count = SaleOrderItem.countItemrun(item.getOrder_id(),SaleOrderItem.STATUS_INVOICE, conn); 
								//System.out.println("add_invoice : choose_15");
								String count2 = SaleOrderItem.countAllrun(item.getOrder_id(), conn);
								//System.out.println("add_invoice : choose_16");
								if(count.equalsIgnoreCase(count2)){
									//System.out.println("add_invoice : choose_17");
									order.setStatus(SaleOrder.STATUS_PREPARE); //70
									//System.out.println("add_invoice : choose_18");
									order.setUpdate_by(entity.getUpdate_by());
									//System.out.println("add_invoice : choose_19");
									
									detail.setStatus(order.getStatus());
									Detailinv.updateStatusSaleOrderDetill(conn,detail);
									
									SaleOrder.updateStatus(conn,order); 
									//System.out.println("add_invoice : choose_20");
								}
							}
						}
						kson.setSuccess();
						kson.setData("invoice",detail.getNo());
					}
					
					conn.commit();
					conn.close();
					
					rr.outTH(kson.getJson());	
				}
				if (checkAction(rr, "gen_receive_id")) {
					Receive entity = new Receive();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					Receive.insert(entity);
					
					kson.setSuccess();
					kson.setData("invoice", entity.getInvoice());
					kson.setData("type_inv",entity.getType_inv());
					kson.setData("ch","1");
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "update_receive")) {
					Receive entity = new Receive();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					Receive.update(entity);
					
					kson.setSuccess();
					kson.setData("invoice", entity.getInvoice());
					kson.setData("type_inv",entity.getType_inv());
					kson.setData("ch","1");
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "receive_check")) {
					/*Receive entity = new Receive();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					entity.setStatus(Receive.STATUS_RECEIVE);
					Receive.updateStatus(entity);*/
					receive_check(rr,null);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "verify")) {
					Receive entity = new Receive();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					entity.setStatus(Receive.STATUS_VERIFY);
					Receive.select(entity);
					
					SaleOrder order = new SaleOrder();
					WebUtils.bindReqToEntity(order, rr.req);
					
					SaleOrderItem item = new SaleOrderItem();
					WebUtils.bindReqToEntity(item, rr.req);
					
					Customer cus = new Customer();
					cus.setCus_id(order.getCus_id());
					cus = Customer.select(cus);
					
					if(order.getOrder_type().equalsIgnoreCase(SaleOrder.TYPE_DROP)){
						entity.setTypes(SaleOrder.TYPE_DROP);
						entity.setStatus(Receive.STATUS_CLOSE);
					}else{
					
						if(order.getOrder_type().equalsIgnoreCase(SaleOrder.TYPE_MODIFY)){
							order.setDue_date(WebUtils.getCurrentDate());
						}else{
							order.setDue_date(item.getRequest_date());
						}
						order.setCreate_by(order.getUpdate_by());
						order.setUpdate_by("");
						SaleOrder.insert(order);
						
						item.setOrder_id(order.getOrder_id());
						item.setItem_type("s");
						item.setDiscount(cus.getCus_discount());
						
						String type = getParam(rr, "b");
						String vat_novat = getParam(rr, "c");
						
						Connection conn = DBPool.getConnection();
						if(order.getOrder_type().equalsIgnoreCase(SaleOrder.TYPE_CHANGE)){
							
							if(type.equalsIgnoreCase("inv")){
								item.setInvoice(DBUtility.genNumber(conn,SaleOrderItem.tableName,"invoice"));
								if(vat_novat.equalsIgnoreCase("vat")){
									P_number p = new P_number();
									p.setId_pnumber(DBUtility.genNumber(conn,P_number.tableName,"id_pnumber"));
									p.setRun_number(item.getInvoice());
									P_number.insert(p);
								}else{
									N_number n = new N_number();
									n.setId_nnumber(DBUtility.genNumber(conn,N_number.tableName,"id_nnumber"));
									n.setRun_number(entity.getInvoice());
									N_number.insert(n);
								}
								
							}else{
								item.setTemp_invoice(DBUtility.genNumber(conn,SaleOrderItem.tableName,"temp_invoice"));	
							}
							entity.setTypes(SaleOrder.TYPE_CHANGE);
						}else if(order.getOrder_type().equalsIgnoreCase(SaleOrder.TYPE_MODIFY)){
							//TODO กลับมาแก้ status
							if(entity.getType_inv().equalsIgnoreCase("")){
								item.setInvoice(entity.getInvoice());
							}else{
								item.setTemp_invoice(entity.getInvoice());
							}
							item.setItem_id(entity.getFG());
							item.setItem_qty(entity.getQty());		
							item.setRequest_date(WebUtils.getCurrentDate());
							item.setUnit_price("0");
							item.setDiscount("0");
							entity.setTypes(SaleOrder.TYPE_MODIFY);
						}
						conn.close();
						SaleOrderItem.insertItem(item);
					}
					entity.setStatus(Receive.STATUS_CLOSE);
					Receive.updateTypeStatus(entity);
					
					kson.setSuccess();
					kson.setData("order_id", order.getOrder_id());
					kson.setData("cus_id",order.getCus_id());
					kson.setData("types",order.getOrder_type());
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "change_pd")) {
					
					Production entity = new Production();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					Connection conn = DBPool.getConnection();
					conn.setAutoCommit(false);
					
					entity.setSent_id(entity.getStatus());
					String status = entity.getStatus();
					
					if(entity.getStatus().equalsIgnoreCase(Production.STATUS_NO_PRODUCE)){
						if(entity.getItem_type().equalsIgnoreCase("FG")){
							entity.setStatus(Production.STATUS_FINNISH);
						}
					}
					
					Production.update_plan(entity);
					if(!(entity.getItem_type().equalsIgnoreCase("PRO"))){
						ProduceItemMat.delete(entity.getPro_id());
						////System.out.print(entity.getPro_id() +": "+item_id+" : " + entity.getItem_qty() + " : " + entity.getSent_id());
						RDFormular.keepMatProduce(entity.getPro_id(),entity.getItem_id(),entity.getItem_qty(),entity.getSent_id());
					}
					

					SaleOrderItem order =  SaleOrderItem.selectOrder(entity.getItem_run());
					//กรณี FG
					if(entity.getItem_type().equalsIgnoreCase("FG") && order.getItem_type().equalsIgnoreCase("s")){
						order.setUpdate_by(entity.getCreate_by());
						
						if(status.equalsIgnoreCase(Production.STATUS_NO_PRODUCE)){
						order.setStatus(SaleOrderItem.STATUS_PRE_SEND);
						}else{
						order.setStatus(SaleOrderItem.STATUS_CLOSE_QT);
						}
						SaleOrderItem.updateStatusByItemrun(order);	
					
					}
					//โปรโมชั่น
					if((order.getItem_type().equalsIgnoreCase("p") && entity.getItem_type().equalsIgnoreCase("FG")) || entity.getItem_type().equalsIgnoreCase("PRO")){
						String countFG = Production.countFG(order.getItem_run(), conn);
						String countitemrun = PackageItem.countPkItem(entity.getItem_id(), conn);
						
						if(countFG.equalsIgnoreCase(countitemrun)){
							order.setUpdate_by(entity.getCreate_by());
							if(status.equalsIgnoreCase(Production.STATUS_NO_PRODUCE)){
								order.setStatus(SaleOrderItem.STATUS_PRE_SEND);
							}else{
								order.setStatus(SaleOrderItem.STATUS_CLOSE_QT);
							}
							SaleOrderItem.updateStatusByItemrun(order);	
						}
					}
					
					String row = SaleOrderItem.countItemrun(order.getOrder_id(),SaleOrderItem.STATUS_CLOSE_QT, conn);
					String count = SaleOrderItem.countAllrun(order.getOrder_id(), conn);
					if(row.equalsIgnoreCase(count)){
						
						SaleOrder saleorder = new SaleOrder();
						saleorder.setOrder_id(order.getOrder_id());
						saleorder.setUpdate_by(entity.getCreate_by());
						saleorder.setStatus(SaleOrder.STATUS_PREPARE_PD);
						SaleOrder.updateStatus(conn,saleorder);
					}					
					
					conn.commit();
					conn.close();	
					kson.setSuccess();	
					rr.out(kson.getJson());
				}
			}
		} catch (Exception e) {
			kson.setError(e);
			rr.out(kson.getJson());
		}
	}
	
	private void receive_check(ReqRes rr,String i) throws IllegalArgumentException, UnsupportedEncodingException, ParseException, IllegalAccessException, InvocationTargetException, SQLException{
		Receive entity = new Receive();
		WebUtils.bindReqToEntity(entity, rr.req);
		
		entity.setStatus(Receive.STATUS_RECEIVE);
		Receive.updateStatus(entity);
	}
}
