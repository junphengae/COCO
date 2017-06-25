package com.bitmap.servlet.sto;

import com.bitmap.bean.sto.STOBean;
import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;

import java.io.IOException;
import java.sql.Connection;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class STOServlet
 */
public class STOServlet extends ServletUtils {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see ServletUtils#ServletUtils()
     */
    public STOServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	@Override
	public void doPost(ReqRes rr) throws ServletException {
		
		try {
			if (isAction(rr)) {
				if (checkAction(rr, "create_sto")) {
					STOBean entity = new STOBean();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					Connection conn = DBPool.getConnection();
					conn.setAutoCommit(false);
					
					STOBean.createSTO(entity, conn);;
					
					conn.commit();
					conn.close();
					kson.setSuccess();
					kson.setData("sto_no", entity.getSto_no());
					rr.out(kson.getJson());
					
				}
				
				
				
				
				
			}
		} catch (Exception e) {
			// TODO: handle exception
		}
		
	}

}
