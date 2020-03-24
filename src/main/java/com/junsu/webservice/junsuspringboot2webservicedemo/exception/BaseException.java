package com.junsu.webservice.junsuspringboot2webservicedemo.exception;

import lombok.Getter;

@Getter
public class BaseException extends RuntimeException {
    private final String code;
    private final String message;

    public BaseException(String code, String message) {
        super(message);
        this.code = code;
        this.message = message;
    }
}
