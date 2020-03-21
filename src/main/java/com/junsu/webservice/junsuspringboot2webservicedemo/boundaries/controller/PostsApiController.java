package com.junsu.webservice.junsuspringboot2webservicedemo.boundaries.controller;

import com.junsu.webservice.junsuspringboot2webservicedemo.boundaries.dto.PostsResponseDto;
import com.junsu.webservice.junsuspringboot2webservicedemo.boundaries.dto.PostsSaveRequestDto;
import com.junsu.webservice.junsuspringboot2webservicedemo.boundaries.dto.PostsUpdateRequestDto;
import com.junsu.webservice.junsuspringboot2webservicedemo.service.PostsService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RequiredArgsConstructor
@RestController
public class PostsApiController {

    private final PostsService postsService;

    @PostMapping("/api/v1/posts")
    public Long create(@RequestBody PostsSaveRequestDto requestDto) {
        return postsService.save(requestDto);
    }

    @PutMapping("/api/v1/posts/{id}")
    public Long update(@PathVariable Long id, @RequestBody PostsUpdateRequestDto requestDto) {
        return postsService.update(id, requestDto);
    }

    @GetMapping("/api/v1/posts/{id}")
    public PostsResponseDto detail(@PathVariable Long id) {
        return postsService.findById(id);
    }

    @DeleteMapping("/api/v1/posts/{id}")
    public Long delete(@PathVariable Long id) {
        postsService.delete(id);
        return id;
    }
}
