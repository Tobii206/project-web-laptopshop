package datt.nguyenthanhlong.laptopshop.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import datt.nguyenthanhlong.laptopshop.domain.Notification;
import datt.nguyenthanhlong.laptopshop.domain.User;

@Repository
public interface NotificationRepository extends JpaRepository<Notification, Long> {
    List<Notification> findTop5ByUserOrderByCreatedAtDesc(User user);

    long countByUserAndReadStatusFalse(User user);
}
