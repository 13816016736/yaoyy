package com.ms.biz.shiro;

import com.ms.biz.config.WebConfig;
import com.ms.dao.config.MyBatisConfig;
import com.ms.service.redis.RedisConfig;
import com.ms.service.redis.RedisManager;
import com.ms.service.shiro.CacheManager;
import com.ms.service.shiro.MsShiroFilterFactoryBean;
import com.ms.service.shiro.ShiroRedisCacheManager;
import org.apache.shiro.spring.LifecycleBeanPostProcessor;
import org.apache.shiro.spring.security.interceptor.AuthorizationAttributeSourceAdvisor;
import org.apache.shiro.web.mgt.DefaultWebSecurityManager;
import org.springframework.aop.framework.autoproxy.DefaultAdvisorAutoProxyCreator;
import org.springframework.boot.autoconfigure.AutoConfigureAfter;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.filter.DelegatingFilterProxy;

import java.util.LinkedHashMap;
import java.util.Map;


@Configuration
@AutoConfigureAfter({RedisConfig.class, WebConfig.class, MyBatisConfig.class})
public class ShiroConfiguration {

    private static Map<String, String> filterChainDefinitionMap = new LinkedHashMap<String, String>();

    @Bean
    public FilterRegistrationBean filterRegistrationBean() {
        FilterRegistrationBean filterRegistration = new FilterRegistrationBean();
        filterRegistration.setFilter(new DelegatingFilterProxy("shiroFilter"));
        //  该值缺省为false,表示生命周期由SpringApplicationContext管理,设置为true则表示由ServletContainer管理
        filterRegistration.addInitParameter("targetFilterLifecycle", "true");
        filterRegistration.setEnabled(true);
        filterRegistration.addUrlPatterns("/*");
        return filterRegistration;
    }

    @Bean(name = "cacheManager")
    public ShiroRedisCacheManager getCacheManager(RedisManager redisManager) {
        ShiroRedisCacheManager shiroRedisCacheManager = new ShiroRedisCacheManager();
        shiroRedisCacheManager.setRedisManager(redisManager);
        shiroRedisCacheManager.setApplicationPrefix("biz:");
        shiroRedisCacheManager.setExpire(3600);
        return shiroRedisCacheManager;
    }

    @Bean(name = "credentialsMatcher")
    public RetryLimitHashedCredentialsMatcher getCredentialsMatcher(ShiroRedisCacheManager cacheManager) {
        RetryLimitHashedCredentialsMatcher retryLimitHashedCredentialsMatcher = new RetryLimitHashedCredentialsMatcher(cacheManager);
        retryLimitHashedCredentialsMatcher.setRetryCounterCacheName("retryCounter");
        return retryLimitHashedCredentialsMatcher;
    }

    @Bean(name = "bizRealm")
    public BizRealm getShiroRealm(CacheManager cacheManager, RetryLimitHashedCredentialsMatcher credentialsMatcher) {
        BizRealm realm =  new BizRealm();
        realm.setCredentialsMatcher(credentialsMatcher);
//        realm.setAuthenticationCachingEnabled(true);
//        realm.setAuthenticationCacheName("yaoyy_biz_authenticationCache");
//        // realm.setAuthorizationCacheName("yaoyy_biz_authorizationCache");
//        realm.setAuthorizationCachingEnabled(false);
//        realm.setCacheManager(cacheManager);
        return realm;
    }

    @Bean(name = "lifecycleBeanPostProcessor")
    public LifecycleBeanPostProcessor getLifecycleBeanPostProcessor() {
        return new LifecycleBeanPostProcessor();
    }

//    @Bean
//    public DefaultAdvisorAutoProxyCreator getDefaultAdvisorAutoProxyCreator() {
//        DefaultAdvisorAutoProxyCreator daap = new DefaultAdvisorAutoProxyCreator();
//        daap.setProxyTargetClass(true);
//        return daap;
//    }

    @Bean(name = "securityManager")
    public DefaultWebSecurityManager getDefaultWebSecurityManager(BizRealm realm) {
        DefaultWebSecurityManager dwsm = new DefaultWebSecurityManager();
        dwsm.setRealm(realm);
        return dwsm;
    }

    @Bean
    public AuthorizationAttributeSourceAdvisor getAuthorizationAttributeSourceAdvisor(DefaultWebSecurityManager defaultWebSecurityManager) {
        AuthorizationAttributeSourceAdvisor aasa = new AuthorizationAttributeSourceAdvisor();
        aasa.setSecurityManager(defaultWebSecurityManager);
        return new AuthorizationAttributeSourceAdvisor();
    }

    @Bean(name = "bizAuthorizationFilter")
    public BizAuthorizationFilter bizAuthorizationFilter(){
        BizAuthorizationFilter biz = new BizAuthorizationFilter();
        return biz;
    }

    @Bean(name = "shiroFilter")
    public MsShiroFilterFactoryBean getMsShiroFilterFactoryBean(DefaultWebSecurityManager defaultWebSecurityManager) {
        MsShiroFilterFactoryBean shiroFilterFactoryBean = new MsShiroFilterFactoryBean();
        shiroFilterFactoryBean
                .setSecurityManager(defaultWebSecurityManager);
        shiroFilterFactoryBean.setLoginUrl("/user/login");
        shiroFilterFactoryBean.setSuccessUrl("/");
        shiroFilterFactoryBean.setUnauthorizedUrl("/error/403");
        shiroFilterFactoryBean.setFiltersString("bizAuthorization=bizAuthorizationFilter");

        shiroFilterFactoryBean.setFilterChainDefinitionsString("/user/login=anon;" +
                "/user/logout=logout;" +
                "/user/updatePassword=bizAuthorization;" +
                "/apply/sample=anon;"  +
                "/assets/**=anon;" +
                "/error/**=anon;" +
                "/sample/** = bizAuthorization;" +
                "/center/**=bizAuthorization;" +
                "/follow/**=bizAuthorization;" +
                "/pick/**=bizAuthorization;" +
                "/follow/**=bizAuthorization;" +
                "/bill/**=bizAuthorization;" +
                "/supplier/**=bizAuthorization;" +
                "/message/**=bizAuthorization;" +
                "/**=anon;");
        return shiroFilterFactoryBean;
    }

}
