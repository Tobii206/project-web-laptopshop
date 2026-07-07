package datt.nguyenthanhlong.laptopshop.controller.client;

import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpServletRequest;
import datt.nguyenthanhlong.laptopshop.domain.Notification;
import datt.nguyenthanhlong.laptopshop.domain.User;
import datt.nguyenthanhlong.laptopshop.service.NotificationService;
import datt.nguyenthanhlong.laptopshop.service.UserService;

@Controller
public class NotificationController {
    private final NotificationService notificationService;
    private final UserService userService;

    public NotificationController(NotificationService notificationService, UserService userService) {
        this.notificationService = notificationService;
        this.userService = userService;
    }

    @GetMapping("/notifications/read/{id}")
    public String readNotification(@PathVariable long id, HttpServletRequest request) {
        if (request.getUserPrincipal() == null) {
            return "redirect:/login";
        }
        User currentUser = this.userService.getUserByEmail(request.getUserPrincipal().getName());
        String link = this.notificationService.markReadAndGetLink(id, currentUser);
        return "redirect:" + normalizeRedirect(link);
    }

    @GetMapping("/notifications/api/current")
    @ResponseBody
    public Map<String, Object> currentNotifications(HttpServletRequest request) {
        Map<String, Object> response = new LinkedHashMap<>();
        if (request.getUserPrincipal() == null) {
            response.put("unread", 0);
            response.put("notifications", java.util.List.of());
            return response;
        }

        User currentUser = this.userService.getUserByEmail(request.getUserPrincipal().getName());
        response.put("unread", this.notificationService.countUnread(currentUser));
        response.put("notifications", this.notificationService.fetchLatest(currentUser).stream()
                .map(this::toDto)
                .toList());
        return response;
    }

    private String normalizeRedirect(String link) {
        if (link == null || link.isBlank() || !link.startsWith("/") || link.startsWith("//")) {
            return "/";
        }
        if (link.equals("/ai-chat") || link.startsWith("/ai-chat?")) {
            return "/?openChat=1";
        }
        return link;
    }

    private Map<String, Object> toDto(Notification notification) {
        Map<String, Object> dto = new LinkedHashMap<>();
        dto.put("id", notification.getId());
        dto.put("title", notification.getTitle());
        dto.put("content", notification.getContent());
        dto.put("readStatus", notification.isReadStatus());
        return dto;
    }
}
