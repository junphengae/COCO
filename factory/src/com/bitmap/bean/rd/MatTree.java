package com.bitmap.bean.rd;

import java.util.ArrayList;
import java.util.List;

public class MatTree {
	String mat_code = "";
	String group_id = "";
	String order_qty = "";
	String request_qty = "";
	String inv_qty = "";
	String plan_qty = "";
	String description = "";
	String ref_code = "";
	List<MatTree> mat = new ArrayList<MatTree>();
	
	public String getRef_code() {
		return ref_code;
	}
	public void setRef_code(String ref_code) {
		this.ref_code = ref_code;
	}
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
	public String getOrder_qty() {
		return order_qty;
	}
	public void setOrder_qty(String order_qty) {
		this.order_qty = order_qty;
	}
	public String getInv_qty() {
		return inv_qty;
	}
	public void setInv_qty(String inv_qty) {
		this.inv_qty = inv_qty;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getPlan_qty() {
		return plan_qty;
	}
	public void setPlan_qty(String plan_qty) {
		this.plan_qty = plan_qty;
	}
	public List<MatTree> getMat() {
		return mat;
	}
	public void setMat(List<MatTree> mat) {
		this.mat = mat;
	}
	public String getRequest_qty() {
		return request_qty;
	}
	public void setRequest_qty(String request_qty) {
		this.request_qty = request_qty;
	}
}
