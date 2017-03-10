    <!-- 侧栏菜单 -->
    <div class="sidebar">
        <dl>
            <dt>
                <a href="index"><i class="fa fa-dashboard"></i>控制面板</a>
            </dt>
        </dl>
        <@shiro.hasPermission name="specialad:index">
        <dl>
            <dt>
                <a href="javascript:;">
                    <i class="fa fa-star"></i>
                    <span>专场广告</span>
                    <i class="fa fa-angle-down arrow"></i>
                </a>
            </dt>
            <dd>
            <@shiro.hasPermission name="special:list">
                <a href="special/list"><i class="fa fa-circle-o"></i>专场列表</a>
            </@shiro.hasPermission>
            <@shiro.hasPermission name="ad:list">
                <a href="ad/list"><i class="fa fa-circle-o"></i>广告列表</a>
            </@shiro.hasPermission>
            </dd>
        </dl>
        </@shiro.hasPermission>
        <@shiro.hasPermission name="cms:index">
        <dl>
            <dt>
                <a href="javascript:;">
                    <i class="fa fa-file-text"></i>
                    <span>CMS管理</span>
                    <i class="fa fa-angle-down arrow"></i>
                </a>
            </dt>
            <dd>
                <@shiro.hasPermission name="cms:list">
                <a href="cms/list"><i class="fa fa-circle-o"></i>CMS列表</a>
                </@shiro.hasPermission>
            </dd>
        </dl>
        </@shiro.hasPermission>
        <@shiro.hasPermission name="user:index">
        <dl>
            <dt>
                <a href="javascript:;">
                    <i class="fa fa-user"></i>
                    <span>用户管理</span>
                    <i class="fa fa-angle-down arrow"></i>
                </a>
            </dt>
            <dd>
                <@shiro.hasPermission name="user:list">
                <a href="/user/list"><i class="fa fa-circle-o"></i>用户列表</a>
                </@shiro.hasPermission>
            </dd>
        </dl>
        </@shiro.hasPermission>
        <@shiro.hasPermission name="sample:index">
        <dl>
            <dt>
                <a href="javascript:;">
                    <i class="fa fa-truck"></i>
                    <span>寄样服务</span>
                    <i class="fa fa-angle-down arrow"></i>
                </a>
            </dt>
            <dd>
                <@shiro.hasPermission name="sample:list">
                    <a href="/sample/list"><i class="fa fa-circle-o"></i>寄样列表</a>
                </@shiro.hasPermission>
            </dd>
        </dl>
        </@shiro.hasPermission>
        <@shiro.hasPermission name="pick:index">
        <dl>
            <dt>
                <a href="javascript:;">
                    <i class="fa fa-shopping-bag"></i>
                    <span>订单管理</span>
                    <i class="fa fa-angle-down arrow"></i>
                </a>
            </dt>
            <dd>
                <@shiro.hasPermission name="pick:list">
                <a href="/pick/list"><i class="fa fa-circle-o"></i>订单列表</a>
                </@shiro.hasPermission>
            </dd>
        </dl>
        </@shiro.hasPermission>
        <@shiro.hasPermission name="commodity:index">
        <dl>
            <dt>
                <a href="javascript:;">
                    <i class="fa fa-cart-plus"></i>
                    <span>商品管理</span>
                    <i class="fa fa-angle-down arrow"></i>
                </a>
            </dt>
            <dd>
                <@shiro.hasPermission name="category:list">
                    <a href="/category/list"><i class="fa fa-circle-o"></i>品种列表</a>
                </@shiro.hasPermission>
                <@shiro.hasPermission name="commodity:list">
                    <a href="/commodity/list"><i class="fa fa-circle-o"></i>商品列表</a>
                </@shiro.hasPermission>
            </dd>
        </dl>
        </@shiro.hasPermission>
        <@shiro.hasPermission name="memberole:index">
        <dl>
            <dt>
                <a href="javascript:;">
                    <i class="fa fa-list"></i>
                    <span>账号权限</span>
                    <i class="fa fa-angle-down arrow"></i>
                </a>
            </dt>
            <dd>
                <@shiro.hasPermission name="member:list">
                    <a href="/member/index"><i class="fa fa-circle-o"></i>管理员列表</a>
                </@shiro.hasPermission>
                <@shiro.hasPermission name="role:list">
                    <a href="/role/index"><i class="fa fa-circle-o"></i>角色列表</a>
                </@shiro.hasPermission>
            </dd>
        </dl>
        </@shiro.hasPermission>
       <@shiro.hasPermission name="supplier:index">
        <dl>
            <dt>
                <a href="javascript:;">
                    <i class="fa fa-users"></i>
                    <span>供应商管理</span>
                    <i class="fa fa-angle-down arrow"></i>
                </a>
            </dt>
            <dd>
                <@shiro.hasPermission name="supplier:list">
                <a href="/supplier/list"><i class="fa fa-circle-o"></i>未签约供应商</a>
                </@shiro.hasPermission>
                <a href="/supplier/signlist"><i class="fa fa-circle-o"></i>签约供应商</a>
                <a href="/supplier/stock"><i class="fa fa-circle-o"></i>寄卖库存管理</a>
                <a href="/supplier/commodity"><i class="fa fa-circle-o"></i>寄卖商品列表</a>
                <a href="/supplier/order"><i class="fa fa-circle-o"></i>寄卖订单列表</a>
            </dd>
        </dl>
        </@shiro.hasPermission>


    <@shiro.hasPermission name="pay:index">
        <dl>
            <dt>
                <a href="javascript:;">
                    <i class="fa fa-money"></i>
                    <span>账单流水管理</span>
                    <i class="fa fa-angle-down arrow"></i>
                </a>
            </dt>
            <dd>
                <@shiro.hasPermission name="payRecord:list">
                    <a href="/payRecord/list"><i class="fa fa-circle-o"></i>交易流水列表</a>
                </@shiro.hasPermission>
                <@shiro.hasPermission name="bill:list">
                    <a href="/bill/list"><i class="fa fa-circle-o"></i>账单列表</a>
                </@shiro.hasPermission>
            </dd>
        </dl>
    </@shiro.hasPermission>
    <@shiro.hasPermission name="setting:all">
        <dl>
            <dt>
                <a href="javascript:;">
                    <i class="fa fa-cog"></i>
                    <span>系统设置</span>
                    <i class="fa fa-angle-down arrow"></i>
                </a>
            </dt>
            <dd>
                <a href="/setting"><i class="fa fa-circle-o"></i>系统设置</a>
            </dd>
        </dl>
    </@shiro.hasPermission>
       <@shiro.hasPermission name="quotation:index">
        <dl>
            <dt>
                <a href="javascript:;">
                    <i class="fa fa-flag"></i>
                    <span>资讯管理</span>
                    <i class="fa fa-angle-down arrow"></i>
                </a>
            </dt>
            <dd>
               <@shiro.hasPermission name="quotation:list">
                <a href="/quotation/list"><i class="fa fa-circle-o"></i>报价单列表</a>
               </@shiro.hasPermission>
                <a href="/announcement/list"><i class="fa fa-circle-o"></i>网站公告</a>
            </dd>
        </dl>
       </@shiro.hasPermission>

    </div>