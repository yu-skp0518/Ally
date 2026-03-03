package com.ally.controller;

import com.ally.client.RakutenBooksClient;
import com.ally.entity.Book;
import com.ally.entity.User;
import com.ally.security.AllyUserDetails;
import com.ally.service.BookmarkService;
import com.ally.service.BookService;
import com.ally.service.CommentService;
import com.ally.service.GenreService;
import com.ally.service.SubjectService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/books")
@RequiredArgsConstructor
public class PublicBooksController {

    private final BookService bookService;
    private final CommentService commentService;
    private final BookmarkService bookmarkService;
    private final GenreService genreService;
    private final SubjectService subjectService;

    @GetMapping("/top")
    public String top(Model model) {
        Page<Book> books = bookService.findAllNotDeleted(PageRequest.of(0, 10));
        model.addAttribute("books", books);
        return "public/books/top";
    }

    @GetMapping
    public String index(@RequestParam(defaultValue = "0") int page, Model model) {
        Page<Book> books = bookService.findAllNotDeleted(PageRequest.of(page, 10));
        model.addAttribute("books", books);
        return "public/books/index";
    }

    @GetMapping("/search")
    public String search(@RequestParam(required = false) String keyword, Model model) {
        if (keyword != null && !keyword.isBlank()) {
            if (!bookService.isRakutenConfigured()) {
                model.addAttribute("alert", "楽天APIの設定がありません。RAKUTEN_APP_ID を設定してください。");
                model.addAttribute("rakutenBooks", List.<RakutenBooksClient.RakutenBookItem>of());
            } else {
                model.addAttribute("rakutenBooks", bookService.searchRakutenByTitle(keyword));
            }
        } else {
            model.addAttribute("notice", "キーワードを入力してください。");
        }
        return "public/books/search";
    }

    @GetMapping("/new")
    public String newBook(@RequestParam Long isbn, RedirectAttributes ra, Model model) {
        if (!bookService.isRakutenConfigured()) {
            ra.addFlashAttribute("alert", "楽天APIの設定がありません。");
            return "redirect:/books/search";
        }
        Optional<RakutenBooksClient.RakutenBookItem> item = bookService.getRakutenByIsbn(isbn);
        if (item.isEmpty()) {
            ra.addFlashAttribute("alert", "該当する書籍が見つかりませんでした。");
            return "redirect:/books/search";
        }
        Book book = fromRakutenItem(item.get());
        model.addAttribute("rakutenItem", item.get());
        model.addAttribute("book", book);
        model.addAttribute("genres", genreService.findAll());
        model.addAttribute("subjects", subjectService.findAll());
        return "public/books/new";
    }

    @PostMapping
    public String create(@AuthenticationPrincipal AllyUserDetails userDetails,
                         @RequestParam Long isbn, @RequestParam Long genreId, @RequestParam Long subjectId,
                         @RequestParam String story, @RequestParam Float rate,
                         @RequestParam(required = false) String title, @RequestParam(required = false) String author,
                         @RequestParam(required = false) String itemCaption, @RequestParam(required = false) String itemUrl,
                         @RequestParam(required = false) String publisherName, @RequestParam(required = false) Integer itemPrice,
                         @RequestParam(required = false) String largeImageUrl, @RequestParam(required = false) String mediumImageUrl, @RequestParam(required = false) String smallImageUrl,
                         RedirectAttributes ra, Model model) {
        if (userDetails == null) {
            return "redirect:/login";
        }
        if (bookService.alreadyPostedByUser(userDetails.getUser().getId(), isbn)) {
            ra.addFlashAttribute("alert", "この書籍は以前に投稿しています");
            return "redirect:/books/search";
        }
        Book book = new Book();
        book.setIsbn(isbn);
        book.setTitle(title != null ? title : "");
        book.setAuthor(author != null ? author : "");
        book.setItemCaption(itemCaption != null ? itemCaption : "");
        book.setItemUrl(itemUrl != null ? itemUrl : "");
        book.setPublisherName(publisherName != null ? publisherName : "");
        book.setItemPrice(itemPrice != null ? itemPrice : 0);
        book.setLargeImageUrl(largeImageUrl != null ? largeImageUrl : "");
        book.setMediumImageUrl(mediumImageUrl != null ? mediumImageUrl : "");
        book.setSmallImageUrl(smallImageUrl != null ? smallImageUrl : "");
        book.setStory(story != null ? story : "");
        book.setRate(rate);
        book.setGenre(bookService.getGenreReference(genreId));
        book.setSubject(bookService.getSubjectReference(subjectId));
        Book saved = bookService.create(book, userDetails.getUser());
        ra.addFlashAttribute("createSuccess", "新規投稿を作成しました！");
        return "redirect:/books/show/" + saved.getId();
    }

