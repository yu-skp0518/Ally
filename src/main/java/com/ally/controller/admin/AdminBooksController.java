package com.ally.controller.admin;

import com.ally.entity.Book;
import com.ally.service.BookService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminBooksController {

    private final BookService bookService;

    @GetMapping("/books/{id}")
    public String show(@PathVariable Long id, Model model) {
        return bookService.findById(id)
                .map(book -> {
                    model.addAttribute("book", book);
                    return "admin/books/show";
                })
                .orElse("redirect:/admin/users");
    }

    @PostMapping("/books/{id}")
    public String update(@PathVariable Long id, @RequestParam(defaultValue = "false") boolean isDeleted,
                         RedirectAttributes ra) {
        bookService.findById(id).ifPresent(book -> {
            book.setIsDeleted(isDeleted);
            bookService.update(book);
        });
        ra.addFlashAttribute("success", "更新しました");
        return "redirect:/admin/books/" + id;
    }
}
