package com.campus.food;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * 校园美食推荐平台 - 启动类
 *
 * 这个类是整个项目的"总开关"，main 方法一跑，Spring Boot 就启动了。
 */
@SpringBootApplication
public class CampusFoodApplication {

    public static void main(String[] args) {
        SpringApplication.run(CampusFoodApplication.class, args);
    }

}
