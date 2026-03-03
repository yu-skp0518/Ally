package com.ally.repository;

import com.ally.entity.Relationship;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface RelationshipRepository extends JpaRepository<Relationship, Long> {

    Optional<Relationship> findByFollowingIdAndFollowerId(Long followingId, Long followerId);

    boolean existsByFollowingIdAndFollowerId(Long followingId, Long followerId);

    List<Relationship> findByFollowingId(Long followingId);

    List<Relationship> findByFollowerId(Long followerId);
}
