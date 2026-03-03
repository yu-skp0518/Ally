package com.ally.controller;

import com.ally.entity.User;
import com.ally.security.AllyUserDetails;
import com.ally.service.BookService;
import com.ally.service.RelationshipService;
import com.ally.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/users")
@RequiredArgsConstructor
public class PublicUsersController {

    private final UserService userService;
    private final BookService bookService;
    private final RelationshipService relationshipService;

    @GetMapping("/{id}")
    public String show(@PathVariable Long id, @AuthenticationPrincipal AllyUserDetails currentUser, Model model) {
        return userService.findById(id)
                .map(user -> {
                    model.addAttribute("user", user);
                    model.addAttribute("books", bookService.findByUserId(id, PageRequest.of(0, 20)));
                    if (currentUser != null) {
                        model.addAttribute("isFollowing", relationshipService.isFollowing(currentUser.getUser().getId(), id));
                    }
                    return "public/users/show";
                })
                .orElse("redirect:/books");
    }

    @GetMapping("/{id}/edit")
    public String edit(@PathVariable Long id, @AuthenticationPrincipal AllyUserDetails userDetails, Model model) {
        if (userDetails == null || !userDetails.getUser().getId().equals(id)) {
            return "redirect:/books";
        }
        return userService.findById(id)
                .map(user -> {
                    model.addAttribute("user", user);
                    return "public/users/edit";
                })
                .orElse("redirect:/books");
    }

    @PostMapping("/{id}")
    public String update(@PathVariable Long id, @AuthenticationPrincipal AllyUserDetails userDetails,
                         @RequestParam String name, @RequestParam String nickName, @RequestParam(required = false) String profile,
                         RedirectAttributes ra) {
        if (userDetails == null || !userDetails.getUser().getId().equals(id)) {
            return "redirect:/books";
        }
        User user = userDetails.getUser();
        user.setName(name);
        user.setNickName(nickName);
        user.setProfile(profile);
        userService.update(user);
        ra.addFlashAttribute("success", "変更を保存しました");
        return "redirect:/users/" + id;
    }

    @GetMapping("/{id}/confirm")
    public String confirmQuit(@PathVariable Long id, @AuthenticationPrincipal AllyUserDetails userDetails, Model model) {
        if (userDetails == null || !userDetails.getUser().getId().equals(id)) {
            return "redirect:/books";
        }
        model.addAttribute("user", userDetails.getUser());
        return "public/users/confirm";
    }

    @PostMapping("/{id}/quit")
    public String quit(@PathVariable Long id, @AuthenticationPrincipal AllyUserDetails userDetails, RedirectAttributes ra) {
        if (userDetails != null && userDetails.getUser().getId().equals(id)) {
            userService.quit(id);
            ra.addFlashAttribute("notice", "退会しました");
        }
        return "redirect:/books/top";
    }
}
