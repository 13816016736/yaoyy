package com.ms.biz.controller;

import com.alibaba.druid.support.json.JSONUtils;
import com.alipay.api.AlipayClient;
import com.alipay.api.DefaultAlipayClient;
import com.alipay.api.internal.util.AlipaySignature;
import com.alipay.api.request.AlipayTradeWapPayRequest;
import com.ms.service.properties.AliPayProperties;
import com.ms.biz.properties.BizSystemProperties;
import com.ms.dao.enums.PayTypeEnum;
import com.ms.dao.enums.SettleTypeEnum;
import com.ms.dao.model.User;
import com.ms.dao.vo.AccountBillVo;
import com.ms.dao.vo.PaymentVo;
import com.ms.dao.vo.PickVo;
import com.ms.service.AccountBillService;
import com.ms.service.PaymentService;
import com.ms.service.PickService;
import com.ms.service.UserService;
import com.ms.tools.exception.NotFoundException;
import com.ms.tools.utils.SeqNoUtil;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.PrintWriter;
import java.util.*;

/**
 * Created by wangbin on 2017/1/3.
 */
@Controller
@RequestMapping("alipay/")
public class AliPayController {


    private static final Logger logger = Logger.getLogger( AliPayController.class);
    @Autowired
    private AliPayProperties aliPayProperties;

    @Autowired
    private PickService pickService;

    @Autowired
    private AccountBillService accountBillService;

    @Autowired
    private HttpSession httpSession;

    @Autowired
    private BizSystemProperties systemProperties;

    @Autowired
    private PaymentService paymentService;

    @Autowired
    private UserService userService;

    /**
     * 阿里支付页面
     * @param orderId
     * @param billId
     * @param model
     * @return
     */
    @RequestMapping(value = "index")
    public String index(Integer orderId,Integer billId,String authId,ModelMap model){
        User user=userService.findByOpenId(authId);
        if(user==null){
            throw new NotFoundException("找不到该用户");
        }
        if (orderId != null) {
            PickVo pick = pickService.findVoById(orderId);
            if(pick==null){
                throw new NotFoundException("找不到该订单");
            }
            if (SettleTypeEnum.SETTLE_ALL.getType().equals(pick.getSettleType())) {
                model.put("money",pick.getAmountsPayable());
            } else if (SettleTypeEnum.SETTLE_DEPOSIT.getType().equals(pick.getSettleType())) {
                model.put("money",pick.getDeposit());
            }



        } else if (billId != null) {
            AccountBillVo accountBillVo = accountBillService.findVoById(billId);
            if(accountBillVo==null){
                throw new NotFoundException("找不到该账单");
            }
            Float total = accountBillVo.getAmountsPayable() - accountBillVo.getAlreadyPayable();
            model.put("money",total);
        }
        model.put("orderId",orderId);
        model.put("billId",billId);
        model.put("userId",user.getId());
        return "alipay";
    }


    @RequestMapping(value = "pay")
    public void pay(HttpServletResponse response,
                    Integer orderId, Integer billId,Integer userId) throws Exception{
        User user = userService.findById(userId);
        Map<String,Object> params = new HashMap<>();
        PaymentVo payment = new PaymentVo();
        payment.setUserId(user.getId());
        payment.setPayType(PayTypeEnum.ALIPAY.getType());

        if (orderId != null) {
            PickVo pick = pickService.findVoById(orderId);
            params.put("body","药优优订单支付");
            payment.setType(0);
            payment.setOrderId(orderId);
            if (SettleTypeEnum.SETTLE_ALL.getType().equals(pick.getSettleType())) {
                params.put("total_amount",pick.getAmountsPayable());
                payment.setMoney(pick.getAmountsPayable());
            } else if (SettleTypeEnum.SETTLE_DEPOSIT.getType().equals(pick.getSettleType())) {
                payment.setMoney(pick.getDeposit());
                params.put("total_amount",pick.getDeposit());
            }


        } else if (billId != null) {
            AccountBillVo accountBillVo = accountBillService.findVoById(billId);
            params.put("body","药优优账单支付");;
            payment.setType(1);
            payment.setBillId(billId);
            Float total = accountBillVo.getAmountsPayable() - accountBillVo.getAlreadyPayable();
            payment.setMoney(total);
            params.put("total_amount",total);
        }
        //params.put("total_amount",0.01f);//测试用
        String outTradeNo= SeqNoUtil.getPaymentCode();
        params.put("out_trade_no",outTradeNo);
        payment.setOutTradeNo(outTradeNo);
        params.put("subject",outTradeNo);
        params.put("product_code","QUICK_WAP_PAY");
        params.put("seller_id",aliPayProperties.getSellerId());
        String content =  JSONUtils.toJSONString(params);
        AlipayClient alipayClient = new DefaultAlipayClient("https://openapi.alipay.com/gateway.do",aliPayProperties.getAppId(),aliPayProperties.getPrivateKey(),"json",aliPayProperties.getCharset(),aliPayProperties.getPublicKey(),"RSA2");
        AlipayTradeWapPayRequest alipayRequest = new AlipayTradeWapPayRequest();//创建API对应的request
        alipayRequest.setReturnUrl(systemProperties.getBaseUrl()+"/alipay/return"); //回调页面
        alipayRequest.setNotifyUrl(systemProperties.getBaseUrl()+"/alipay/callback");//在公共参数中设置回跳和通知地址
        alipayRequest.setBizContent(content);//填充业务参数
        payment.setOutParam(content);
        logger.info("支付宝支付参数："+content);
        String form = alipayClient.pageExecute(alipayRequest).getBody(); //调用SDK生成表单
        payment.setStatus(0);
        payment.setCreateTime(new Date());
        paymentService.create(payment);
        response.setContentType("text/html;charset=" + aliPayProperties.getCharset());
        response.getWriter().write(form);//直接将完整的表单html输出到页面
        response.getWriter().flush();
    }

