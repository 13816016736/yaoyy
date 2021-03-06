package com.ms.service;

import com.github.pagehelper.PageInfo;
import com.ms.dao.model.Supplier;
import com.ms.dao.vo.SupplierCertifyVo;
import com.ms.dao.vo.SupplierJudgeVo;
import com.ms.dao.vo.SupplierVo;
import me.chanjar.weixin.mp.bean.result.WxMpUser;

import java.util.List;

public interface SupplierService extends ICommonService<Supplier>{

    PageInfo<SupplierVo> findByParams(SupplierVo supplierVo,Integer pageNum,Integer pageSize);

    SupplierVo findVoById(Integer id);

    void save(SupplierVo supplierVo);

    List<SupplierVo> search(String name);

    PageInfo<SupplierVo> findVoByParams(SupplierVo supplierVo,Integer pageNum,Integer pageSize);

    /**
     * 前台供应商入驻
     * @param supplierVo
     */
    Boolean register(SupplierVo supplierVo);


    /**
     * 前台供应商注册
     * @param supplierVo
     * @return
     */
    Boolean join(SupplierVo supplierVo,WxMpUser wxMpUser);


    /**
     * 核实供应商
     * @param supplierCertifyVo
     */
    void certify(SupplierCertifyVo supplierCertifyVo);

    /**
     *评价供应商
     */
    void judge(SupplierJudgeVo supplierJudgeVo);

    /**
     * 查询是否有该手机号的供应商
     */
    Boolean existSupplier(String phone);




}
