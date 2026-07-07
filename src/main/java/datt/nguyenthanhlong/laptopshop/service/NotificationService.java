package datt.nguyenthanhlong.laptopshop
.service;

import java.util.List;

import org.springframework.stereotype.Service;

import datt.nguyenthanhlong.laptopshop.domain.Notification;
import datt.nguyenthanhlong.laptopshop.domain.User;
import datt.nguyenthanhlong.laptopshop.repository.NotificationRepository;
import datt.nguyenthanhlong.laptopshop.repository.UserRepository;

@Service
public class NotificationService {
    private final NotificationRepository notificationRepository;
    private final UserRepository userRepository;

    public NotificationService(NotificationRepository notificationRepository, UserRepository userRepository) {
        this.notificationRepository = notificationRepository;
        this.userRepository = userRepository;
    }

    public void notify(User user, String title, String content, String link) {
        if (user == null) {
            return;
        }
        Notification notification = new Notification();
        notification.setUser(user);
        notification.setTitle(title);
        notification.setContent(content);
        notification.setLink(link);
        notification.setReadStatus(false);
        this.notificationRepository.save(notification);
    }

    public void notifyAdmins(String title, String content, String link) {
        List<User> admins = this.userRepository.findByRole_Name("ADMIN");
        for (User admin : admins) {
            notify(admin, title, content, link);
        }
    }

    public List<Notification> fetchLatest(User user) {
        if (user == null) {
            return List.of();
        }
        return this.notificationRepository.findTop5ByUserOrderByCreatedAtDesc(user);
    }

    public long countUnread(User user) {
        if (user == null) {
            return 0;
        }
        return this.notificationRepository.countByUserAndReadStatusFalse(user);
    }

    public void markAllRead(User user) {
        if (user == null) {
            return;
        }
        List<Notification> notifications = this.notificationRepository.findTop5ByUserOrderByCreatedAtDesc(user);
        for (Notification notification : notifications) {
            notification.setReadStatus(true);
        }
        this.notificationRepository.saveAll(notifications);
    }

    public String markReadAndGetLink(long notificationId, User user) {
        if (user == null) {
            return "/";
        }
        return this.notificationRepository.findById(notificationId)
                .filter(notification -> notification.getUser() != null && notification.getUser().getId() == user.getId())
                .map(notification -> {
                    notification.setReadStatus(true);
                    this.notificationRepository.save(notification);
                    String link = notification.getLink();
                    return link == null || link.isBlank() ? "/" : link;
                })
                .orElse("/");
    }
}
