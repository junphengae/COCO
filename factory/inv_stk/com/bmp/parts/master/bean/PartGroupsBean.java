package com.bmp.parts.master.bean;

import java.sql.Timestamp;

public class PartGroupsBean {

	private String group_id = "";
	private String group_name_en = "";
	private String group_name_th = "";
	private String create_by = "";
	private Timestamp create_date = null;
	private String update_by = "";
	private Timestamp update_date = null;
	
	public String getGroup_id() {
		return group_id;
	}
	public void setGroup_id(String group_id) {
		this.group_id = group_id;
	}
	public String getGroup_name_en() {
		return group_name_en;
	}
	public void setGroup_name_en(String group_name_en) {
		this.group_name_en = group_name_en;
	}
	public String getGroup_name_th() {
		return group_name_th;
	}
	public void setGroup_name_th(String group_name_th) {
		this.group_name_th = group_name_th;
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
