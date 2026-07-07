package datt.nguyenthanhlong.laptopshop.service;

import java.util.List;
import java.util.ArrayList;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;

import jakarta.servlet.http.HttpSession;
import datt.nguyenthanhlong.laptopshop.domain.Cart;
import datt.nguyenthanhlong.laptopshop.domain.CartDetail;
import datt.nguyenthanhlong.laptopshop.domain.DiscountVoucher;
import datt.nguyenthanhlong.laptopshop.domain.Order;
import datt.nguyenthanhlong.laptopshop.domain.OrderDetail;
import datt.nguyenthanhlong.laptopshop.domain.Product;
import datt.nguyenthanhlong.laptopshop.domain.User;
import datt.nguyenthanhlong.laptopshop.repository.CartDetailRepository;
import datt.nguyenthanhlong.laptopshop.repository.CartRepository;
import datt.nguyenthanhlong.laptopshop.repository.OrderDetailRepository;
import datt.nguyenthanhlong.laptopshop.repository.OrderRepository;
import datt.nguyenthanhlong.laptopshop.repository.ProductRepository;

@Service
public class ProductService {
    private final ProductRepository productRepository;
    private final CartRepository cartRepository;
    private final CartDetailRepository cartDetailRepository;
    private final UserService userService;
    private final OrderRepository orderRepository;
    private final OrderDetailRepository orderDetailRepository;
    private final DiscountVoucherService discountVoucherService;

    public ProductService(ProductRepository productRepository, CartRepository cartRepository,
            CartDetailRepository cartDetailRepository, UserService userService, OrderRepository orderRepository,
            OrderDetailRepository orderDetailRepository, DiscountVoucherService discountVoucherService) {
        this.productRepository = productRepository;
        this.cartRepository = cartRepository;
        this.cartDetailRepository = cartDetailRepository;
        this.userService = userService;
        this.orderRepository = orderRepository;
        this.orderDetailRepository = orderDetailRepository;
        this.discountVoucherService = discountVoucherService;
    }

    public Product handleSaveProduct(Product product) {
        return this.productRepository.save(product);
    }

    public Page<Product> fetchProducts(Pageable pageable) {
        return this.productRepository.findAll(pageable);
    }

    public Page<Product> fetchProductsWithFilters(
            Pageable pageable,
            String keyword,
            List<String> factories,
            List<String> targets,
            List<String> prices) {
        Specification<Product> spec = Specification.where(null);

        if (keyword != null && !keyword.isBlank()) {
            String normalizedKeyword = "%" + keyword.trim().toLowerCase() + "%";
            spec = spec.and((root, query, criteriaBuilder) -> criteriaBuilder.or(
                    criteriaBuilder.like(criteriaBuilder.lower(root.get("name")), normalizedKeyword),
                    criteriaBuilder.like(criteriaBuilder.lower(root.get("shortDesc")), normalizedKeyword),
                    criteriaBuilder.like(criteriaBuilder.lower(root.get("detailDesc")), normalizedKeyword),
                    criteriaBuilder.like(criteriaBuilder.lower(root.get("factory")), normalizedKeyword),
                    criteriaBuilder.like(criteriaBuilder.lower(root.get("target")), normalizedKeyword),
                    criteriaBuilder.like(criteriaBuilder.lower(root.get("target")), "%" + inferTargetKeyword(keyword) + "%")));

            Double inferredMaxPrice = inferMaxPrice(keyword);
            if (inferredMaxPrice != null) {
                spec = spec.and((root, query, criteriaBuilder) ->
                        criteriaBuilder.lessThanOrEqualTo(root.get("price"), inferredMaxPrice));
            }
        }

        if (factories != null && !factories.isEmpty()) {
            spec = spec.and((root, query, criteriaBuilder) -> root.get("factory").in(factories));
        }

        if (targets != null && !targets.isEmpty()) {
            spec = spec.and((root, query, criteriaBuilder) -> root.get("target").in(targets));
        }

        if (prices != null && !prices.isEmpty()) {
            spec = spec.and((root, query, criteriaBuilder) -> {
                List<jakarta.persistence.criteria.Predicate> predicates = new ArrayList<>();
                for (String price : prices) {
                    switch (price) {
                        case "duoi-10-trieu":
                            predicates.add(criteriaBuilder.lessThanOrEqualTo(root.get("price"), 10000000d));
                            break;
                        case "10-15-trieu":
                            predicates.add(criteriaBuilder.between(root.get("price"), 10000000d, 15000000d));
                            break;
                        case "15-20-trieu":
                            predicates.add(criteriaBuilder.between(root.get("price"), 15000000d, 20000000d));
                            break;
                        case "tren-20-trieu":
                            predicates.add(criteriaBuilder.greaterThanOrEqualTo(root.get("price"), 20000000d));
                            break;
                        default:
                            break;
                    }
                }
                return predicates.isEmpty()
                        ? criteriaBuilder.conjunction()
                        : criteriaBuilder.or(predicates.toArray(new jakarta.persistence.criteria.Predicate[0]));
            });
        }

        return this.productRepository.findAll(spec, pageable);
    }

