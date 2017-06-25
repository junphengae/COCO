package com.bitmap.bean.production;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import com.bitmap.bean.hr.Personal;
import com.bitmap.bean.inventory.InventoryLot;
import com.bitmap.bean.inventory.InventoryLotControl;
import com.bitmap.bean.inventory.InventoryMaster;
import com.bitmap.bean.rd.MatTree;
import com.bitmap.bean.rd.RDFormular;
import com.bitmap.bean.sale.Customer;
import com.bitmap.bean.sale.Package;
import com.bitmap.bean.sale.PackageItem;
import com.bitmap.bean.sale.SaleOrder;
import com.bitmap.bean.sale.SaleOrderItem;
import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.utils.Money;
import com.bitmap.webutils.PageControl;

public class Production {

	public static String tableName = "production";
	private static String[] keys = {"pro_id"};
	static String[] fieldNames = {"item_run","item_id","item_type","ref_pro","parent_id","item_qty","status","ref_stg_no","take","sent_id","fin_date","update_by","update_date"};
	
	public static String STATUS_PRODUCE = "10";
	public static String STATUS_NO_PRODUCE = "20";
	public static String STATUS_PREPARE = "30";
	public static String STATUS_OUTLET_PD = "35";
	public static String STATUS_FINNISH = "40";
	public static String STATUS_OUTLET = "50";
	public static String STATUS_MOVETO_STO = "60";
	
	String pro_id = "";
	String item_run = "";
	String item_id = "";
	String item_type = "";
	String ref_pro = "";
	String parent_id = "";
	String item_qty = "";
	String status = "";
	String ref_stg_no = "";
	String ref_sto_no = "";
	String take = "";
	//เก็บประเภทการผลิต 1.ผลิต 2.ไม่ผลิต
	String sent_id = "";
	Date fin_date = null;
	String create_by = "";
	Timestamp create_date = null;
	String update_by = "";
	Timestamp update_date = null;
	
	public static String status(String status){
		HashMap<String , String> map = new HashMap<String, String>();
		map.put("10", "สั่งผลิตแล้ว");
		map.put("20", "ไม่ต้องผลิต");
		map.put("30", "กำลังผลิต");
		map.put("35", "ผลิตเสร็จเรียบร้อย");
		map.put("40", "สินค้ามีในคงคลัง");
		map.put("50", "เบิกของแล้ว");
		map.put("60", "สร้างSTO");
		return map.get(status);
	}
	
	public static List<String[]> statusDropdown2(){
		List<String[]> list = new ArrayList<String[]>();		
		list.add(new String[]{"10", "สั่งผลิตแล้ว"});
		list.add(new String[]{"20", "ไม่ต้องผลิต"});
		list.add(new String[]{"30", "กำลังผลิต"});
		list.add(new String[]{"40", "สินค้ามีในคงคลัง"});
		return list;
	}
	
	InventoryMaster UIMat = new InventoryMaster();
	Package UIPac = null;
	RDFormular UIRd = new RDFormular();
	SaleOrderItem UIorder = new SaleOrderItem();
	Customer UICus = new Customer();
	SaleOrder UIor = new SaleOrder();
	Personal UIPer = new Personal();
	PackageItem UIpacItem = null;
	String UIOrderType = "";


	String UIcheck = new String();
	
	
	public String getUIOrderType() {
		return UIOrderType;
	}

	public void setUIOrderType(String uIOrderType) {
		UIOrderType = uIOrderType;
	}

	public String getParent_id() {
		return parent_id;
	}

	public void setParent_id(String parent_id) {
		this.parent_id = parent_id;
	}

	public String getUIcheck() {
		return UIcheck;
	}

	public void setUIcheck(String uIcheck) {
		UIcheck = uIcheck;
	}

	public PackageItem getUIpacItem() {
		return UIpacItem;
	}

	public void setUIpacItem(PackageItem uIpacItem) {
		UIpacItem = uIpacItem;
	}

	public String getSent_id() {
		return sent_id;
	}

	public void setSent_id(String sent_id) {
		this.sent_id = sent_id;
	}

	public Personal getUIPer() {
		return UIPer;
	}

	public void setUIPer(Personal uIPer) {
		UIPer = uIPer;
	}

	public SaleOrder getUIor() {
		return UIor;
	}

	public void setUIor(SaleOrder uIor) {
		UIor = uIor;
	}

	public SaleOrderItem getUIorder() {
		return UIorder;
	}

	public void setUIorder(SaleOrderItem uIorder) {
		UIorder = uIorder;
	}

	public RDFormular getUIRd() {
		return UIRd;
	}

	public void setUIRd(RDFormular uIRd) {
		UIRd = uIRd;
	}


	
	public static List<String[]> statusDropdown(){
		List<String[]> list = new ArrayList<String[]>();		
		list.add(new String[]{"10", "สั่งผลิตแล้ว"});
		list.add(new String[]{"20", "ไม่ต้องผลิต"});
		return list;
	}
	
	public Date getFin_date() {
		return fin_date;
	}