    //https://doc.open.alipay.com/docs/doc.htm?treeId=203&articleId=105285&docType=1
    @RequestMapping(value = "callback")
    public void callBack(HttpServletRequest request,HttpServletResponse response)throws Exception{
        //获取返回所有参数
        Map<String,String> params = new HashMap<String,String>();
        Map requestParams = request.getParameterMap();
        for (Iterator iter = requestParams.keySet().iterator(); iter.hasNext();) {
            String name = (String) iter.next();
            String[] values = (String[]) requestParams.get(name);
            String valueStr = "";
            for (int i = 0; i < values.length; i++) {
                valueStr = (i == values.length - 1) ? valueStr + values[i]
                        : valueStr + values[i] + ",";
            }
            params.put(name, valueStr);
        }
        logger.info("支付宝回调参数："+params);
        PrintWriter out=response.getWriter();
        boolean result=AlipaySignature.rsaCheckV1(params,aliPayProperties.getPublicKey(),aliPayProperties.getCharset(),"RSA2");
        if(result){
            String trade_status=params.get("trade_status");
            //支付成功
            PaymentVo payment=paymentService.getByOutTradeNo(params.get("out_trade_no"));
            if(payment!=null&&payment.getCallbackTime()==null) {
                payment.setPayAppId(aliPayProperties.getAppId());
                payment.setInParam(params.toString());
                if (trade_status.equals("TRADE_FINISHED") || trade_status.equals("TRADE_SUCCESS")) {
                    payment.setStatus(1);
                    payment.setTradeNo(params.get("trade_no"));
                    pickService.handlePay(payment);
                }//支付失败
                else {
                    payment.setTradeNo(params.get("trade_no"));
                    payment.setStatus(2);
                    pickService.handlePay(payment);
                }
            }
            out.print("success");
        }
        else{
            out.print("fail");
        }
    }

    /**
     * 支付宝支付完毕之后回调页面
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "return")
    public String aliPayReturn(HttpServletRequest request)throws Exception{
        Map<String,String> params = new HashMap<String,String>();
        Map requestParams = request.getParameterMap();
        for (Iterator iter = requestParams.keySet().iterator(); iter.hasNext();) {
            String name = (String) iter.next();
            String[] values = (String[]) requestParams.get(name);
            String valueStr = "";
            for (int i = 0; i < values.length; i++) {
                valueStr = (i == values.length - 1) ? valueStr + values[i]
                        : valueStr + values[i] + ",";
            }
            params.put(name, valueStr);
        }
        logger.info("支付宝返回页面："+params);
        boolean result=AlipaySignature.rsaCheckV1(params,aliPayProperties.getPublicKey(),aliPayProperties.getCharset(),"RSA2");
        if(result){
            //支付成功
            PaymentVo payment=paymentService.getByOutTradeNo(params.get("out_trade_no"));
            if(payment!=null) {
                payment.setPayAppId(aliPayProperties.getAppId());
                payment.setInParam(params.toString());
                if(payment.getCallbackTime()==null){
                        payment.setStatus(1);
                        payment.setTradeNo(params.get("trade_no"));
                        pickService.handlePay(payment);
                    }

                if(payment.getType()==0){
                    return "redirect:/paySuccess?orderId="+payment.getOrderId();
                }
                else{
                    return "redirect:/paySuccess?billId="+payment.getBillId();
                }

            }


        }
        return  "redirect:/pick/list";
    }

}
