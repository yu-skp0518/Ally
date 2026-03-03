package com.ally.controller;

import com.ally.service.BookService;
import com.ally.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.PageImpl;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequestMapping("/searches")
@RequiredArgsConstructor
public class SearchController {

    private final BookService bookService;
    private final UserService userService;

    @GetMapping("/search")
    public String search(@RequestParam(required = false) String keyword,
                         @RequestParam(defaultValue = "book") String modelType,
                         Model model) {
        var pageable = PageRequest.of(0, 20);
        if (keyword == null || keyword.isBlank()) {
            model.addAttribute("books", bookService.findAllNotDeleted(pageable));
            model.addAttribute("users", userService.search("", pageable));
            return "public/searches/search";
        }
        model.addAttribute("keyword", keyword);
        if ("user".equals(modelType)) {
            model.addAttribute("users", userService.search(keyword, pageable));
            model.addAttribute("books", new PageImpl<>(List.of(), pageable, 0));
        } else {
            model.addAttribute("books", bookService.searchByKeyword(keyword, pageable));
            model.addAttribute("users", userService.search(keyword, pageable));
        }
        return "public/searches/search";
    }
}
