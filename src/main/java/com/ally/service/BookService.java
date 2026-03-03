package com.ally.service;

import com.ally.client.RakutenBooksClient;
import com.ally.entity.Book;
import com.ally.entity.Genre;
import com.ally.entity.Subject;
import com.ally.entity.User;
import com.ally.repository.BookRepository;
import com.ally.repository.GenreRepository;
import com.ally.repository.SubjectRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class BookService {

    private final BookRepository bookRepository;
    private final GenreRepository genreRepository;
    private final SubjectRepository subjectRepository;
    private final RakutenBooksClient rakutenClient;

    @Transactional(readOnly = true)
    public Page<Book> findAllNotDeleted(Pageable pageable) {
        return bookRepository.findByIsDeletedFalse(pageable);
    }

    @Transactional(readOnly = true)
    public Optional<Book> findById(Long id) {
        return bookRepository.findById(id);
    }

    @Transactional(readOnly = true)
    public Page<Book> findByUserId(Long userId, Pageable pageable) {
        return bookRepository.findByUserIdAndIsDeletedFalse(userId, pageable);
    }

    @Transactional(readOnly = true)
    public Page<Book> findByGenreId(Long genreId, Pageable pageable) {
        return bookRepository.findByGenreIdAndIsDeletedFalse(genreId, pageable);
    }

    @Transactional(readOnly = true)
    public Page<Book> findBySubjectId(Long subjectId, Pageable pageable) {
        return bookRepository.findBySubjectIdAndIsDeletedFalse(subjectId, pageable);
    }

    @Transactional(readOnly = true)
    public Page<Book> searchByKeyword(String keyword, Pageable pageable) {
        return bookRepository.searchByKeyword(keyword, pageable);
    }

    @Transactional
    public Book create(Book book, User user) {
        book.setUser(user);
        return bookRepository.save(book);
    }

    @Transactional
    public Book update(Book book) {
        return bookRepository.save(book);
    }

    @Transactional
    public void softDelete(Long bookId) {
        bookRepository.findById(bookId).ifPresent(b -> {
            b.setIsDeleted(true);
            bookRepository.save(b);
        });
    }

    public List<RakutenBooksClient.RakutenBookItem> searchRakutenByTitle(String keyword) {
        return rakutenClient.searchByTitle(keyword);
    }

    public Optional<RakutenBooksClient.RakutenBookItem> getRakutenByIsbn(long isbn) {
        return rakutenClient.searchByIsbn(isbn);
    }

    public boolean isRakutenConfigured() {
        return rakutenClient.isConfigured();
    }

    public boolean alreadyPostedByUser(Long userId, Long isbn) {
        return bookRepository.existsByUserIdAndIsbn(userId, isbn);
    }

    public Genre getGenreReference(Long id) {
        return genreRepository.getReferenceById(id);
    }

    public Subject getSubjectReference(Long id) {
        return subjectRepository.getReferenceById(id);
    }
}
