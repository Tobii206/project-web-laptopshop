package datt.nguyenthanhlong.laptopshop.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

import datt.nguyenthanhlong.laptopshop.service.AiChatRealtimeService;

@Configuration
@EnableWebSocket
public class AiChatWebSocketConfig implements WebSocketConfigurer {
    private final AiChatRealtimeService aiChatRealtimeService;

    public AiChatWebSocketConfig(AiChatRealtimeService aiChatRealtimeService) {
        this.aiChatRealtimeService = aiChatRealtimeService;
    }

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        registry.addHandler(this.aiChatRealtimeService, "/ws/ai-chat")
                .setAllowedOriginPatterns("*");
    }
}
