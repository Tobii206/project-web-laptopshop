package datt.nguyenthanhlong.laptopshop.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import datt.nguyenthanhlong.laptopshop.domain.Cart;
import datt.nguyenthanhlong.laptopshop.domain.User;

public interface CartRepository extends JpaRepository<Cart, Long> {
    Cart findByUser(User user);
}
