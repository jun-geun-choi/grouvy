package com.example.grouvy.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.Message;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.simp.config.ChannelRegistration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.ChannelInterceptor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

  @Override
  public void registerStompEndpoints(StompEndpointRegistry registry) {
    registry.addEndpoint("/ws")                                // 웹소캣 연결 주소
            .setAllowedOrigins("http://localhost:8080")                                   // 언제든지 웹소캣에 접속할 수 있는 설정
            .withSockJS();                                            // SockJS 활성화

  }

  @Override
  public void configureMessageBroker(MessageBrokerRegistry brokerRegistry) {
    //stompClient.send("/app/chatSend", ...) -> @MessageMapping으로 라우팅
    brokerRegistry.setApplicationDestinationPrefixes("/app");

    //메시지 브로커가 처리할 수신 경로(prefix) 설정
    // "/topic" : 여러 사용자에게 브로드캐스팅할 때 사용
    // "/queue" : 특정 사용자 1명에게 보내는 1:1 알림 등에 사용 (convertAndSendToUser)
    brokerRegistry.enableSimpleBroker("/topic","queue");

    //convertAndSendToUser() 사용 시 자동으로 "/user/{username}/queue" 형태의 경로로 라우팅
    //예: convertAndSendToUser("user123", "/queue/messages", ...) → /user/user123/queue/messages
    brokerRegistry.setUserDestinationPrefix("/user");
  }

  //WebSocket에서 받은 메세지에 로그인된 사용자 인증 정보를 연결해주기 위한 설정이다.
  @Override
  public void configureClientInboundChannel(ChannelRegistration registration) {
    registration.interceptors(new ChannelInterceptor() {          //STOMP 메세지가 @MessageMapping에 들어가기 전 처리할 수 있는 필터를 등록한다.

      @Override
      public Message<?> preSend(Message<?> message, MessageChannel channel) {  // STOMP 메세지를 받고 @MessageMapping에 들어가기 전의 동작을 정의하는 메소드 preSend
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(message);     // STOMP의 헤더 부분만 읽기 위해 래핑.

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();   //Spring Security 컨텍스트에서 현재 로그인한 사용자 정보를 가져와서,
        if (auth != null && accessor.getUser() == null) {                               // 존재 유무를 파악하고
          accessor.setUser(auth);                                                       // STOMP 헤더에 저장한다. - 이 헤더에는 웹소캣 세션도 포함되어 있다.
        }
        return message;                                                                 // 그러고 STOMP 메세지를 반환한다.
      }
    });
  }

}
