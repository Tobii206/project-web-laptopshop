package datt.nguyenthanhlong.laptopshop.config;

import java.util.ArrayList;
import java.util.List;
import java.time.LocalDateTime;

import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

import datt.nguyenthanhlong.laptopshop.domain.Order;
import datt.nguyenthanhlong.laptopshop.domain.OrderDetail;
import datt.nguyenthanhlong.laptopshop.domain.Product;
import datt.nguyenthanhlong.laptopshop.domain.Role;
import datt.nguyenthanhlong.laptopshop.domain.User;
import datt.nguyenthanhlong.laptopshop.domain.DiscountVoucher;
import datt.nguyenthanhlong.laptopshop.repository.DiscountVoucherRepository;
import datt.nguyenthanhlong.laptopshop.repository.OrderDetailRepository;
import datt.nguyenthanhlong.laptopshop.repository.OrderRepository;
import datt.nguyenthanhlong.laptopshop.repository.ProductRepository;
import datt.nguyenthanhlong.laptopshop.repository.RoleRepository;
import datt.nguyenthanhlong.laptopshop.repository.UserRepository;

@Configuration
public class DataInitializer {

    @Bean
    CommandLineRunner initDefaultData(
            RoleRepository roleRepository,
            UserRepository userRepository,
            ProductRepository productRepository,
            OrderRepository orderRepository,
            OrderDetailRepository orderDetailRepository,
            DiscountVoucherRepository discountVoucherRepository,
            PasswordEncoder passwordEncoder) {
        return args -> {
            Role adminRole = ensureRole(roleRepository, "ADMIN", "Administrator");
            Role userRole = ensureRole(roleRepository, "USER", "Default user");

            ensureAdminUser(userRepository, passwordEncoder, adminRole);
            ensureDiscountVouchers(discountVoucherRepository);
            List<User> users = ensureSampleUsers(userRepository, passwordEncoder, userRole);
            List<Product> products = ensureSampleProducts(productRepository);
            ensureSampleOrders(orderRepository, orderDetailRepository, users, products);
        };
    }

    private void ensureDiscountVouchers(DiscountVoucherRepository discountVoucherRepository) {
        ensureDiscountVoucher(discountVoucherRepository, "WELCOME500", "Giam 500k cho don tu 10 trieu", "FIXED",
                500000, 0, 10000000);
        ensureDiscountVoucher(discountVoucherRepository, "LAPTOP5", "Giam 5% toi da 1.5 trieu", "PERCENT",
                5, 1500000, 15000000);
        ensureDiscountVoucher(discountVoucherRepository, "VIP2M", "Giam 2 trieu cho don tu 30 trieu", "FIXED",
                2000000, 0, 30000000);
    }

    private void ensureDiscountVoucher(DiscountVoucherRepository discountVoucherRepository, String code, String name,
            String type, double value, double maxDiscount, double minOrderValue) {
        if (discountVoucherRepository.existsByCode(code)) {
            return;
        }

        DiscountVoucher voucher = new DiscountVoucher();
        voucher.setCode(code);
        voucher.setName(name);
        voucher.setDiscountType(type);
        voucher.setDiscountValue(value);
        voucher.setMaxDiscount(maxDiscount);
        voucher.setMinOrderValue(minOrderValue);
        voucher.setActive(true);
        discountVoucherRepository.save(voucher);
    }

    private Role ensureRole(RoleRepository roleRepository, String name, String description) {
        Role role = roleRepository.findByName(name);
        if (role == null) {
            role = new Role();
            role.setName(name);
            role.setDescription(description);
            role = roleRepository.save(role);
        }
        return role;
    }

    private void ensureAdminUser(UserRepository userRepository, PasswordEncoder passwordEncoder, Role adminRole) {
        String adminEmail = "admin@gmail.com";
        if (!userRepository.existsByEmail(adminEmail)) {
            User admin = new User();
            admin.setEmail(adminEmail);
            admin.setFullName("Administrator");
            admin.setPassword(passwordEncoder.encode("12345678"));
            admin.setAddress("Ho Chi Minh City");
            admin.setPhone("0123456789");
            admin.setRole(adminRole);
            admin.setAvatar("1729616125048-394273848_719384350222734_4927315314174274433_n.jpg");
            userRepository.save(admin);
        }
    }

    private List<User> ensureSampleUsers(
            UserRepository userRepository,
            PasswordEncoder passwordEncoder,
            Role userRole) {
        List<User> users = new ArrayList<>();

        for (int i = 1; i <= 10; i++) {
            String email = "user" + i + "@gmail.com";
            User user = userRepository.findByEmail(email);
            if (user == null) {
                user = new User();
                user.setEmail(email);
                user.setFullName("User " + i);
                user.setPassword(passwordEncoder.encode("12345678"));
                user.setAddress("District " + i + ", Ho Chi Minh City");
                user.setPhone(String.format("09000000%02d", i));
                user.setRole(userRole);
                user.setAvatar("1729516857190-Screenshot_20241016-210116.png");
                user = userRepository.save(user);
            }
            users.add(user);
        }

        return users;
    }

