<!DOCTYPE html>
<html lang="en">
<head>
    <title>收货地址-药优优</title>
    <#include "./common/meta.ftl"/>
</head>
<body class="ui-body-nofoot body-gray">
<header class="ui-header">
    <div class="title">收货地址</div>
    <div class="abs-l mid">
        <a href="javascript:history.back();" class="fa fa-back"></a>
    </div>
</header><!-- /ui-header -->

<section class="ui-content">
    <div class="consignee" id="attention_commodity">
        <#list addressList as addresss>
        <div class="item">
            <label class="item-select" rid = ${addresss.id}>
                <input type="radio"   class="fa-cbx cbx mid">
                <strong>${addresss.consignee}  ${addresss.tel}</strong>
                <span>${addresss.fullAdd} ${addresss.detail}</span>
            </label>
                <div class="op">
                    <a href="#"  class="add-del" rid="${addresss.id}" onclick="return false" ><i class="fa fa-remove add-del" rid="${addresss.id}"></i> 删除</a>
                    <a href="/address/detail/${addresss.id}"><i class="fa fa-edit"></i> 编辑</a>
                </div>
        </div>
        </#list>

        <div class="item">
            <a href="/address/add" class="add"><i class="fa fa-add"></i> 新增收货地址</a>
        </div>
    </div>
</section><!-- /ui-content -->

<div class="ui-loading"></div>


<#include "./common/footer.ftl"/>
<script src="${urls.getForLookupPath('/assets/js/layer.js')}"></script>
<script>

    var _global = {
        fn: {
            init: function() {
                // 初始化选择之前选择的地址
                var addr = sessionStorage.getItem("pickAddrId${orderId!}");
                if (addr) {
                    addr = JSON.parse(addr);
                    if(addr.id != -1){
                        // 选择地址
                        $("label[rid='"+addr.id+"']").find("input").attr("checked",true);
                    }
                }
                this.bindEvent();
            },
            bindEvent: function() {
                var self = this,
                        $wrap = $('#attention_commodity');

                // 选中地址
                $wrap.on('click', '.item-select', function() {
                    var $this = $(this);
                    var addr = {};
                    addr.id =  $this.attr("rid");
                    addr.title= $this.find("strong").html();
                    addr.detail = $this.find("span").html();
                    sessionStorage.setItem("pickAddrId${orderId!}",JSON.stringify(addr));
                    <#if callback?exists>
                        window.location.href = "${callback!}";
                    <#else>
                    window.location.href = "/pick/detail/${orderId!}";
                    </#if>
                });

                //删除
                $wrap.on('click', '.add-del', function() {
                    var $this = $(this);
                    layer.open({
                        className: 'layer-custom',
                        content: '确定要删除吗？',
                        btn: ['确定', '取消'],
                        yes: function(index) {
                            $.ajax({
                                url: '/address/delete/'+$this.attr("rid"),
                                type: 'POST',
                                success: function(result) {
                                    // 删除时要删除对应 session 缓存值
                                    var addr = sessionStorage.getItem("pickAddrId${orderId!}");
                                    if (addr) {
                                        addr = JSON.parse(addr);
                                        if(addr.id == $this.attr("rid")){
                                            sessionStorage.removeItem("pickAddrId${orderId!}");
                                        }
                                    }
                                    $this.closest('.item').remove();
                                    layer.close(index);
                                    if ($wrap.find('.item').length === 0) {
                                        $wrap.empty();
                                        self.empty(true);
                                    }
                                }
                            })

                        }
                    });
                    return false;
                })
            }
        }
    }

    $(function(){
        _global.fn.init();
    });

</script>
</body>
</html>