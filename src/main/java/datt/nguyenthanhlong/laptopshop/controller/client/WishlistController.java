package datt.nguyenthanhlong.laptopshop.controller.client;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

import jakarta.servlet.http.HttpServletRequest;
import datt.nguyenthanhlong.laptopshop.domain.Product;
import datt.nguyenthanhlong.laptopshop.domain.User;
import datt.nguyenthanhlong.laptopshop.domain.WishlistItem;
import datt.nguyenthanhlong.laptopshop.repository.WishlistItemRepository;
import datt.nguyenthanhlong.laptopshop.service.ProductService;
import datt.nguyenthanhlong.laptopshop.service.UserService;

@Controller
public class WishlistController {
    private final WishlistItemRepository wishlistItemRepository;
    private final ProductService productService;
    private final UserService userService;

    public WishlistController(WishlistItemRepository wishlistItemRepository, ProductService productService,
            UserService userService) {
        this.wishlistItemRepository = wishlistItemRepository;
        this.productService = productService;
        this.userService = userService;
    }

    @GetMapping("/wishlist")
    public String showWishlist(Model model, HttpServletRequest request) {
        User user = getCurrentUser(request);
        model.addAttribute("items", this.wishlistItemRepository.findByUserOrderByIdDesc(user));
        return "client/wishlist/show";
    }

    @PostMapping("/wishlist/add/{id}")
    public String addWishlist(@PathVariable long id, HttpServletRequest request) {
        User user = getCurrentUser(request);
        Product product = this.productService.findProductById(id);
        if (user != null && product != null && this.wishlistItemRepository.findByUserAndProduct(user, product).isEmpty()) {
            WishlistItem item = new WishlistItem();
            item.setUser(user);
            item.setProduct(product);
            this.wishlistItemRepository.save(item);
        }
        return "redirect:/product/" + id;
    }

    @PostMapping("/wishlist/delete/{id}")
    public String deleteWishlist(@PathVariable long id) {
        this.wishlistItemRepository.deleteById(id);
        return "redirect:/wishlist";
    }

    private User getCurrentUser(HttpServletRequest request) {
        if (request.getUserPrincipal() == null) {
            return null;
        }
        return this.userService.getUserByEmail(request.getUserPrincipal().getName());
    }
}
