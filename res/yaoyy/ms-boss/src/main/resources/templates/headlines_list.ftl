<!DOCTYPE html>
<html lang="en">
<head>
<#include "./common/meta.ftl"/>
<title>药商头条-药优优</title>
</head>
<body>
<div class="wrapper">
    <#include "./common/header.ftl"/>
    <#include "./common/aside.ftl"/>
    <div class="content">
        <div class="breadcrumb">
            <ul>
                <li>资讯管理</li>
                <li>药商头条</li>
            </ul>
        </div>

        <div class="box">
            <div class="tools">
                <div class="filter">
                    <form id="filterForm" method="get" action="/headlines/list">
                        <input type="text" name="title" class="ipt" placeholder="标题">
                        <button type="submit" class="ubtn ubtn-blue" id="search_btn">搜索</button>
                    </form>
                </div>

                <div class="action-add">
                    <a href="/headlines/create" class="ubtn ubtn-blue">新建药商头条</a>
                </div>
            </div>

            <div class="table">
                <table>
                    <thead>
                    <tr>
                        <th width="50"><input type="checkbox" class="cbx"></th>
                        <th>标题</th>
                        <th>标签</th>
                        <th>状态</th>
                        <th>访问量</th>
                        <th width="150">创建时间</th>
                        <th width="150">修改时间</th>
                        <th width="180" class="tc">操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <#list pageInfo.list as article>
                    <tr <#if article.status==0>class="gray"</#if>>
                        <td><input type="checkbox" class="cbx"></td>
                        <td>${article.title!}</td>
                        <td>${(article.tagStr)!}</td>
                        <td><#if article.status==0>草稿<#else >发布</#if></td>
                        <td>${article.hits!}</td>
                        <td>${(article.createTime?datetime)!}</td>
                        <td>${(article.updateTime?datetime)!}</td>
                        <td class="tc" data-id="${article.id}">
                            <a href="/headlines/editor/${article.id}" class="ubtn ubtn-blue jedit">编辑</a>
                            <a href="javascript:;" class="ubtn ubtn-gray jdel">删除</a>
                            <#if article.status == 0>
                                <a href="javascript:;" class="ubtn ubtn-red jputup">启用</a>
                            <#else>
                                <a href="javascript:;" class="ubtn ubtn-black jputdown">禁用</a>
                            </#if>
                        </td>
                    </tr>
                    </#list>
                    </tbody>
                </table>
            </div>
            <#import "./module/pager.ftl" as pager />
            <@pager.pager info=pageInfo url="headlines/list" params="" />
        </div>
    </div>
    
    <#include "./common/footer.ftl"/>
</div>

<script>
!(function($, window) {
    var _global = {
        deleteUrl  : '/cms/delete/',
        enableUrl  : '/cms/enable/',
        disableUrl : '/cms/disable/',
        init: function() {
            navLight('11-3');
            this.bindEvent();
        },
        bindEvent: function() {
            var that = this,
                $table = $('.table');

            that.enable = true; // 防止重复提交

            var response = function(url, data, type) {
                $.ajax({
                    type: type || 'POST',
                    url: url,
                    dataType: 'json',
                    data: data || {},
                    beforeSend: function() {
                        that.enable = false;
                    },
                    success: function(data) {
                        data.status == 200 && window.location.reload();
                    },
                    complete: function() {
                        that.enable = true;
                    }
                })
            }

            // 删除
            $table.on('click', '.jdel', function() {
                var url = that.deleteUrl + $(this).parent().data('id');

                layer.confirm('确认删除此文章？', {icon: 3}, function (index) {
                    response(url, {}, 'GET');
                });
                return false;
            })

            // 上架
            $table.on('click', '.jputup', function() {
                var url = that.enableUrl + $(this).parent().data('id');

                layer.confirm('确认启用此文章？', {icon: 3}, function (index) {
                    response(url);
                });
                return false;
            })

            // 下架
            $table.on('click', '.jputdown', function() {
                var url = that.disableUrl + $(this).parent().data('id');

                layer.confirm('确认禁用此文章？', {icon: 3}, function (index) {
                    response(url);
                });
                return false;
            })
        }
    }
    _global.init();
})(window.Zepto||window.jQuery, window);
</script>
</body>
</html>