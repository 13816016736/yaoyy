package com.ms.dao.enums;

/**
 * Created by xiao on 2016/10/31.
 * 后台订单跟踪记录描述
 */
public enum PickTrackingTypeEnum {


    PICK_APPLY(0,"提交选货单"),
    PICK_AGREE(1,"同意受理选货单"),
    PICK_REFUSE(2,"拒绝受理选货单"),
    PICK_RECORD(3,"跟踪记录"),
    PICK_NOT_FINISH(4,"该选货单未完成"),
    PICK_FINISH(5,"该选货单交易完成"),
    PICK_ORDER(6,"为客户下单"),
    PICK_RECEIPT(7,"确认收货"),
    PICK_PAYALL(8,"确认支付了全款"),
    PICK_PAYPOSIT(9,"确认支付了保证金"),
    PICK_ORDER_DELIVERIED(11,"订单已发货"),
    PICK_CONFIRM(12,"确认了订单"),
    PICK_UPDATE(13,"修改了订单"),
    PICK_SUBMIT_PAY(14,"提交了支付信息"),
    PICK_CANCEL(15,"订单已取消"),
    PICK_SELFPAY_DEPOSTI(16,"支付保证金"),
    PICK_SELFPAY_ALL(17,"支付全款"),
    PICK_PAY_BILL(18,"支付账单"),
    PICK_CONFIG_PAY_BILL(19,"确认支付账单"),
    PICK_ADD_ACCOUNT(20,"添加了结算信息"),
    PICK_COMPLETE(21,"确认货物合格，订单状态变为已完成"),
    PICK_RETURN(22,"货物不合格订单状态变为退货");












    private PickTrackingTypeEnum(Integer value, String text) {
        this.value = value;
        this.text = text;
    }

    private Integer value;
    private String text;
    public Integer getValue() {
        return value;
    }

    public String getText() {
        return text;
    }

    /**
     * 通过ID来查询属性名称
     *
     * @param id
     * @return
     */
    public static String findByValue(Integer id) {
        for (PickTrackingTypeEnum trackingEnum: PickTrackingTypeEnum.values()) {
            if (trackingEnum.getValue().equals(id)) {
                return trackingEnum.getText();
            }
        }
        return null;
    }

}