	public void setFin_date(Date fin_date) {
		this.fin_date = fin_date;
	}

	public String getTake() {
		return take;
	}

	public void setTake(String take) {
		this.take = take;
	}

	public String getRef_pro() {
		return ref_pro;
	}

	public void setRef_pro(String ref_pro) {
		this.ref_pro = ref_pro;
	}

	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public InventoryMaster getUIMat() {
		return UIMat;
	}
	public void setUIMat(InventoryMaster uIMat) {
		UIMat = uIMat;
	}
	public Package getUIPac() {
		return UIPac;
	}
	public void setUIPac(Package uIPac) {
		UIPac = uIPac;
	}
	public String getItem_run() {
		return item_run;
	}
	public void setItem_run(String item_run) {
		this.item_run = item_run;
	}
	public String getItem_type() {
		return item_type;
	}
	public void setItem_type(String item_type) {
		this.item_type = item_type;
	}
	public String getItem_qty() {
		return item_qty;
	}
	public void setItem_qty(String item_qty) {
		this.item_qty = item_qty;
	}
	public String getPro_id() {
		return pro_id;
	}
	public void setPro_id(String pro_id) {
		this.pro_id = pro_id;
	}
	public String getItem_id() {
		return item_id;
	}
	public void setItem_id(String item_id) {
		this.item_id = item_id;
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
	
	public Customer getUICus() {
		return UICus;
	}

	public void setUICus(Customer uICus) {
		UICus = uICus;
	}
	
	
	public String getRef_stg_no() {
		return ref_stg_no;
	}

	public void setRef_stg_no(String ref_stg_no) {
		this.ref_stg_no = ref_stg_no;
	}

	public String getRef_sto_no() {
		return ref_sto_no;
	}

	public void setRef_sto_no(String ref_sto_no) {
		this.ref_sto_no = ref_sto_no;
	}

	public static Production select(String pro_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{		
		Connection conn = DBPool.getConnection();
		Production entity = new Production();
		entity.setPro_id(pro_id);
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}
	
	public static List<Production> selectAllProduct(PageControl ctrl, List<String[]> paramList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT sale_customer.cus_name,sale_customer.cus_id,sale_order.create_by,production.*,sale_order_item.* FROM " + tableName + ",sale_customer,sale_order_item,sale_order WHERE sent_id != '' AND production.item_type = 'FG' and production.item_run = sale_order_item.item_run and sale_order_item.order_id = sale_order.order_id and sale_customer.cus_id = sale_order.cus_id ";
	
		Iterator<String[]> ite = paramList.iterator();
		boolean check = false;
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
					if(str[1].length() > 0 && str[0].equalsIgnoreCase("sent_id")){
						sql += " AND production." + str[0] + "='" + str[1] + "'";
						check =true;
					}
					if(check == false){
						sql += " AND sale_customer." + str[0] + "='" + str[1] + "'";
					}
			}	
		}
		sql += " ORDER BY (sent_id*1) ASC";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Production> list = new ArrayList<Production>();
		while (rs.next()) {
			
					Production entity = new Production();
					DBUtility.bindResultSet(entity, rs);			
					entity.setUIorder(SaleOrderItem.selectOrder(entity.getItem_run()));
					entity.setUIor(SaleOrder.selectByID(entity.getUIorder().getOrder_id()));
					entity.setUICus(Customer.select(entity.getUIor().getCus_id(), conn));
					entity.setUIPer(Personal.select(entity.getUIor().getCreate_by()));
					entity.setUIMat(InventoryMaster.select(entity.getItem_id(), conn));

					list.add(entity);
			}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<Production> selectByQid(PageControl ctrl, List<String[]> paramList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT distinct(sent_id),item_run FROM " + tableName + " WHERE status = " + Production.STATUS_FINNISH;
	
		Iterator<String[]> ite = paramList.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
						sql += " AND " + str[0] + "='" + str[1] + "'";
			}	
		}
		sql += " ORDER BY (sent_id*1) ASC";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Production> list = new ArrayList<Production>();
		while (rs.next()) {
					Production entity = new Production();
					DBUtility.bindResultSet(entity, rs);
					entity.setUIorder(SaleOrderItem.selectOrder(entity.getItem_run()));
					entity.setUIor(SaleOrder.selectByID(entity.getUIorder().getOrder_id()));
					entity.setUICus(Customer.select(entity.getUIor().getCus_id(), conn));				
					list.add(entity);
			}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	/**
	 * whan : plan_list_report
	 * <br>
	 * select รายการโปรดักชั่น
	 * @param ctrl
	 * @param paramList
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws ParseException
	 */
	public static List<Production> selectWithCTRL(PageControl ctrl, List<String[]> paramList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException, ParseException{
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1";
	
		Iterator<String[]> ite = paramList.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if(str[0].equalsIgnoreCase("create_date")){
					Date b = DBUtility.getDate(str[1]);
					
					SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
					
					String s = df.format(b);
					sql += " AND " + str[0] + " between '" + s + " 00:00:00.00' AND '" + s + " 23:59:59.99'";
					
				}else{
					sql += " AND " + str[0] + "='" + str[1] + "'";
				}
						
			}	
		}
		sql += " ORDER BY (pro_id*1) DESC";
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Production> list = new ArrayList<Production>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					Production entity = new Production();
					DBUtility.bindResultSet(entity, rs);
					
