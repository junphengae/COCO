package com.bmp.report.html.bean;

import java.sql.Timestamp;

public class ServiceRepairDetailBean {

	private String 		id				= "";
	private String 		number			= "";
	private String 		labor_id		= "";
	private String 		labor_name		= "";
	private String 		labor_qty		= "";
	private String 		labor_rate		= "";
	private String 		discount		= "";
	private String 		discount_flag	= "";
	private String 		status			= "";
	private String 		note			= "";
	private String 		vat				= "";
	private String 		total_vat		= "";
	private String 		srd_dis_total_before	= "";
	private String 		srd_dis_total	= "";
	private String 		srd_net_price	= "";
	private Timestamp 	due_date 		= null;
	private String 		create_by		= "";
	private Timestamp 	create_date 	= null;
	private String 		update_by		= "";
	private Timestamp 	update_date 	= null;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getNumber() {
		return number;
	}
	public void setNumber(String number) {
		this.number = number;
	}
	public String getLabor_id() {
		return labor_id;
	}
	public void setLabor_id(String labor_id) {
		this.labor_id = labor_id;
	}
	public String getLabor_name() {
		return labor_name;
	}
	public void setLabor_name(String labor_name) {
		this.labor_name = labor_name;
	}
	public String getLabor_qty() {
		return labor_qty;
	}
	public void setLabor_qty(String labor_qty) {
		this.labor_qty = labor_qty;
	}
	public String getLabor_rate() {
		return labor_rate;
	}
	public void setLabor_rate(String labor_rate) {
		this.labor_rate = labor_rate;
	}
	public String getDiscount() {
		return discount;
	}
	public void setDiscount(String discount) {
		this.discount = discount;
	}
	public String getDiscount_flag() {
		return discount_flag;
	}
	public void setDiscount_flag(String discount_flag) {
		this.discount_flag = discount_flag;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getNote() {
		return note;
	}
	public void setNote(String note) {
		this.note = note;
	}
	public String getVat() {
		return vat;
	}
	public void setVat(String vat) {
		this.vat = vat;
	}
	public String getTotal_vat() {
		return total_vat;
	}
	public void setTotal_vat(String total_vat) {
		this.total_vat = total_vat;
	}
	public String getSrd_dis_total_before() {
		return srd_dis_total_before;
	}
	public void setSrd_dis_total_before(String srd_dis_total_before) {
		this.srd_dis_total_before = srd_dis_total_before;
	}
	public String getSrd_dis_total() {
		return srd_dis_total;
	}
	public void setSrd_dis_total(String srd_dis_total) {
		this.srd_dis_total = srd_dis_total;
	}
	public String getSrd_net_price() {
		return srd_net_price;
	}
	public void setSrd_net_price(String srd_net_price) {
		this.srd_net_price = srd_net_price;
	}
	public Timestamp getDue_date() {
		return due_date;
	}
	public void setDue_date(Timestamp due_date) {
		this.due_date = due_date;
	}
	public String getCreate_by() {
		return create_by;
	}
	public void setCreate_by(String create_by) {
		this.create_by = create_by;
	}
	public Timestamp getCreate_date() {
		return create_date;
	}
	public void setCreate_date(Timestamp create_date) {
		this.create_date = create_date;
	}
	public String getUpdate_by() {
		return update_by;
	}
	public void setUpdate_by(String update_by) {
		this.update_by = update_by;
	}
	public Timestamp getUpdate_date() {
		return update_date;
	}
	public void setUpdate_date(Timestamp update_date) {
		this.update_date = update_date;
	}
	
	
	
	
	
}
