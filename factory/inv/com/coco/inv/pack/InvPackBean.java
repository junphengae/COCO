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
	private String pack_id = "";
	private String description  = "";
	private String other_unit  = "";	
	private String factor  = "";
	private String main_unit = "";
	private String std_unit  = "";	
	private String des_unit  = "";
	private String unit_pack = "";	
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
	public String getPack_id() {
		return pack_id;
	}
	public void setPack_id(String pack_id) {
		this.pack_id = pack_id;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getOther_unit() {
		return other_unit;
	}
	public void setOther_unit(String other_unit) {
		this.other_unit = other_unit;
	}
	public String getFactor() {
		return factor;
	}
	public void setFactor(String factor) {
		this.factor = factor;
	}
	public String getMain_unit() {
		return main_unit;
	}
	public void setMain_unit(String main_unit) {
		this.main_unit = main_unit;
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
	public String getUnit_pack() {
		return unit_pack;
	}
	public void setUnit_pack(String unit_pack) {
		this.unit_pack = unit_pack;
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
