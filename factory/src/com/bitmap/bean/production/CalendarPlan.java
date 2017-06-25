package com.bitmap.bean.production;

import com.bitmap.utils.CalendarEvent;

public class CalendarPlan extends CalendarEvent {
	String backgroundColor = "";
	String borderColor = "";
	
	public String getBackgroundColor() {
		return backgroundColor;
	}
	public void setBackgroundColor(String backgroundColor) {
		this.backgroundColor = backgroundColor;
	}
	public String getBorderColor() {
		return borderColor;
	}
	public void setBorderColor(String borderColor) {
		this.borderColor = borderColor;
	}
}