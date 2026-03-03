package com.ally.controller.admin;

import com.ally.entity.Genre;
import com.ally.service.GenreService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminGenresController {

    private final GenreService genreService;

    @GetMapping("/genres")
    public String index(Model model) {
        model.addAttribute("genres", genreService.findAll());
        model.addAttribute("genre", new Genre());
        return "admin/genres/index";
    }

    @GetMapping("/genres/{id}")
    public String show(@PathVariable Long id, Model model) {
        return genreService.findById(id)
                .map(genre -> {
                    model.addAttribute("genre", genre);
                    return "admin/genres/show";
                })
                .orElse("redirect:/admin/genres");
    }

    @PostMapping("/genres")
    public String create(@RequestParam String name, RedirectAttributes ra) {
        Genre genre = new Genre();
        genre.setName(name);
        genreService.save(genre);
        ra.addFlashAttribute("notice", "ジャンルを追加しました");
        return "redirect:/admin/genres";
    }
}
