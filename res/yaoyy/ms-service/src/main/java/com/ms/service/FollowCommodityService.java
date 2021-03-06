package com.ms.service;

import com.github.pagehelper.PageInfo;
import com.ms.dao.model.FollowCommodity;
import com.ms.dao.vo.FollowCommodityVo;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface FollowCommodityService extends ICommonService<FollowCommodity>{

    public PageInfo<FollowCommodityVo> findByParams(FollowCommodityVo followCommodityVo,Integer pageNum,Integer pageSize);

    /**
     * 关注商品
     * @param commodityId
     * @param userId
     */
    public void watch(Integer commodityId, Integer userId);

    /**
     * 取消关注
     * @param followId
     * @param commodityId
     * @param userId
     */
    public void unwatch(Integer followId,Integer commodityId, Integer userId);

    /**
     * 获取关注的商品数量
     * @param userId
     * @return
     */
    public Integer count(Integer userId);

    /**
     * 获取用户关注的商品
     * @param userId
     * @return
     */
    public List<FollowCommodityVo> findCommodity(Integer userId);

    /**
     * 查询用户关注的商品Id
     * @param userId
     * @return
     */
    public List<Integer> findCommodityIds(Integer userId);

    /**
     * 商品价格变动后更新关注的商品动态
     * @param commodityId
     * @return
     */
    Integer updateStatus(Integer commodityId);

    /**
     * 修改用户关注商品状态为已读
     * @param userId
     * @return
     */
    Integer changeRead(Integer userId);
}
