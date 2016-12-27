<!DOCTYPE html>
<html lang="en">
<head>
    <title>订单详情-boss</title>
    <#include "./common/meta.ftl"/>
</head>
<body class='wrapper'>
<#include "./common/header.ftl"/>
<#include "./common/aside.ftl"/>

<div class="content">
    <div class="breadcrumb">
        <ul>
            <li>订单模块</li>
            <li>订单列表</li>
        </ul>
    </div>

    <div class="fa-tab">
        <span class="on">订单信息</span>
        <span>客户信息</span>
    </div>

    <div class="fa-tab-cont">
        <div class="items">
            <div class="box fa-form fa-form-info">
                <div class="hd">基本信息</div>
                <div class="item">
                    <div class="txt">订单编号：</div>
                    <div class="val">${pickVo.code}</div>
                </div>
                <div class="item">
                    <div class="txt">状态：</div>
                    <div class="val c-red">${pickVo.statusText}</div>
                </div>
                <div class="item">
                    <div class="txt">客户姓名：</div>
                    <div class="val">${pickVo.nickname}</div>
                </div>
                <div class="item">
                    <div class="txt">手机号：</div>
                    <div class="val">${pickVo.phone}</div>
                </div>
                <!--
                <div class="item">
                    <div class="txt">地区：</div>
                    <div class="val">安徽亳州</div>
                </div>
                -->
                <div class="item">
                    <div class="txt">申请时间：</div>
                    <div class="val">${(pickVo.createTime?datetime)!}</div>
                </div>
            </div>

            <div class="box fa-form fa-form-info">
                <div class="hd">收货信息</div>
                <div class="item">
                    <div class="txt">收货人：</div>
                    <div class="val">王彬</div>
                </div>
                <div class="item">
                    <div class="txt">收货人电话：</div>
                    <div class="val">18801285391</div>
                </div>
                <div class="item">
                    <div class="txt">收货地址：</div>
                    <div class="val">武汉市洪山区光谷银座</div>
                </div>
                <div class="item">
                    <div class="txt">发票：</div>
                    <div class="val">沪谯药业</div>
                </div>
                <div class="item">
                    <div class="txt">备注：</div>
                    <div class="val">无</div>
                </div>
            </div>

            <div class="box fa-form">
                <div class="hd">订单追踪</div>
                <ol class="trace" id="trace">
                    <li><span>2016年10月12日 12:30</span><span>用户提交采购单</span></li>
                    <li>操作人   2016年10月12日    12：30   同意/拒绝受理该采购单</li>
                    <li>操作人   2016年10月12日    12：30   为客户下单/结束交易</li>
                    <li>操作人   2016年10月12日    12：30   修改了商品详情/修改了结算详情</li>
                    <li>2016年10月12日    12：30   用户支付了保证金/支付了全款/确认了订单</li>
                    <li>操作人   2016年10月12日    12：30   确认发货</li>
                </ol>
            </div>

            <div class="box fa-form">
                <div class="hd">商品详情</div>
                <div class="attr">
                    <table>
                        <thead>
                        <tr>
                            <th>商品名称</th>
                            <th>产地</th>
                            <th width="200">规格等级</th>
                            <th>数量</th>
                            <th>单位</th>
                            <th>价格</th>
                            <th>合计</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td><a href="#">茯苓</a></td>
                            <td>云南</td>
                            <td><p>2级货，过4号筛，直径0.8cm以内</p></td>
                            <td>10</td>
                            <td>公斤</td>
                            <td>50元/公斤</td>
                            <td>500元</td>
                        </tr>
                        <tr>
                            <td><a href="#">天麻</a></td>
                            <td>陕西</td>
                            <td><p>2级货，统片，颜色均匀，过10号筛</p></td>
                            <td>10</td>
                            <td>公斤</td>
                            <td>50元/公斤</td>
                            <td>500元</td>
                        </tr>
                        </tbody>
                        <tfoot>
                        <tr>
                            <td colspan="7" class="total"><span>合计：</span><em>800元</em></td>
                        </tr>
                        </tfoot>
                    </table>
                </div>
            </div>

            <div class="box fa-form fa-form-info">
                <div class="hd">结算详情</div>
                <div class="item">
                    <div class="txt">商品总价：</div>
                    <div class="val"><em>350.00元</em></div>
                </div>
                <div class="item">
                    <div class="txt">运费：</div>
                    <div class="val"><em>50.00元</em></div>
                </div>
                <div class="item">
                    <div class="txt">包装费：</div>
                    <div class="val"><em>0元</em>（免包装费）</div>
                </div>
                <div class="item">
                    <div class="txt">检测费：</div>
                    <div class="val"><em>0元</em>（免检测费）</div>
                </div>
                <div class="item f16">
                    <div class="txt">总计：</div>
                    <div class="val"><em>400元</em></div>
                </div>
                <div class="hr"></div>
                <div class="item f16">
                    <div class="txt">结算类型：</div>
                    <div class="val">支付保证金 <!-- <a href="#" class="c-blue">跳转到账单页</a> --></div>
                </div>
                <div class="item">
                    <div class="txt">账期：</div>
                    <div class="val">30天</div>
                </div>
                <div class="item">
                    <div class="txt">保证金金额：</div>
                    <div class="val"><em>100.00元</em></div>
                </div>
                <!--
                <div class="item">
                    <div class="txt">支付方式：</div>
                    <div class="val">微信支付</div>
                </div>
                <div class="item">
                    <div class="txt">已付款：</div>
                    <div class="val"><em>100.00元</em></div>
                </div>
                <div class="item">
                    <div class="txt">欠款：</div>
                    <div class="val"><em>300.00元</em></div>
                </div>
                <div class="item">
                    <div class="txt">支付时间：</div>
                    <div class="val">2016年6月28日 12：30</div>
                </div>
                -->
                <div class="ft">
                    <a href="pick_info3.html" class="ubtn ubtn-blue">修改订单</a>
                </div>
                <!--
                <div class="item">
                    <div class="txt">支付方式：</div>
                    <div class="val">银行转账</div>
                </div>
                <div class="item">
                    <div class="txt">支付凭证：</div>
                    <div class="val thumb">
                        <img src="uploads/Koala.jpg" alt="" width="160" height="80">
                    </div>
                </div>
                <div class="item">
                    <div class="txt">支付时间：</div>
                    <div class="val">2016年6月28日 12：30</div>
                </div>
                <div class="ft">
                    <button class="ubtn ubtn-blue">确认收款</button>
                </div>
                -->
            </div>
        </div>
        <div class="items">
            <div class="box fa-form">
                <div class="hd">客户信息</div>
                <form id="myform">
                    <div class="item">
                        <div class="txt">个人称呼：</div>
                        <div class="cnt">
                            <input type="text" name="username" class="ipt" placeholder="" autocomplete="off">
                        </div>
                    </div>
                    <div class="item">
                        <div class="txt">联系电话：</div>
                        <div class="cnt">
                            <input type="text" name="mobile" class="ipt" placeholder="" autocomplete="off">
                        </div>
                    </div>
                    <div class="item">
                        <div class="txt">地区：</div>
                        <div class="cnt">
                            <input type="text" name="region" class="ipt" placeholder="" autocomplete="off">
                        </div>
                    </div>
                    <div class="item">
                        <div class="txt">身份类型：</div>
                        <div class="cnt cbxs">
                            <label><input type="radio" name="type" class="cbx">饮片厂</label>
                            <label><input type="radio" name="type" class="cbx">药厂</label>
                            <label><input type="radio" name="type" class="cbx">药材经营公司</label>
                            <label><input type="radio" name="type" class="cbx">个体经营户</label>
                            <label><input type="radio" name="type" class="cbx">合作社</label>
                            <label><input type="radio" name="type" class="cbx">种植基地</label>
                            <label><input type="radio" name="type" class="cbx">其他</label>
                            <label><input type="radio" name="type" class="cbx">个人经营</label>
                            <label><input type="radio" name="type" class="cbx">采购经理</label>
                            <label><input type="radio" name="type" class="cbx">销售经理</label>
                        </div>
                    </div>
                    <div class="item">
                        <div class="txt">姓名/单位：</div>
                        <div class="cnt">
                            <input type="text" name="company" class="ipt" placeholder="姓名/单位" autocomplete="off">
                        </div>
                    </div>
                    <div class="item">
                        <div class="txt">用户备注：</div>
                        <div class="cnt">
                            <textarea name="" id="" class="ipt ipt-mul"></textarea>
                        </div>
                    </div>
                    <div class="ft">
                        <button type="button" class="ubtn ubtn-blue">保存客户信息</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<#include "./common/footer.ftl"/>



<script src="assets/plugins/laydate/laydate.js"></script>
<script src="assets/plugins/validator/jquery.validator.min.js"></script>
<script>
    var _global = {
        v: {
        },
        fn: {
            init: function() {
                this.tab();
            },
            tab: function() {
                var $items = $('.fa-tab-cont').find('.items'),
                        $wrapper = $('.wrapper');

                $('.fa-tab').on('click', 'span', function() {
                    var k = $(this).index();
                    $(this).addClass('on').siblings().removeClass('on');
                    $items.hide().eq(k).show();
                    $wrapper.css('min-height', 'auto');
                    _fix();
                })
            }
        }
    }

    $(function() {
        _global.fn.init();
    })
</script>
</body>
</html>