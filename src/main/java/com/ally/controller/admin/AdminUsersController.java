package com.ally.controller.admin;

import com.ally.entity.User;
import com.ally.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminUsersController {

    private final UserService userService;

    @GetMapping("/users")
    public String index(@RequestParam(defaultValue = "0") int page, Model model) {
        Page<User> users = userService.search("", PageRequest.of(page, 20));
        model.addAttribute("users", users);
        return "admin/users/index";
    }

    @GetMapping("/users/{id}")
    public String show(@PathVariable Long id, Model model) {
        return userService.findById(id)
                .map(user -> {
                    model.addAttribute("user", user);
                    return "admin/users/show";
                })
                .orElse("redirect:/admin/users");
    }

    @PostMapping("/users/{id}")
    public String update(@PathVariable Long id, @RequestParam(required = false) Boolean isValid) {
        if (Boolean.TRUE.equals(isValid)) {
            userService.unban(id);
        } else {
            userService.quit(id);
        }
        return "redirect:/admin/users/" + id;
    }
}
