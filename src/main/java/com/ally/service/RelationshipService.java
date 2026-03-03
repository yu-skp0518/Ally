package com.ally.service;

import com.ally.entity.Relationship;
import com.ally.entity.User;
import com.ally.repository.RelationshipRepository;
import com.ally.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class RelationshipService {

    private final RelationshipRepository relationshipRepository;
    private final UserRepository userRepository;

    @Transactional(readOnly = true)
    public List<User> findFollowings(Long userId) {
        return relationshipRepository.findByFollowingId(userId).stream()
                .map(Relationship::getFollower)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<User> findFollowers(Long userId) {
        return relationshipRepository.findByFollowerId(userId).stream()
                .map(Relationship::getFollowing)
                .toList();
    }

    @Transactional(readOnly = true)
    public boolean isFollowing(Long followingId, Long followerId) {
        return relationshipRepository.existsByFollowingIdAndFollowerId(followingId, followerId);
    }

    @Transactional
    public void follow(User following, User follower) {
        if (!relationshipRepository.existsByFollowingIdAndFollowerId(following.getId(), follower.getId())) {
            Relationship r = new Relationship();
            r.setFollowing(following);
            r.setFollower(follower);
            relationshipRepository.save(r);
        }
    }

    @Transactional
    public void unfollow(Long followingId, Long followerId) {
        relationshipRepository.findByFollowingIdAndFollowerId(followingId, followerId)
                .ifPresent(relationshipRepository::delete);
    }
}
