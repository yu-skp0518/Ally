package com.ally.service;

import com.ally.entity.Book;
import com.ally.entity.Bookmark;
import com.ally.entity.User;
import com.ally.repository.BookmarkRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class BookmarkService {

    private final BookmarkRepository bookmarkRepository;

    @Transactional(readOnly = true)
    public Optional<Bookmark> findByUserAndBook(Long userId, Long bookId) {
        return bookmarkRepository.findByUserIdAndBookId(userId, bookId);
    }

    @Transactional(readOnly = true)
    public boolean isBookmarkedBy(Long userId, Long bookId) {
        return bookmarkRepository.existsByUserIdAndBookId(userId, bookId);
    }

    @Transactional(readOnly = true)
    public Page<Bookmark> findByUserId(Long userId, Pageable pageable) {
        return bookmarkRepository.findByUserId(userId, pageable);
    }

    @Transactional
    public Bookmark create(User user, Book book) {
        Bookmark b = new Bookmark();
        b.setUser(user);
        b.setBook(book);
        return bookmarkRepository.save(b);
    }

    @Transactional
    public void delete(Long userId, Long bookId) {
        bookmarkRepository.findByUserIdAndBookId(userId, bookId).ifPresent(bookmarkRepository::delete);
    }
}
