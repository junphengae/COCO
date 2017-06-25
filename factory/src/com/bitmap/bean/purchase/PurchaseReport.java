package com.bitmap.bean.purchase;

import com.bitmap.bean.inventory.Vendor;

public class PurchaseReport {
	String po_sum = "0";
	Vendor vendor = null;
	
	String po_close_sum = "0";
	String po_close_on_time = "0";
	String po_close_late = "0";
	String po_terminate = "0";
	String date_start = "";
	String date_end = "";
	
	public String getPo_sum() {
		return po_sum;
	}
	public void setPo_sum(String po_sum) {
		this.po_sum = po_sum;
	}
	public Vendor getVendor() {
		return vendor;
	}
	public void setVendor(Vendor vendor) {
		this.vendor = vendor;
	}
	public String getPo_close_sum() {
		return po_close_sum;
	}
	public void setPo_close_sum(String po_close_sum) {
		this.po_close_sum = po_close_sum;
	}
	public String getPo_close_on_time() {
		return po_close_on_time;
	}
	public void setPo_close_on_time(String po_close_on_time) {
		this.po_close_on_time = po_close_on_time;
	}
	public String getPo_close_late() {
		return po_close_late;
	}
	public void setPo_close_late(String po_close_late) {
		this.po_close_late = po_close_late;
	}
	public String getDate_start() {
		return date_start;
	}
	public void setDate_start(String date_start) {
		this.date_start = date_start;
	}
	public String getDate_end() {
		return date_end;
	}
	public void setDate_end(String date_end) {
		this.date_end = date_end;
	}
	public String getPo_terminate() {
		return po_terminate;
	}
	public void setPo_terminate(String po_terminate) {
		this.po_terminate = po_terminate;
	}
	
	
}
