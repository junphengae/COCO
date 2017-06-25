package com.bitmap.bean.inventory;

public class MaterialSearch {
	String check = "";
	String mor = "";
	String keyword = "";
	String where = "description";
	String group_id = "n/a";
	String cat_id = "n/a";
	
	public String getCheck() {
		return check;
	}
	public void setCheck(String check) {
		this.check = check;
	}
	public String getKeyword() {
		return keyword;
	}
	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}
	public String getWhere() {
		return where;
	}
	public void setWhere(String where) {
		this.where = where;
	}
	public String getGroup_id() {
		return group_id;
	}
	public void setGroup_id(String group_id) {
		this.group_id = group_id;
	}
	public String getCat_id() {
		return cat_id;
	}
	public void setCat_id(String cat_id) {
		this.cat_id = cat_id;
	}
	public String getMor() {
		return mor;
	}
	public void setMor(String mor) {
		this.mor = mor;
	}
}