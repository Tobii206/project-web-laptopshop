package datt.nguyenthanhlong.laptopshop.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import datt.nguyenthanhlong.laptopshop.domain.Order;
import datt.nguyenthanhlong.laptopshop.domain.User;

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {
    Page<Order> findAll(Pageable pageable);
    List<Order> findByUserOrderByCreatedAtDescIdDesc(User user);
    List<Order> findByUserAndCreatedAtBetweenOrderByCreatedAtDescIdDesc(User user, LocalDateTime start, LocalDateTime end);
}
