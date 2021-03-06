<!DOCTYPE html>
<html lang="en">
<head>
<#include "./common/meta.ftl"/>
<title>报价单详情-药优优</title>
</head>
<body>
<div class="wrapper">
    <#include "./common/header.ftl"/>
    <#include "./common/aside.ftl"/>
    <div class="content">
        <div class="breadcrumb">
            <ul>
                <li>报价单管理</li>
                <li>报价单详情</li>
            </ul>
        </div>

        <div class="box fa-form">
            <form id="myform">
                <input type="hidden" name="id" id="qid" value="${(quotation.id)!}">
                <div class="item">
                    <div class="txt"><i>*</i>标题：</div>
                    <div class="cnt">
                        <input type="text" name="title" value="${(quotation.title)!}" class="ipt" placeholder="请输入标题" autocomplete="off">
                    </div>
                </div>
                <div class="item">
                    <div class="txt">品种：</div>
                    <div class="cnt">
                        <input type="text" id="breed" class="ipt" placeholder="请输入品种" autocomplete="off">
                        <button type="button" class="ubtn ubtn-blue">添加到报价清单</button>
                    </div>
                </div>
                <div class="item">
                    <div class="txt"><i>*</i>报价清单：</div>
                    <div class="cnt table" id="quoteList"></div>
                </div>
                <div class="item">
                    <div class="txt">报价单描述：</div>
                    <div class="cnt">
                        <script id="description" name="description" type="text/plain">
                       ${(quotation.description)!}
                        </script>
                        <span id="describeError"></span>
                    </div>
                </div>

                <div class="ft">
                    <button type="button" class="ubtn ubtn-blue" id="jsubmit">保存草稿</button>
                    <button type="button" class="ubtn ubtn-red" id="jpublish">直接发布</button>
                </div>
            </form>
        </div>
    </div>

    <#include "./common/footer.ftl"/>
</div>

