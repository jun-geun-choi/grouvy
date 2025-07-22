package com.example.grouvy.chat.dto;

//응답 받을 때, 헤더 + 바디 표시를 자유롭게 하기 위해서 필요.
//최종적으로 서버에서 응답 받은 데이터는 여기서 정의한 대로 받게 됨.
import org.springframework.http.ResponseEntity;

public class ResponseEntityUtils {

   public static  ResponseEntity<ApiResponse<Void>> ok(String message) {
      return ResponseEntity
            .status(200)
            .body(ApiResponse.success(message));
   }
   
   public static <T> ResponseEntity<ApiResponse<T>> ok(T data) {
      return ResponseEntity
            .status(200)
            .body(ApiResponse.success(data));
   }
   
   public static <T> ResponseEntity<ApiResponse<T>> ok(String message, T data) {
      return ResponseEntity
            .status(200)
            .body(ApiResponse.success(message, data));
   }
   
   public static ResponseEntity<ApiResponse<Void>> fail(int status, String message) {
      return ResponseEntity
            .status(status)
            .body(ApiResponse.fail(status, message));
   }
}
