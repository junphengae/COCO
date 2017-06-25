package com.bmp.report.html.bean;

import java.sql.Timestamp;

public class servicePartDetailBean {
	private String pn = "";
	private String description = "";
	private String sum_qty = "";
	private String sum_spd_vat_total = "";
	private String sum_spd_dis_total = "";
	private String sum_net_price = "";
	private String unit_price = "";
	private String type_name = "";
	private Timestamp job_close_date = null;
	private Timestamp date_sale_min = null;
	private Timestamp date_sale_max = null;
	
	
	public String getSum_spd_vat_total() {
		return sum_spd_vat_total;
	}
	public void setSum_spd_vat_total(String sum_spd_vat_total) {
		this.sum_spd_vat_total = sum_spd_vat_total;
	}
	public String getPn() {
		return pn;
	}
	public void setPn(String pn) {
		this.pn = pn;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getSum_qty() {
		return sum_qty;
	}
	public void setSum_qty(String sum_qty) {
		this.sum_qty = sum_qty;
	}
	public String getSum_spd_dis_total() {
		return sum_spd_dis_total;
	}
	public void setSum_spd_dis_total(String sum_spd_dis_total) {
		this.sum_spd_dis_total = sum_spd_dis_total;
	}
	public String getSum_net_price() {
		return sum_net_price;
	}
	public void setSum_net_price(String sum_net_price) {
		this.sum_net_price = sum_net_price;
	}
	public String getUnit_price() {
		return unit_price;
	}
	public void setUnit_price(String unit_price) {
		this.unit_price = unit_price;
	}
	public String getType_name() {
		return type_name;
	}
	public void setType_name(String type_name) {
		this.type_name = type_name;
	}
	public Timestamp getJob_close_date() {
		return job_close_date;
	}
	public void setJob_close_date(Timestamp job_close_date) {
		this.job_close_date = job_close_date;
	}
	public Timestamp getDate_sale_min() {
		return date_sale_min;
	}
	public void setDate_sale_min(Timestamp date_sale_min) {
		this.date_sale_min = date_sale_min;
	}
	public Timestamp getDate_sale_max() {
		return date_sale_max;
	}
	public void setDate_sale_max(Timestamp date_sale_max) {
		this.date_sale_max = date_sale_max;
	}
	

}
