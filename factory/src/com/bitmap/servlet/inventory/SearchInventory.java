package com.bitmap.servlet.inventory;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;
import java.text.ParseException;

import javax.servlet.ServletException;

import com.bitmap.bean.inventory.InventoryMaster;
import com.bitmap.bean.inventory.MaterialSearch;
import com.bitmap.webutils.PageControl;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;

/**
 * Servlet implementation class SearchInventory
 */
public class SearchInventory extends ServletUtils {
	private static final long serialVersionUID = 1L;
       
    public SearchInventory() {
        super();
    }

	public void doPost(ReqRes rr) throws ServletException {
		try {
			String page = getParam(rr, "page");
			PageControl ctrl = new PageControl();
			ctrl.setLine_per_page(20);
			
			if (getAction(rr).length() > 0) {
				if (checkAction(rr, "search")){
					actionSearch(rr,ctrl);
				}
				
				if (checkAction(rr, "search_after_edit")){
					ctrl = (PageControl) getSession(rr, "PAGE_CTRL");
					actionSearchAfterEdit(rr,ctrl);
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
		
		setSession(rr, "MAT_LIST", InventoryMaster.selectWithCTRL(ctrl, sql));
		setSession(rr, "PAGE_CTRL", ctrl);
		redirect(rr, "material_search.jsp");
	
	}
}