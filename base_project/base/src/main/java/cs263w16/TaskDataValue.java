package cs263w16;

import java.io.*;
import java.util.*;

public class TaskDataValue implements Serializable {
	private String value;
	private Date date;

	private static final long serialVersionUID = -1662829519219063057L;

	public TaskDataValue(String value) {
		this.value = value;
		date = new Date();
	}

	public String getValue() {
		return this.value;
	}

	public Date getDate() {
		return this.date;
	}

	public String getPrintableString() {
		return " value: " + value + " Date: " + date;
	}

}
