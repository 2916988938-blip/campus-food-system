package com.campus.food.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 测试控制器 —— 用来验证"浏览器发请求，服务器回响应"这条路走通了
 *
 * @RestController 告诉 Spring：这个类负责处理 HTTP 请求，返回的内容直接是响应体
 */
@RestController
public class HelloController {

    /**
     * 访问 http://localhost:8080/hello 就会走到这里
     */
    @GetMapping("/hello")
    public String hello() {
        return "校园美食平台，环境跑通啦！";
    }

}
