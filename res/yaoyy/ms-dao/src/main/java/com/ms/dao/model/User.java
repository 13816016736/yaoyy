package com.ms.dao.model;

import java.io.Serializable;
import java.util.Date;


public class User  implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private Integer id;
	
	//(0：注册用户，1：申请寄样生成的用户 -1 禁用用户) 已废弃
	// 1 采购商 2 供应商
	private Integer type;
	
	//手机号
	private String phone;
	
	//用户密码
	private String password;
	
	private String salt;
	
	//用户公众号对应的openid
	private String openid;
	
	private Date updateTime;
	
	private Date createTime;

	//0：注册用户，1：申请寄样生成的用户(针对采购商)
	//10: 后台导入 11: 微信注册 （针对采购商）
	private Integer source;

	// 0禁用 1启用
	private Integer status;

	// 0 未认证 1已认证(主要针对供应商)
	private Integer verify;

	//供应商用户使用字段，0 未签合同，1已签合同
	private Integer contract;

	//绑定供应商id
	private Integer supplierId;
	
	public User(){}
	
	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getType() {
		return type;
	}

	public void setType(Integer type) {
		this.type = type;
	}
	
	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}
	
	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}
	
	public String getSalt() {
		return salt;
	}

	public void setSalt(String salt) {
		this.salt = salt;
	}
	
	public String getOpenid() {
		return openid;
	}

	public void setOpenid(String openid) {
		this.openid = openid;
	}
	
	public Date getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}
	
	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public Integer getSource() {
		return source;
	}

	public void setSource(Integer source) {
		this.source = source;
	}

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public Integer getVerify() {
		return verify;
	}

	public void setVerify(Integer verify) {
		this.verify = verify;
	}

	public Integer getContract() {return contract;}

	public void setContract(Integer contract) {this.contract = contract;}

	public Integer getSupplierId() {return supplierId;}

	public void setSupplierId(Integer supplierId) {this.supplierId = supplierId;}

}