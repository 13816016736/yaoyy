package com.ms.dao.enums;

/**
 * Created by xiao on 2016/11/9.
 * 前台订单状态描述
 */
public enum BizPickEnum {
    PICK_NOTHANDLE(0,"采购单已提交，等待客服来电"),
    PICK_HANDING(1,"选货单已受理"),
    PICK_NOTFINISH(2,"取消订单"),
    PICK_FINISH(3,"交易已完成"),
    PICK_REFUSE(4,"采购单失效"),
    PICK_PAY(5,"待支付"),
    PICK_DELIVERY(6,"待发货"),
    PICK_DELIVERIED(7,"待收货"),
    PICK_CONFIRM(8,"待确认"),
    PICK_CANCLE(9,"已取消");



    private BizPickEnum (Integer value, String text) {
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
        for (BizPickEnum  pickEnum: BizPickEnum.values()) {
            if (pickEnum.getValue().equals(id)) {
                return pickEnum.getText();
            }
        }
        return null;
    }

}
