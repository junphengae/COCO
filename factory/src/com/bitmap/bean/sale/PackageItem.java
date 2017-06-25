package com.bitmap.bean.sale;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import com.bitmap.bean.inventory.InventoryMaster;
import com.bitmap.bean.rd.MatTree;
import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.utils.Money;

public class PackageItem {

	public static String tableName = "sale_package_item";
	private static String[] keys = {"pk_id","mat_code","run"};
	private static String[] fieldNames = {"mat_code","unit_price","discount","qty","update_by","update_date"};
	
	String run ="1";
	String pk_id = "";
	String mat_code = "";
	String unit_price = "";
	String discount = "";
	String qty = "";
	String create_by = "";
	Timestamp create_date = null;
	String update_by = "";
	Timestamp update_date = null;
	
	String UISumQty = "0";
	InventoryMaster UIMat = new InventoryMaster();
	
	
	public String getQty() {
		return qty;
	}
	public void setQty(String qty) {
		this.qty = qty;
	}
	public InventoryMaster getUIMat() {
		return UIMat;
	}
	public void setUIMat(InventoryMaster uIMat) {
		UIMat = uIMat;
	}
	public String getPk_id() {
		return pk_id;
	}
	public void setPk_id(String pk_id) {
		this.pk_id = pk_id;
	}
	public String getMat_code() {
		return mat_code;
	}
	public void setMat_code(String mat_code) {
		this.mat_code = mat_code;
	}
	public String getUnit_price() {
		return unit_price;
	}
	public void setUnit_price(String unit_price) {
		this.unit_price = unit_price;
	}
	public String getDiscount() {
		return discount;
	}
	public void setDiscount(String discount) {
		this.discount = discount;
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
	
	public String getRun() {
		return run;
	}
	public void setRun(String run) {
		this.run = run;
	}
	
	public String getUISumQty() {
		return UISumQty;
	}
	public void setUISumQty(String uISumQty) {
		UISumQty = uISumQty;
	}
	public static void select(PackageItem entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		entity.setUIMat(InventoryMaster.select(entity.getMat_code(), conn));
		conn.close();
	}
		
	public static void insert(PackageItem entity) throws IllegalAccessException, InvocationTargetException, SQLException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		entity.setRun(DBUtility.genNumberFromDB(conn, tableName, entity,new String[] {"pk_id"}, "run"));
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		
		/* update price to Package*/
		Package pk = new Package();
		pk.setPk_id(entity.getPk_id());
		pk.setCreate_by(entity.getCreate_by());
		pk.setPrice(calPrice(entity.getPk_id(), conn));
		Package.updatePrice(pk,conn);
		
		conn.close();
	}
	
