package com.ally.controller;

import com.ally.entity.Inquiry;
import com.ally.security.AllyUserDetails;
import com.ally.service.InquiryService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/inquiries")
@RequiredArgsConstructor
public class InquiryController {

    private final InquiryService inquiryService;

    @GetMapping("/new")
    public String newForm(@AuthenticationPrincipal AllyUserDetails userDetails, Model model) {
        model.addAttribute("inquiry", new Inquiry());
        if (userDetails != null) {
            model.addAttribute("currentUser", userDetails.getUser());
        }
        return "public/inquiries/new";
    }

    @PostMapping
    public String create(@AuthenticationPrincipal AllyUserDetails userDetails,
                         @RequestParam String name, @RequestParam String email,
                         @RequestParam String title, @RequestParam String body,
                         @RequestParam(defaultValue = "0") int category,
                         RedirectAttributes ra) {
        if (userDetails == null) {
            return "redirect:/login";
        }
        Inquiry inquiry = new Inquiry();
        inquiry.setUser(userDetails.getUser());
        inquiry.setName(name);
        inquiry.setEmail(email);
        inquiry.setTitle(title);
        inquiry.setBody(body);
        inquiry.setCategory(category);
        inquiryService.save(inquiry);
        ra.addFlashAttribute("notice", "お問い合わせを送信しました");
        return "redirect:/users/" + userDetails.getUser().getId();
    }
}