    private Book fromRakutenItem(RakutenBooksClient.RakutenBookItem item) {
        Book book = new Book();
        if (item.getIsbn() != null && !item.getIsbn().isBlank()) {
            try {
                book.setIsbn(Long.parseLong(item.getIsbn().replace("-", "")));
            } catch (NumberFormatException e) {
                book.setIsbn(0L);
            }
        }
        book.setTitle(item.getTitle() != null ? item.getTitle() : "");
        book.setAuthor(item.getAuthor() != null ? item.getAuthor() : "");
        book.setItemCaption(item.getItemCaption() != null ? item.getItemCaption() : "");
        book.setItemUrl(item.getItemUrl() != null ? item.getItemUrl() : "");
        book.setPublisherName(item.getPublisherName() != null ? item.getPublisherName() : "");
        book.setItemPrice(item.getItemPrice() != null ? item.getItemPrice() : 0);
        book.setLargeImageUrl(item.getLargeImageUrl() != null ? item.getLargeImageUrl() : "");
        book.setMediumImageUrl(item.getMediumImageUrl() != null ? item.getMediumImageUrl() : "");
        book.setSmallImageUrl(item.getSmallImageUrl() != null ? item.getSmallImageUrl() : "");
        return book;
    }

    @GetMapping("/show/{id}")
    public String show(@PathVariable Long id, @AuthenticationPrincipal AllyUserDetails userDetails,
                       @RequestParam(defaultValue = "0") int page, Model model) {
        Optional<Book> bookOpt = bookService.findById(id);
        if (bookOpt.isEmpty()) {
            return "redirect:/books";
        }
        Book book = bookOpt.get();
        model.addAttribute("book", book);
        model.addAttribute("comment", new com.ally.entity.Comment());
        Pageable pageable = PageRequest.of(page, 5);
        model.addAttribute("comments", commentService.findByBookId(id, pageable));
        model.addAttribute("amounts", commentService.countByBookId(id));
        if (userDetails != null) {
            model.addAttribute("currentUserBookmark", bookmarkService.findByUserAndBook(userDetails.getUser().getId(), id));
        }
        return "public/books/show";
    }

    @GetMapping("/edit/{id}")
    public String edit(@PathVariable Long id, @AuthenticationPrincipal AllyUserDetails userDetails, Model model) {
        Optional<Book> bookOpt = bookService.findById(id);
        if (bookOpt.isEmpty() || userDetails == null || !bookOpt.get().getUser().getId().equals(userDetails.getUser().getId())) {
            return "redirect:/books";
        }
        model.addAttribute("book", bookOpt.get());
        model.addAttribute("genres", genreService.findAll());
        model.addAttribute("subjects", subjectService.findAll());
        return "public/books/edit";
    }

    @PostMapping("/update/{id}")
    public String update(@PathVariable Long id, @AuthenticationPrincipal AllyUserDetails userDetails,
                         @RequestParam String story, @RequestParam Float rate,
                         @RequestParam Long genreId, @RequestParam Long subjectId,
                         RedirectAttributes ra) {
        Optional<Book> existing = bookService.findById(id);
        if (existing.isEmpty() || userDetails == null || !existing.get().getUser().getId().equals(userDetails.getUser().getId())) {
            return "redirect:/books";
        }
        Book b = existing.get();
        b.setStory(story);
        b.setRate(rate);
        b.setGenre(bookService.getGenreReference(genreId));
        b.setSubject(bookService.getSubjectReference(subjectId));
        bookService.update(b);
        ra.addFlashAttribute("success", "変更内容を保存しました!");
        return "redirect:/books/show/" + id;
    }

    @PostMapping("/{bookId}/disenable")
    public String disenable(@PathVariable Long bookId, @AuthenticationPrincipal AllyUserDetails userDetails, RedirectAttributes ra) {
        if (userDetails != null) {
            bookService.softDelete(bookId);
            ra.addFlashAttribute("disenabled", "投稿を削除しました!");
            return "redirect:/users/" + userDetails.getUser().getId();
        }
        return "redirect:/books";
    }
}
