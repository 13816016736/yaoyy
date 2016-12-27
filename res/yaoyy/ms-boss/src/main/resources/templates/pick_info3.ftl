<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>订单详情-boss</title>
    <meta name="renderer" content="webkit" />
    <link rel="shortcut icon" href="images/favicon.ico" type="image/x-icon" />
    <link rel="stylesheet" href="assets/awesome/css/font-awesome.min.css">
    <link rel="stylesheet" href="assets/css/style.css" />
</head>
<body class='wrapper'>

<div class="header">
    <div class="logo">
        <a href="index.html">药优优</a>
    </div>
    <div class="menu">
        <ul>
            <li>
                <a href="#" class="dropdown-toggle"> <i class="fa fa-question-circle"></i> 帮助 </a>
            </li>
            <li class="dropdown user user-menu">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                    <i class="fa fa-user"></i>
                    <span class="hidden-xs">王彬</span>
                </a>
            </li>
            <li>
                <a href="/logout">
                    <i class="fa fa-power-off"></i>
                    退出
                </a>
            </li>
        </ul>
    </div>
</div>

<!-- 侧栏菜单 -->
<div class="aside" id="jaside"></div>

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
                    <div class="val">20161014001</div>
                </div>
                <div class="item">
                    <div class="txt">状态：</div>
                    <div class="val c-red">待支付</div>
                </div>
                <div class="item">
                    <div class="txt">客户姓名：</div>
                    <div class="val">王先生</div>
                </div>
                <div class="item">
                    <div class="txt">手机号：</div>
                    <div class="val">18801285391</div>
                </div>
                <div class="item">
                    <div class="txt">地区：</div>
                    <div class="val">安徽亳州</div>
                </div>
                <div class="item">
                    <div class="txt">申请时间：</div>
                    <div class="val">2016年6月28日 12：30</div>
                </div>
            </div>

            <div class="box fa-form">
                <div class="hd">商品详情</div>
                <div class="attr">
                    <div class="op">修改</div>
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

            <div class="box fa-form" id="calc">
                <div class="hd">报价清单</div>
                <div class="item">
                    <div class="txt">商品总价：</div>
                    <div class="cnt"><div class="ipt-wrap"><input type="text" class="ipt" id="sum2" value="800" disabled><span class="unit">元</span></div></div>
                </div>
                <div class="item">
                    <div class="txt">运费：</div>
                    <div class="cnt"><div class="ipt-wrap"><input type="text" class="ipt price" value="0"><span class="unit">元</span></div></div>
                </div>
                <div class="item">
                    <div class="txt">包装费：</div>
                    <div class="cnt"><div class="ipt-wrap"><input type="text" class="ipt price" value="0"><span class="unit">元</span></div></div>
                </div>
                <div class="item">
                    <div class="txt">检测费：</div>
                    <div class="cnt"><div class="ipt-wrap"><input type="text" class="ipt price" value="0"><span class="unit">元</span></div></div>
                </div>
                <div class="item">
                    <div class="txt">税款：</div>
                    <div class="cnt"><div class="ipt-wrap"><input type="text" class="ipt price" value="0"><span class="unit">元</span></div></div>
                </div>
                <div class="item">
                    <div class="txt">总计：</div>
                    <div class="cnt"><em class="c-red" id="sum3">800</em></div>
                </div>
                <div class="item">
                    <div class="txt">付款方式：</div>
                    <div class="cnt cbxs2">
                        <label><input type="radio" name="paytype" class="cbx" value="1" checked>全款</label>
                        <label><input type="radio" name="paytype" class="cbx" value="2">保证金</label>
                        <label><input type="radio" name="paytype" class="cbx" value="3">赊账</label>
                    </div>
                </div>
                <div class="group">
                    <div class="item">
                        <div class="txt">保证金金额：</div>
                        <div class="cnt"><div class="ipt-wrap"><input type="text" class="ipt ipt-short deposit" value="0"><span class="unit">元</span></div></div>
                    </div>
                    <div class="item">
                        <div class="txt">账期：</div>
                        <div class="cnt"><div class="ipt-wrap"><input type="text" class="ipt ipt-short day" value="0"><span class="unit">天</span></div></div>
                    </div>
                </div>
                <div class="ft">
                    <button type="button" class="ubtn ubtn-blue">提交订单</button>
                </div>
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

