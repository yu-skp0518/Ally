package com.ally.repository;

import com.ally.entity.Book;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface BookRepository extends JpaRepository<Book, Long> {

    Page<Book> findByIsDeletedFalse(Pageable pageable);

    Page<Book> findByUserIdAndIsDeletedFalse(Long userId, Pageable pageable);

    Page<Book> findByGenreIdAndIsDeletedFalse(Long genreId, Pageable pageable);

    Page<Book> findBySubjectIdAndIsDeletedFalse(Long subjectId, Pageable pageable);

    @Query("SELECT b FROM Book b WHERE b.isDeleted = false AND (b.title LIKE %:keyword% OR b.author LIKE %:keyword% OR b.story LIKE %:keyword%)")
    Page<Book> searchByKeyword(@Param("keyword") String keyword, Pageable pageable);

    boolean existsByUserIdAndIsbn(Long userId, Long isbn);
}
