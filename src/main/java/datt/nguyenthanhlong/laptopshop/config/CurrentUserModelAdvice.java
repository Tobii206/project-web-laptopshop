package datt.nguyenthanhlong.laptopshop.config;

import java.util.List;

import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import datt.nguyenthanhlong.laptopshop.domain.Notification;
import datt.nguyenthanhlong.laptopshop.domain.User;
import datt.nguyenthanhlong.laptopshop.service.NotificationService;
import datt.nguyenthanhlong.laptopshop.service.UserService;

@ControllerAdvice
public class CurrentUserModelAdvice {
    private final UserService userService;
    private final NotificationService notificationService;

    public CurrentUserModelAdvice(UserService userService, NotificationService notificationService) {
        this.userService = userService;
        this.notificationService = notificationService;
    }

    @ModelAttribute("currentUser")
    public User currentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            return null;
        }
        return userService.getUserByEmail(authentication.getName());
    }

    @ModelAttribute("currentCartQuantity")
    public long currentCartQuantity() {
        User user = currentUser();
        if (user == null || user.getCart() == null) {
            return 0;
        }
        return user.getCart().getQuantity();
    }

    @ModelAttribute("currentNotifications")
    public List<Notification> currentNotifications() {
        return this.notificationService.fetchLatest(currentUser());
    }

    @ModelAttribute("currentUnreadNotifications")
    public long currentUnreadNotifications() {
        return this.notificationService.countUnread(currentUser());
    }
}
