package com.ms.service;

import com.github.pagehelper.PageInfo;
import com.ms.dao.model.User;
import com.ms.dao.vo.UserDetailVo;
import com.ms.dao.vo.UserVo;
import me.chanjar.weixin.mp.bean.result.WxMpUser;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.subject.Subject;

import java.util.List;

public interface UserService extends ICommonService<User>{


    PageInfo<UserVo> findByParams(UserVo userVo,Integer pageNum,Integer pageSize);

    UserVo findByPhone(String phone);
    UserVo findByOpenId(String openId);

    UserVo findById(Integer id);

    void disable(Integer id);

    void enable(Integer id);

    void login(Subject subject, UsernamePasswordToken token);

    void logout();

    User loginSms(String phone, String code);

    void register(String phone, String code, String password, String name);

    UserVo sign(UserVo userVo, UserDetailVo userDetailVo);

    User registerWechat(String phone,String openId,String nickname,String headImgUrl,String name);

    void sendRegistSms(String phone);

    void sendLoginSms(String phone);

    void sendResetPasswordSms(String phone);

    void resetPassword(String phone, String code, String password);

    /**
     * 供应商登入
     * @param subject
     * @param token
     * @param wxMpUser
     */
    void login(Subject subject, UsernamePasswordToken token, WxMpUser wxMpUser);

    PageInfo<UserVo> findVoByParams(UserVo userVo,Integer pageNum,Integer pageSize);

    void signSave(UserVo userVo);

    List<UserVo> findByParamsNoPage(UserVo userVo);

    /**
     * 查询已签约供应商
     * @param name
     * @return
     */
    List<UserVo> findSupplierSignUser(String name);

    /**
     * 供应商是否绑定
     * @param supplierId
     * @return
     */
    boolean isBinding(Integer supplierId);

}
