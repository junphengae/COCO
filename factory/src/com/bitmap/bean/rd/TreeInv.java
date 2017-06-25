package com.bitmap.bean.rd;

import java.util.Date;

public class TreeInv {
	String mat_code = "";
	String group_id = "";
	String cat_name = "";
	String sub_cat_name = "";
	String description = "";
	String std_unit = "";
	String des_unit = "";
	Date mfg = null;

	public String getMat_code() {
		return mat_code;
	}
	public void setMat_code(String mat_code) {
		this.mat_code = mat_code;
	}
	public String getGroup_id() {
		return group_id;
	}
	public void setGroup_id(String group_id) {
		this.group_id = group_id;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getCat_name() {
		return cat_name;
	}
	public void setCat_name(String cat_name) {
		this.cat_name = cat_name;
	}
	public String getSub_cat_name() {
		return sub_cat_name;
	}
	public void setSub_cat_name(String sub_cat_name) {
		this.sub_cat_name = sub_cat_name;
	}
	public String getStd_unit() {
		return std_unit;
	}
	public void setStd_unit(String std_unit) {
		this.std_unit = std_unit;
	}
	public String getDes_unit() {
		return des_unit;
	}
	public void setDes_unit(String des_unit) {
		this.des_unit = des_unit;
	}
	public Date getMfg() {
		return mfg;
	}
	public void setMfg(Date mfg) {
		this.mfg = mfg;
	}
	
	
}
