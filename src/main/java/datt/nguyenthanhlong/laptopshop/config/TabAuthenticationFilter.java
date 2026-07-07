package datt.nguyenthanhlong.laptopshop.config;

import java.io.IOException;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import datt.nguyenthanhlong.laptopshop.service.TabTokenService;

@Component
public class TabAuthenticationFilter extends OncePerRequestFilter {
    public static final String TAB_TOKEN_COOKIE = "LAPTOPSHOP_TAB_TOKEN";

    private final TabTokenService tabTokenService;
    private final UserDetailsService userDetailsService;

    public TabAuthenticationFilter(TabTokenService tabTokenService, UserDetailsService userDetailsService) {
        this.tabTokenService = tabTokenService;
        this.userDetailsService = userDetailsService;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        String tabToken = request.getParameter("tabToken");
        if (tabToken == null || tabToken.isBlank()) {
            tabToken = request.getHeader("X-Tab-Token");
        }
        if (tabToken == null || tabToken.isBlank()) {
            tabToken = readTokenCookie(request);
        }

        String email = tabTokenService.resolveEmail(tabToken);
        if (email != null) {
            UserDetails userDetails = userDetailsService.loadUserByUsername(email);
            UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(
                    userDetails,
                    null,
                    userDetails.getAuthorities());
            authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
            SecurityContextHolder.getContext().setAuthentication(authentication);
        }

        filterChain.doFilter(request, response);
    }

    private String readTokenCookie(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies == null) {
            return null;
        }
        for (Cookie cookie : cookies) {
            if (TAB_TOKEN_COOKIE.equals(cookie.getName())) {
                return cookie.getValue();
            }
        }
        return null;
    }
}
