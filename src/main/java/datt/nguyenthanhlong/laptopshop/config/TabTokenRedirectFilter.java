package datt.nguyenthanhlong.laptopshop.config;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpServletResponseWrapper;

@Component
public class TabTokenRedirectFilter extends OncePerRequestFilter {

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        String tabToken = request.getParameter("tabToken");
        if (tabToken == null || tabToken.isBlank()) {
            filterChain.doFilter(request, response);
            return;
        }

        HttpServletResponseWrapper responseWrapper = new HttpServletResponseWrapper(response) {
            @Override
            public void sendRedirect(String location) throws IOException {
                super.sendRedirect(appendTabToken(location, tabToken));
            }
        };

        filterChain.doFilter(request, responseWrapper);
    }

    private String appendTabToken(String location, String tabToken) {
        if (location == null || location.isBlank() || location.contains("tabToken=")) {
            return location;
        }
        String separator = location.contains("?") ? "&" : "?";
        return location + separator + "tabToken=" + URLEncoder.encode(tabToken, StandardCharsets.UTF_8);
    }
}
