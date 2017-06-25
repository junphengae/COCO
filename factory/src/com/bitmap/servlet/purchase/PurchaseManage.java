package com.bitmap.servlet.purchase;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;
import java.text.ParseException;

import javax.servlet.ServletException;

import com.bitmap.bean.inventory.InventoryMaster;
import com.bitmap.bean.inventory.MaterialSearch;
import com.bitmap.bean.purchase.PurchaseOrder;
import com.bitmap.bean.purchase.PurchaseRequest;
import com.bitmap.webutils.PageControl;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;

/**
 * Servlet implementation class PurchaseInventory
 */
public class PurchaseManage extends ServletUtils {
	private static final long serialVersionUID = 1L;
       
    public PurchaseManage() {
        super();
    }

    public void doPost(ReqRes rr) throws ServletException {
		try {
			String page = getParam(rr, "page");
			PageControl ctrl = new PageControl();
			ctrl.setLine_per_page(20);
			
			if (isAction(rr)) {
				if (checkAction(rr, "search")){
					actionSearch(rr,ctrl);
				}
				
				if (checkAction(rr, "search_after_edit")){
					ctrl = (PageControl) getSession(rr, "PAGE_CTRL");
					actionSearchAfterEdit(rr,ctrl);
				}
				
				if (checkAction(rr, "create_pr")) {
					PurchaseRequest entity = new PurchaseRequest();
					WebUtils.bindReqToEntity(entity, rr.getRequest());
					
					PurchaseRequest.insert(entity);
					kson.setSuccess();
					rr.outTH(kson.getJson());
				}
				
				if (checkAction(rr, "update_pr")) {
					PurchaseRequest entity = new PurchaseRequest();
					WebUtils.bindReqToEntity(entity, rr.getRequest());
					
					PurchaseRequest.update(entity);
					kson.setSuccess();
					rr.outTH(kson.getJson());
				}
				
				if (checkAction(rr, "cancel_pr")) {
					PurchaseRequest entity = new PurchaseRequest();
					WebUtils.bindReqToEntity(entity, rr.getRequest());
					
					PurchaseRequest.status_cancel(entity);
					kson.setSuccess();
					rr.outTH(kson.getJson());
				}
				
				if (checkAction(rr, "md_approve")) {
					PurchaseRequest entity = new PurchaseRequest();
					WebUtils.bindReqToEntity(entity, rr.getRequest());
					
					PurchaseRequest.status_md_approve(entity);
					kson.setSuccess();
					rr.outTH(kson.getJson());
				}
				
				if (checkAction(rr, "md_reject")) {
					PurchaseRequest entity = new PurchaseRequest();
					WebUtils.bindReqToEntity(entity, rr.getRequest());
					
					PurchaseRequest.status_md_reject(entity);
					kson.setSuccess();
					rr.outTH(kson.getJson());
				}
				
				if (checkAction(rr, "issue_po")) {
					PurchaseOrder po = new PurchaseOrder();
					WebUtils.bindReqToEntity(po, rr.req);
					
					String po_no = PurchaseOrder.createPO(po);
					
					kson.setSuccess();
					kson.setData("po", po_no);
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "add_to_po")) {
					PurchaseRequest pr = new PurchaseRequest();
					WebUtils.bindReqToEntity(pr, rr.req);
					pr.setStatus(PurchaseRequest.STATUS_PO_OPEN);
					PurchaseRequest.updateStatus(pr, new String[]{"po","status","update_by","update_date"});
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "remove_from_po")) {
					PurchaseRequest pr = new PurchaseRequest();
					WebUtils.bindReqToEntity(pr, rr.req);
					pr.setStatus(PurchaseRequest.STATUS_MD_APPROVED);
					pr.setPo("");
					PurchaseRequest.updateStatus(pr, new String[]{"po","status","update_by","update_date"});
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "save_po")) {
					PurchaseOrder po = new PurchaseOrder();
					WebUtils.bindReqToEntity(po, rr.req);
					
					PurchaseOrder.update(po);
					
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "cancel_po")) {
					PurchaseOrder po = new PurchaseOrder();
					WebUtils.bindReqToEntity(po, rr.req);
					
					PurchaseOrder.cancelPO(po);
					PurchaseRequest.status_po_terminate(po);
					
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "cancel_po_4_new")) {
					PurchaseOrder po = new PurchaseOrder();
					WebUtils.bindReqToEntity(po, rr.req);
					
					PurchaseOrder poNew = new PurchaseOrder();
					poNew.setReference_po(po.getPo());
					poNew.setVendor_id(po.getVendor_id());
					poNew.setApprove_by(po.getUpdate_by());
					
					String po_no = PurchaseOrder.createPO4cancelPO(poNew);
					
					po.setNote(po.getNote() + "\n** ยกเลิกเพื่อออกใบใหม่ [ใบสั่งซื้อที่ออกใหม่เลขที่: " + po_no + "]");
					PurchaseOrder.cancelPO(po);
					
					kson.setSuccess();
					kson.setData("po", po_no);
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "checkPO")) {
					PurchaseOrder po = new PurchaseOrder();
					WebUtils.bindReqToEntity(po, rr.req);
					boolean has = PurchaseOrder.check(po);
					
					if (has) {
						kson.setSuccess();
					} else {						
						kson.setError("!! ไม่พบใบสั่งซื้อตามที่ระบุ กรุณาตรวจสอบ !!");
					}
					rr.outTH(kson.getJson());
				}
			} else {
				if (page.length() > 0) {
					MaterialSearch mSearch = (MaterialSearch)getSession(rr, "MAT_SEARCH");
					ctrl = (PageControl) getSession(rr, "PAGE_CTRL");
					ctrl.setPage_num(Integer.parseInt(page));
					
					String sql = " 1=1";
					
					if (mSearch.getKeyword().length() > 0) {
						
							sql += " AND " + mSearch.getWhere() + " like '%" + mSearch.getKeyword() + "%'";
						
					}
					
					if (!mSearch.getGroup_id().equalsIgnoreCase("n/a")) {
						sql += " AND group_id ='" + mSearch.getGroup_id() + "'";
					}
					
					if (!mSearch.getCat_id().equalsIgnoreCase("n/a")) {
						sql += " AND cat_id ='" + mSearch.getCat_id() + "'";
					}
					
					if (mSearch.getCheck().equalsIgnoreCase("true")) {
						sql += " AND group_id IS NULL";
					}
					
					if (mSearch.getMor().equalsIgnoreCase("true")) {
						sql += " AND (mor*1) >= (balance*1) AND group_id !='FG'";
					}
					
					setSession(rr, "MAT_LIST", InventoryMaster.selectWithCTRL(ctrl, sql));
					setSession(rr, "PAGE_CTRL", ctrl);
					redirect(rr, "material_search.jsp");
				} else {
					setSession(rr, "PAGE_CTRL", ctrl);
					removeSession(rr, "MAT_LIST");
					removeSession(rr, "MAT_SEARCH");
					redirect(rr, "material_search.jsp");
				}
			}
		} catch (Exception e) {
			kson.setError(e);
			rr.out(kson.getJson());
		}
	}
	
	private void actionSearch(ReqRes rr, PageControl ctrl) throws IOException, IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, ParseException {
		MaterialSearch mSearch = new MaterialSearch();
		WebUtils.bindReqToEntity(mSearch, rr.req);
		
		String sql = " 1=1";
		
		if (mSearch.getKeyword().length() > 0) {
			
				sql += " AND " + mSearch.getWhere() + " like '%" + mSearch.getKeyword() + "%'";
			
		}
		
		if (!mSearch.getGroup_id().equalsIgnoreCase("n/a")) {
			sql += " AND group_id ='" + mSearch.getGroup_id() + "'";
		}
		
		if (!mSearch.getCat_id().equalsIgnoreCase("n/a")) {
			sql += " AND cat_id ='" + mSearch.getCat_id() + "'";
		}
		
		if (mSearch.getCheck().equalsIgnoreCase("true")) {
			sql += " AND group_id IS NULL";
		}
		
		if (mSearch.getMor().equalsIgnoreCase("true")) {
			sql += " AND (mor*1) >= (balance*1) AND group_id !='FG'";
		}
		
		setSession(rr, "MAT_LIST", InventoryMaster.selectWithCTRL(ctrl, sql));
		setSession(rr, "PAGE_CTRL", ctrl);
		setSession(rr, "MAT_SEARCH", mSearch);
		redirect(rr, "material_search.jsp");
	}
	
	private void actionSearchAfterEdit(ReqRes rr, PageControl ctrl) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, IOException {
		MaterialSearch mSearch = (MaterialSearch)getSession(rr, "MAT_SEARCH");
		
		String sql = " 1=1";
		
		if (mSearch.getKeyword().length() > 0) {
			
				sql += " AND " + mSearch.getWhere() + " like '%" + mSearch.getKeyword() + "%'";
			
		}
		
		if (!mSearch.getGroup_id().equalsIgnoreCase("n/a")) {
			sql += " AND group_id ='" + mSearch.getGroup_id() + "'";
		}
		
		if (!mSearch.getCat_id().equalsIgnoreCase("n/a")) {
			sql += " AND cat_id ='" + mSearch.getCat_id() + "'";
		}
		
		if (mSearch.getCheck().equalsIgnoreCase("true")) {
			sql += " AND group_id IS NULL";
		}
		
		if (mSearch.getMor().equalsIgnoreCase("true")) {
			sql += " AND (mor*1) >= (balance*1) AND group_id !='FG'";
		}
		
		setSession(rr, "MAT_LIST", InventoryMaster.selectWithCTRL(ctrl, sql));
		setSession(rr, "PAGE_CTRL", ctrl);
		redirect(rr, "material_search.jsp");
	
	}
}