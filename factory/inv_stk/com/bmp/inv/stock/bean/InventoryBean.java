package com.bmp.inv.stock.bean;

public class InventoryBean {
	
	private String mat_code;
	private String po_no;
	private String des_unit;
	private String lot_no;
	private String product_desc;
	private String lot_expire;
	private String  lot_qty;
	
	public String getMat_code() {
		return mat_code;
	}
	public void setMat_code(String mat_code) {
		this.mat_code = mat_code;
	}
	public String getPo_no() {
		return po_no;
	}
	public void setPo_no(String po_no) {
		this.po_no = po_no;
	}
	public String getLot_no() {
		return lot_no;
	}
	public void setLot_no(String lot_no) {
		this.lot_no = lot_no;
	}
	public String getProduct_desc() {
		return product_desc;
	}
	public void setProduct_desc(String product_desc) {
		this.product_desc = product_desc;
	}
	public String getLot_expire() {
		return lot_expire;
	}
	public void setLot_expire(String lot_expire) {
		this.lot_expire = lot_expire;
	}
	public String getLot_qty() {
		return lot_qty;
	}
	public void setLot_qty(String lot_qty) {
		this.lot_qty = lot_qty;
	}
	public String getDes_unit() {
		return des_unit;
	}
	public void setDes_unit(String des_unit) {
		this.des_unit = des_unit;
	}
	
	
}
