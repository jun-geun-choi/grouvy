package com.example.grouvy.user.exception;

public class UserRegisterException extends AppException {

    private String field;

    public UserRegisterException(String field, String message) {
        super(message);
        this.field = field;
    }

    public String getField() {
        return field;
    }
}
