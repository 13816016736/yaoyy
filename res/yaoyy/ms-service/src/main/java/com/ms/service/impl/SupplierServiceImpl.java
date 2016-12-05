package com.ms.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.ms.dao.ICommonDao;
import com.ms.dao.SupplierDao;
import com.ms.dao.model.Supplier;
import com.ms.dao.vo.SupplierVo;
import com.ms.service.SupplierService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Service
public class SupplierServiceImpl  extends AbsCommonService<Supplier> implements SupplierService{

	@Autowired
	private SupplierDao supplierDao;


	@Override
	public PageInfo<SupplierVo> findByParams(SupplierVo supplierVo,Integer pageNum,Integer pageSize) {

		pageNum = pageNum==null?1:pageNum;
		pageSize = pageSize==null?10:pageSize;

        PageHelper.startPage(pageNum, pageSize);
    	List<SupplierVo>  list = supplierDao.findByParams(supplierVo);
        PageInfo page = new PageInfo(list);
        return page;
	}

	@Override
	public SupplierVo findVoById(Integer id) {
		return supplierDao.findVoById(id);
	}

	@Override
	@Transactional
	public void save(SupplierVo supplierVo) {
		Date now=new Date();
		if(supplierVo.getId()==null){
			supplierVo.setCreateTime(now);
			supplierVo.setUpdateTime(now);
			supplierDao.create(supplierVo);
		}
		else{
			supplierVo.setUpdateTime(now);
			supplierDao.update(supplierVo);
		}
	}


	@Override
	public ICommonDao<Supplier> getDao() {
		return supplierDao;
	}

}
