<!DOCTYPE html>
<html lang="en">
<head>
<#include "./common/meta.ftl"/>
<title>供应商列表-药优优</title>
</head>
<body>
<div class="wrapper">

    <#include "./common/header.ftl"/>
    <#include "./common/aside.ftl"/>

    <div class="content">
        <div class="breadcrumb">
            <ul>
                <li>供应商管理</li>
                <li>供应商列表</li>
            </ul>
        </div>

        <div class="box">
            <div class="tools">
                <div class="filter">
                    <form action="" id="searchForm">
                        <input type="text" name="name"class="ipt" value="${(supplierVo.name)!}" placeholder="姓名">
                        <button class="ubtn ubtn-blue" id="search">搜索</button>
                    </form>
                </div>
                <div class="action-add">
                    <a href="/supplier/create" class="ubtn ubtn-blue">新建供应商</a>
                </div>
            </div>

            <div class="table">
                <table>
                    <thead>
                        <tr>
                            <th><input type="checkbox" class="cbx"></th>
                            <th>姓名</th>
                            <th>入驻品种</th>
                            <th>手机号</th>
                            <th>地区</th>
                            <th>入驻时间</th>
                            <th width="170" class="tc">操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <#list supplierVoPageInfo.list as supplier>
                        <tr>
                            <td><input type="checkbox" class="cbx"></td>
                            <td>${supplier.name}</td>
                            <td>${supplier.enterCategoryText}</td>
                            <td>${supplier.phone}</td>
                            <td>${supplier.area}</td>
                            <td>${(supplier.createTime?datetime)!}</td>
                            <td class="tc">
                                <a href="/supplier/detail/${supplier.id}" class="ubtn ubtn-blue jedit">编辑</a>
                            </td>
                        </tr>
                        </#list>
                    </tbody>
                </table>
            </div>
            <#import "./module/pager.ftl" as pager />
            <@pager.pager info=supplierVoPageInfo url="/supplier/list" params="" />
        </div>
    </div>

    <#include "./common/footer.ftl"/>

<script>
    var _global = {
        v: {
            listUrl: '/supplier/list'
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
                var $search=$("#search");

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

                $search.on('click',function () {
                    var params = [];
                    $("#searchForm .ipt").each(function() {
                        var val = $.trim(this.value);
                        val && params.push($(this).attr('name') + '=' + val);
                    })
                    location.href=_global.v.listUrl+'?'+params.join('&');
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