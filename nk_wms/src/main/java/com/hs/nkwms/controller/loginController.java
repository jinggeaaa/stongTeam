package com.hs.nkwms.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * loginContrller
 */
@Controller
@RequestMapping(value = "/login")
public class loginController {

    //登录页面
    @RequestMapping(value = "/login")
    public String login() {
        return "Login" ;
    }
}