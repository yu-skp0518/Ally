package com.ally.controller;

import com.ally.service.BookService;
import com.ally.service.SubjectService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/subjects")
@RequiredArgsConstructor
public class PublicSubjectsController {

    private final SubjectService subjectService;
    private final BookService bookService;

    @GetMapping
    public String index(Model model) {
        model.addAttribute("subjects", subjectService.findAll());
        return "public/subjects/index";
    }

    @GetMapping("/{id}")
    public String show(@PathVariable Long id, Model model) {
        return subjectService.findById(id)
                .map(subject -> {
                    model.addAttribute("subject", subject);
                    model.addAttribute("books", bookService.findBySubjectId(id, PageRequest.of(0, 100)).getContent());
                    return "public/subjects/show";
                })
                .orElse("redirect:/subjects");
    }
}
