package com.bitmap.servlet.rd;

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
 * Servlet implementation class SearchFormular
 */
public class SearchFormular extends ServletUtils {
	private static final long serialVersionUID = 1L;
       
    public SearchFormular() {
        super();
    }

    public void doPost(ReqRes rr) throws ServletException {
		try {
			String page = getParam(rr, "page");
			PageControl ctrl = new PageControl();
			
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
					
					String sql = "";
					if (mSearch.getKeyword().length() > 0) {
						if (mSearch.getWhere().equalsIgnoreCase("mat_code")) {
							sql += mSearch.getWhere() + "='" + mSearch.getKeyword() + "'";
						} else {
							sql += mSearch.getWhere() + " like '%" + mSearch.getKeyword() + "%'";
						}
						
						if (!mSearch.getGroup_id().equalsIgnoreCase("n/a")) {
							sql += " AND group_id ='" + mSearch.getGroup_id() + "'";
						}
						
						if (!mSearch.getCat_id().equalsIgnoreCase("n/a")) {
							sql += " AND cat_id ='" + mSearch.getCat_id() + "'";
						}
						
						sql += " AND group_id != 'MT' AND group_id!= 'PK'";
					} else {
						if (!mSearch.getGroup_id().equalsIgnoreCase("n/a")) {
							sql += " group_id ='" + mSearch.getGroup_id() + "'";
							
							if (!mSearch.getCat_id().equalsIgnoreCase("n/a")) {
								sql += " AND cat_id ='" + mSearch.getCat_id() + "'";
							}
							sql += " AND group_id != 'MT' AND group_id!= 'PK'";
						}else{						
							sql += " ggroup_id != 'MT' AND group_id!= 'PK'";
						}
						
					}
					
					setSession(rr, "PAGE_CTRL", ctrl);
					setSession(rr, "MAT_LIST", InventoryMaster.selectWithCTRL(ctrl, sql));
					redirect(rr, "formular_search.jsp");
				} else {
					setSession(rr, "PAGE_CTRL", ctrl);
					removeSession(rr, "MAT_LIST");
					removeSession(rr, "MAT_SEARCH");
					redirect(rr, "formular_search.jsp");
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
		
		String sql = "";
		if (mSearch.getKeyword().length() > 0) {
			if (mSearch.getWhere().equalsIgnoreCase("mat_code")) {
				sql += mSearch.getWhere() + "='" + mSearch.getKeyword() + "'";
			} else {
				sql += mSearch.getWhere() + " like '%" + mSearch.getKeyword() + "%'";
			}
			
			if (!mSearch.getGroup_id().equalsIgnoreCase("n/a")) {
				sql += " AND group_id ='" + mSearch.getGroup_id() + "'";
			}
			
			if (!mSearch.getCat_id().equalsIgnoreCase("n/a")) {
				sql += " AND cat_id ='" + mSearch.getCat_id() + "'";
			}
			
			sql += " AND group_id != 'MT' AND group_id!= 'PK'";
		} else {
			if (!mSearch.getGroup_id().equalsIgnoreCase("n/a")) {
				sql += " group_id ='" + mSearch.getGroup_id() + "'";
				
				if (!mSearch.getCat_id().equalsIgnoreCase("n/a")) {
					sql += " AND cat_id ='" + mSearch.getCat_id() + "'";
				}
				sql += " AND group_id != 'MT' AND group_id!= 'PK'";
			}else{
				sql += " group_id != 'MT' AND group_id!= 'PK'";
			}
		}
		setSession(rr, "PAGE_CTRL", ctrl);
		setSession(rr, "MAT_LIST", InventoryMaster.selectWithCTRL(ctrl, sql));
		setSession(rr, "MAT_SEARCH", mSearch);
		redirect(rr, "formular_search.jsp");
	}
	
	private void actionSearchAfterEdit(ReqRes rr, PageControl ctrl) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, IOException {
		MaterialSearch mSearch = (MaterialSearch)getSession(rr, "MAT_SEARCH");
		
		String sql = "";
		if (mSearch.getKeyword().length() > 0) {
			if (mSearch.getWhere().equalsIgnoreCase("mat_code")) {
				sql += mSearch.getWhere() + "='" + mSearch.getKeyword() + "'";
			} else {
				sql += mSearch.getWhere() + " like '%" + mSearch.getKeyword() + "%'";
			}
			
			if (!mSearch.getGroup_id().equalsIgnoreCase("n/a")) {
				sql += " AND group_id ='" + mSearch.getGroup_id() + "'";
			}
			
			if (!mSearch.getCat_id().equalsIgnoreCase("n/a")) {
				sql += " AND cat_id ='" + mSearch.getCat_id() + "'";
			}
			
			sql += " AND group_id != 'MT' AND group_id!= 'PK'";
		} else {
			if (!mSearch.getGroup_id().equalsIgnoreCase("n/a")) {
				sql += " group_id ='" + mSearch.getGroup_id() + "'";
				
				if (!mSearch.getCat_id().equalsIgnoreCase("n/a")) {
					sql += " AND cat_id ='" + mSearch.getCat_id() + "'";
				}
				sql += " AND group_id != 'MT' AND group_id!= 'PK'";
			}else{						
				sql += " group_id != 'MT' AND group_id!= 'PK'";
			}
		}
		
		setSession(rr, "PAGE_CTRL", ctrl);
		setSession(rr, "MAT_LIST", InventoryMaster.selectWithCTRL(ctrl, sql));
		redirect(rr, "formular_search.jsp");
	
	}

}
