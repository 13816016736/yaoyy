package com.ms.dao.vo;

import com.ms.dao.model.Commodity;
import com.ms.dao.model.Gradient;

import java.util.List;

public class CommodityVo extends Commodity{

    // 品种名
    private String categoryName;

    // 单位名称
    private String unitName;

    // 量大价优价格梯度
    private List<Gradient> gradient;

    // 用户是否关注
    private Boolean watch = false;

    // 供应商名称
    private String supplierName;

    // 供应商电话
    private String supplierTel;

    //根据关键字搜索商品名称
    private String keyword;

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public List<Gradient> getGradient() {
        return gradient;
    }

    public void setGradient(List<Gradient> gradient) {
        this.gradient = gradient;
    }

    public String getUnitName() {
        return unitName;
    }

    public void setUnitName(String unitName) {
        this.unitName = unitName;
    }

    public Boolean getWatch() {
        return watch;
    }

    public void setWatch(Boolean watch) {
        this.watch = watch;
    }

    public String getSupplierName() {
        return supplierName;
    }

    public void setSupplierName(String supplierName) {
        this.supplierName = supplierName;
    }

    public String getSupplierTel() {
        return supplierTel;
    }

    public void setSupplierTel(String supplierTel) {
        this.supplierTel = supplierTel;
    }

    public String getKeyword() {return keyword;}

    public void setKeyword(String keyword) {this.keyword = keyword;}
}