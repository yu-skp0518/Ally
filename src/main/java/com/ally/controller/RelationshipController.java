package com.ally.controller;

import com.ally.security.AllyUserDetails;
import com.ally.service.RelationshipService;
import com.ally.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/users/{userId}/relationships")
@RequiredArgsConstructor
public class RelationshipController {

    private final RelationshipService relationshipService;
    private final UserService userService;

    @PostMapping
    public String create(@PathVariable Long userId, @AuthenticationPrincipal AllyUserDetails userDetails,
                        RedirectAttributes ra) {
        if (userDetails != null) {
            userService.findById(userId).ifPresent(follower ->
                    relationshipService.follow(userDetails.getUser(), follower));
        }
        return "redirect:/users/" + userId;
    }

    @DeleteMapping
    public String destroy(@PathVariable Long userId, @AuthenticationPrincipal AllyUserDetails userDetails) {
        if (userDetails != null) {
            relationshipService.unfollow(userDetails.getUser().getId(), userId);
        }
        return "redirect:/users/" + userId;
    }

    @GetMapping("/followings")
    public String followings(@PathVariable Long userId, Model model) {
        return userService.findById(userId)
                .map(user -> {
                    List<com.ally.entity.User> followings = relationshipService.findFollowings(userId);
                    model.addAttribute("user", user);
                    model.addAttribute("followings", followings);
                    return "public/relationships/followings";
                })
                .orElse("redirect:/books");
    }

    @GetMapping("/followers")
    public String followers(@PathVariable Long userId, Model model) {
        return userService.findById(userId)
                .map(user -> {
                    List<com.ally.entity.User> followers = relationshipService.findFollowers(userId);
                    model.addAttribute("user", user);
                    model.addAttribute("followers", followers);
                    return "public/relationships/followers";
                })
                .orElse("redirect:/books");
    }
}
