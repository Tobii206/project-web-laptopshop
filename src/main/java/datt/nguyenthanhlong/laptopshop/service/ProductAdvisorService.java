package datt.nguyenthanhlong.laptopshop.service;

import java.text.Normalizer;
import java.util.Comparator;
import java.util.List;
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.stereotype.Service;

import datt.nguyenthanhlong.laptopshop.domain.Product;
import datt.nguyenthanhlong.laptopshop.domain.dto.ProductRecommendationDTO;

@Service
public class ProductAdvisorService {
    private final ProductService productService;

    public ProductAdvisorService(ProductService productService) {
        this.productService = productService;
    }

    public List<ProductRecommendationDTO> recommend(String need, String budgetText, String purpose, String factory) {
        String normalizedNeed = normalize(need + " " + purpose + " " + factory);
        Double maxBudget = parseBudget(budgetText + " " + need);
        String normalizedFactory = normalize(factory);

        return this.productService.fetchProducts().stream()
                .filter(product -> product.getQuantity() > 0)
                .map(product -> scoreProduct(product, normalizedNeed, maxBudget, normalizedFactory))
                .filter(item -> item.getScore() > 0)
                .sorted(Comparator.comparing(ProductRecommendationDTO::getScore).reversed()
                        .thenComparing(item -> item.getProduct().getPrice()))
                .limit(3)
                .toList();
    }

    public String buildAdvisorSummary(List<ProductRecommendationDTO> recommendations, String need) {
        if (recommendations == null || recommendations.isEmpty()) {
            return "AI chưa tìm thấy mẫu thật sự phù hợp. Hãy tăng ngân sách hoặc mở rộng nhu cầu.";
        }
        Product best = recommendations.get(0).getProduct();
        return "AI goi y uu tien " + best.getName()
                + " vi phu hop nhat voi nhu cau: " + safeText(need, "mua laptop")
                + ". Nên xem thêm 2 mẫu còn lại để so sánh giá và tồn kho.";
    }

    public String buildComparisonSummary(List<Product> products) {
        if (products == null || products.size() < 2) {
            return "Hãy chọn ít nhất 2 sản phẩm để AI so sánh rõ hơn.";
        }

        Product cheapest = products.stream().min(Comparator.comparing(Product::getPrice)).orElse(products.get(0));
        Product bestStock = products.stream().max(Comparator.comparing(Product::getQuantity)).orElse(products.get(0));
        Product gaming = products.stream()
                .filter(product -> normalize(product.getTarget() + " " + product.getName() + " " + product.getShortDesc())
                        .contains("gaming"))
                .findFirst()
                .orElse(null);

        StringBuilder builder = new StringBuilder();
        builder.append("AI nhan xet: ");
        builder.append(cheapest.getName()).append(" đang có giá dễ tiếp cận nhất. ");
        if (gaming != null) {
            builder.append("Neu uu tien gaming, nen xem ").append(gaming.getName()).append(". ");
        }
        builder.append("Neu muon mua nhanh va it rui ro het hang, ")
                .append(bestStock.getName())
                .append(" có tồn kho tốt hơn.");
        return builder.toString();
    }

    private ProductRecommendationDTO scoreProduct(Product product, String need, Double maxBudget, String factory) {
        int score = 20;
        String text = normalize(product.getName() + " " + product.getFactory() + " "
                + product.getTarget() + " " + product.getShortDesc() + " " + product.getDetailDesc());
        StringBuilder reason = new StringBuilder();

        if (maxBudget != null) {
            if (product.getPrice() <= maxBudget) {
                score += 35;
                reason.append("nam trong ngan sach; ");
            } else if (product.getPrice() <= maxBudget * 1.12) {
                score += 12;
                reason.append("vuot nhe ngan sach nhung van dang can nhac; ");
            } else {
                score -= 45;
            }
        }

        if (!factory.isBlank() && text.contains(factory)) {
            score += 18;
            reason.append("dung hang yeu thich; ");
        }

        if (need.contains("gaming") || need.contains("game")) {
            score += containsAny(text, "gaming", "rog", "loq", "victus", "rtx") ? 28 : -8;
            reason.append("phu hop nhu cau gaming; ");
        }
        if (containsAny(need, "lap trinh", "code", "it", "hoc")) {
            score += containsAny(text, "ram", "ssd", "i5", "i7", "ultra", "ryzen", "lap trinh", "sinh vien") ? 22 : 4;
            reason.append("hop hoc tap/lap trinh; ");
        }
        if (containsAny(need, "van phong", "mong nhe", "pin", "di chuyen")) {
            score += containsAny(text, "mong", "nhe", "air", "xps", "zenbook", "pin", "van phong") ? 24 : 2;
            reason.append("hop van phong va di chuyen; ");
        }
        if (containsAny(need, "do hoa", "thiet ke", "design", "render")) {
            score += containsAny(text, "do hoa", "design", "rtx", "gaming", "creator") ? 24 : 2;
            reason.append("co the dung cho do hoa; ");
        }

        if (product.getQuantity() > 0) {
            score += Math.min(10, (int) product.getQuantity() / 5);
        }
        if (product.getSold() > 0) {
            score += Math.min(8, (int) product.getSold());
        }

        if (reason.length() == 0) {
            reason.append("cân bằng giá, tồn kho và mô tả sản phẩm; ");
        }
        return new ProductRecommendationDTO(product, Math.max(score, 0), trimReason(reason.toString()));
    }

    private boolean containsAny(String text, String... tokens) {
        for (String token : tokens) {
            if (text.contains(token)) {
                return true;
            }
        }
        return false;
    }

    private Double parseBudget(String value) {
        String normalized = normalize(value);
        Matcher millionMatcher = Pattern.compile("(\\d+)\\s*(trieu|tr|m)\\b").matcher(normalized);
        if (millionMatcher.find()) {
            return Double.parseDouble(millionMatcher.group(1)) * 1000000d;
        }
        Matcher numberMatcher = Pattern.compile("(\\d{7,})")
                .matcher(normalized.replace(".", "").replace(",", "").replace(" ", ""));
        if (numberMatcher.find()) {
            return Double.parseDouble(numberMatcher.group(1));
        }
        return null;
    }

    private String normalize(String value) {
        if (value == null) {
            return "";
        }
        String normalized = Normalizer.normalize(value, Normalizer.Form.NFD)
                .replaceAll("\\p{M}", "")
                .toLowerCase(Locale.ROOT);
        return normalized.replace('đ', 'd').trim();
    }

    private String trimReason(String reason) {
        String value = reason == null ? "" : reason.trim();
        if (value.endsWith(";")) {
            value = value.substring(0, value.length() - 1);
        }
        return value;
    }

    private String safeText(String value, String fallback) {
        return value == null || value.isBlank() ? fallback : value.trim();
    }
}
