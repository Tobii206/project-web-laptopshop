package datt.nguyenthanhlong.laptopshop.repository;

import java.util.Collection;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import datt.nguyenthanhlong.laptopshop.domain.OrderDetail;
import datt.nguyenthanhlong.laptopshop.domain.User;
import datt.nguyenthanhlong.laptopshop.domain.WarrantyClaim;

public interface WarrantyClaimRepository extends JpaRepository<WarrantyClaim, Long> {
    List<WarrantyClaim> findAllByOrderByRequestedAtDescIdDesc();
    List<WarrantyClaim> findByUserOrderByRequestedAtDescIdDesc(User user);
    List<WarrantyClaim> findByOrderDetailIn(Collection<OrderDetail> orderDetails);
    Optional<WarrantyClaim> findByOrderDetail(OrderDetail orderDetail);
}