    private String inferTargetKeyword(String keyword) {
        String value = keyword == null ? "" : keyword.toLowerCase();
        if (value.contains("gaming") || value.contains("game")) {
            return "gaming";
        }
        if (value.contains("lap trinh") || value.contains("code") || value.contains("it")) {
            return "sinhvien";
        }
        if (value.contains("hoc") || value.contains("van phong") || value.contains("office")) {
            return "sinhvien";
        }
        if (value.contains("mong nhe") || value.contains("mỏng nhẹ")) {
            return "mong-nhe";
        }
        if (value.contains("do hoa") || value.contains("design") || value.contains("thiet ke")) {
            return "thiet-ke";
        }
        return value.trim();
    }

    private Double inferMaxPrice(String keyword) {
        if (keyword == null) {
            return null;
        }
        String value = keyword.toLowerCase();
        String normalizedValue = java.text.Normalizer.normalize(value, java.text.Normalizer.Form.NFD)
                .replaceAll("\\p{M}", "");
        java.util.regex.Matcher shorthandMatcher = java.util.regex.Pattern.compile("(\\d+)\\s*(trieu|tr|m)\\b")
                .matcher(normalizedValue);
        if (shorthandMatcher.find()) {
            return Double.parseDouble(shorthandMatcher.group(1)) * 1000000d;
        }
        java.util.regex.Matcher matcher = java.util.regex.Pattern.compile("(\\d+)\\s*(trieu|triệu)").matcher(value);
        if (matcher.find()) {
            return Double.parseDouble(matcher.group(1)) * 1000000d;
        }
        java.util.regex.Matcher numberMatcher = java.util.regex.Pattern.compile("(\\d{7,})")
                .matcher(normalizedValue.replace(".", "").replace(",", "").replace(" ", ""));
        if (numberMatcher.find()) {
            return Double.parseDouble(numberMatcher.group(1));
        }
        return null;
    }

    public List<Product> fetchProducts() {
        return this.productRepository.findAll();
    }

    public List<Product> fetchLowStockProducts(long threshold) {
        return this.productRepository.findAll().stream()
                .filter(product -> product.getQuantity() <= threshold)
                .toList();
    }

    public Optional<Product> fetchProductById(long id) {
        return this.productRepository.findById(id);
    }

    public Product findProductById(long id) {
        return this.productRepository.findOneById(id);
    }

    public List<Product> findRelatedProducts(Product product, int limit) {
        if (product == null) {
            return List.of();
        }
        double minPrice = product.getPrice() * 0.75;
        double maxPrice = product.getPrice() * 1.25;
        return this.productRepository.findAll().stream()
                .filter(item -> item.getId() != product.getId())
                .filter(item -> item.getFactory().equalsIgnoreCase(product.getFactory())
                        || item.getTarget().equalsIgnoreCase(product.getTarget())
                        || (item.getPrice() >= minPrice && item.getPrice() <= maxPrice))
                .limit(limit)
                .toList();
    }

