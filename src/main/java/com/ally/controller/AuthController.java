package com.ally.controller;

import com.ally.entity.User;
import com.ally.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping
@RequiredArgsConstructor
public class AuthController {

    private final UserService userService;

    @GetMapping("/signup")
    public String signupForm(Model model) {
        model.addAttribute("user", new User());
        return "signup";
    }

    @PostMapping("/signup")
    public String signup(@RequestParam String email, @RequestParam String password,
                         @RequestParam String name, @RequestParam String nickName,
                         RedirectAttributes ra) {
        if (userService.findByEmail(email).isPresent()) {
            ra.addFlashAttribute("alert", "このメールアドレスは既に登録されています");
            return "redirect:/signup";
        }
        if (userService.existsByName(name)) {
            ra.addFlashAttribute("alert", "この名前は既に使用されています");
            return "redirect:/signup";
        }
        User user = new User();
        user.setEmail(email);
        user.setName(name);
        user.setNickName(nickName);
        userService.register(user, password);
        ra.addFlashAttribute("notice", "登録しました。ログインしてください。");
        return "redirect:/login";
    }
}
