<!DOCTYPE html>
<html lang="en">
<head>
    <title>药优优-优选好药 底价直采</title>
<#include "./common/meta.ftl"/>
</head>
<body class="ui-body body-gray">
<header class="ui-header">
    <div class="logo">药优优药材商城</div>
    <div class="abs-r mid">
        <a href="category/search"><i class="fa fa-search"></i></a>
    </div>
</header><!-- /ui-header -->
<#include "./common/navigation.ftl">
<section class="ui-content">

    <div class="ui-slide" id="slide1">
        <ul>
            <#list banners as banner>
                <li><a href="${banner.href!}"><img src="${banner.pictureUrl!}" alt="${banner.name!}"></a></li>
            </#list>
        </ul>
    </div>

    <#list specials as special>
        <div class="ui-floor">
            <a href="${special.href!}"><img src="${special.pictureUrl!}" alt="${special.name!}"></a>
        </div>
    </#list>


</section><!-- /ui-content -->
<#include "./common/footer.ftl"/>
<script>

    var _global = {
        fn: {
            init: function() {
                this.slide();
                this.sideQrcode();
            },
            slide: function() {
                var $slide = $('#slide1'),
                        $nav,
                        length = $slide.find('li').length;

                if (length < 2) {
                    return;
                }
                var nav = ['<div class="nav">'];
                for (var i = 0 ; i < length; i++) {
                    nav.push( i === 0 ? '<i class="current"></i>' : '<i></i>');
                }
                nav.push('</div>');
                $slide.append(nav.join(''));
                $nav = $slide.find('i');

                $slide.swipeSlide({
                    autoSwipe: true,
                    firstCallback : function(i){
                        $nav.eq(i).addClass('current').siblings().removeClass('current');
                    },
                    callback : function(i){
                        $nav.eq(i).addClass('current').siblings().removeClass('current');
                    }
                });
            },
            sideQrcode: function() {
                var isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
                if (!isMobile) {
                    $('body').append('<div class="sideQrcode"><span>微信“扫一扫”立即关注</span><img src="/assets/images/qrcode.png" width="150" height="150"><span>微信号：药优优</span></div>');
                }
            }
        }
    }

    $(function(){
        _global.fn.init();

    });

</script>
<script>
    var weixinShare = {
        appId: '${signature.appid!}',
        title: '优选好药 底价直采《药优优》',
        desc: '药优优——原药材销售平台 优选好药，底价直采！ 质量保障，价格保障，货源保障！',
        link: '${signature.url!}',
        imgUrl: "${baseUrl}/assets/images/logo3.jpg",
        timestamp: ${signature.timestamp?string("#")},
        nonceStr: '${signature.noncestr!}',
        signature: '${signature.signature!}'
    }
</script>
<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script src="${urls.getForLookupPath('/assets/js/weixin_share.js')}"></script>

</body>
</html>