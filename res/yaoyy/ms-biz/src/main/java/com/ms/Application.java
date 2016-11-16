package com.ms;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.context.embedded.ConfigurableEmbeddedServletContainer;
import org.springframework.boot.context.embedded.EmbeddedServletContainerCustomizer;
import org.springframework.boot.web.servlet.ErrorPage;
import org.springframework.boot.web.support.ErrorPageFilter;
import org.springframework.boot.web.support.SpringBootServletInitializer;
import org.springframework.context.annotation.Bean;
import org.springframework.http.HttpStatus;

/**
 * Created by burgl on 2016/8/13.
 */

@SpringBootApplication
public class Application extends SpringBootServletInitializer implements EmbeddedServletContainerCustomizer {




    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }

    @Override
    public void customize(ConfigurableEmbeddedServletContainer container) {
        container.setPort(8188);
    }


    public Application() {
        super();
    }

    @Bean
    public  ErrorPageFilter initErrorPageFilter() {
        ErrorPageFilter filter = new ErrorPageFilter();
        filter.addErrorPages(new ErrorPage(HttpStatus.NOT_FOUND,"/error/404"));
        filter.addErrorPages(new ErrorPage(HttpStatus.INTERNAL_SERVER_ERROR,"/error/500"));
        filter.addErrorPages(new ErrorPage(HttpStatus.BAD_REQUEST,"/error/400"));
        filter.addErrorPages(new ErrorPage(RuntimeException.class,"/error/500"));
        return filter;
    }

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(Application.class);
    }
}
