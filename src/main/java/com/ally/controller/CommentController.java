package com.ally.controller;

import com.ally.entity.Comment;
import com.ally.security.AllyUserDetails;
import com.ally.service.BookService;
import com.ally.service.CommentService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;

@Controller
@RequestMapping("/books/{bookId}/comments")
@RequiredArgsConstructor
public class CommentController {

    private final CommentService commentService;
    private final BookService bookService;

    @PostMapping
    public String create(@PathVariable Long bookId, @AuthenticationPrincipal AllyUserDetails userDetails,
                         @RequestParam String body, @RequestParam(required = false) BigDecimal score,
                         RedirectAttributes ra) {
        if (userDetails == null) {
            return "redirect:/login";
        }
        var bookOpt = bookService.findById(bookId);
        if (bookOpt.isEmpty()) {
            return "redirect:/books";
        }
        Comment comment = new Comment();
        comment.setBody(body);
        comment.setScore(score);
        comment.setUser(userDetails.getUser());
        comment.setBook(bookOpt.get());
        commentService.save(comment);
        ra.addFlashAttribute("createSuccess", "コメントを投稿しました");
        return "redirect:/books/show/" + bookId;
    }

    @DeleteMapping("/{id}")
    public String destroy(@PathVariable Long bookId, @PathVariable Long id,
                         @AuthenticationPrincipal AllyUserDetails userDetails, RedirectAttributes ra) {
        if (userDetails != null) {
            commentService.findById(id).filter(c -> c.getUser().getId().equals(userDetails.getUser().getId()))
                    .ifPresent(c -> commentService.delete(c.getId()));
        }
        return "redirect:/books/show/" + bookId;
    }
}
