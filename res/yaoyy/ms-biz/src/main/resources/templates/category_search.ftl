<!DOCTYPE html>
<html lang="en">
<head>
    <title>搜索-药优优</title>
    <#include "./common/meta.ftl"/>
</head>
<body class="ui-body-nofoot body-gray">
<header class="ui-header">
    <div class="title">搜索</div>
    <div class="abs-l mid">
        <a href="javascript:history.back();" class="fa fa-back"></a>
    </div>
</header>
<div class="ui-content">
    <div class="ui-search">
        <div class="form">
            <form action="category/list">
                <input type="text" name="name" id="keyword" class="ipt" placeholder="请输入原药材品种名称" autocomplete="off">
                <button type="submit" id="submit" class="fa fa-search submit mid"></button>
            </form>
            <div class="suggest">
                <div class="suggest-panel"></div>
                <div class="suggest-close">关闭</div>
            </div>
        </div>
    </div>

    <div class="search-his" id="searchHistory"></div>
</div>

<#include "./common/footer.ftl"/>
<script src="${urls.getForLookupPath('/assets/js/layer.js')}"></script>
<script>

    var _global = {
        v: {
            searchHistoryName: 'searchhistory',
            searchCategoryUrl:'category/search'
        },
        fn: {
            init: function() {
                this.showHistory();
                this.searchForm();
                this.autocomplete();
            },
            showHistory: function() {
                var self = this;
                var html = [];
                var his = _YYY.localstorage.get(_global.v.searchHistoryName);
                var h = [];

                if (his) {
                    html.push('<ul>');
                    h = his.split(',');
                    for (var i in h) {
                        if (!h[i]) {
                            continue;
                        }
                        html.push('<li><i class="fa fa-clock"></i>');
                        html.push('<span>' + h[i] + '</span>');
                        html.push('<em class="fa fa-del mid"></em>');
                        html.push("</li>");
                        if (i > 3) {
                            break;
                        }
                    }
                    html.push('<li class="clear">清除搜索历史记录</li>');
                    html.push("</ul>");
                    self.historyBind();
                }
                $('#searchHistory').html(html.join(''));
            },
            historyBind: function() {
                var self = this,
                        $searchHistory = $('#searchHistory');
                // 清空搜索历史
                $searchHistory.on('click', '.clear', function() {
                    layer.open({
                        className: 'layer-custom',
                        content: '确定要清空吗？',
                        btn: ['确定', '取消'],
                        yes: function(index) {
                            self.clearHistory();
                            $searchHistory.html('');
                            layer.close(index);
                        }
                    });
                    return false;
                })

                // 删除搜索历史
                $searchHistory.on('click', '.fa-del', function() {
                    var his = _YYY.localstorage.get(_global.v.searchHistoryName) || '';
                    var val = $(this).parent().find('span').html();
                    his = (',' + his).replace(',' + val, '');
                    _YYY.localstorage.set(_global.v.searchHistoryName, his.substring(1));
                    self.showHistory();
                    return false;
                })

                // keyword
                $searchHistory.on('click', 'li', function() {
                    $('#keyword').val($(this).find('span').html());
                })
            },
            // 添加一条历史记录
            addHistory: function(val) {
                var his = _YYY.localstorage.get(_global.v.searchHistoryName) || '';
                if (his) {
                    his = (',' + his).replace(',' + val, '');
                    his = val + ',' + his.substring(1);
                } else {
                    his = val;
                }
                _YYY.localstorage.set(_global.v.searchHistoryName, his);
            },
            clearHistory: function() {
                _YYY.localstorage.remove(_global.v.searchHistoryName);
            },
            searchForm: function() {
                var self = this;
                $('#submit').on('click', function() {
                    var val = $.trim($('#keyword').val());
                    val && self.addHistory(val);
                })
            },
            autocomplete: function() {
                var t,
                    self = this,
                    $suggestions = $('.suggest');
                var search = function() {
                    if($('#keyword').val()!=""){
                        $.ajax({
                            url: _global.v.searchCategoryUrl,
                            type:"POST",
                            data:{name:$('#keyword').val()},
                            success: function(data) {
                                if(data.data.length!=0){
                                    var model = [];
                                    $.each(data.data, function(i, item) {
                                        model.push('<a href="category/list/?name=' ,item.name ,'">', item.name, '</a>');
                                    })
                                    if (model.length === 0) {
                                        model.push('<span>暂无此商品</span>');
                                    }
                                    $suggestions.show().find('.suggest-panel').html(model.join(''));
                                }
                            }
                        })
                    }
                }
                var _s = function() {
                    t && clearTimeout(t);
                    t = setTimeout(function() {
                        search();
                    }, 300);
                }
                $('#keyword').on('input', _s);

                // 添加历史记录
                $suggestions.on('click', 'a', function() {
                    self.addHistory($(this).html());
                })

                // 关闭
                $suggestions.on('click', '.suggest-close', function() {
                    $suggestions.hide();
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