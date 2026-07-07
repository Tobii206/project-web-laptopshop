package datt.nguyenthanhlong.laptopshop.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import datt.nguyenthanhlong.laptopshop.domain.Cart;
import datt.nguyenthanhlong.laptopshop.domain.CartDetail;
import datt.nguyenthanhlong.laptopshop.domain.Product;

public interface CartDetailRepository extends JpaRepository<CartDetail, Long> {
    boolean existsByCartAndProduct(Cart cart, Product product);

    CartDetail findByCartAndProduct(Cart cart, Product product);
}
