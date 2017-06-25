package com.bitmap.bean.rd;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Array;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import com.bitmap.bean.inventory.InventoryMaster;
import com.bitmap.bean.logistic.ProduceItemMat;
import com.bitmap.bean.production.Production;
import com.bitmap.bean.sale.Customer;
import com.bitmap.bean.sale.SaleOrderItemMat;
import com.bitmap.bean.util.StatusUtil;
import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.utils.Money;

public class RDFormular {
	public static String tableName = "rd_formular" ;
	public static String[] keys = {"mat_code"} ;
	
	public static String[] fieldNames = {"ref_no", "volume", "yield", "cus_id", "colour_tone", "colour_tone_detail", "date_matching", "remark", "status", "update_by","update_date"}; 	
	
	private String mat_code = "";
	private String request_no = "";
	private String ref_no = "";
	private String volume = "";
	private String cus_id = "";
	private String yield = "0";
	private String colour_tone = "";
	private String colour_tone_detail = "";
	private Date date_matching = null;
	private String remark = "";
	private String create_by = "";
	private Timestamp create_date = null;
	private String check_by = "";
	private Timestamp check_date = null;
	private String approve_by = "";
	private Timestamp approve_date = null;
	private String update_by = "";
	private Timestamp update_date = null;
	private String status = "";
	
	private InventoryMaster UIMat = new InventoryMaster();
	public InventoryMaster getUIMat() {return UIMat;}
	public void setUIMat(InventoryMaster uIMat) {UIMat = uIMat;}
	
	private RDFormularInfo UIInfo = new RDFormularInfo();
	public RDFormularInfo getUIInfo() {return UIInfo;}
	public void setUIInfo(RDFormularInfo uIInfo) {UIInfo = uIInfo;}
	
	private List<RDFormularStep> UIStep = new ArrayList<RDFormularStep>();
	public List<RDFormularStep> getUIStep() {return UIStep;}
	public void setUIStep(List<RDFormularStep> uIStep) {UIStep = uIStep;}
	