<script src="assets/js/jquery.autocomplete.js"></script>
<script src="assets/plugins/validator/jquery.validator.min.js"></script>
<link href="assets/plugins/umeditor/themes/default/css/umeditor.css" rel="stylesheet">
<script src="assets/plugins/umeditor/umeditor.config.js"></script>
<script src="assets/plugins/umeditor/umeditor.min.js"></script>
<script src="assets/plugins/umeditor/lang/zh-cn/zh-cn.js"></script>
<script>
    var  status=1;//直接发布

    var _global = {
        v: {
            flag: false
        },
        fn: {
            init: function() {
                navLight('11-1');
                this.checkForm();
                this.searchBreeds();
                this.bindEvent();
            },
            checkForm: function() {
                var _enable = true,
                    $myform = $('#myform');

                // 表单验证
                $myform.validator({
                    fields: {
                        title: '标题: required',
                    },
                    valid: function(form) {
                        // 验证成功
                        if (!_enable) {
                            return;
                        }
                        _enable = false;
                        var data = $myform.serializeObject();
                        data.status=status;
                        if($("#qid").val()==""){
                            delete data["id"];
                        }


                        var quoteList=[];
                        $("#quoteList").find('table').each(function(){
                             var quote={};
                             quote.categoryName=$(this).find("tr th.cat").text();
                             quote.categoryId=$(this).find("tr th.cat").attr("cid");
                             var attributes=[];
                             $(this).find("tr.attrName th").each(function(index){
                                 var attrName=$(this).find('input').val();
                                 if(index==3){
                                     return;
                                 }
                                 attributes.push(attrName);
                             });
                             var tbodyValues=[];
                             $(this).find("tbody tr").each(function(){
                                 var attrValue={};
                                 var commdityId=$(this).attr("id");
                                 attrValue.commdityId=commdityId;
                                 var values=[];
                                 $(this).find("td").each(function (index) {
                                     if(index==3){
                                         return;
                                     }
                                     var attval=$(this).find('input').val();
                                     values.push(attval);
                                 })
                                 attrValue.values=values;
                                 tbodyValues.push(attrValue);
                            })

                             quote.attributes= attributes;
                             quote.attrValues= tbodyValues;
                             quoteList.push(quote);

                        })
                        if(quoteList.length==0){
                            $.notify({
                                type: 'error',
                                title: '添加失败',
                                text: '报价清单必须填写'
                            });
                            return;
                        }
                        data.content=JSON.stringify(quoteList);

                        $.ajax({
                            url: "/quotation/save",
                            type: "POST",
                            contentType : 'application/json',
                            data: JSON.stringify(data),
                            success: function(result) {
                                if (result.status == "200") {
                                    $.notify({
                                        type: 'success',
                                        title: '操作成功',
                                        callback: function() {
                                            location.href = '/quotation/list';
                                        }
                                    });
                                }
                                _enable = true;
                            }
                        })
                    }
                });
                //实例化编辑器
                <#if quotation?exists>
                var um = UM.getEditor('description', {
                        initialFrameWidth: isMobile ? '100%' : 750,
                        initialFrameHeight: 320
                    });
                <#else>
                    var um = UM.getEditor('description', {
                        initialFrameWidth: isMobile ? '100%' : 750,
                        initialFrameHeight: 320
                    }).setContent("");
                </#if>

               <#if quotation?exists && quotation.content != "">
                   var $quoteList = $('#quoteList');
                   var model = [];
                   $.each(${quotation.content}, function (index,contentItem) {
                       model.push('<table class="tc" id="table' , contentItem.categoryId , '">');
                       model.push('<thead>');
                       model.push('<tr><th colspan="4" class="tl" cid="',contentItem.categoryId ,'">' , contentItem.categoryName , '</th></tr>');
                       model.push('<tr class="attrName"> ');
                       $.each(contentItem.attributes, function(ai, item) {
                           model.push('<th><div class="ipt-wrap"><input class="ipt" placeholder="自定义" value="',item,'" type="text"></div></th> ');
                       })
                       model.push('<th>操作</th></tr></thead><tbody>');

                       $.each(contentItem.attrValues, function(i, item) {
                           model.push('<tr id="' , item.commdityId , '">');
                           $.each(item.values,function(index, val){
                               model.push('<td><div class="ipt-wrap"><input class="ipt" type="text" value="',val,'"></div></td> ');
                           })
                           model.push('<td><button type="button" class="ubtn ubtn-blue del">删除</button></td>');
                           model.push('</tr>')

                       })
                       model.push('</tbody>');
                       model.push('<tfoot class="tc">');
                       model.push('<tr><td colspan="4"><a href="javascript:;" class="c-blue add" data-id="' , contentItem.categoryId , '">+添加一个规格</a></td></tr>');
                       model.push('</tfoot>');
                       model.push('</table>');
                    })
                   $quoteList.append(model.join(''));
                </#if>
            },
            bindEvent:function(){
                $("#jsubmit").click(function () {
                    status=0;
                    $("#myform").submit();
                });

                $("#jpublish").click(function () {
                    status=1;
                    $("#myform").submit();
                });
            },
            // 查询品种
            searchBreeds: function() {
                var self = this;
                vals = [],
                        timer = 0,
                        breedId = 0,
                        $breed = $('#breed');

                $breed.autocomplete({
                    serviceUrl: 'category/search',
                    paramName: 'name',
                    deferRequestBy: 100,
                    showNoSuggestionNotice: true,
                    noSuggestionNotice: '没有该品种',
                    transformResult: function (response) {
                        response = JSON.parse(response);
                        if (response.status == "200") {
                            return {
                                suggestions: $.map(response.data, function (dataItem) {
                                    return {value: dataItem.name, data: dataItem.id};
                                })
                            };
                        } else {
                            return {
                                suggestions: []
                            }
                        }
                    },
                    onSelect: function (suggestion) {
                        breedId = suggestion.data;
                    }
                });

                // 添加到报价单
                $breed.next().on('click', function() {
                    if ($('#table' + breedId).length === 1) {
                        $.notify({
                            type: 'error', 
                            title: '添加失败',
                            text: '此品种已在报价清单中'
                        });
                        return false;
                    }
                    $.ajax({
                        url: '/commodity/getByCategory',
                        data: {categoryId: breedId},
                        type: 'POST',
                        success: function(res) {
                            $breed.val('');
                            res.data && res.data.length > 1 && self.toHtml(res.data);
                        }
                    })
                })

                // 删除报价清单商品
                $('#quoteList').on('click', '.del', function() {
                    var $pa = $(this).closest('tr');
                    if ($pa.siblings().length === 0) {
                        $pa.closest('table').remove();
                    } else {
                        $pa.closest('table').find('tfoot').show();
                        $pa.remove();
                    }
                })

                // 添加一个规格
                $('#quoteList').on('click', '.add', function() {
                    if (_global.v.flag) {
                        return false;
                    }
                    _global.v.flag = true;
                    self.showinfo($(this).data('id'));
                    return false; // 阻止链接跳转
                })
            },
            toHtml: function(json) {
                var 
                    commodity      = json[0],
                    categoryId     = commodity.categoryId;
                    categoryName   = commodity.categoryName;
                    categoryOrigin = commodity.origin,
                    model          = [];

                model.push('<table class="tc" id="table' , categoryId , '">');
                model.push('<thead>');
                model.push('<tr><th colspan="4" class="tl" cid="', categoryId ,'">' , categoryOrigin, '  ', categoryName , '</th></tr>');
                model.push('<tr class="attrName"><th><div class="ipt-wrap"><input class="ipt" placeholder="自定义" value="规格" type="text"></div></th>' +
                        '<th><div class="ipt-wrap"><input class="ipt" placeholder="自定义" value="药优优报价" type="text"></div></th>' +
                        '<th><div class="ipt-wrap"><input class="ipt" placeholder="自定义" value="亳州市场价" type="text"></div></th> \n <th>操作</th></tr>');
                model.push('</thead>');
                model.push('<tbody>');
                $.each(json, function(i, item) {
                    model.push('<tr id="' , item.id , '"><td><div class="ipt-wrap"><input class="ipt" value="',  item.spec ,'"type="text"></div> </td>' +
                            '<td><div class="ipt-wrap"><input class="ipt" value="' , item.price, '元/', item.unitName , '" type="text"></div></td>  ' +
                            '<td><div class="ipt-wrap"><input class="ipt" type="text"></div></td>' +
                            '<td><button type="button" class="ubtn ubtn-blue del">删除</button></td></tr>');
                })
                model.push('</tbody>');
                model.push('<tfoot class="hide tc">');
                model.push('<tr><td colspan="4"><a href="javascript:;" class="c-blue add" data-id="' , categoryId , '">+添加一个规格</a></td></tr>');
                model.push('</tfoot>');
                model.push('</table>');
                $('#quoteList').prepend(model.join(''));
            },
            showinfo: function(id) {
                var showBox = function(data) {
                    var model = [];
                    var tr = {};
                    $.each(data, function(i, item) {
                        if ($('#' + item.id).length === 0) {
                            model.push('<li>');
                            model.push('<div class="info">' , item.spec , '</div>');
                            model.push('<div class="price">' , item.price , '</div>');
                            model.push('<div class="edit"><button type="button" class="ubtn ubtn-blue join" data-iid="' , item.id , '">添加</button></div>');
                            model.push('</li>');
                            tr[item.id] = '<tr id="'+item.id + '"><td><div class="ipt-wrap"><input class="ipt" value=" '+item.spec +'"type="text"></div> </td>' +
                            '<td><div class="ipt-wrap"><input class="ipt" value="' + item.price+'元/'+item.unitName + '" type="text"></div></td>  ' +
                            '<td><div class="ipt-wrap"><input class="ipt" type="text"></div></td>' +
                            '<td><button type="button" class="ubtn ubtn-blue del">删除</button></td></tr>';
                        }
                    })
                    layer.closeAll();
                    if (model.length === 0) {
                        $.notify({
                            type: 'error', 
                            title: '添加失败',
                            text: '所有商品已添加'
                        });
                        return;
                    }
                    model.unshift('<div class="group-choose"><ul>');
                    model.push('</ul></div>');
                    layer.open({
                        skin: 'layer-form',
                        area: ['600px'],
                        type: 1,
                        content: model.join(''),
                        title: '添加规格'
                    });

                    $('.group-choose').on('click', '.join', function() {
                        var iid = $(this).data('iid');
                        if (tr[iid]) {
                            if ($(this).closest('li').siblings().length === 0) {
                                $('#table' + id).find('tbody').append(tr[iid]).next().hide();
                            } else {
                                $('#table' + id).find('tbody').append(tr[iid]);
                            }
                            layer.closeAll();
                        }
                    })
                }

                // 加载数据
                var k = $.ajax({
                    url: '/commodity/getByCategory',
                    data: {categoryId: id},
                    type:"POST",
                    success: function(response) {
                        showBox(response.data);
                    },
                    complete: function() {
                        _global.v.flag = false;
                    }
                })
                
                // 体验不好
                // loading
                layer.open({
                    area: ['200px'],
                    type: 1,
                    content: '<div class="layer-loading">加载中...</div>',
                    title: '添加规格',
                    cancel: function() {
                        k.abort();
                    }
                });
            },
            /**
             * [inArray 查询数组元素]
             * @param  {[string]} needle [查询值]
             * @param  {[Array]} array  [查询数组]
             * @param  {[bollen]} del    [选填，为true时删除该值]
             * @return {[bollen]}        [true or false]
             */
            inArray: function(needle, array, del) {
                if (typeof needle == 'string' || typeof needle == 'number') {
                    for (var i in array) {
                        if (array[i] == needle) {
                            del && array.splice(i, 1);
                            return true;
                        }
                    }
                }
                return false;
            }
        }
    }

    $(function() {
        _global.fn.init();
    })
</script>
</body>
</html>