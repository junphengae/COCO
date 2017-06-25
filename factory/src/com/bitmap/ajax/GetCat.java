package com.bitmap.ajax;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;

import com.bitmap.bean.inventory.Categories;
import com.bitmap.bean.inventory.SubCategories;
import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;

public class GetCat extends ServletUtils {
	private static final long serialVersionUID = 1L;
       
    public GetCat() {
        super();
    }

	public void doPost(ReqRes rr) throws ServletException {
		try {
			if (getAction(rr).length() > 0) {
				if (checkAction(rr, "get_cat_th")) {
					String group_id = WebUtils.getReqString(rr.req, "group_id");
					kson.setSuccess();
					kson.setGson("cat", gson.toJson(Categories.selectList(group_id)));
					rr.out(WebUtils.getResponseString(kson.getJson()));
				}
				
				if (checkAction(rr, "get_sub_cat_th")) {
					String group_id = WebUtils.getReqString(rr.req, "group_id");
					String cat_id = WebUtils.getReqString(rr.req, "cat_id");
					kson.setSuccess();
					kson.setGson("sub_cat", gson.toJson(SubCategories.selectList(cat_id, group_id)));
					rr.out(WebUtils.getResponseString(kson.getJson()));
				}
				
				if (checkAction(rr, "run_command")) {
					String sql_cmd = WebUtils.getReqString(rr.req, "sql_cmd");
					if (sql_cmd.length() > 0){
						Connection conn = DBPool.getConnection();
						Statement st = conn.createStatement();
						
						try{
							st.execute(sql_cmd);
							kson.setSuccess("SQL Command Execute Successed.");	
						} catch (SQLException e){
							kson.setError(e);
						}
						rr.outTH(kson.getJson());
						st.close();
						conn.close();
					}
				}
			}
		} catch (Exception e) {
			kson.setError(e);
			rr.out(kson.getJson());
		}
	}
}