package com.ally.controller;

import com.ally.security.AllyUserDetails;
import com.ally.service.BookmarkService;
import com.ally.service.BookService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/users/{userId}/bookmarks")
@RequiredArgsConstructor
public class BookmarkController {

    private final BookmarkService bookmarkService;
    private final BookService bookService;

    @PostMapping
    public String create(@PathVariable Long userId, @RequestParam Long bookId,
                        @AuthenticationPrincipal AllyUserDetails userDetails) {
        if (userDetails != null && userDetails.getUser().getId().equals(userId)) {
            bookService.findById(bookId).ifPresent(book ->
                    bookmarkService.create(userDetails.getUser(), book));
        }
        return "redirect:/books/show/" + bookId;
    }

    @DeleteMapping
    public String destroy(@PathVariable Long userId, @RequestParam Long bookId,
                         @AuthenticationPrincipal AllyUserDetails userDetails) {
        if (userDetails != null && userDetails.getUser().getId().equals(userId)) {
            bookmarkService.delete(userId, bookId);
        }
        return "redirect:/books/show/" + bookId;
    }

    @GetMapping
    public String index(@PathVariable Long userId, @AuthenticationPrincipal AllyUserDetails userDetails,
                        @RequestParam(defaultValue = "0") int page, Model model) {
        if (userDetails == null || !userDetails.getUser().getId().equals(userId)) {
            return "redirect:/books";
        }
        model.addAttribute("user", userDetails.getUser());
        model.addAttribute("bookmarks", bookmarkService.findByUserId(userId, PageRequest.of(page, 10)));
        return "public/bookmarks/index";
    }
}
