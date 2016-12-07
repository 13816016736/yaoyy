<!DOCTYPE html>
<html lang="en">
<head>
    <title>报价单列表-boss</title>
    <#include "./common/meta.ftl"/>
</head>
<body class='wrapper'>

<<#include "./common/header.ftl"/>
<#include "./common/aside.ftl"/>

<div class="content">
    <div class="breadcrumb">
        <ul>
            <li>报价单管理</li>
            <li>报价单列表</li>
        </ul>
    </div>

    <div class="box">
        <div class="tools">
            <div class="filter">
                <form action="">
                    <input type="text" class="ipt" placeholder="标题">
                    <select name="" id="" class="slt">
                        <option value="">全部</option>
                        <option value="">草稿</option>
                        <option value="">发布</option>
                    </select>
                    <button class="ubtn ubtn-blue">搜索</button>
                </form>
            </div>
            <div class="action-add">
                <a href="/quotation/create" class="ubtn ubtn-blue">新建报价单</a>
            </div>
        </div>

        <div class="table">
            <table>
                <thead>
                <tr>
                    <th><input type="checkbox" class="cbx"></th>
                    <th>标题</th>
                    <th>状态</th>
                    <th>创建时间</th>
                    <th width="170" class="tc">操作</th>
                </tr>
                </thead>
                <tbody>
                <#list pageInfo.list as quotation>
                <tr <#if quotation.status==0>class="gray"</#if>>
                    <td><input type="checkbox" class="cbx"></td>
                    <td>${(quotation.title)!}</td>
                    <td>${(quotation.status)!}</td>
                    <td>${(quotation.createTime?datetime)!}</td>
                    <td class="tc">
                        <a href="/quotation/detail/${quotation.id}" class="ubtn ubtn-blue jedit">编辑</a>
                        <a href="javascript:;" class="ubtn ubtn-gray jdel">删除</a>
                        <#if quotation.status==0>
                            <a href="javascript:;" class="ubtn ubtn-red jpublish">发布</a>
                        <#else>
                            <a href="javascript:;" class="ubtn ubtn-red jpublish">草稿</a>
                        </#if>
                    </td>
                </tr>
                </#list>
                </tbody>
            </table>
        </div>

    <#import "./module/pager.ftl" as pager />
    <@pager.pager info=pageInfo url="/quotation/list" params="" />
    </div>
</div>

<#include "./common/footer.ftl"/>


<script>
    var _global = {
        v: {
            deleteUrl: ''
        },
        fn: {
            init: function() {
                this.bindEvent();
            },
            bindEvent: function() {
                var $table = $('.table'),
                        $cbx = $table.find('td input:checkbox'),
                        $checkAll = $table.find('th input:checkbox'),
                        count = $cbx.length;

                // 删除
                $table.on('click', '.jdel', function() {
                    var url = _global.v.deleteUrl + $(this).attr('href');
                    layer.confirm('确认删除此品种？', {icon: 3, title: '提示'}, function (index) {
                        $.get(url, function (data) {
                            if (data.status == "y") {
                                window.location.reload();
                            }
                        }, "json");
                        layer.close(index);
                    });
                    return false; // 阻止链接跳转
                })

                // 全选
                $checkAll.on('click', function() {
                    var isChecked = this.checked;
                    $cbx.each(function() {
                        this.checked = isChecked;
                    })
                })
                // 单选
                $cbx.on('click', function() {
                    var _count = 0;
                    $cbx.each(function() {
                        _count += this.checked ? 1 : 0;
                    })
                    $checkAll.prop('checked', _count === count);
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