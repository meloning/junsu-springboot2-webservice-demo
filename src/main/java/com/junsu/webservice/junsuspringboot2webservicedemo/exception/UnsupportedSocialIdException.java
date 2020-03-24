package com.junsu.webservice.junsuspringboot2webservicedemo.exception;

import lombok.Getter;

@Getter
public class UnsupportedSocialIdException extends BaseException {
    private final String message;

    public UnsupportedSocialIdException(String message) {
        super("unsupported_socialId", message);
        this.message = message;
    }
}