	public static void update(PackageItem entity) throws IllegalAccessException, InvocationTargetException, SQLException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		
		/* update price to Package*/
		Package pk = new Package();
		pk.setPk_id(entity.getPk_id());
		pk.setUpdate_by(entity.getUpdate_by());
		pk.setPrice(calPrice(entity.getPk_id(), conn));
		Package.updatePrice(pk,conn);
		conn.close();
	}
	
	public static String calPrice(String pk_id, Connection conn) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE pk_id='" + pk_id + "'";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		String total = "0";
		while (rs.next()) {
			PackageItem entity = new PackageItem();
			DBUtility.bindResultSet(entity, rs);
			
			total = Money.add(total, Money.discount(Money.multiple(entity.getUnit_price(), entity.getQty()), entity.getDiscount()));
		}
		rs.close();
		st.close();
		return total;
	}
	
	public static void main(String[] a) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		//PackageItem.calPrice("5", conn);
		conn.close();
	}
	
	public static List<PackageItem> listByPk(String pk_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE pk_id='" + pk_id + "'";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PackageItem> list = new ArrayList<PackageItem>();
		while (rs.next()) {
			PackageItem entity = new PackageItem();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIMat(InventoryMaster.select(entity.getMat_code(), conn));
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	public static List<String[]> selectPackage(String pk_id) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT distinct(mat_code) as id FROM " + tableName + " WHERE pk_id = '" + pk_id + "'"; 
		SaleOrderItem entity = new SaleOrderItem();

		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<String[]> l = new ArrayList<String[]>();
		while(rs.next()){
			String id = DBUtility.getString("id", rs);
			entity.setUIMat(InventoryMaster.select(id, conn));
			String name = entity.getUIMat().getDescription();
			String[] vals = {id,name};
			l.add(vals);		
		}
		
		conn.close();
		return l;
	}
	public static List<PackageItem> listPackage(String pk_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT *,sum(qty) as sum_qty FROM " + tableName + " WHERE pk_id='" + pk_id + "' GROUP BY mat_code";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PackageItem> list = new ArrayList<PackageItem>();
		while (rs.next()) {
			PackageItem entity = new PackageItem();
			DBUtility.bindResultSet(entity, rs);
			entity.setUISumQty(DBUtility.getString("sum_qty", rs));
			entity.setUIMat(InventoryMaster.select(entity.getMat_code(), conn));
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<PackageItem> getOnePac(String pk_id,String mat_code) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT *,sum(qty) as sum_qty FROM " + tableName + " WHERE pk_id='" + pk_id + "' AND mat_code = '" + mat_code + "' GROUP BY mat_code";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PackageItem> list = new ArrayList<PackageItem>();
		while (rs.next()) {
			PackageItem entity = new PackageItem();
			DBUtility.bindResultSet(entity, rs);
			entity.setUISumQty(DBUtility.getString("sum_qty", rs));
			entity.setUIMat(InventoryMaster.select(entity.getMat_code(), conn));
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static PackageItem sumPackage(String pk_id,String mat_code) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT sum(qty) as sum_qty FROM " + tableName + " WHERE pk_id='" + pk_id + "' AND mat_code = '" + mat_code + "' GROUP BY mat_code";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		PackageItem entity = new PackageItem();
		while (rs.next()) {
			DBUtility.bindResultSet(entity, rs);
			entity.setUISumQty(DBUtility.getString("sum_qty", rs));
		}
		rs.close();
		st.close();
		conn.close();
		return entity;
	}
	
	public static List<PackageItem> listByPkandMat(String pk_id,String mat_code) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE pk_id='" + pk_id + "' AND mat_code = '" + mat_code;
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PackageItem> list = new ArrayList<PackageItem>();
		while (rs.next()) {
			PackageItem entity = new PackageItem();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIMat(InventoryMaster.select(entity.getMat_code(), conn));
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	
	public static void delete(PackageItem entity) throws IllegalAccessException, InvocationTargetException, SQLException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		// TODO ก่อนลบ เช็คก่อนว่ามีใครนำ package นี้ไปใช้แล้วรึยัง??? 	
		DBUtility.deleteFromDB(conn, tableName, entity, keys);	

		/* update price to Package*/
		Package pk = new Package();
		pk.setPk_id(entity.getPk_id());
		pk.setUpdate_by(entity.getUpdate_by());
		pk.setUpdate_date(entity.getUpdate_date());
		pk.setPrice(calPrice(entity.getPk_id(), conn));
		Package.updatePrice(pk,conn);
		conn.close();
	}

	
	public static HashMap<String, PackageItem> SumItem(String pk_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		List listPK = PackageItem.listByPk(pk_id);
		Iterator itePK = listPK.iterator();
		HashMap<String, PackageItem> map =new HashMap<String, PackageItem>();
		while (itePK.hasNext()){
			PackageItem item = (PackageItem) itePK.next();
			
			if (map.get(item.getMat_code())== null) {
				map.put(item.getMat_code(), item);
			} else {
				PackageItem mapItem = map.get(item.getMat_code());
				mapItem.setQty(Money.add(mapItem.getQty(), item.getQty()));
				map.put(item.getMat_code(), mapItem);
			}
			
		}
		
		conn.close();
		return map;
	}
	
	public static String SumItemByMat(String pk_id,String mat_code) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT sum(qty) FROM " + tableName + " WHERE pk_id='" + pk_id + "' AND mat_code = '" + mat_code;
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);		
		String qty = "";
		while (rs.next()) {
			qty = DBUtility.getString("qty", rs);		
		}
		rs.close();
		st.close();
		conn.close();
		return qty;
	}
	
	public static String countPkItem(String pk_id,Connection conn) throws SQLException{
		String sql = "SELECT count(distinct(mat_code)) as count FROM " + tableName + " WHERE pk_id = '" + pk_id + "'";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		String count = "";
		while (rs.next()) {
			count = DBUtility.getString("count", rs);
		}
		rs.close();
		st.close();
		return count;
	}
	/**
	 * Used : SalePrderItem.selectallitemByinvoice
	 * <br>
	 * sum price:unit from pk_id
	 * @param pk_id
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static String sumPriceFromPkid(String pk_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT sum(unit_price) as sum_qty FROM " + tableName + " WHERE pk_id='" + pk_id + "' AND discount != '100'";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		String sum = "0";
		while (rs.next()) {
			PackageItem entity = new PackageItem();
			DBUtility.bindResultSet(entity, rs);
			sum  = DBUtility.getString("sum_qty", rs);
		}
		rs.close();
		st.close();
		conn.close();
		return sum;
	}
	/**
	 * whan : Sale_order_item.report_fg
	 * <br>
	 * sum qty by matcode and pk_id then insert on hashmap
	 * @param pk_id
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static HashMap<String,MatTree> sumPackageBypkid(HashMap<String, MatTree> mat,String pk_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT mat_code,sum(qty) as sum_qty FROM " + tableName + " WHERE pk_id='" + pk_id + "' GROUP BY mat_code";
		System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			PackageItem entity = new PackageItem();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIMat(InventoryMaster.select(entity.getMat_code(), conn));
			
			MatTree tree = mat.get(entity.getMat_code());
			
			if (tree == null){
				tree = new MatTree();
				tree.setRef_code(entity.getUIMat().getRef_code());
				tree.setMat_code(entity.getMat_code());
				tree.setGroup_id(entity.getUIMat().getDes_unit());
				tree.setOrder_qty(DBUtility.getString("sum_qty", rs));
				tree.setDescription(entity.getUIMat().getDescription());
				mat.put(entity.getMat_code(), tree);
			}else{
				String qty = tree.getOrder_qty();
				tree.setOrder_qty(Money.add(qty,DBUtility.getString("sum_qty", rs)));
				mat.put(entity.getMat_code(), tree);
			}
		}
		rs.close();
		st.close();
		conn.close();
		return mat;
	}
	
	public static HashMap<String, PackageItem> SumItem_plan(String pk_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		List listPK = PackageItem.listByPk(pk_id);
		Iterator itePK = listPK.iterator();
		HashMap<String, PackageItem> map =new HashMap<String, PackageItem>();
		while (itePK.hasNext()){
			PackageItem item = (PackageItem) itePK.next();
			
			if (map.get(item.getMat_code())== null) {
				map.put(item.getMat_code(), item);
			} else {
				PackageItem mapItem = map.get(item.getMat_code());
				mapItem.setQty(Money.add(mapItem.getQty(), item.getQty()));
				map.put(item.getMat_code(), mapItem);
			}
			
		}
		
		conn.close();
		return map;
	}
}