    public void handleDeleteProduct(Product product) {
        this.productRepository.delete(product);
    }

    public void handleAddProductToCart(long productId, String email, HttpSession session){
        User user = this.userService.getUserByEmail(email);

        if(user != null){
            Cart cart = this.cartRepository.findByUser(user);

            if(cart == null){
                // Nếu người dùng chưa có giỏ hàng thì tạo ra giỏ hàng
                Cart newCart = new Cart();
                newCart.setUser(user);
                newCart.setQuantity(0);

                cart = newCart;
                // Lưu vào db
                this.cartRepository.save(cart);
            }

            Optional<Product> productOptional = this.productRepository.findById(productId);

            if(productOptional.isPresent()){
                Product product = productOptional.get();
                if (product.getQuantity() <= 0) {
                    return;
                }
                // Tìm ra sản phẩm trong giỏ hàng
                CartDetail oldDetail = this.cartDetailRepository.findByCartAndProduct(cart, product);

                if(oldDetail == null){
                    // Nếu trong giỏ hàng chưa có sản phẩm này
                    CartDetail cartDetail = new CartDetail();

                    cartDetail.setCart(cart);
                    cartDetail.setPrice(product.getPrice());
                    cartDetail.setQuantity(1);
                    cartDetail.setProduct(product);

                    this.cartDetailRepository.save(cartDetail);
                    // Tăng số lượng giỏ hàng lên
                    long quantityCart = cart.getQuantity() + 1;
                    cart.setQuantity(quantityCart);
                    // Lưu số lượng giỏ hàng vào session để cập nhật giao diện
                    if (session != null) {
                        session.setAttribute("quantity", quantityCart);
                    }
                    // Luu vao database
                    this.cartRepository.save(cart);
                } else {
                    // Nếu giỏ hàng đã có sản phẩm này thì chỉ tăng số lượng
                    if (oldDetail.getQuantity() >= product.getQuantity()) {
                        return;
                    }
                    oldDetail.setQuantity(oldDetail.getQuantity()+1);
                    // Luu vao database
                    this.cartDetailRepository.save(oldDetail);
                }
            }
        }
    }

    public void handleAddProductToCartFromProductDetail(long productId, String email, HttpSession session, long quantity){
        User user = this.userService.getUserByEmail(email);

        if(user != null){
            Cart cart = this.cartRepository.findByUser(user);

            if(cart == null){
                // Nếu người dùng chưa có giỏ hàng thì tạo ra giỏ hàng
                Cart newCart = new Cart();
                newCart.setUser(user);
                newCart.setQuantity(0);

                cart = newCart;
                // Lưu vào db
                this.cartRepository.save(cart);
            }

            Optional<Product> productOptional = this.productRepository.findById(productId);

            if(productOptional.isPresent()){
                Product product = productOptional.get();
                if (product.getQuantity() <= 0) {
                    return;
                }
                long safeQuantity = Math.max(1, Math.min(quantity, product.getQuantity()));
                // Tìm ra sản phẩm trong giỏ hàng
                CartDetail oldDetail = this.cartDetailRepository.findByCartAndProduct(cart, product);

                if(oldDetail == null){
                    // Nếu trong giỏ hàng chưa có sản phẩm này
                    CartDetail cartDetail = new CartDetail();

                    cartDetail.setCart(cart);
                    cartDetail.setPrice(product.getPrice());
                    cartDetail.setQuantity(safeQuantity);
                    cartDetail.setProduct(product);

                    this.cartDetailRepository.save(cartDetail);
                    // Tăng số lượng giỏ hàng lên
                    long quantityCart = cart.getQuantity() + 1;
                    cart.setQuantity(quantityCart);
                    // Lưu số lượng giỏ hàng vào session để cập nhật giao diện
                    if (session != null) {
                        session.setAttribute("quantity", quantityCart);
                    }
                    // Luu vao database
                    this.cartRepository.save(cart);
                } else {
                    // Nếu giỏ hàng đã có sản phẩm này thì chỉ tăng số lượng
                    long nextQuantity = Math.min(product.getQuantity(), oldDetail.getQuantity() + safeQuantity);
                    oldDetail.setQuantity(nextQuantity);
                    // Luu vao database
                    this.cartDetailRepository.save(oldDetail);
                }
            }
        }
    }

