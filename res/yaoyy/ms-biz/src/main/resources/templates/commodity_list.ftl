<!DOCTYPE html>
<html lang="en">
  <head>
    <#include "./common/meta.ftl"/>
    <title>品种列表-药优优</title>
</head>
<body class="ui-body body-gray">
    <header class="ui-header">
        <div class="title">品种列表</div>
        <div class="abs-l mid">
            <a href="javascript:history.back();" class="fa fa-back"></a>
        </div>
        <div class="abs-r mid search">
            <form>
                <input type="text" name="keyword" id="keyword" value="" class="ipt" />
                <button type="submit" id="search" class="fa fa-search mid submit"></button>
            </form>
        </div>
    </header><!-- /ui-header -->

    <#include "./common/navigation.ftl">

    <section class="ui-content">
        <div class="plist">
            <dl class="side">
                <dd>品种列表</dd>
                <#if categoryVos??>
                <#list categoryVos as categoryVo>
                <dd <#if categoryId?? && categoryId == categoryVo.id>class="curr"</#if>><a href="javascript;" data-id="${categoryVo.id}">${categoryVo.name!}</a></dd>
                </#list>
                </#if>
            </dl>
            <ul id="plist"></ul>
            <input type="hidden" id="categoryId" value="${categoryId!}"/>
        </div>
    </section><!-- /ui-content -->

    <#include "./common/footer.ftl"/>
    <script>

    var _global = {
        fn: {
            init: function() {
                this.bindEvent();
                this.loadPlist();
            },
            bindEvent: function() {
                var that = this,    
                    $plist = $('#plist'),
                    $keyword = $('#keyword'),
                    $cid = $('#categoryId');

                $('.side').on('click', 'a', function() {
                    var cid = $(this).data('id');

                    $(this).parent().addClass('curr').siblings().removeClass('curr');
                    $keyword.val('');
                    $cid.val(cid);
                    $plist.empty();
                    that.pageNum = 1;
                    that.me.unlock();
                    that.me.noData(false);
                    that.getData({categoryId: cid});
                    return false;
                })

                // 搜索
                $('#search').on('click', function(){
                    $cid.val('');
                    $plist.empty();
                    that.pageNum = 1;
                    that.me.unlock();
                    that.me.noData(false);
                    that.getData({keyword: $keyword.val()});
                    return false;
                });
            },
            loadPlist: function() {
                var that = this;
                that.pageNum = 1; // 当前页

                that.me = $('.ui-content').dropload({
                    scrollArea: window,
                    threshold: 50,
                    loadDownFn: function(){
                        that.getData({
                            pageNum: that.pageNum, 
                            categoryId: $('#categoryId').val(), 
                            keyword: $('#keyword').val()
                        });
                    }
                });
            },
            getData: function(parameter) {
                var that = this;
                $.ajax({
                    type: 'POST',
                    url: 'commodity/list',
                    dataType: 'json',
                    data: parameter,
                    success: function(res){
                        if (res.data.isLastPage) {
                            that.me.lock();
                            that.me.noData();
                            if (res.data.list.length === 0) {
                                // 没有商品
                                me.$domDown.hide();
                            }
                        }
                        that.toHtml(res.data.list);
                        that.pageNum ++;
                    },
                    error: function(xhr, type){
                        popover('网络连接超时，请您稍后重试!');
                    },
                    complete: function() {
                        that.me.resetload();
                    }
                });
            },
            toHtml: function(data) {
                var html = [];
                $.each(data, function(i, item) {
                    html.push('<li>\n');
                    html.push( '<a href="/commodity/detail/' + item.id + '">\n');
                    html.push(     '<div class="cnt">\n');
                    html.push(         '<div class="title">', item.name, '</div>\n');
                    html.push(         '<div class="summary">', item.title, '</div>\n');
                    html.push(         '<div class="price">\n');
                    html.push(              '<i>&yen;</i>\n');
                    html.push(              '<em>', item.price, '</em>\n');
                    html.push(              '<b>', item.unitName, '</b>\n');
                    html.push(          '</div>\n');
                    html.push(     '</div>');
                    html.push(     '<div class="pic"><img src="', item.thumbnailUrl, '" width="110" height="90" alt="', item.title, '"></div>\n');
                    html.push( '</a>\n');
                    html.push('</li>');
                })
                $('#plist').append(html.join(''));
            },
            empty: function(isEmpty) {
                if (isEmpty) {
                    $('.ui-content').prepend('<div class="ui-notice ui-notice-extra"> \n 品种列表还没有商品，<br>去商品详情页面可以添加商品到选货单！ \n <a class="ubtn ubtn-primary" href="/">返回首页</a> \n </div>');
                }
            }
        }
    }

    $(function(){
        _global.fn.init();
    });

</script>
</body>
</html>