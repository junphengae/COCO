package com.bitmap.security;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import com.bitmap.dbconnection.mysql.vbi.*;
import com.bitmap.bean.hr.Personal;

public class SecurityProfile {
	private boolean login = false;
	private Personal personal = new Personal();
	//private HashMap<String,SecuritySystem> sysMap = new HashMap<String, SecuritySystem>();
	private List<SecuritySystem> list = new ArrayList<SecuritySystem>();
	private List<String[]> roleList = new ArrayList<String[]>();
	
	public static SecurityProfile login(SecurityUser user) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException {
		SecurityProfile profile = new SecurityProfile();
		
		Connection conn = DBPool.getConnection();
		SecurityUser securUser = SecurityUser.login(conn, user);
		
		profile.setLogin(securUser.isLogin());
		
		if (profile.isLogin()) {
			profile.setPersonal(Personal.login(conn, securUser.getUser_id()));
			//profile.setSysMap(SecuritySystem.selectByUserId(securUser.getUser_id()));
			profile.setList(SecuritySystem.selectListByUserId(securUser.getUser_id()));
			profile.setRoleList(SecurityRole.selectUserRole(securUser.getUser_id()));
		}
		conn.close();
		return profile;
	}
	
	public static boolean check(String id, SecurityProfile profile){
		boolean isRole = false;
		Iterator<String[]> ite = profile.getRoleList().iterator();
		while (ite.hasNext()) {
			String[] role = (String[]) ite.next();
			if (id.equalsIgnoreCase(role[0])) {
				isRole = true;
			}
		}
		return isRole;
	}

	public boolean isLogin() {
		return login;
	}
	public void setLogin(boolean login) {
		this.login = login;
	}
	public Personal getPersonal() {
		return personal;
	}
	public void setPersonal(Personal personal) {
		this.personal = personal;
	}
	/*public HashMap<String, SecuritySystem> getSysMap() {
		return sysMap;
	}
	public void setSysMap(HashMap<String, SecuritySystem> sysMap) {
		this.sysMap = sysMap;
	}*/

	public List<SecuritySystem> getList() {
		return list;
	}
	public void setList(List<SecuritySystem> list) {
		this.list = list;
	}

	public List<String[]> getRoleList() {
		return roleList;
	}

	public void setRoleList(List<String[]> roleList) {
		this.roleList = roleList;
	}
}