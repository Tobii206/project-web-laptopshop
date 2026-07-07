package datt.nguyenthanhlong.laptopshop.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import datt.nguyenthanhlong.laptopshop.domain.Product;
import datt.nguyenthanhlong.laptopshop.domain.User;
import datt.nguyenthanhlong.laptopshop.domain.WishlistItem;

@Repository
public interface WishlistItemRepository extends JpaRepository<WishlistItem, Long> {
    List<WishlistItem> findByUserOrderByIdDesc(User user);

    Optional<WishlistItem> findByUserAndProduct(User user, Product product);
}
