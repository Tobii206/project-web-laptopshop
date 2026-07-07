package datt.nguyenthanhlong.laptopshop.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import datt.nguyenthanhlong.laptopshop.domain.Order;
import datt.nguyenthanhlong.laptopshop.domain.OrderStatusHistory;

public interface OrderStatusHistoryRepository extends JpaRepository<OrderStatusHistory, Long> {
    List<OrderStatusHistory> findByOrderOrderByCreatedAtDescIdDesc(Order order);
}
