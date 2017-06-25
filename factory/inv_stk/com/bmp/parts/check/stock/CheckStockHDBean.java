package com.bmp.parts.check.stock;

import java.sql.Timestamp;

public class CheckStockHDBean {

	private int check_id 		 	= 0;
	private String status		 	= "";
	private Timestamp approve_date 	= null;
	private String approve_by  		= "";
	private Timestamp check_date 	= null;
	private String check_by		 	= "";
	private Timestamp update_date	= null;
	private String update_by 	 	= "";
	
	public int getCheck_id() {
		return check_id;
	}
	public void setCheck_id(int check_id) {
		this.check_id = check_id;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public Timestamp getApprove_date() {
		return approve_date;
	}
	public void setApprove_date(Timestamp approve_date) {
		this.approve_date = approve_date;
	}
	public String getApprove_by() {
		return approve_by;
	}
	public void setApprove_by(String approve_by) {
		this.approve_by = approve_by;
	}
	public Timestamp getCheck_date() {
		return check_date;
	}
	public void setCheck_date(Timestamp check_date) {
		this.check_date = check_date;
	}
	public String getCheck_by() {
		return check_by;
	}
	public void setCheck_by(String check_by) {
		this.check_by = check_by;
	}
	public Timestamp getUpdate_date() {
		return update_date;
	}
	public void setUpdate_date(Timestamp update_date) {
		this.update_date = update_date;
	}
	public String getUpdate_by() {
		return update_by;
	}
	public void setUpdate_by(String update_by) {
		this.update_by = update_by;
	}
	
	
}
