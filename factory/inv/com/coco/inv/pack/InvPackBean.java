/**
 * 
 */
package com.coco.inv.pack;

import java.sql.Timestamp;

/**
 * @author Jack JPK
 *
 */
public class InvPackBean {

	private String mat_code  = "";
	private String description  = "";
	private String unit_des  = "";
	private String factor  = "";
	private Timestamp create_date  = null;
	private String create_by  = "";
	private Timestamp update_date  =  null;
	private String update_by  = "";
	
	public String getMat_code() {
		return mat_code;
	}
	public void setMat_code(String mat_code) {
		this.mat_code = mat_code;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getUnit_des() {
		return unit_des;
	}
	public void setUnit_des(String unit_des) {
		this.unit_des = unit_des;
	}
	public String getFactor() {
		return factor;
	}
	public void setFactor(String factor) {
		this.factor = factor;
	}
	public Timestamp getCreate_date() {
		return create_date;
	}
	public void setCreate_date(Timestamp create_date) {
		this.create_date = create_date;
	}
	public String getCreate_by() {
		return create_by;
	}
	public void setCreate_by(String create_by) {
		this.create_by = create_by;
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
