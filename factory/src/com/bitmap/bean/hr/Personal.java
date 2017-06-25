package com.bitmap.bean.hr;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import com.bitmap.dbconnection.mysql.vbi.*;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.security.SecurityUser;
import com.bitmap.webutils.PageControl;
import com.bitmap.ajax.AutoComplete;

public class Personal {
	public static String tableName = "per_personal";
	private static String[] keys = {"per_id"};
	private static String[]	field = {"prefix","name","surname","sex","mobile","email","dep_id","div_id","pos_id","date_start","create_by","date_update"};
	
	private String per_id = "";
	private String tag_id = "";
	private String prefix = "";
	private String name = "";
	private String surname = "";
	private String sex = "";
	private String mobile = "";
	private String email = "";
	private String div_id = "";
	private String dep_id = "";
	private String pos_id = "";
	private String branch_id = "";
	private Date date_start = null;
	private Date date_end = null;
	private Date date_retire = null;
	private String image = "";
	private String create_by = "";
	private Timestamp date_create = null;
	private Timestamp date_update = null;
	
	private Position UIPosition = new Position();
	public Position getUIPosition() {return UIPosition;}
	public void setUIPosition(Position uIPosition) {UIPosition = uIPosition;}
	
	private Division UIDivision = new Division();
	public Division getUIDivision() {return UIDivision;}
	public void setUIDivision(Division uIDivision) {UIDivision = uIDivision;}
	
	private Department UIDepartment = new Department();
	public Department getUIDepartment() {return UIDepartment;}
	public void setUIDepartment(Department uIDepartment) {UIDepartment = uIDepartment;}
	
	private SecurityUser UISecurity = new SecurityUser();
	public SecurityUser getUISecurity() {return UISecurity;}
	public void setUISecurity(SecurityUser uISecurity) {UISecurity = uISecurity;}

	private PersonalDetail perDetail = new PersonalDetail();
	
	public static Personal login(Connection conn, String per_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Personal entity = new Personal();
		entity.setPer_id(per_id);
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		entity.setUIPerDetail(PersonalDetail.select(conn, per_id));
		return entity;
	}
	
	public static Personal selectOnlyPerson(String per_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Personal entity = new Personal();
		entity.setPer_id(per_id);
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}
	
	public static String selectName(String per_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Personal entity = new Personal();
		entity.setPer_id(per_id);
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity.getName();
	}
	
	public static String selectNameANDSurName(String per_id,Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Personal entity = new Personal();
		entity.setPer_id(per_id);
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		return entity.getName()+" " + entity.getSurname();
	}
	
	public static String selectNameANDSurName(String per_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		Personal entity = new Personal();
		entity.setPer_id(per_id);
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		return entity.getName()+" " + entity.getSurname();
	}
	
	public static Personal selectOnlyPerson(String per_id, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Personal entity = new Personal();
		entity.setPer_id(per_id);
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		return entity;
	}
	
	public static Personal select(String per_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Personal entity = new Personal();
		entity.setPer_id(per_id);
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		entity.setUIPerDetail(PersonalDetail.select(conn, per_id));
		entity.setUIPosition(Position.select(entity.getPos_id(), conn));
		entity.setUIDivision(Division.select(entity.getDiv_id(), conn));
		entity.setUIDepartment(Department.select(entity.getDep_id(), conn));
		conn.close();
		return entity;
	}
	
	public static void insert(Personal personal) throws IllegalAccessException, InvocationTargetException, SQLException {
		Connection conn = DBPool.getConnection();
		personal.setPer_id(genPer_id(conn));
		personal.setDate_create(DBUtility.getDBCurrentDateTime());
		if (personal.getPrefix().equalsIgnoreCase("นาย")) {
			personal.setSex("m");
		} else {
			personal.setSex("f");
		}
		DBUtility.insertToDB(conn, tableName, personal);
		conn.close();
	}	
	
	private static String genPer_id(Connection conn) throws SQLException{
		String per_id = "00001";
		String sql = "SELECT per_id FROM " + tableName + " ORDER BY (per_id*1) DESC";
		ResultSet rs = conn.createStatement().executeQuery(sql);
		if (rs.next()) {
			String temp = rs.getString(1);
			
			if (temp.indexOf("dev") == -1) {
				String id = (Integer.parseInt(temp) + 100001) + "";
				per_id = id.substring(1,id.length());
			}
		}
		rs.close();
		return per_id;
	}
	