<div class="footer">
    <div class="inner">
        &copy; <a href="#!">亳州市东方康元中药材信息咨询有限公司</a> 版权所有.
    </div>
</div>

<script src="assets/js/jquery191.js"></script>
<script src="assets/js/common.js"></script>
<script src="assets/plugins/layer/layer.js"></script>
<script src="assets/plugins/validator/jquery.validator.min.js"></script>
<script>
    !(function() {
        var formatPrice = function(val) {
            return val.toFixed(2);
        }

        var _global = {
            v: {
            },
            fn: {
                init: function() {
                    this.tab();
                    this.modify();
                    this.bindEvent();
                    this.total();
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
                },
                // 修改商品数量
                modify: function() {
                    var status = 'done',
                            $ipts = $('.attr').find('.ipt');

                    $('.op').on('click', function() {
                        if (status === 'done') { // 修改
                            status = 'modify';
                            $(this).html('完成');
                            $ipts.prop('disabled', false);

                            // 发送数据到后台
                            $.ajax({})
                        } else {
                            status = 'done';
                            $(this).html('修改');
                            $ipts.prop('disabled', true);
                        }
                    })
                },
                bindEvent: function() {
                    var self = this,
                            $ipts = $('.attr').find('.ipt'),
                            $body = $('body');

                    this.unitPrice = [];

                    $ipts.each(function(i) {
                        var $sum = $(this).closest('tr').find('span'),
                                myprice = $(this).data('price');

                        // 保存初始值
                        self.unitPrice.push({
                            sum: this.value * myprice
                        })

                        // 小计
                        $sum.html(formatPrice(this.value * myprice));

                        // 修改数量
                        $(this).on('blur', function() {
                            var amount = this.value,
                                    sum = 0;
                            if (amount) {
                                amount = (!isNaN(amount = parseInt(amount, 10)) && amount) > 0 ? amount : 1;
                            } else {
                                amount = 1;
                            }
                            sum = formatPrice(amount * myprice);
                            $sum.html(sum);
                            this.value = amount;
                            self.unitPrice[i].sum = sum;
                            self.total();
                        })
                    })

                    $body.on('focus', '.ipt', function() {
                        $(this).select();
                    })

                    // 各种费用
                    $body.on('keyup', '.price', function() {
                        var val = this.value;
                        if (!/^\d+\.?\d*$/.test(val)) {
                            val = Math.abs(parseFloat(val));
                            this.value = isNaN(val) ? '' : val;
                        }
                    })
                            .on('blur', '.price', function() {
                                self.total2();
                            })

                    // 保证金
                    $body.on('keyup', '.deposit', function() {
                        var val = this.value;
                        if (!/^\d+\.?\d*$/.test(val)) {
                            val = Math.abs(parseFloat(val));
                            this.value = isNaN(val) ? '' : val;
                        }
                    })

                    // 账期
                    $body.on('keyup', '.day', function() {
                        var val = this.value;
                        if (val) {
                            val = (!isNaN(val = parseInt(val, 10)) && val) > 0 ? val : 1;
                            this.value = Math.max(val, 1);
                        }
                    })

                    // 付款方式
                    $body.on('click', '.cbx', function() {
                        if (this.value == 1) {
                            $('#calc').find('.group').hide();
                        } else if (this.value == 2) {
                            $('#calc').find('.group').show().find('.item').show();
                        } else {
                            $('#calc').find('.group').show().find('.item').hide().eq(1).show();
                        }
                    })

                    // 确定
                    $body.on('click', '#calc .ubtn-blue', function() {
                        window.location.href = 'pick_info2.html';
                    })

                    // 关闭弹层
                    // $body.on('click', '#calc .ubtn-gray', function() {
                    //     layer.closeAll();
                    // })
                },
                // 统计商品价格
                total: function() {
                    var sum = 0;
                    $.each(this.unitPrice, function(i, item) {
                        sum += parseFloat(item.sum);
                    })
                    this.sum = sum;
                    sum = formatPrice(sum);
                    $('#sum1').html(sum);
                    $('#sum2').val(sum);
                    this.total2();
                },
                // 统计各种费用后的价格
                total2: function() {
                    var sum = this.sum;
                    $('#calc').find('.price').each(function() {
                        sum += parseFloat(this.value);
                    })
                    $('#sum3').html(formatPrice(sum));
                }
            }
        }

        _global.fn.init();
    })();
</script>
</body>
</html>