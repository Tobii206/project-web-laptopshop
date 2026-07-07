package datt.nguyenthanhlong.laptopshop.controller.client;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import datt.nguyenthanhlong.laptopshop.domain.Cart;
import datt.nguyenthanhlong.laptopshop.domain.CartDetail;
import datt.nguyenthanhlong.laptopshop.domain.DiscountVoucher;
import datt.nguyenthanhlong.laptopshop.domain.Order;
import datt.nguyenthanhlong.laptopshop.domain.Product;
import datt.nguyenthanhlong.laptopshop.domain.Review;
import datt.nguyenthanhlong.laptopshop.domain.User;
import datt.nguyenthanhlong.laptopshop.repository.CartDetailRepository;
import datt.nguyenthanhlong.laptopshop.repository.CartRepository;
import datt.nguyenthanhlong.laptopshop.service.OrderDetailService;
import datt.nguyenthanhlong.laptopshop.service.OrderService;
import datt.nguyenthanhlong.laptopshop.service.DiscountVoucherService;
import datt.nguyenthanhlong.laptopshop.service.ProductService;
import datt.nguyenthanhlong.laptopshop.service.ReviewService;
import datt.nguyenthanhlong.laptopshop.service.UserService;

@Controller
public class ItemController {

    private final ProductService productService;
    private final UserService userService;
    private final CartRepository cartRepository;
    private final CartDetailRepository cartDetailRepository;
    private final OrderDetailService orderDetailService;
    private final ReviewService reviewService;
    private final DiscountVoucherService discountVoucherService;
    private final OrderService orderService;

    public ItemController(ProductService productService, UserService userService, CartRepository cartRepository,
            CartDetailRepository cartDetailRepository, OrderDetailService orderDetailService, ReviewService reviewService,
            DiscountVoucherService discountVoucherService, OrderService orderService) {
        this.productService = productService;
        this.userService = userService;
        this.cartRepository = cartRepository;
        this.cartDetailRepository = cartDetailRepository;
        this.orderDetailService = orderDetailService;
        this.reviewService = reviewService;
        this.discountVoucherService = discountVoucherService;
        this.orderService = orderService;
    }

    @GetMapping("/cart")
    public String getCartPage(Model model, HttpServletRequest request){
        String email = request.getUserPrincipal().getName();

        User user = this.userService.getUserByEmail(email);
        Cart cart = user.getCart();
        List<CartDetail> cartDetails = cart == null ? new ArrayList<CartDetail>() : cart.getCartDetails();

        double totalPrice = 0;
        for(CartDetail cartDetail : cartDetails){
            totalPrice += cartDetail.getPrice() * cartDetail.getQuantity();
        }

        model.addAttribute("cartDetails", cartDetails);
        model.addAttribute("totalPrice", totalPrice);
        model.addAttribute("cart", cart);

        return "client/cart/show";
    }

    @PostMapping("/add-product-to-cart/{id}")
    public String addProductToCart(@PathVariable long id, HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        long productId = id;
        String email = request.getUserPrincipal().getName();
        // Truyền vào session để cập nhật dữ liệu lên giao diện trực tiếp
        this.productService.handleAddProductToCart(productId, email, session);

        return "redirect:/";
    }

    @PostMapping("/add-product-to-cart-from-product-detail")
    public String addProductToCartFromProductDetail(@RequestParam("id") String id,
            @RequestParam(value = "quantity", required = false) String quantity, HttpServletRequest request){
        if (id == null || id.isBlank()) {
            return "redirect:/shop";
        }
        long productId = Long.parseLong(id);
        long parsedQuantity = (quantity == null || quantity.isBlank()) ? 1 : Long.parseLong(quantity);
        HttpSession session = request.getSession(false);
        String email = request.getUserPrincipal().getName();

        this.productService.handleAddProductToCartFromProductDetail(productId, email, session, parsedQuantity);
        return "redirect:/product/" + productId;
    }

    @PostMapping("/delete-cart-product/{id}")
    public String deleteCartProduct(@PathVariable long id, HttpServletRequest request) {

        HttpSession session = request.getSession(false);
        // Lấy ra id của cartDetail cẫn xóa
        long cartDetailId = id;
        // Lấy ra cartDetail cần xóa
        CartDetail cartDetail = this.cartDetailRepository.findById(cartDetailId).get();
        // Lấy ra cart của cartDetail
        Cart cart = cartDetail.getCart();
        // Xóa cartDetail
        this.cartDetailRepository.delete(cartDetail);

        if(cart.getQuantity() > 1){
            cart.setQuantity(cart.getQuantity() - 1);
            this.cartRepository.save(cart);
            session.setAttribute("quantity", cart.getQuantity());
        }else{
            this.cartRepository.delete(cart);
            session.setAttribute("quantity", 0);
        }
        return "redirect:/cart";
    }

