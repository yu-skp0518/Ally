package com.ally.service;

import com.ally.entity.Comment;
import com.ally.repository.CommentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CommentService {

    private final CommentRepository commentRepository;

    @Transactional(readOnly = true)
    public Page<Comment> findByBookId(Long bookId, Pageable pageable) {
        return commentRepository.findByBookIdOrderByCreatedAtDesc(bookId, pageable);
    }

    @Transactional(readOnly = true)
    public Optional<Comment> findById(Long id) {
        return commentRepository.findById(id);
    }

    @Transactional(readOnly = true)
    public long countByBookId(Long bookId) {
        return commentRepository.countByBookId(bookId);
    }

    @Transactional
    public Comment save(Comment comment) {
        return commentRepository.save(comment);
    }

    @Transactional
    public void delete(Long id) {
        commentRepository.deleteById(id);
    }
}
