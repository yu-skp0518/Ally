package com.ally.controller;

import com.ally.entity.Genre;
import com.ally.service.BookService;
import com.ally.service.GenreService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/genres")
@RequiredArgsConstructor
public class PublicGenresController {

    private final GenreService genreService;
    private final BookService bookService;

    @GetMapping
    public String index(Model model) {
        model.addAttribute("genres", genreService.findAll());
        return "public/genres/index";
    }

    @GetMapping("/{id}")
    public String show(@PathVariable Long id, Model model) {
        return genreService.findById(id)
                .map(genre -> {
                    model.addAttribute("genre", genre);
                    model.addAttribute("books", bookService.findByGenreId(id, PageRequest.of(0, 100)).getContent());
                    return "public/genres/show";
                })
                .orElse("redirect:/genres");
    }
}
