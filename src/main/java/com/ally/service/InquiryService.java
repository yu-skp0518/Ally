package com.ally.service;

import com.ally.entity.Inquiry;
import com.ally.repository.InquiryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class InquiryService {

    private final InquiryRepository inquiryRepository;

    @Transactional(readOnly = true)
    public Optional<Inquiry> findById(Long id) {
        return inquiryRepository.findById(id);
    }

    @Transactional(readOnly = true)
    public Page<Inquiry> findByUserId(Long userId, Pageable pageable) {
        return inquiryRepository.findByUserId(userId, pageable);
    }

    @Transactional(readOnly = true)
    public Page<Inquiry> findAll(Pageable pageable) {
        return inquiryRepository.findAll(pageable);
    }

    @Transactional
    public Inquiry save(Inquiry inquiry) {
        return inquiryRepository.save(inquiry);
    }
}
