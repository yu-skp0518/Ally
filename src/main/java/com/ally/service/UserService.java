package com.ally.service;

import com.ally.entity.User;
import com.ally.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Transactional(readOnly = true)
    public Optional<User> findById(Long id) {
        return userRepository.findById(id);
    }

    @Transactional(readOnly = true)
    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    @Transactional(readOnly = true)
    public boolean existsByName(String name) {
        return userRepository.findByName(name).isPresent();
    }

    @Transactional(readOnly = true)
    public Page<User> search(String keyword, Pageable pageable) {
        if (keyword == null || keyword.isBlank()) {
            return userRepository.findAll(pageable);
        }
        return userRepository.findByNameContainingOrNickNameContaining(keyword, keyword, pageable);
    }

    @Transactional
    public User register(User user, String rawPassword) {
        user.setEncryptedPassword(passwordEncoder.encode(rawPassword));
        return userRepository.save(user);
    }

    @Transactional
    public User update(User user) {
        return userRepository.save(user);
    }

    @Transactional
    public void quit(Long userId) {
        userRepository.findById(userId).ifPresent(u -> {
            u.setIsValid(false);
            userRepository.save(u);
        });
    }

    @Transactional
    public void unban(Long userId) {
        userRepository.findById(userId).ifPresent(u -> {
            u.setIsValid(true);
            userRepository.save(u);
        });
    }
}
