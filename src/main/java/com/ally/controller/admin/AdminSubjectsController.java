package com.ally.controller.admin;

import com.ally.entity.Subject;
import com.ally.service.SubjectService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminSubjectsController {

    private final SubjectService subjectService;

    @GetMapping("/subjects")
    public String index(Model model) {
        model.addAttribute("subjects", subjectService.findAll());
        return "admin/subjects/index";
    }

    @GetMapping("/subjects/{id}")
    public String show(@PathVariable Long id, Model model) {
        return subjectService.findById(id)
                .map(subject -> {
                    model.addAttribute("subject", subject);
                    return "admin/subjects/show";
                })
                .orElse("redirect:/admin/subjects");
    }

    @PostMapping("/subjects/{id}")
    public String update(@PathVariable Long id, @RequestParam String name) {
        subjectService.findById(id).ifPresent(s -> {
            s.setName(name);
            subjectService.save(s);
        });
        return "redirect:/admin/subjects/" + id;
    }
}
