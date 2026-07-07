package datt.nguyenthanhlong.laptopshop.controller.client;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import datt.nguyenthanhlong.laptopshop.config.TabAuthenticationFilter;
import datt.nguyenthanhlong.laptopshop.domain.User;
import datt.nguyenthanhlong.laptopshop.service.TabTokenService;
import datt.nguyenthanhlong.laptopshop.service.UserService;

@Controller
public class TabAuthController {
    private final DaoAuthenticationProvider authProvider;
    private final TabTokenService tabTokenService;
    private final UserService userService;

    public TabAuthController(DaoAuthenticationProvider authProvider, TabTokenService tabTokenService,
            UserService userService) {
        this.authProvider = authProvider;
        this.tabTokenService = tabTokenService;
        this.userService = userService;
    }

    @PostMapping("/tab-login")
    public void login(
            @RequestParam("username") String username,
            @RequestParam("password") String password,
            HttpServletResponse response) throws IOException {
        try {
            Authentication authentication = authProvider.authenticate(
                    UsernamePasswordAuthenticationToken.unauthenticated(username, password));

            User user = userService.getUserByEmail(authentication.getName());
            if (user == null) {
                throw new BadCredentialsException("User not found");
            }

            String token = tabTokenService.issueToken(user.getEmail());
            Cookie tokenCookie = new Cookie(TabAuthenticationFilter.TAB_TOKEN_COOKIE, token);
            tokenCookie.setHttpOnly(true);
            tokenCookie.setPath("/");
            tokenCookie.setMaxAge(60 * 60 * 24 * 7);
            response.addCookie(tokenCookie);

            String targetUrl = "ADMIN".equals(user.getRole().getName()) ? "/admin" : "/";
            response.sendRedirect(targetUrl + "?tabToken=" + URLEncoder.encode(token, StandardCharsets.UTF_8));
        } catch (BadCredentialsException ex) {
            response.sendRedirect("/login?error");
        }
    }

    @PostMapping("/tab-logout")
    public String logout(@RequestParam(value = "tabToken", required = false) String tabToken,
            HttpServletRequest request,
            HttpServletResponse response) {
        if (tabToken == null || tabToken.isBlank()) {
            tabToken = readTokenCookie(request);
        }
        tabTokenService.revokeToken(tabToken);
        Cookie tokenCookie = new Cookie(TabAuthenticationFilter.TAB_TOKEN_COOKIE, "");
        tokenCookie.setHttpOnly(true);
        tokenCookie.setPath("/");
        tokenCookie.setMaxAge(0);
        response.addCookie(tokenCookie);
        return "redirect:/login?logout";
    }

    private String readTokenCookie(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies == null) {
            return null;
        }
        for (Cookie cookie : cookies) {
            if (TabAuthenticationFilter.TAB_TOKEN_COOKIE.equals(cookie.getName())) {
                return cookie.getValue();
            }
        }
        return null;
    }
}
