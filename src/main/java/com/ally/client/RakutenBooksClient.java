package com.ally.client;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Component
public class RakutenBooksClient {

    private static final String BASE_URL = "https://app.rakuten.co.jp/services/api/BooksBook/Search/20170404";

    private final RestTemplate restTemplate = new RestTemplate();

    @Value("${app.rakuten.app-id:}")
    private String applicationId;

    public boolean isConfigured() {
        return applicationId != null && !applicationId.isBlank();
    }

    public List<RakutenBookItem> searchByTitle(String keyword) {
        if (!isConfigured() || keyword == null || keyword.isBlank()) {
            return List.of();
        }
        String url = UriComponentsBuilder.fromHttpUrl(BASE_URL)
                .queryParam("applicationId", applicationId)
                .queryParam("title", keyword)
                .queryParam("format", "json")
                .toUriString();
        try {
            RakutenResponse response = restTemplate.getForObject(url, RakutenResponse.class);
            return response != null && response.getItems() != null
                    ? response.getItems().stream().map(RakutenItemWrapper::getItem).toList()
                    : List.of();
        } catch (Exception e) {
            return List.of();
        }
    }

    public Optional<RakutenBookItem> searchByIsbn(long isbn) {
        if (!isConfigured()) {
            return Optional.empty();
        }
        String url = UriComponentsBuilder.fromHttpUrl(BASE_URL)
                .queryParam("applicationId", applicationId)
                .queryParam("isbn", String.valueOf(isbn))
                .queryParam("format", "json")
                .toUriString();
        try {
            RakutenResponse response = restTemplate.getForObject(url, RakutenResponse.class);
            if (response != null && response.getItems() != null && !response.getItems().isEmpty()) {
                return Optional.of(response.getItems().get(0).getItem());
            }
        } catch (Exception ignored) {
        }
        return Optional.empty();
    }

    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class RakutenResponse {
        @JsonProperty("Items")
        private List<RakutenItemWrapper> items;
    }

    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class RakutenItemWrapper {
        @JsonProperty("Item")
        private RakutenBookItem item;
    }

    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class RakutenBookItem {
        @JsonProperty("isbn")
        private String isbn;
        @JsonProperty("title")
        private String title;
        @JsonProperty("author")
        private String author;
        @JsonProperty("itemCaption")
        private String itemCaption;
        @JsonProperty("itemUrl")
        private String itemUrl;
        @JsonProperty("publisherName")
        private String publisherName;
        @JsonProperty("itemPrice")
        private Integer itemPrice;
        @JsonProperty("largeImageUrl")
        private String largeImageUrl;
        @JsonProperty("mediumImageUrl")
        private String mediumImageUrl;
        @JsonProperty("smallImageUrl")
        private String smallImageUrl;
    }
}