    public void handleUpdateCartBeforeCheckout(List<CartDetail> cartDetails){
        for(CartDetail cartDetail : cartDetails){
            Optional<CartDetail> cartDetailOptional = this.cartDetailRepository.findById(cartDetail.getId());
            if(cartDetailOptional.isPresent()){
                CartDetail cartDetailCurrent = cartDetailOptional.get();
                long requestedQuantity = Math.max(1, cartDetail.getQuantity());
                long stockQuantity = cartDetailCurrent.getProduct() == null ? requestedQuantity
                        : cartDetailCurrent.getProduct().getQuantity();
                cartDetailCurrent.setQuantity(Math.min(requestedQuantity, stockQuantity));
                this.cartDetailRepository.save(cartDetailCurrent);
            }
        }
    }

    public Order handlePlaceOrder(User user, HttpSession session, String receiverName, String receiverPhone,
            String receiverAddress, String paymentMethod){
        Cart cart = user.getCart();
        if (cart == null || cart.getCartDetails() == null || cart.getCartDetails().isEmpty()) {
            return null;
        }

        Order order = new Order();
        order.setUser(user);
        order.setReceiverName(receiverName);
        order.setReceiverPhone(receiverPhone);
        order.setReceiverAddress(receiverAddress);
        order.setStatus("PENDING");
        String normalizedPaymentMethod = "QR".equalsIgnoreCase(paymentMethod) ? "QR" : "COD";
        order.setPaymentMethod(normalizedPaymentMethod);
        order.setPaymentStatus("QR".equals(normalizedPaymentMethod) ? "WAITING_PAYMENT" : "UNPAID");
        order.setCustomerConfirmedReceived(false);
        order.setReturnRequested(false);
        order.setReturnStatus("NONE");

        double subtotalPrice = 0;
        for(CartDetail cartDetail : cart.getCartDetails()){
             subtotalPrice += cartDetail.getPrice() * cartDetail.getQuantity();
        }
        double discountAmount = 0;
        DiscountVoucher bestVoucher = null;
        Optional<DiscountVoucher> bestVoucherOptional = this.discountVoucherService.findBestVoucher(subtotalPrice);
        if (bestVoucherOptional.isPresent()) {
            bestVoucher = bestVoucherOptional.get();
            discountAmount = this.discountVoucherService.calculateDiscount(bestVoucher, subtotalPrice);
        }

        order.setSubtotalPrice(subtotalPrice);
        order.setDiscountAmount(discountAmount);
        if (bestVoucher != null && discountAmount > 0) {
            order.setVoucherCode(bestVoucher.getCode());
            order.setVoucherName(bestVoucher.getName());
        }
        order.setTotalPrice(Math.max(0, subtotalPrice - discountAmount));

        List<CartDetail> cartDetails = cart.getCartDetails();
        for (CartDetail cartDetail : cartDetails) {
            Product product = cartDetail.getProduct();
            if (product == null || product.getQuantity() < cartDetail.getQuantity()) {
                return null;
            }
        }

        this.orderRepository.save(order);

        for(CartDetail cartDetail : cartDetails){
            Product product = cartDetail.getProduct();
            long orderedQuantity = cartDetail.getQuantity();
            product.setQuantity(Math.max(0, product.getQuantity() - orderedQuantity));
            product.setSold(product.getSold() + orderedQuantity);
            this.productRepository.save(product);

            OrderDetail orderDetail = new OrderDetail();
            orderDetail.setOrder(order);
            orderDetail.setProduct(product);
            orderDetail.setPrice(cartDetail.getPrice());
            orderDetail.setQuantity(orderedQuantity);
            this.orderDetailRepository.save(orderDetail);
        }

        this.cartDetailRepository.deleteAll(cartDetails);

        this.cartRepository.delete(cart);

        if (session != null) {
            session.setAttribute("quantity", 0);
        }

        return order;
    }
}