    @PostMapping("/confirm-checkout")
    public String getCheckoutPage(@ModelAttribute("cart") Cart cart){
        List<CartDetail> cartDetails = cart == null ? new ArrayList<CartDetail>() : cart.getCartDetails();
        this.productService.handleUpdateCartBeforeCheckout(cartDetails);

        return "redirect:/checkout";
    }

    @GetMapping("/checkout")
    public String getCheckoutPage(Model model, HttpServletRequest request){
        String email = request.getUserPrincipal().getName();

        User user = this.userService.getUserByEmail(email);
        Cart cart = user.getCart();
        List<CartDetail> cartDetails = cart == null ? new ArrayList<CartDetail>() : cart.getCartDetails();

        double totalPrice = 0;
        for(CartDetail cartDetail : cartDetails){
            totalPrice += cartDetail.getPrice() * cartDetail.getQuantity();
        }
        DiscountVoucher bestVoucher = this.discountVoucherService.findBestVoucher(totalPrice).orElse(null);
        double discountAmount = this.discountVoucherService.calculateDiscount(bestVoucher, totalPrice);

        model.addAttribute("cartDetails", cartDetails);
        model.addAttribute("totalPrice", totalPrice);
        model.addAttribute("bestVoucher", bestVoucher);
        model.addAttribute("discountAmount", discountAmount);
        model.addAttribute("finalPrice", Math.max(0, totalPrice - discountAmount));
        return "client/cart/checkout";
    }

    @PostMapping("/place-order")
    public String handlePlaceOrder(HttpServletRequest request,
                                    Model model,
                                    @RequestParam("receiverName") String receiverName,
                                    @RequestParam("receiverPhone") String receiverPhone,
                                    @RequestParam("receiverAddress") String receiverAddress,
                                    @RequestParam(value = "paymentMethod", defaultValue = "COD") String paymentMethod){
        HttpSession session = request.getSession(false);
        String email = request.getUserPrincipal().getName();
        User user = this.userService.getUserByEmail(email);

        Order order = this.productService.handlePlaceOrder(user, session, receiverName, receiverPhone, receiverAddress,
                paymentMethod);
        model.addAttribute("order", order);
        if (order != null && "QR".equalsIgnoreCase(order.getPaymentMethod())) {
            model.addAttribute("qrUrl", buildQrUrl(order));
        }
        return "client/cart/thanks";
    }

    @PostMapping("/order-history/{id}/payment-submitted")
    public String markPaymentSubmitted(@PathVariable long id, HttpServletRequest request) {
        User currentUser = this.userService.getUserByEmail(request.getUserPrincipal().getName());
        this.orderService.markQrPaymentSubmitted(id, currentUser);
        return "redirect:/order-history";
    }

    private String buildQrUrl(Order order) {
        String addInfo = "ORDER" + order.getId();
        String accountName = URLEncoder.encode("NGUYEN THANH LONG", StandardCharsets.UTF_8);
        String encodedAddInfo = URLEncoder.encode(addInfo, StandardCharsets.UTF_8);
        return "https://img.vietqr.io/image/TCB-3208032006-compact2.png?amount="
                + Math.round(order.getTotalPrice())
                + "&addInfo=" + encodedAddInfo
                + "&accountName=" + accountName;
    }


    @GetMapping("/product/{id}")
    public String getProductPage(Model model, @PathVariable long id, HttpServletRequest request) {
        Product pr = this.productService.fetchProductById(id).get();
        List<Review> reviews = this.reviewService.fetchReviewsByProduct(pr);
        boolean canReview = false;
        long reviewTurns = 0;
        if (request.getUserPrincipal() != null) {
            User user = this.userService.getUserByEmail(request.getUserPrincipal().getName());
            if (user != null) {
                reviewTurns = this.reviewService.countAvailableReviewTurns(pr, user);
                canReview = reviewTurns > 0;
            }
        }
        model.addAttribute("product", pr);
        model.addAttribute("reviews", reviews);
        model.addAttribute("canReview", canReview);
        model.addAttribute("reviewTurns", reviewTurns);
        model.addAttribute("relatedProducts", this.productService.findRelatedProducts(pr, 4));
        return "client/product/detail";
    }

    @PostMapping("/product/{id}/review")
    public String submitReview(@PathVariable long id,
            @RequestParam("rating") int rating,
            @RequestParam("comment") String comment,
            HttpServletRequest request) {
        if (request.getUserPrincipal() == null) {
            return "redirect:/login";
        }

        User user = this.userService.getUserByEmail(request.getUserPrincipal().getName());
        Product product = this.productService.findProductById(id);
        if (user == null || product == null) {
            return "redirect:/product/" + id;
        }

        if (this.reviewService.countAvailableReviewTurns(product, user) <= 0) {
            return "redirect:/product/" + id;
        }

        int normalizedRating = Math.max(1, Math.min(5, rating));
        String normalizedComment = comment == null ? "" : comment.trim();
        if (normalizedComment.isBlank()) {
            return "redirect:/product/" + id;
        }

        this.reviewService.saveReviewForCompletedOrder(product, user, normalizedRating, normalizedComment);
        return "redirect:/product/" + id;
    }

}
