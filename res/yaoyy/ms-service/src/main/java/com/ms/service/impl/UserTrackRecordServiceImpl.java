package com.ms.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.ms.dao.ICommonDao;
import com.ms.dao.UserTrackRecordDao;
import com.ms.dao.model.UserTrackRecord;
import com.ms.dao.vo.UserTrackRecordVo;
import com.ms.service.UserTrackRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class UserTrackRecordServiceImpl  extends AbsCommonService<UserTrackRecord> implements UserTrackRecordService{

	@Autowired
	private UserTrackRecordDao userTrackRecordDao;


	@Override
	public PageInfo<UserTrackRecordVo> findByParams(UserTrackRecordVo userTrackRecordVo,Integer pageNum,Integer pageSize) {
    	PageHelper.startPage(pageNum, pageSize);
    	List<UserTrackRecordVo>  list = userTrackRecordDao.findByParams(userTrackRecordVo);
        PageInfo page = new PageInfo(list);
        return page;
	}

	@Override
	public List<UserTrackRecordVo> findByParamsNoPage(UserTrackRecordVo userTrackRecordVo) {
		return userTrackRecordDao.findVoByParams(userTrackRecordVo);
	}

	@Override
	public UserTrackRecordVo findByContent(UserTrackRecordVo userTrackRecordVo) {
		List<UserTrackRecordVo>  list = userTrackRecordDao.findVoByParams(userTrackRecordVo);
		if(list.size()!=0){
			return  list.get(list.size()-1);
		}
		return null;
	}


	@Override
	public ICommonDao<UserTrackRecord> getDao() {
		return userTrackRecordDao;
	}

}
