package datt.nguyenthanhlong.laptopshop.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import datt.nguyenthanhlong.laptopshop.domain.DiscountVoucher;

@Repository
public interface DiscountVoucherRepository extends JpaRepository<DiscountVoucher, Long> {
    boolean existsByCode(String code);

    List<DiscountVoucher> findByActiveTrue();
}