					entity.setUIorder(SaleOrderItem.selectOrder(entity.getItem_run()));
					if(entity.getItem_type().equalsIgnoreCase("PRO")){
						entity.setUIPac(Package.select(entity.getItem_id()));
					}else{
						entity.setUIMat(InventoryMaster.selectOnlyMat(entity.getItem_id()));
						//entity.setUIRd(RDFormular.selectByMatCode(entity.getItem_id()));
					}
					
					SaleOrder order = new SaleOrder();
					order.setOrder_id(entity.getUIorder().getOrder_id());
					SaleOrder.select(order);
					
					entity.setUIOrderType(order.getOrder_type());
					entity.setUIcheck(order.getCus_id());
					
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
	
	public static List<Production> sal_invoiceWithCTRL(PageControl ctrl, List<String[]> paramList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1 AND item_type = 'FG' AND status = '" + STATUS_PREPARE + "'";
	
		Iterator<String[]> ite = paramList.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
						sql += " AND " + str[0] + "='" + str[1] + "'";
			}	
		}
		sql += " ORDER BY (pro_id*1) ASC";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Production> list = new ArrayList<Production>();
		while (rs.next()) {
			Production entity = new Production();
			DBUtility.bindResultSet(entity, rs);
			
			entity.setUIorder(SaleOrderItem.selectOrder(entity.getItem_run()));
			if(entity.getItem_type().equalsIgnoreCase("PRO")){
			entity.setUIPac(Package.select(entity.getItem_id(), conn));
			}else{
			entity.setUIMat(InventoryMaster.select(entity.getItem_id(), conn));
			}
			
			entity.setUIor(SaleOrder.selectByID(entity.getUIorder().getOrder_id()));
			entity.setUICus(Customer.select(entity.getUIor().getCus_id(), conn));
			list.add(entity);
					
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<Production> selectByStatusPacked(PageControl ctrl, List<String[]> paramList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "select pd.* from production pd join production_staging pdstg on  pd.ref_stg_no = pdstg.stg_no where pdstg.status = 50 AND pd.status != 60 ";

		sql += " ORDER BY (pro_id*1) ASC";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Production> list = new ArrayList<Production>();
		while (rs.next()) {
			Production entity = new Production();
			DBUtility.bindResultSet(entity, rs);
			
			entity.setUIorder(SaleOrderItem.selectOrder(entity.getItem_run()));
			if(entity.getItem_type().equalsIgnoreCase("PRO")){
			entity.setUIPac(Package.select(entity.getItem_id(), conn));
			}else{
			entity.setUIMat(InventoryMaster.select(entity.getItem_id(), conn));
			}
			
			entity.setUIor(SaleOrder.selectByID(entity.getUIorder().getOrder_id()));
			entity.setUICus(Customer.select(entity.getUIor().getCus_id(), conn));
			list.add(entity);
					
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<Production> selectReport(PageControl ctrl, List<String[]> paramList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "select * from production,sale_order_item,sale_order,sale_customer where 1=1 AND production.status = 30 and production.item_type !='SS' and sale_order_item.item_run = production.item_run ";
		sql += " AND sale_order_item.order_id = sale_order.order_id and sale_customer.cus_id = sale_order.cus_id and production.item_type != 'PRO'";
		
		Iterator<String[]> ite = paramList.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
					sql += " AND sale_customer." + str[0] + "='" + str[1] + "'";
			}
		}
		sql += " ORDER BY (pro_id*1) ASC";
		//System.out.println(sql);
		
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Production> list = new ArrayList<Production>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					Production entity = new Production();
					DBUtility.bindResultSet(entity, rs);
					
					entity.setUIorder(SaleOrderItem.selectOrder(entity.getItem_run()));
					entity.setUIor(SaleOrder.selectByID(entity.getUIorder().getOrder_id()));
					entity.setUICus(Customer.select(entity.getUIor().getCus_id(), conn));
					entity.setUIPer(Personal.select(entity.getUIor().getCreate_by()));
					entity.setUIMat(InventoryMaster.select(entity.getItem_id(), conn));
					
					
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
	public static Production selectByProid(Production entity) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE pro_id ='" + entity.getPro_id() + "' AND item_id = '" + entity.getItem_id() + "'";
		//System.out.println(sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		while(rs.next()){
			DBUtility.bindResultSet(entity, rs);
			entity.setUIMat(InventoryMaster.select(entity.getItem_id(), conn));
			entity.setUIcheck("true");
		}	
		rs.close();
		st.close();
		conn.close();
		return entity;
	}
	
	public static Production selectByRefpro(Production entity) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE ref_pro ='" + entity.getPro_id() + "' AND item_id = '" + entity.getItem_id() + "'";
		//System.out.println(sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		while(rs.next()){
			DBUtility.bindResultSet(entity, rs);
		}	
		rs.close();
		st.close();
		conn.close();
		return entity;
	}
	
	public static String[] checkMatcodeNProid(String pro_id,String item_id,String group_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		//System.out.print("aaaaa");
		Connection conn = DBPool.getConnection();
		String sql = "";
		if(group_id.equalsIgnoreCase("SS")){
			sql = "SELECT * FROM " + tableName + " WHERE ref_pro ='" + pro_id + "' AND item_id = '" + item_id + "'";
		}else{
			sql = "SELECT sale_order_item.invoice,sale_order_item.temp_invoice FROM sale_order_item,production WHERE production.pro_id = '" + pro_id + "' AND production.item_id = '" + item_id + "' AND production.item_run = sale_order_item.item_run";
		}
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		String[] newss = new String[3];
		
		while(rs.next()){
			if(group_id.equalsIgnoreCase("FG")){
				newss[0] = DBUtility.getString("invoice", rs);
				newss[1] = DBUtility.getString("temp_invoice", rs);
			}
			newss[2] = "true";
		}	
		rs.close();
		st.close();
		conn.close();
		return newss;
	}
	
	public static boolean checkMatcodeNProid2(String pro_id,String item_id,String group_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		String sql = "";
		//เบิกออกถ้าเป็น ss ใช้ ref_id เป็น fg ใช้ pro_id
		if(group_id.equalsIgnoreCase("SS")){
			sql = "SELECT * FROM " + tableName + " WHERE  ref_pro = '" + pro_id + "' AND item_id = '" + item_id + "'";
		}else{
			sql = "SELECT * FROM " + tableName + " WHERE  pro_id = '" + pro_id + "' AND item_id = '" + item_id + "'";
		}
		
		System.out.println(sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		boolean check = false;
		while(rs.next()){
			check = true;
		}	
		rs.close();
		st.close();
		conn.close();
		return check;
	}

	public static boolean Pro_idAndMat_code(Production entity) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE pro_id ='" + entity.getPro_id() + "' and item_id = '" + entity.getItem_id() + "' and status = " + STATUS_PRODUCE;
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		boolean check = false;
		while(rs.next()){
			check = true;
			DBUtility.bindResultSet(entity, rs);
			entity.setUIMat(InventoryMaster.select(entity.getItem_id(), conn));
		}
		rs.close();
		st.close();
		conn.close();
		return check;
	}
	
	public static List<Production> selectList(String item_run,String item_id,String pro_id) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE item_run ='" + item_run + "' AND item_id = '" + item_id + "' AND pro_id = '" + pro_id + "'";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);

		//System.out.print(sql);
		List<Production> list = new ArrayList<Production>();
		while (rs.next()) {
			Production entity = new Production();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIMat(InventoryMaster.select(entity.getItem_id(), conn));
			entity.setUIRd(RDFormular.selectByMatCode(item_id, conn));
			
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
		
	}
	
	public static Production selectByitemrunNproid(String pro_id,String item_run,Connection conn) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE item_run ='" + item_run + "' and pro_id = '" + pro_id + "'";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);

		Production pro = new Production();
		while (rs.next()) {		
			DBUtility.bindResultSet(pro, rs);
		}
		rs.close();
		st.close();
		return pro;		
	}
	
	public static List<Production> selectList(String item_run) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE item_run ='" + item_run + "' ORDER BY (pro_id*1) ASC";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);

		List<Production> list = new ArrayList<Production>();
		while (rs.next()) {
			Production entity = new Production();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIMat(InventoryMaster.select(entity.getItem_id(), conn));

			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<Production> selectPK(String item_run) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE item_run ='" + item_run + "' AND item_type = 'PK' ORDER BY (pro_id*1) ASC";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);

		List<Production> list = new ArrayList<Production>();
		while (rs.next()) {
			Production entity = new Production();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIMat(InventoryMaster.select(entity.getItem_id(), conn));

			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static boolean checkItemtype(String item_run,int count,String item_type) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT count(item_run) AS cnt FROM " + tableName + " WHERE item_run ='" + item_run + "' AND item_type = '" + item_type + "'";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);

		//System.out.println(count +"_" + sql);
		boolean check = false;
		while (rs.next()){
			if(item_type == "SS"){
				if(DBUtility.getInteger("cnt", rs) == count){
					check = true;
				}
			}else if(count > 0 && item_type == "FG"){
				if(DBUtility.getInteger("cnt", rs) == count){
					check = true;
				}else{
					check = false;
				}	
			}else {
				if(DBUtility.getInteger("cnt", rs) == 0){
					check = false;
				}else{
					check = true;
				}				
			}			
		}	
		
		rs.close();
		st.close();
		conn.close();
		return check;
		
	}
	public static String checkItemPro(String item_run,String item_type,String mat_code) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT count(item_run) AS cnt FROM " + tableName + " WHERE item_run ='" + item_run + "' AND item_type = '" + item_type + "' AND parent_id = '" + mat_code + "'";
		//System.out.println(mat_code + "    " + sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		String count = "";
		while (rs.next()){
				count = DBUtility.getString("cnt", rs);

		}			

		rs.close();
		st.close();
		conn.close();
		return count;		
	}
	
	public static void main(String[] s) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		//checkstatus("3", conn);
		conn.close();
	}
	
	public static boolean selectSS(String item_run,String item_id,String parent_id) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE item_run ='" + item_run + "' AND item_id = '" + item_id + "' AND parent_id = '" + parent_id + "'";
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		boolean check = false;
		while (rs.next()) {
			check = true;
		}
		rs.close();
		st.close();
		conn.close();
		return check;
		
	}
	
	public static void updateRef_id(Production pro) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		String pro_id = pro.getPro_id();
		String update_by = pro.getCreate_by();
		String sql = "SELECT * FROM " + tableName + " WHERE item_run ='" + pro.getItem_run() + "' AND parent_id = '" + pro.getItem_id() + "'";
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			if(DBUtility.getString("ref_pro", rs).equalsIgnoreCase("")){
					pro.setPro_id(DBUtility.getString("pro_id", rs));
					pro.setRef_pro(pro_id);
					pro.setUpdate_by(update_by);
					Production.insertRef_id(pro);
			}
			
		}
		rs.close();
		st.close();
		conn.close();
	
	}
	
	public static void checkRef_id(Production pro) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
				if(!(pro.getParent_id().equalsIgnoreCase(pro.getItem_id()))){
					Production.updateRef_id(pro);	
				}
	}
	
	public static void insertPro(Production entity,PackageItem item) throws IllegalAccessException, InvocationTargetException, SQLException, IllegalArgumentException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();		

		String qty = PackageItem.SumItemByMat(item.getPk_id(),item.getMat_code());
				entity.setItem_type("FG");
				entity.setItem_id(item.getMat_code());
				entity.setItem_qty(Money.multiple(entity.getItem_qty(),qty));
				
				Production.insert(entity,conn);
		conn.close();
	}
	
	public static Production insert(Production pro,Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException, UnsupportedEncodingException{	
		pro.setPro_id(DBUtility.genNumber(conn, tableName, "pro_id"));
		String pro_id = pro.getPro_id();
		pro.setCreate_date(DBUtility.getDBCurrentDateTime());		
		DBUtility.insertToDB(conn, tableName, pro);
		Production.checkRef_id(pro);
		
		pro.setPro_id(pro_id);
		return pro;
	}
	
	public static void insertRef_id(Production pro) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();	
		pro.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, pro,new String[] {"ref_pro","update_date","update_by"},new String[] {"pro_id"});
		conn.close();
	}
	
	public static void OutletPD(Production pro,String qty) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		String update_by = pro.getUpdate_by();
		Production.selectByRefpro(pro);
		
		String lost95 = Money.divide(Money.multiple("95",pro.getItem_qty()),"100");
		
		if(DBUtility.getDouble(qty) >= DBUtility.getDouble(lost95)){
			pro.setStatus(Production.STATUS_OUTLET_PD);
			pro.setUpdate_date(DBUtility.getDBCurrentDateTime());
			pro.setUpdate_by(update_by);
			DBUtility.updateToDB(conn, tableName, pro,new String[] {"status","update_date","update_by"},new String[] {"ref_pro"});		
		}else{
			int val = InventoryLotControl.sumOutlet(pro.getRef_pro());
			
			if(val >= DBUtility.getDouble(lost95)){				
				pro.setStatus(Production.STATUS_OUTLET_PD);
				pro.setUpdate_date(DBUtility.getDBCurrentDateTime());
				pro.setUpdate_by(update_by);
				DBUtility.updateToDB(conn, tableName, pro,new String[] {"status","update_date","update_by"},new String[] {"ref_pro"});		
			}	
		}
		conn.close();
	}
	
	public static void OutletIV(Production pro,String qty) throws Exception{
		Connection conn = DBPool.getConnection();
		
			String update_by = pro.getUpdate_by();
			
			Production.selectByProid(pro);
			SaleOrderItem item = new SaleOrderItem();
			item = SaleOrderItem.selectOrder(pro.getItem_run());
			
			boolean test = false;
			
			//ถ้าเป็น promotion
			if(item.getItem_type().equalsIgnoreCase("p")){
					PackageItem pkitem = PackageItem.sumPackage(item.getItem_id(),pro.getItem_id());
					item.setItem_qty(pkitem.getUISumQty()); 			
			}
			//ถ้าเป็น FG
			if(DBUtility.getDouble(qty) >= DBUtility.getDouble(item.getItem_qty())){
				//System.out.println("receive more = " + qty);
				//System.out.println("want = " + item.getItem_qty());
				
				pro.setStatus(Production.STATUS_OUTLET);
				pro.setUpdate_date(DBUtility.getDBCurrentDateTime());
				pro.setUpdate_by(update_by);
				DBUtility.updateToDB(conn, tableName, pro,new String[] {"status","update_date","update_by"},new String[] {"pro_id"});	
				test = true;
			}else{
				int val = InventoryLotControl.sumOutlet(pro.getPro_id());
				
				if(val >= DBUtility.getDouble(item.getItem_qty())){
					//System.out.println("receive less = " + val);
					//System.out.println("want = " + item.getItem_qty());
					
					pro.setStatus(Production.STATUS_OUTLET);
					pro.setUpdate_date(DBUtility.getDBCurrentDateTime());
					pro.setUpdate_by(update_by);
					DBUtility.updateToDB(conn, tableName, pro,new String[] {"status","update_date","update_by"},new String[] {"pro_id"});	
					test = true;
				}
			}
			
			if(test == true){
				//promotion
				if(item.getItem_type().equalsIgnoreCase("p")){
					String check = countPDPro(item.getItem_run(),conn);
					String row = countAllPDPro(item.getItem_run(), conn);
					//System.out.println("check : " +check);
					//System.out.println("row : " + row);
					if(check.equalsIgnoreCase(row)){
						item.setStatus(SaleOrderItem.STATUS_OUTLET);
						item.setUpdate_by(update_by);
						SaleOrderItem.updateStatusByItemrun(item);
					}
				//fg	
				}else{
				//เปลี่ยน status = 80 by item_run
						item.setStatus(SaleOrderItem.STATUS_OUTLET);
						item.setUpdate_by(update_by);
						SaleOrderItem.updateStatusByItemrun(item);			
				}
				
				String check1 = SaleOrderItem.countItemrun(item.getOrder_id(),SaleOrderItem.STATUS_OUTLET, conn);
				String check2 = SaleOrderItem.countAllrun(item.getOrder_id(), conn);
				//System.out.println("check1 : " + check1);
				//System.out.println("check2 : " + check2);
				if(check1.equalsIgnoreCase(check2)){
					SaleOrder order = new SaleOrder();
					order.setOrder_id(item.getOrder_id());
					order.setStatus(SaleOrder.STATUS_OUTLET);
					order.setUpdate_by(update_by);
					SaleOrder.updateStatus(conn,order);		
				}
			}
		conn.close();
	}

	public static String countPDPro(String item_run,Connection conn) throws SQLException{
		String sql = "SELECT COUNT(pro_id) as count FROM " + tableName + " WHERE item_run = '" + item_run + "' AND item_type = 'FG' AND status = '" + Production.STATUS_OUTLET + "'";
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
	
	public static String countAllPDPro(String item_run,Connection conn) throws SQLException{
		String sql = "SELECT COUNT(pro_id) as count FROM " + tableName + " WHERE item_run = '" + item_run + "' AND item_type = 'FG'";
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
	
	public static String checkstatus(String pro_id,Connection conn) throws SQLException{
		String sql = "SELECT COUNT(pro_id) as count FROM " + tableName + " WHERE ref_pro = '" + pro_id + "' AND item_type='SS' AND status = '" + Production.STATUS_OUTLET_PD + "'";
		//System.out.println(sql);
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
	
	public static String checkstatus50ByOrderid(String order_id,String status,Connection conn) throws SQLException{
		String sql = "select COUNT(sale_order_item.item_run) as count from sale_order_item,production where order_id = '" + order_id + "' AND sale_order_item.item_run  = production.item_run  AND production.item_type = 'FG' AND " + tableName + ".status = '" + status + "'";
		System.out.println(sql);
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
	
	public static String checkAllstatusByOrderid(String order_id,Connection conn) throws SQLException{
		String sql = "select COUNT(sale_order_item.item_run) as count from sale_order_item,production where order_id = '" + order_id + "' AND sale_order_item.item_run  = production.item_run  AND production.item_type = 'FG'";
		System.out.println(sql);
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
	public static String checkAllstatus(String pro_id,Connection conn) throws SQLException{
		String sql = "SELECT COUNT(pro_id) as count FROM " + tableName + " WHERE ref_pro = '" + pro_id + "' AND item_type='SS'";
		//System.out.println(sql);
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
	
	public static void InletPD(Production pro,String qty) throws Exception{
		Connection conn = DBPool.getConnection();
		
		String update_by = pro.getUpdate_by();
		//System.out.println("AAAA" + update_by);
		Production.selectByProid(pro);
		
		//System.out.println(pro.getItem_id() +  " : " + pro.getPro_id() + " : " + pro.getUIcheck());
		if(pro.getUIcheck().equalsIgnoreCase("true")){
			SaleOrderItem item = new SaleOrderItem();
			item = SaleOrderItem.selectOrder(pro.getItem_run());
			
			//นับว่า ลูกของ ของ mat ตัวนี้ เบิกออกไปทำแล้วหรือยัง
			String count = checkstatus(pro.getPro_id(),conn);
			//นับลูกทั้งหมดที่มี ref_id เดียวกัน pro_id
			String count1 = checkAllstatus(pro.getPro_id(), conn);
			
			//ตอนนี้ให้ไม่ต้องสนใจ ss ให้รับ fg ได้เลย
			count = "1";
			count1 = "1";
			///////////////////////////
			if(count.equalsIgnoreCase(count1)){
				RDFormular rd = RDFormular.selectByMatCode(pro.getItem_id(), conn);
				String volumn = qty;
				
				// volumn * จำนวนที่รับเข้ามา  FG รับเป็นแพคเเกจ
				if(pro.getItem_type().equalsIgnoreCase("FG")){
					volumn = Money.multiple(rd.getVolume(), qty);
				}
				
				String lost95 = Money.divide(Money.multiple("90",pro.getItem_qty()),"100");
				//System.out.println("inlet:" + volumn);
				//System.out.println("less:" + lost95);
				
				//รับเข้าเช็คจาก ตาราง production
					if(DBUtility.getDouble(volumn) >= DBUtility.getDouble(lost95)){
						
						if(pro.getItem_type().equalsIgnoreCase("SS")){
							pro.setStatus(Production.STATUS_PREPARE);
						}else{
							pro.setStatus(Production.STATUS_FINNISH);
						}
						//System.out.println("inlet:" + volumn);
						//System.out.println("less:" + lost95);
						pro.setUpdate_date(DBUtility.getDBCurrentDateTime());
						pro.setUpdate_by(update_by);
						DBUtility.updateToDB(conn, tableName, pro,new String[] {"status","update_date","update_by"},new String[] {"pro_id"});		
					}else{
						String val = InventoryLot.sumInletString(pro.getPro_id(),pro.getItem_id());
						
						val = Money.multiple(val, rd.getVolume());
						
						//System.out.println("inlet:" + val);
						//System.out.println("less:" + lost95);
						if(DBUtility.getDouble(val) >= DBUtility.getDouble(lost95)){				
							if(pro.getItem_type().equalsIgnoreCase("SS")){
								pro.setStatus(Production.STATUS_PREPARE);
							}else{
								pro.setStatus(Production.STATUS_FINNISH);
							}
							pro.setUpdate_date(DBUtility.getDBCurrentDateTime());
							pro.setUpdate_by(update_by);
							DBUtility.updateToDB(conn, tableName, pro,new String[] {"status","update_date","update_by"},new String[] {"pro_id"});				
						}	
					}
					
					if(pro.getItem_type().equalsIgnoreCase("FG")){	
						//นับ FG ที่ status เป็น 40  และนับทั้งหมด
						String row = countFGStatus40(item.getItem_run(),Production.STATUS_FINNISH,conn);
						String count3 = countAllFG(item.getItem_run(), conn);
						
						SaleOrder order = new SaleOrder();
						order.setOrder_id(item.getOrder_id());
						SaleOrder.select(order, conn);
						
						if(row.equalsIgnoreCase(count3)){
							//เมิ้อ status เป็น 40 ทั้ง หมด จะเปลี่ยน SOI เป็น 72	
							pro.setUpdate_by(update_by);
							Production.updateALLPro(pro, conn);
							//System.out.println("if3" + update_by);
							item.setStatus(SaleOrderItem.STATUS_PRE_SEND);
							item.setUpdate_by(update_by);
							SaleOrderItem.updateStatusByInv(conn,item,"item_run");
								
						}
	
						row = SaleOrderItem.countItemrun(item.getOrder_id(),SaleOrderItem.STATUS_PRE_SEND, conn);
						count = SaleOrderItem.countAllrun(item.getOrder_id(), conn);
						//นับ soi ที่ status 72 และทั้งหมด เพื่อเปลี่ยน status order ใหญ่	
						if(row.equalsIgnoreCase(count)){
							if(order.getOrder_type().equalsIgnoreCase(SaleOrder.TYPE_BUFFER)){
								//เด๋วแก้บัพเฟอร์นะ
							//	item.setStatus(SaleOrderItem.STATUS_FIN);
								item.setUpdate_by(update_by);
								SaleOrderItem.updateStatusByInv(conn,item,"order_id");
								
							//	order.setStatus(SaleOrder.STATUS_FIN);
								order.setUpdate_by(update_by);
								SaleOrder.updateStatus(conn,order);
							}		
						}
					}
			}
		}
		conn.close();
	}
	
	public static String countStatus(String item_run,Connection conn) throws SQLException{
		String sql = "SELECT COUNT(status) as count FROM " + tableName + " WHERE status = '" + Production.STATUS_PREPARE + "' AND item_run = '" + item_run + "' AND item_type != 'PRO'";
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

	public static String count(String item_run,Connection conn) throws SQLException{
		String sql = "SELECT COUNT(pro_id) as count FROM " + tableName + " WHERE item_run = '" + item_run + "' AND item_type != 'PRO'";
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
	
	public static String countFGStatus40(String item_run,String status,Connection conn) throws SQLException{
		String sql = "SELECT COUNT(pro_id) as count FROM " + tableName + " WHERE item_run = '" + item_run + "' AND item_type = 'FG' AND status = '" + status + "'";
		System.out.println(sql);
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
	
	public static String countAllFG(String item_run,Connection conn) throws SQLException{
		String sql = "SELECT COUNT(pro_id) as count FROM " + tableName + " WHERE item_run = '" + item_run + "' AND item_type = 'FG'";
		System.out.println(sql);
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
	
	public static String countFG(String item_run,Connection conn) throws SQLException{
		String sql = "SELECT COUNT(pro_id) as count FROM " + tableName + " WHERE item_run = '" + item_run + "' AND item_type = 'FG'";
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
	
	public static void update_q(Production pro) throws IllegalAccessException, InvocationTargetException, SQLException{	
		Connection conn = DBPool.getConnection();
		pro.setStatus(Production.STATUS_OUTLET);
		pro.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName,pro,new String[] {"status","update_date","update_by"},new String[] {"send_id"});
		conn.close();
	}

	public static void updateStatus(Production pro) throws IllegalAccessException, InvocationTargetException, SQLException{	
		Connection conn = DBPool.getConnection();
		pro.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName,pro,new String[] {"status","update_date","update_by"},new String[] {"pro_id"});
		conn.close();
	}
	
	public static void updateALLPro(Production pro,Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException, UnsupportedEncodingException{	
		pro.setStatus(STATUS_FINNISH);
		pro.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName,pro,new String[] {"status","update_date","update_by"},new String[] {"item_run"});		
	}
	
	public static void updateProdToStaging(Production pro,Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException, UnsupportedEncodingException{	
		
		pro.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName,pro,new String[] {"status","ref_stg_no","update_date","update_by"},new String[] {"pro_id"});		
	}
	
	public static void updateProdToSTO(Production pro,Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException, UnsupportedEncodingException{	
		
		pro.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName,pro,new String[] {"status","ref_sto_no","update_date","update_by"},new String[] {"pro_id"});		
	}
	
	public static String countStatus40(String item_run,String status,Connection conn) throws SQLException{
		String sql = "SELECT COUNT(pro_id) as count FROM " + tableName + " WHERE item_run = '" + item_run + "' AND status = '" + status + "'";
		//System.out.println(sql);
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
	
	public static String countAllPD(String item_run,Connection conn) throws SQLException{
		String sql = "SELECT COUNT(pro_id) as count FROM " + tableName + " WHERE item_run = '" + item_run + "'";
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
	 * whan : plan_ap_fg
	 * <br> 
	 * เช็คว่ามี item และ item_id ไหม
	 * @param item_run
	 * @param conn
	 * @return
	 * @throws SQLException
	 */
	public static boolean checkItemrunAndItemid(String item_run,String item_id) throws SQLException{
		String sql = "SELECT * FROM " + tableName + " WHERE item_run = '" + item_run + "' AND item_id = '" + item_id + "'";
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
 		ResultSet rs = st.executeQuery(sql);
		boolean count = false;
		if(rs.next()) {
			count = true;
		}
		rs.close();
		st.close();
		return count;
	}
	/**
	 * whan : plan_change_status
	 * <br>
	 * update เวลากดสั่งผลิต เป็น ไม่ผลิต บราๆ
	 * @param pro
	 * @throws SQLException
	 * @throws UnsupportedEncodingException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static void update_plan(Production pro) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();	
		pro.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, pro,new String[] {"take","status","item_qty","sent_id","fin_date","update_date","update_by"},keys);
		conn.close();
	}
	
	public static List<Production> report_pd() throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException, ParseException{
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1";
		sql += " ORDER BY (pro_id*1) DESC";
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Production> list = new ArrayList<Production>();
		while (rs.next()) {
					Production entity = new Production();
					DBUtility.bindResultSet(entity, rs);
					
					entity.setUIorder(SaleOrderItem.selectOrder(entity.getItem_run()));
					if(entity.getItem_type().equalsIgnoreCase("PRO")){
						entity.setUIPac(Package.select(entity.getItem_id()));
					}else{
						entity.setUIMat(InventoryMaster.selectOnlyMat(entity.getItem_id()));
					}
					
					SaleOrder order = new SaleOrder();
					order.setOrder_id(entity.getUIorder().getOrder_id());
					SaleOrder.select(order);					
					entity.setUIOrderType(order.getOrder_type());
					entity.setUIcheck(order.getCus_id());				
					list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	/**
	 * whan : dashboard
	 * <br>
	 * count status ของ Production
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static HashMap<String, MatTree> sumStatus() throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT status,COUNT(pro_id) as count FROM " + tableName + " WHERE item_type != 'PRO' GROUP BY status ORDER BY (status*1) ASC";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		HashMap<String, MatTree> mat = new HashMap<String, MatTree>();
		while (rs.next()) {
			MatTree tree = mat.get(DBUtility.getString("status", rs));
			tree = new MatTree();
			tree.setGroup_id(Production.status(DBUtility.getString("status", rs)));
			tree.setDescription(DBUtility.getString("count", rs));
			mat.put(DBUtility.getString("status", rs), tree);		
		}
		rs.close();
		st.close();
		conn.close();
		return mat;
	}
	
}