	public static List<Personal> listAll() throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName;
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Personal> list = new ArrayList<Personal>();
		while (rs.next()) {
			Personal entity = new Personal();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<Personal> listByDep(String dep_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE dep_id='" + dep_id + "'";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Personal> list = new ArrayList<Personal>();
		while (rs.next()) {
			Personal entity = new Personal();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<Personal> listByPosition(String pos_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE pos_id='" + pos_id + "'";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Personal> list = new ArrayList<Personal>();
		while (rs.next()) {
			Personal entity = new Personal();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<String[]> listDropdown(String pos_id) throws SQLException{
		Connection conn = DBPool.getConnection();
		List<String[]> list = DBUtility.getDropDownList(conn, tableName, "per_id", new String[]{"name","surname"}, "per_id","pos_id='" + pos_id + "'");
		conn.close();
		return list;
	}
	
	public static List<String[]> listDropdownByDep(String dep_id) throws SQLException{
		Connection conn = DBPool.getConnection();
		List<String[]> list = DBUtility.getDropDownList(conn, tableName, "per_id", new String[]{"name","surname"}, "per_id","dep_id='"+dep_id+" ' ");
		conn.close();
		return list;
	}
	
	public static List<AutoComplete> listByAutocomplete(String str) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE name LIKE '%" + str + "%' OR surname LIKE '%" + str + "%'";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<AutoComplete> list = new ArrayList<AutoComplete>();
		while (rs.next()) {
			Personal entity = new Personal();
			AutoComplete ac = new AutoComplete();
			DBUtility.bindResultSet(entity, rs);
			ac.setId(entity.getPer_id());
			ac.setValue(entity.getName() + " " + entity.getSurname());
			list.add(ac);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<Personal> pageList(PageControl ctrl) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName;
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Personal> list = new ArrayList<Personal>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					Personal entity = new Personal();
					DBUtility.bindResultSet(entity, rs);
					list.add(entity);
				}
				cnt++;
			}
		}
		rs.close();
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		conn.close();
		return list;
	}
	
	public static List<Personal> selectWithCTRL(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1 ";
		
		for (Iterator<String[]> iterator = params.iterator(); iterator.hasNext();) {
			String[] pm = (String[]) iterator.next();
			if (pm[1].length() > 0) {
				if (pm[0].equalsIgnoreCase("search")) {
					sql += " AND per_id LIKE '%" + pm[1] + "%' OR name LIKE '%" + pm[1] + "%'";
				} else {
					sql += " AND " + pm[0] + "='" + pm[1] + "'";
				}
			}
		}
		
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Personal> list = new ArrayList<Personal>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					Personal entity = new Personal();
					DBUtility.bindResultSet(entity, rs);
					entity.setUIPosition(Position.select(entity.getPos_id(), conn));
					entity.setUIDivision(Division.select(entity.getDiv_id(), conn));
					entity.setUIDepartment(Department.select(entity.getDep_id(), conn));
					entity.setUISecurity(SecurityUser.select(entity.getPer_id(),conn));
					list.add(entity);
				}
				cnt++;
			}
		}
		rs.close();
		st.close();
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		conn.close();
		return list;
	}
	
	public static void update(Personal entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setDate_update(DBUtility.getDBCurrentDateTime());
		if (entity.getPrefix().equalsIgnoreCase("นาย")) {
			entity.setSex("m");
		} else {
			entity.setSex("f");
		}
		DBUtility.updateToDB(conn, tableName, entity,field, keys);
		conn.close();
	}
	
	public static void updateImg(String per_id, String imgName) throws IllegalAccessException, InvocationTargetException, SQLException{
		Personal entity = new Personal();
		entity.setPer_id(per_id);
		entity.setImage(imgName);
		Connection conn = DBPool.getConnection();
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"image"}, keys);
		conn.close();
	}
	
	public static void delete(Personal entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.deleteFromDB(conn, tableName, entity, keys);
		PersonalDetail perDetail = new PersonalDetail();
		perDetail.setPer_id(entity.getPer_id());
		PersonalDetail.delete(perDetail);
		conn.close();
	}
	
	public static boolean checkPosition(String pos_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		Personal entity = new Personal();
		entity.setPos_id(pos_id);
		boolean empty = false ;
		empty =  DBUtility.getEntityFromDB(conn, tableName, entity, new String[] {"pos_id" });
		conn.close();
		
		return empty ;
	}
	
	/**
	 * whan : update  วันลาออกของพนักงาน
	 * @param entity
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static void update_retire(Personal entity) throws SQLException, IllegalAccessException, InvocationTargetException
	{
		Connection conn = DBPool.getConnection();
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"date_retire"}, keys);
		conn.close();
	}
	public PersonalDetail getUIPerDetail() {
		return perDetail;
	}
	public void setUIPerDetail(PersonalDetail perDetail) {
		this.perDetail = perDetail;
	}
	public String getPer_id() {
		return per_id;
	}
	public void setPer_id(String per_id) {
		this.per_id = per_id;
	}
	public String getTag_id() {
		return tag_id;
	}
	public void setTag_id(String tag_id) {
		this.tag_id = tag_id;
	}
	public String getPrefix() {
		return prefix;
	}
	public void setPrefix(String prefix) {
		this.prefix = prefix;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getSurname() {
		return surname;
	}
	public void setSurname(String surname) {
		this.surname = surname;
	}
	public String getSex() {
		return sex;
	}
	public void setSex(String sex) {
		this.sex = sex;
	}
	public String getMobile() {
		return mobile;
	}
	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getDiv_id() {
		return div_id;
	}
	public void setDiv_id(String div_id) {
		this.div_id = div_id;
	}
	public String getDep_id() {
		return dep_id;
	}
	public void setDep_id(String dep_id) {
		this.dep_id = dep_id;
	}
	public String getPos_id() {
		return pos_id;
	}
	public void setPos_id(String pos_id) {
		this.pos_id = pos_id;
	}
	public String getBranch_id() {
		return branch_id;
	}
	public void setBranch_id(String branch_id) {
		this.branch_id = branch_id;
	}
	public Date getDate_start() {
		return date_start;
	}
	public void setDate_start(Date date_start) {
		this.date_start = date_start;
	}
	public Date getDate_end() {
		return date_end;
	}
	public void setDate_end(Date date_end) {
		this.date_end = date_end;
	}
	public String getImage() {
		return image;
	}
	public void setImage(String image) {
		this.image = image;
	}
	public String getCreate_by() {
		return create_by;
	}
	public void setCreate_by(String create_by) {
		this.create_by = create_by;
	}
	public Timestamp getDate_create() {
		return date_create;
	}
	public void setDate_create(Timestamp date_create) {
		this.date_create = date_create;
	}
	public Timestamp getDate_update() {
		return date_update;
	}
	public void setDate_update(Timestamp date_update) {
		this.date_update = date_update;
	}
	public Date getDate_retire() {
		return date_retire;
	}
	public void setDate_retire(Date date_retire) {
		this.date_retire = date_retire;
	}
	
	
}