package datt.nguyenthanhlong.laptopshop.service;

import java.io.IOException;
import java.net.URI;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.Collections;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.stereotype.Service;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class AiChatRealtimeService extends TextWebSocketHandler {
    private final ObjectMapper objectMapper;
    private final Set<WebSocketSession> adminSessions = ConcurrentHashMap.newKeySet();
    private final Map<String, Set<WebSocketSession>> customerSessions = new ConcurrentHashMap<>();

    public AiChatRealtimeService(ObjectMapper objectMapper) {
        this.objectMapper = objectMapper;
    }

    @Override
    public void afterConnectionEstablished(WebSocketSession session) {
        Map<String, String> params = queryParams(session.getUri());
        String role = params.getOrDefault("role", "");
        String conversationKey = params.getOrDefault("conversationKey", "");
        session.getAttributes().put("role", role);
        session.getAttributes().put("conversationKey", conversationKey);

        if ("admin".equalsIgnoreCase(role)) {
            this.adminSessions.add(session);
            return;
        }
        if (!conversationKey.isBlank()) {
            this.customerSessions.computeIfAbsent(conversationKey, key -> ConcurrentHashMap.newKeySet()).add(session);
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) {
        this.adminSessions.remove(session);
        Object conversationKey = session.getAttributes().get("conversationKey");
        if (conversationKey instanceof String key && !key.isBlank()) {
            Set<WebSocketSession> sessions = this.customerSessions.getOrDefault(key, Collections.emptySet());
            sessions.remove(session);
            if (sessions.isEmpty()) {
                this.customerSessions.remove(key);
            }
        }
    }

    public void notifyConversationUpdated(String conversationKey) {
        if (conversationKey == null || conversationKey.isBlank()) {
            return;
        }

        try {
            String payload = this.objectMapper.writeValueAsString(Map.of(
                    "type", "chat_updated",
                    "conversationKey", conversationKey,
                    "sentAt", Instant.now().toString()));
            sendAll(this.adminSessions, payload);
            sendAll(this.customerSessions.getOrDefault(conversationKey, Collections.emptySet()), payload);
        } catch (IOException ignored) {
        }
    }

    private void sendAll(Set<WebSocketSession> sessions, String payload) {
        for (WebSocketSession session : sessions) {
            send(session, payload);
        }
    }

    private void send(WebSocketSession session, String payload) {
        if (session == null || !session.isOpen()) {
            return;
        }
        try {
            session.sendMessage(new TextMessage(payload));
        } catch (IOException ignored) {
        }
    }

    private Map<String, String> queryParams(URI uri) {
        Map<String, String> params = new ConcurrentHashMap<>();
        if (uri == null || uri.getQuery() == null || uri.getQuery().isBlank()) {
            return params;
        }
        for (String pair : uri.getQuery().split("&")) {
            int index = pair.indexOf('=');
            if (index <= 0) {
                continue;
            }
            String key = URLDecoder.decode(pair.substring(0, index), StandardCharsets.UTF_8);
            String value = URLDecoder.decode(pair.substring(index + 1), StandardCharsets.UTF_8);
            params.put(key, value);
        }
        return params;
    }
}
