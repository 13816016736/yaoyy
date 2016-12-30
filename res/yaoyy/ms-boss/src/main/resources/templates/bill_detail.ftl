<!DOCTYPE html>
<html lang="en">
<head>
    <title>账单详情-boss</title>
   <#include "./common/meta.ftl"/>
</head>
<body class='wrapper'>
<#include "./common/header.ftl"/>
<#include "./common/aside.ftl"/>

<div class="content">
    <div class="breadcrumb">
        <ul>
            <li>账单管理</li>
            <li>账单详情</li>
        </ul>
    </div>

    <div class="box fa-form fa-form-info">
        <div class="hd">基本信息</div>
        <div class="item">
            <div class="txt">账单编号：</div>
            <div class="val c-blue">${BillVo.code}</div>
        </div>
        <div class="item">
            <div class="txt">订单编号：</div>
            <div class="val c-blue">${BillVo.orderCode}</div>
        </div>
        <div class="item">
            <div class="txt">客户姓名：</div>
            <div class="val">${BillVo.nickname}</div>
        </div>
        <div class="item">
            <div class="txt">客户电话：</div>
            <div class="val">${BillVo.nickname}</div>
        </div>
        <div class="item">
            <div class="txt">单位：</div>
            <div class="val">沪谯药业</div>
        </div>
        <div class="item">
            <div class="txt">地区：</div>
            <div class="val">安徽亳州</div>
        </div>
        <div class="item">
            <div class="txt">身份类型：</div>
            <div class="val">饮片厂</div>
        </div>
    </div>

    <div class="box fa-form">
        <div class="hd">商品信息</div>
        <div class="attr">
            <table>
                <thead>
                <tr>
                    <th>商品名称</th>
                    <th>产地</th>
                    <th width="200">规格等级</th>
                    <th width="80">数量</th>
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
                    <td><input type="text" class="ipt number" disabled value="10" data-price="50"></td>
                    <td>公斤</td>
                    <td>50元/公斤</td>
                    <td><span>500</span>元</td>
                </tr>
                <tr>
                    <td><a href="#">天麻</a></td>
                    <td>陕西</td>
                    <td><p>2级货，统片，颜色均匀，过10号筛</p></td>
                    <td><input type="text" class="ipt number" disabled value="10" data-price="50"></td>
                    <td>公斤</td>
                    <td>50元/公斤</td>
                    <td><span>500</span>元</td>
                </tr>
                </tbody>
                <tfoot>
                <tr>
                    <td colspan="7" class="total"><span>合计：</span><em id="sum1">1000元</em></td>
                </tr>
                </tfoot>
            </table>
        </div>
    </div>

    <div class="box fa-form fa-form-info">
        <div class="hd">账单信息</div>
        <div class="item">
            <div class="txt">申请时间：</div>
            <div class="val">2016年12月24日</div>
        </div>
        <div class="item">
            <div class="txt">操作人：</div>
            <div class="val">王彬</div>
        </div>
        <div class="item">
            <div class="txt">状态：</div>
            <div class="val">未结清</div>
        </div>
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
            <div class="val"><em>0元</em></div>
        </div>
        <div class="item">
            <div class="txt">检测费：</div>
            <div class="val"><em>0元</em></div>
        </div>
        <div class="item">
            <div class="txt">税款：</div>
            <div class="val"><em>0元</em></div>
        </div>
        <div class="item f16">
            <div class="txt">总计：</div>
            <div class="val"><em>400元</em></div>
        </div>
        <div class="hr"></div>
        <div class="item f16">
            <div class="txt">账单类型：</div>
            <div class="val">保证金</div>
        </div>
        <div class="item">
            <div class="txt">账期：</div>
            <div class="val">30天</div>
        </div>
        <div class="item">
            <div class="txt">保证金金额：</div>
            <div class="val"><em>100.00元</em></div>
        </div>
        <div class="item">
            <div class="txt">已付款：</div>
            <div class="val"><em>100.00元</em></div>
        </div>
        <div class="item">
            <div class="txt">欠款：</div>
            <div class="val"><em>300.00元</em></div>
        </div>
        <div class="item f16">
            <div class="txt">剩余帐期：</div>
            <div class="val"><em>20天</em></div>
        </div>
    </div>

    <div class="box fa-form fa-form-info">
        <div class="hd">付款信息</div>
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
    </div>

</div>

<#include "./common/footer.ftl"/>>

</body>
</html>