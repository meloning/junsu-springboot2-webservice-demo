package com.junsu.webservice.junsuspringboot2webservicedemo.boundaries.dto;

import com.junsu.webservice.junsuspringboot2webservicedemo.domain.posts.Posts;
import lombok.Getter;

import java.time.LocalDateTime;

@Getter
public class PostsListResponseDto {
    private Long id;
    private String title;
    private String author;
    private LocalDateTime updatedDate;

    public PostsListResponseDto(Posts entity) {
        this.id = entity.getId();
        this.title = entity.getTitle();
        this.author = entity.getAuthor();
        this.updatedDate = entity.getUpdatedDate();
    }
}
