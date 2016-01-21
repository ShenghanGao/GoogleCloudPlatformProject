package cs263w16;

import javax.xml.bind.annotation.XmlRootElement;
import java.io.*;
import java.util.*;

@XmlRootElement
// JAX-RS supports an automatic mapping from JAXB annotated class to XML and JSON
public class TaskData implements Serializable {
  private static final long serialVersionUID = -1662829519219063057L;

  private String keyname;
  private String value;
  private Date date;

  //add constructors (default () and (String,String,Date))
  public TaskData() {

  }

  public TaskData(String keyname, String value, Date date) {
  	this.keyname = keyname;
  	this.value = value;
  	this.date = date;
  }

  //add getters and setters for all fields
  public String getKeyname() {
  	return this.keyname;
  }

  public String getValue() {
  	return this.value;
  }

  public Date getDate() {
  	return this.date;
  }

  public void setKeyname(String keyname) {
  	this.keyname = keyname;
  }

  public void setValue(String value) {
  	this.value = value;
  }

  public void setDate(Date date) {
  	this.date =  date;
  }
} 