    private List<Product> ensureSampleProducts(ProductRepository productRepository) {
        if (productRepository.count() >= 10) {
            return productRepository.findAll();
        }

        String[][] sampleProducts = {
                { "MacBook Air M3", "28990000", "50", "Laptop Apple mong nhe cho cong viec va hoc tap.",
                        "MacBook Air M3 13 inch, pin tốt, thiết kế gọn nhẹ.", "10", "APPLE", "MONG-NHE",
                        "1731080361004-asus_zenbook_14_oled.jpg" },
                { "ASUS ROG Strix G16", "35990000", "35", "Laptop gaming hieu nang cao voi GPU manh.",
                        "ROG Strix G16 phù hợp gaming và stream.", "7", "ASUS", "GAMING",
                        "1729828677376-9043_hp_victus_900x900_6.jpg" },
                { "Dell XPS 13", "32990000", "28", "Dong ultrabook cao cap cho doanh nhan.",
                        "Dell XPS 13 viền mỏng, màn đẹp, máy gọn.", "5", "DELL", "DOANH-NHAN",
                        "1729829776298-8902_dell_xps_13_9340_t7n66aaaa.jpg" },
                { "Lenovo LOQ 15", "24990000", "40", "Laptop gaming tam trung hieu nang on dinh.",
                        "Lenovo LOQ 15 chiến game và làm việc đa nhiệm.", "8", "LENOVO", "GAMING",
                        "1731079856384-thinkpad_p15.jpg" },
                { "Acer Nitro 5", "21990000", "32", "Laptop gaming pho thong, tan nhiet tot.",
                        "Acer Nitro 5 phù hợp chơi game và học IT.", "11", "ACER", "GAMING",
                        "1729829618767-6713_acer_nitro_5_57y8.jpg" },
                { "LG Gram 16", "30990000", "22", "Laptop sieu nhe voi man hinh lon.",
                        "LG Gram 16 dành cho người cần màn rộng nhưng nhẹ.", "4", "LG", "MONG-NHE",
                        "1729829308254-8982_laptop_lg_gram.jpg" },
                { "ThinkBook 16 G7", "26990000", "30", "Laptop doanh nhan ben bi, ban phim tot.",
                        "ThinkBook 16 G7 phù hợp văn phòng và quản lý.", "6", "LENOVO", "DOANH-NHAN",
                        "1731080051743-thinkbook_16_g7.jpg" },
                { "HP Victus 15", "23990000", "27", "Laptop gaming pho bien cho sinh vien.",
                        "HP Victus 15 hiệu năng ổn định, thiết kế trẻ.", "9", "ASUS", "SINHVIEN-VANPHONG",
                        "1729828677376-9043_hp_victus_900x900_6.jpg" },
                { "ASUS Vivobook S16", "19990000", "45", "Laptop văn phòng màn hình lớn, hiệu năng khá.",
                        "Vivobook S16 phù hợp học tập và làm việc văn phòng.", "13", "ASUS",
                        "SINHVIEN-VANPHONG", "1731080264104-asus_vivobook_s_16.jpg" },
                { "Dell Precision", "41990000", "15", "Workstation cho thiết kế đồ họa và dựng hình.",
                        "Dell Precision danh cho CAD, 3D va do hoa chuyen sau.", "3", "DELL",
                        "THIET-KE-DO-HOA", "1731079730554-dell_precision.jpg" }
        };

        List<Product> products = new ArrayList<>();
        for (String[] sample : sampleProducts) {
            Product product = new Product();
            product.setName(sample[0]);
            product.setPrice(Double.parseDouble(sample[1]));
            product.setQuantity(Long.parseLong(sample[2]));
            product.setDetailDesc(sample[3]);
            product.setShortDesc(sample[4]);
            product.setSold(Long.parseLong(sample[5]));
            product.setFactory(sample[6]);
            product.setTarget(sample[7]);
            product.setImage(sample[8]);
            products.add(product);
        }

        return productRepository.saveAll(products);
    }

    private void ensureSampleOrders(
            OrderRepository orderRepository,
            OrderDetailRepository orderDetailRepository,
            List<User> users,
            List<Product> products) {
        if (users.isEmpty() || products.isEmpty()) {
            return;
        }

        List<Order> existingOrders = orderRepository.findAll();
        if (!existingOrders.isEmpty()) {
            boolean updated = false;
            for (int i = 0; i < existingOrders.size(); i++) {
                Order existingOrder = existingOrders.get(i);
                if (existingOrder.getCreatedAt() == null) {
                    existingOrder.setCreatedAt(LocalDateTime.now().minusDays(existingOrders.size() - i));
                    updated = true;
                }
            }
            if (updated) {
                orderRepository.saveAll(existingOrders);
            }
        }

        if (orderRepository.count() >= 10) {
            return;
        }

        String[] statuses = { "PENDING", "CONFIRM", "SHIPPING", "COMPLETE" };

        for (int i = 0; i < 10; i++) {
            User user = users.get(i % users.size());
            Product productA = products.get(i % products.size());
            Product productB = products.get((i + 1) % products.size());

            long quantityA = (i % 3) + 1;
            long quantityB = ((i + 1) % 2) + 1;
            double totalPrice = productA.getPrice() * quantityA + productB.getPrice() * quantityB;

            Order order = new Order();
            order.setUser(user);
            order.setReceiverName(user.getFullName());
            order.setReceiverPhone(user.getPhone());
            order.setReceiverAddress(user.getAddress());
            order.setStatus(statuses[i % statuses.length]);
            order.setPaymentMethod("COD");
            order.setPaymentStatus("UNPAID");
            order.setTotalPrice(totalPrice);
            order.setCreatedAt(LocalDateTime.now().minusDays(9 - i));
            order = orderRepository.save(order);

            OrderDetail detailA = new OrderDetail();
            detailA.setOrder(order);
            detailA.setProduct(productA);
            detailA.setQuantity(quantityA);
            detailA.setPrice(productA.getPrice());

            OrderDetail detailB = new OrderDetail();
            detailB.setOrder(order);
            detailB.setProduct(productB);
            detailB.setQuantity(quantityB);
            detailB.setPrice(productB.getPrice());

            orderDetailRepository.save(detailA);
            orderDetailRepository.save(detailB);
        }
    }
}