	private Customer UICustomer = new Customer();
	public Customer getUICustomer() {return UICustomer;}
	public void setUICustomer(Customer uICustomer) {UICustomer = uICustomer;}
	/**
	 * 
	 * @param mat_code
	 * @return
	 * @throws IllegalArgumentException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws UnsupportedEncodingException 
	 */
	public static RDFormular selectByMatCode(String mat_code) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		RDFormular entity = new RDFormular();
		entity.setMat_code(mat_code);
		select(entity);
		return entity;
	}
	
	public static RDFormular selectByMatCode(String mat_code, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		RDFormular entity = new RDFormular();
		entity.setMat_code(mat_code);
		select(entity, conn);
		return entity;
	}
	
	/**
	 * 
	 * @param entity
	 * @return boolean
	 * @throws IllegalArgumentException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws UnsupportedEncodingException 
	 */
	public static boolean select(RDFormular entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		boolean has = DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"mat_code"});
		entity.setUIInfo(RDFormularInfo.select(entity.getMat_code(),conn));
		entity.setUIMat(InventoryMaster.select(entity.getMat_code(),conn));
		entity.setUIStep(RDFormularStep.selectList(entity.getMat_code(),conn));
		entity.setUICustomer(Customer.select(entity.getCus_id(), conn));
		conn.close();
		return has;
	}
	
	public static boolean select(RDFormular entity, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		boolean has = DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"mat_code"});
		
		Connection conn1 = DBPool.getConnection();
		entity.setUIInfo(RDFormularInfo.select(entity.getMat_code(),conn1));
		entity.setUIMat(InventoryMaster.select(entity.getMat_code(),conn1));
		entity.setUIStep(RDFormularStep.selectList(entity.getMat_code(),conn1));
		conn1.close();
		return has;
	}
	
	public static void insert(RDFormular entity,InventoryMaster master) throws SQLException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		InventoryMaster.insert4RD(master, conn);
		entity.setMat_code(master.getMat_code());
		entity.setStatus(StatusUtil.RD_CREATE);
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		RDFormularInfo.insert(entity.getMat_code(), conn);
		conn.close();
	}
	
	public static String clone(InventoryMaster master) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		String old_mat_code = master.getMat_code();
		String create_by = master.getCreate_by();
		String desc = master.getDescription();
				
		Connection conn = DBPool.getConnection();
		
		// Clone Master
		String mat_code = InventoryMaster.clone(old_mat_code, desc, create_by, conn);
		
		// Clone RDFormular
		RDFormular formular = selectByMatCode(old_mat_code, conn);
		formular.setMat_code(mat_code);
		formular.setCreate_by(create_by);
		formular.setStatus(StatusUtil.RD_CREATE);
		formular.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, formular);
		
		// Clone RDFormularInfo
		RDFormularInfo.clone(old_mat_code, mat_code, conn);
		
		// Clone RDFormularStep
		RDFormularStep.clone(old_mat_code, mat_code, create_by, conn);
		
		conn.close();
		
		return mat_code;
	}
	
	public static void update(RDFormular entity, InventoryMaster master) throws SQLException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		InventoryMaster.update4RD(master,conn);
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());		
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		conn.close();				
	}
	
	public static void updateStatus(RDFormular entity, String status) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setStatus(status);
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());		
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"status", "update_by","update_date"}, keys);
		conn.close();
	}
		
	public static void ObjectTree(String yeild, RDFormular formular, HashMap<String, MatTree> matMap,HashMap<String, MatTree> pkMap, List<MatTree> ssList) throws IllegalArgumentException, UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		Iterator iteStep = formular.getUIStep().iterator();
		while(iteStep.hasNext()){
			RDFormularStep step = (RDFormularStep) iteStep.next();
			
			Iterator iteMat = step.getUIDetail().iterator();
			while(iteMat.hasNext()){
				RDFormularDetail detail = (RDFormularDetail) iteMat.next();
				InventoryMaster master = detail.getUIMat();

				if (master.getGroup_id().equalsIgnoreCase("MT")){
					MatTree tree = matMap.get(master.getMat_code());
				
					if (tree == null){
						tree = new MatTree();
						tree.setMat_code(master.getMat_code());
						tree.setGroup_id(master.getGroup_id());
						tree.setInv_qty(master.getBalance());
						tree.setOrder_qty(detail.getQty());
						tree.setRequest_qty(Money.divide(Money.multiple(tree.getOrder_qty(),yeild),"100"));
						tree.setDescription(master.getDescription());
						tree.setPlan_qty(SaleOrderItemMat.selectSum(master.getMat_code()));
						matMap.put(master.getMat_code(), tree);
					} else {
						String qty = tree.getOrder_qty();
						tree.setOrder_qty(Money.add(qty, detail.getQty()));
						tree.setRequest_qty(Money.divide(Money.multiple(tree.getOrder_qty(),yeild),"100"));
						matMap.put(master.getMat_code(), tree);
						
					}
				} else if (master.getGroup_id().equalsIgnoreCase("SS")) {
					HashMap<String, MatTree> mat = new HashMap<String, MatTree>();
					MatTree tree = matMap.get(master.getMat_code());
					
					if(tree == null){
					tree = new MatTree();
					tree.setMat_code(master.getMat_code());
					tree.setGroup_id(master.getGroup_id());
					tree.setInv_qty(master.getBalance());
					tree.setOrder_qty(detail.getQty());
					tree.setRequest_qty(Money.divide(Money.multiple(tree.getOrder_qty(),yeild),"100"));
					tree.setDescription(master.getDescription());
					tree.setPlan_qty(SaleOrderItemMat.selectSum(master.getMat_code()));
					
					matMap.put(master.getMat_code(), tree);
					//System.out.println("1." + tree.getMat_code()+ "-" + tree.getRequest_qty());
					RDFormular fml = new RDFormular();
					fml.setMat_code(master.getMat_code());
					RDFormular.select(fml);
					
					matList(tree.getRequest_qty(), fml, tree,mat);	
					ssList.add(tree);
					}else{
						String qty = tree.getRequest_qty();
						String request =  Money.divide(Money.multiple(detail.getQty(),yeild),"100");
						tree.setRequest_qty(Money.add(qty,request));
						
						matMap.put(master.getMat_code(), tree);
						RDFormular fml = new RDFormular();
						fml.setMat_code(master.getMat_code());
						RDFormular.select(fml);
							
						matList(tree.getRequest_qty(), fml, tree,mat);
						//ssList.add(tree);
					}
				} else if (master.getGroup_id().equalsIgnoreCase("PK")) {
					MatTree tree = pkMap.get(master.getMat_code());
					
					if (tree == null){
						tree = new MatTree();
						tree.setMat_code(master.getMat_code());
						tree.setGroup_id(master.getGroup_id());
						tree.setInv_qty(master.getBalance());
						tree.setOrder_qty(detail.getUsage_());
						tree.setDescription(master.getDescription());
						tree.setPlan_qty(SaleOrderItemMat.selectSum(master.getMat_code()));
						
						pkMap.put(master.getMat_code(), tree);
					} else {
						String qty = tree.getOrder_qty();
						tree.setOrder_qty(Money.add(qty, detail.getUsage_()));
						pkMap.put(master.getMat_code(), tree);
					}
				}
			}
		}
	}

	public static void SelectSS(RDFormular formular,List<MatTree> ssList) throws IllegalArgumentException, UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		Iterator iteStep = formular.getUIStep().iterator();
		while(iteStep.hasNext()){
			RDFormularStep step = (RDFormularStep) iteStep.next();
			
			Iterator iteMat = step.getUIDetail().iterator();
			while(iteMat.hasNext()){
				RDFormularDetail detail = (RDFormularDetail) iteMat.next();
				InventoryMaster master = detail.getUIMat();
				
				if (master.getGroup_id().equalsIgnoreCase("SS")) {
					MatTree tree = new MatTree();
					
					tree.setMat_code(master.getMat_code());
					tree.setGroup_id(master.getGroup_id());

					RDFormular fml = new RDFormular();
					fml.setMat_code(master.getMat_code());
					RDFormular.select(fml);
					
					matListSS(fml, tree);
					
					ssList.add(tree);
				}
			}
		}
	}
	
	public static void matListSS(RDFormular fml, MatTree tree) throws SQLException{
		List<MatTree> list = tree.getMat();
		Iterator iteStep = fml.getUIStep().iterator();
		while(iteStep.hasNext()){
			RDFormularStep step = (RDFormularStep) iteStep.next();
			Iterator iteMat = step.getUIDetail().iterator();
			while(iteMat.hasNext()){
				
				RDFormularDetail detail = (RDFormularDetail) iteMat.next();
				InventoryMaster master = detail.getUIMat();
				if (master.getGroup_id().equalsIgnoreCase("SS")) {
					MatTree tree2 = new MatTree();				
					tree2.setMat_code(master.getMat_code());
					tree2.setGroup_id(master.getGroup_id());
					
					RDFormular fml2 = new RDFormular();
					fml2.setMat_code(master.getMat_code());
					
					matListSS(fml2, tree2);
					list.add(tree2);
				}
			}
		}
	}
	
	public static void matList(String volume, RDFormular fml, MatTree tree,HashMap<String, MatTree> mat) throws SQLException{
		List<MatTree> list = tree.getMat();
		Iterator iteStep = fml.getUIStep().iterator();
		while(iteStep.hasNext()){
			RDFormularStep step = (RDFormularStep) iteStep.next();
			Iterator iteMat = step.getUIDetail().iterator();
			while(iteMat.hasNext()){
				
				RDFormularDetail detail = (RDFormularDetail) iteMat.next();
				InventoryMaster master = detail.getUIMat();
				
				if (master.getGroup_id().equalsIgnoreCase("MT")){
					MatTree tree2 = mat.get(master.getMat_code());
					if(tree2 == null){
						tree2 = new MatTree();
						tree2.setMat_code(master.getMat_code());
						tree2.setGroup_id(master.getGroup_id());
						tree2.setInv_qty(master.getBalance());
						tree2.setOrder_qty(detail.getQty());
						tree2.setRequest_qty(Money.divide(Money.multiple(tree2.getOrder_qty(),volume),"100"));
						tree2.setDescription(master.getDescription());
						tree2.setPlan_qty(SaleOrderItemMat.selectSum(master.getMat_code()));
						
						mat.put(master.getMat_code(), tree2);
						list.add(tree2);
					}else{
						String qty = tree2.getOrder_qty();
						tree.setOrder_qty(Money.add(qty, detail.getQty()));
						tree.setRequest_qty(Money.divide(Money.multiple(tree2.getOrder_qty(),volume),"100"));
						mat.put(master.getMat_code(), tree2);
						
					}
				} else if (master.getGroup_id().equalsIgnoreCase("SS")) {
					
					MatTree tree2 = new MatTree();
					
					tree2.setMat_code(master.getMat_code());
					tree2.setGroup_id(master.getGroup_id());
					tree2.setInv_qty(master.getBalance());
					tree2.setOrder_qty(detail.getQty());
					tree2.setRequest_qty(Money.divide(Money.multiple(tree2.getOrder_qty(),volume),"100"));
					tree2.setDescription(master.getDescription());
					tree2.setPlan_qty(SaleOrderItemMat.selectSum(master.getMat_code()));
					
					RDFormular fml2 = new RDFormular();
					fml2.setMat_code(master.getMat_code());
					
					list.add(tree2);
				}
			}
		}
	}
	
	public static void MatTree(RDFormular formular, HashMap<String, MatTree> matMap,HashMap<String, MatTree> pkMap) throws IllegalArgumentException, UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		Iterator iteStep = formular.getUIStep().iterator();
		while(iteStep.hasNext()){
			RDFormularStep step = (RDFormularStep) iteStep.next();
			
			Iterator iteMat = step.getUIDetail().iterator();
			while(iteMat.hasNext()){
				RDFormularDetail detail = (RDFormularDetail) iteMat.next();
				InventoryMaster master = detail.getUIMat();
				
				if (master.getGroup_id().equalsIgnoreCase("MT")){
					MatTree tree = matMap.get(master.getMat_code());
					if (tree == null){
						tree = new MatTree();
						tree.setMat_code(master.getMat_code());
						tree.setGroup_id(master.getGroup_id());
						tree.setInv_qty(master.getBalance());
						tree.setOrder_qty(detail.getQty());
						tree.setDescription(master.getDescription());
						tree.setPlan_qty(SaleOrderItemMat.selectSum(master.getMat_code()));
						
						matMap.put(master.getMat_code(), tree);
					} else {
						String qty = tree.getOrder_qty();
						tree.setOrder_qty(Money.add(qty, detail.getQty()));
						matMap.put(master.getMat_code(), tree);			
					}				
				} else if (master.getGroup_id().equalsIgnoreCase("SS")) {
					RDFormular fss = new RDFormular();
					fss.setMat_code(master.getMat_code());
					RDFormular.select(fss);
					MatTree(fss, matMap ,pkMap);
				} else if (master.getGroup_id().equalsIgnoreCase("PK")) {
					MatTree tree = pkMap.get(master.getMat_code());
					
					if (tree == null){
						tree = new MatTree();
						tree.setMat_code(master.getMat_code());
						tree.setGroup_id(master.getGroup_id());
						tree.setInv_qty(master.getBalance());
						tree.setOrder_qty(detail.getUsage_());
						tree.setDescription(master.getDescription());
						tree.setPlan_qty(SaleOrderItemMat.selectSum(master.getMat_code()));
						
						pkMap.put(master.getMat_code(), tree);
					} else {
						String qty = tree.getOrder_qty();
						tree.setOrder_qty(Money.add(qty, detail.getUsage_()));
						pkMap.put(master.getMat_code(), tree);
					}
				}
			}
		}
	}
		
	public static void selectFgAndPk(HashMap<String, MatTree> matMap,String mat_code,String item_run,String type,String item_qty) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		RDFormular formular = new RDFormular();
		formular.setMat_code(mat_code);
		RDFormular.select(formular);
		
		Iterator iteStep = formular.getUIStep().iterator();
		while(iteStep.hasNext()){
			RDFormularStep step = (RDFormularStep) iteStep.next();
			Iterator iteMat = step.getUIDetail().iterator();
			
			while(iteMat.hasNext()){
				RDFormularDetail detail = (RDFormularDetail) iteMat.next();
				InventoryMaster master = detail.getUIMat();

				String volume = item_qty;			
				if (master.getGroup_id().equalsIgnoreCase("MT")){
					MatTree tree = matMap.get(master.getMat_code());
					if (tree == null){
						tree = new MatTree();
						tree.setRef_code(master.getRef_code());
						tree.setMat_code(master.getMat_code());
						tree.setGroup_id(master.getGroup_id());
						tree.setOrder_qty(Money.divide(Money.multiple(detail.getQty(),volume),"100"));
						tree.setDescription(master.getDescription());
						matMap.put(master.getMat_code(), tree);

					}
				} else if(master.getGroup_id().equalsIgnoreCase("PK")){
						MatTree tree = matMap.get(master.getMat_code());
					
						tree = new MatTree();
						tree.setRef_code(master.getRef_code());
						tree.setMat_code(master.getMat_code());
						tree.setGroup_id(master.getGroup_id());
						tree.setOrder_qty(Money.divide(item_qty,formular.getVolume()));
						tree.setDescription(master.getDescription());
						
						matMap.put(master.getMat_code(), tree);
				}
			}
		}
	}
		
	public static void keepMatProduce(String pro_id,String mat_code,String item_qty,String status) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		HashMap<String, MatTree> matMap = new HashMap<String, MatTree>();
		RDFormular formular = new RDFormular();

		formular.setMat_code(mat_code);
		RDFormular.select(formular);
		
		Iterator iteStep = formular.getUIStep().iterator();
		while(iteStep.hasNext()){
			RDFormularStep step = (RDFormularStep) iteStep.next();
			Iterator iteMat = step.getUIDetail().iterator();
			
			while(iteMat.hasNext()){
				RDFormularDetail detail = (RDFormularDetail) iteMat.next();
				InventoryMaster master = detail.getUIMat();

				String volume = item_qty;	
				MatTree tree = matMap.get(master.getMat_code());			
				tree = new MatTree();
				tree.setMat_code(master.getMat_code());
				tree.setGroup_id(master.getGroup_id());
						
				if(master.getGroup_id().equalsIgnoreCase("PK")){
					Production pro =  Production.select(pro_id);
					tree.setOrder_qty(pro.getTake());
				}else{
					tree.setOrder_qty(Money.divide(Money.multiple(detail.getQty(),volume),"100"));
				}
				matMap.put(master.getMat_code(), tree);
				ProduceItemMat.insert(tree,pro_id,volume,status);
			}
		}
	}
	
	/**
	 * whan : 
	 * <br> plan_produce for fg(ขายปกติ)
	 * @param pro_id
	 * @param mat_code
	 * @param item_qty
	 * @param status
	 * @param choose
	 * @throws SQLException
	 * @throws UnsupportedEncodingException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static void keepMatProduce(String pro_id,String mat_code,String item_qty,String status,String[] myList) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		HashMap<String, MatTree> matMap = new HashMap<String, MatTree>();
		RDFormular formular = new RDFormular();

		formular.setMat_code(mat_code);
		RDFormular.select(formular);
		
		Iterator iteStep = formular.getUIStep().iterator();
		while(iteStep.hasNext()){
			RDFormularStep step = (RDFormularStep) iteStep.next();
			Iterator iteMat = step.getUIDetail().iterator();
			
			while(iteMat.hasNext()){
				RDFormularDetail detail = (RDFormularDetail) iteMat.next();
				InventoryMaster master = detail.getUIMat();

				String volume = item_qty;	
				MatTree tree = matMap.get(master.getMat_code());			
				tree = new MatTree();
				tree.setMat_code(master.getMat_code());
				tree.setGroup_id(master.getGroup_id());
						
				if(master.getGroup_id().equalsIgnoreCase("PK")){
					for (int i = 0; i < myList.length; i++) {
						String[] a = myList[i].split("_");
						if(a[0].equalsIgnoreCase(tree.getMat_code())){
							tree.setOrder_qty(a[1]);
						}
					}
				}else{
					tree.setOrder_qty(Money.divide(Money.multiple(detail.getQty(),volume),"100"));
				}
				matMap.put(master.getMat_code(), tree);
				ProduceItemMat.insert(tree,pro_id,volume,status);
			}
		}
	}
	
	public static String pkValue(String val ){
		String[] v = val.split("\\.");
		int i = DBUtility.getInteger(v[0]);
		if(v.length > 1){
			int j = DBUtility.getInteger(v[1]);	
			if (j > 0) {
				i++;
			}	
		}
		return i +"";
	}

	public static HashMap<String,MatTree> sumMatcode(List<MatTree> ssList) throws IllegalArgumentException, UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		Iterator ite = ssList.iterator();
		HashMap<String, MatTree> matMap = new HashMap<String, MatTree>();
		while(ite.hasNext()){
			MatTree master = (MatTree) ite.next();
			MatTree tree = matMap.get(master.getMat_code());
				if (tree == null){
					tree = new MatTree();
					tree.setMat_code(master.getMat_code());
					tree.setGroup_id(master.getGroup_id());
					tree.setInv_qty(master.getInv_qty());
					tree.setRequest_qty(master.getRequest_qty());
					tree.setDescription(master.getDescription());
					tree.setPlan_qty(master.getPlan_qty());
					
					matMap.put(master.getMat_code(), tree);
					//System.out.println(tree.getMat_code() +"__" + tree.getRequest_qty());
				} else {
					String qty = master.getRequest_qty();
					tree.setRequest_qty(Money.add(qty,tree.getRequest_qty()));
					matMap.put(master.getMat_code(), tree);		
					//System.out.println(tree.getMat_code() +"__" + tree.getRequest_qty());
				}	
		}
		return matMap; 
	}
		
	public static void main(String[] s){
	//	String i = pkValue("25.00");
	//	System.out.print(i);
	}

	public String getMat_code() {
		return mat_code;
	}
	public void setMat_code(String mat_code) {
		this.mat_code = mat_code;
	}
	public String getRequest_no() {
		return request_no;
	}
	public void setRequest_no(String request_no) {
		this.request_no = request_no;
	}
	public String getRef_no() {
		return ref_no;
	}
	public void setRef_no(String ref_no) {
		this.ref_no = ref_no;
	}
	public String getVolume() {
		return volume;
	}
	public void setVolume(String volume) {
		this.volume = volume;
	}
	public String getYield() {
		return yield;
	}
	public void setYield(String yield) {
		this.yield = yield;
	}
	public String getColour_tone() {
		return colour_tone;
	}
	public void setColour_tone(String colour_tone) {
		this.colour_tone = colour_tone;
	}
	public String getColour_tone_detail() {
		return colour_tone_detail;
	}
	public void setColour_tone_detail(String colour_tone_detail) {
		this.colour_tone_detail = colour_tone_detail;
	}
	public Date getDate_matching() {
		return date_matching;
	}
	public void setDate_matching(Date date_matching) {
		this.date_matching = date_matching;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
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
	public String getCheck_by() {
		return check_by;
	}
	public void setCheck_by(String check_by) {
		this.check_by = check_by;
	}
	public Timestamp getCheck_date() {
		return check_date;
	}
	public void setCheck_date(Timestamp check_date) {
		this.check_date = check_date;
	}
	public String getApprove_by() {
		return approve_by;
	}
	public void setApprove_by(String approve_by) {
		this.approve_by = approve_by;
	}
	public Timestamp getApprove_date() {
		return approve_date;
	}
	public void setApprove_date(Timestamp approve_date) {
		this.approve_date = approve_date;
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
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getCus_id() {
		return cus_id;
	}
	public void setCus_id(String cus_id) {
		this.cus_id = cus_id;
	}
}