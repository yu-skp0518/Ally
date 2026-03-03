package com.ally.controller;

import com.ally.security.AllyUserDetails;
import com.ally.service.CommentService;
import com.ally.service.LikeService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/books/{bookId}/comments/{commentId}/likes")
@RequiredArgsConstructor
public class LikeController {

    private final LikeService likeService;
    private final CommentService commentService;

    @PostMapping
    public String create(@PathVariable Long bookId, @PathVariable Long commentId,
                        @AuthenticationPrincipal AllyUserDetails userDetails, RedirectAttributes ra) {
        if (userDetails != null) {
            commentService.findById(commentId).ifPresent(comment ->
                    likeService.create(userDetails.getUser(), comment));
        }
        return "redirect:/books/show/" + bookId;
    }

    @DeleteMapping
    public String destroy(@PathVariable Long bookId, @PathVariable Long commentId,
                         @AuthenticationPrincipal AllyUserDetails userDetails) {
        if (userDetails != null) {
            likeService.delete(userDetails.getUser().getId(), commentId);
        }
        return "redirect:/books/show/" + bookId;
    }
}
