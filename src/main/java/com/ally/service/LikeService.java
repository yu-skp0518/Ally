package com.ally.service;

import com.ally.entity.Comment;
import com.ally.entity.Like;
import com.ally.entity.User;
import com.ally.repository.LikeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class LikeService {

    private final LikeRepository likeRepository;

    @Transactional(readOnly = true)
    public boolean existsByUserAndComment(Long userId, Long commentId) {
        return likeRepository.existsByUserIdAndCommentId(userId, commentId);
    }

    @Transactional
    public Like create(User user, Comment comment) {
        Like like = new Like();
        like.setUser(user);
        like.setComment(comment);
        return likeRepository.save(like);
    }

    @Transactional
    public void delete(Long userId, Long commentId) {
        likeRepository.findByUserIdAndCommentId(userId, commentId).ifPresent(likeRepository::delete);
    }
}
