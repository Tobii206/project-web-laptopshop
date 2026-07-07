package datt.nguyenthanhlong.laptopshop.service;

import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.stereotype.Service;

@Service
public class TabTokenService {
    private final Map<String, String> tokenToEmail = new ConcurrentHashMap<>();

    public String issueToken(String email) {
        String token = UUID.randomUUID().toString();
        tokenToEmail.put(token, email);
        return token;
    }

    public String resolveEmail(String token) {
        if (token == null || token.isBlank()) {
            return null;
        }
        return tokenToEmail.get(token);
    }

    public void revokeToken(String token) {
        if (token == null || token.isBlank()) {
            return;
        }
        tokenToEmail.remove(token);
    }
}
