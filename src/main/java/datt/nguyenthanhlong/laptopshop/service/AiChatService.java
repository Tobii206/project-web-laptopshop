package datt.nguyenthanhlong.laptopshop.service;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

import datt.nguyenthanhlong.laptopshop.domain.AiChatMessage;
import datt.nguyenthanhlong.laptopshop.domain.Product;
import datt.nguyenthanhlong.laptopshop.domain.User;
import datt.nguyenthanhlong.laptopshop.domain.dto.ProductRecommendationDTO;
import datt.nguyenthanhlong.laptopshop.repository.AiChatMessageRepository;

@Service
public class AiChatService {
    public static final String SENDER_CUSTOMER = "CUSTOMER";
    public static final String SENDER_AI = "AI";
    public static final String SENDER_ADMIN = "ADMIN";

    private static final String STATUS_NEW = "NEW";
    private static final String STATUS_AI_REPLIED = "AI_REPLIED";
    private static final String STATUS_WAITING_ADMIN = "WAITING_ADMIN";
    private static final String STATUS_REPLIED = "REPLIED";

    private final AiChatMessageRepository aiChatMessageRepository;
    private final NotificationService notificationService;
    private final ProductService productService;
    private final ProductAdvisorService productAdvisorService;
    private final AiChatRealtimeService aiChatRealtimeService;
    private final ObjectMapper objectMapper;
    private final HttpClient httpClient;

    @Value("${openai.api-key:}")
    private String openAiApiKey;

    @Value("${openai.model:gpt-4.1}")
    private String openAiModel;

    public AiChatService(AiChatMessageRepository aiChatMessageRepository, ObjectMapper objectMapper,
            NotificationService notificationService, ProductService productService,
            ProductAdvisorService productAdvisorService, AiChatRealtimeService aiChatRealtimeService) {
        this.aiChatMessageRepository = aiChatMessageRepository;
        this.notificationService = notificationService;
        this.productService = productService;
        this.productAdvisorService = productAdvisorService;
        this.aiChatRealtimeService = aiChatRealtimeService;
        this.objectMapper = objectMapper;
        this.httpClient = HttpClient.newHttpClient();
    }

    public AiChatMessage createMessage(String question, User user, String guestName, String guestEmail) {
        String conversationKey = user == null ? "" : buildUserConversationKey(user);
        return createMessage(question, user, guestName, guestEmail, conversationKey);
    }

    public AiChatMessage createMessage(String question, User user, String guestName, String guestEmail,
            String conversationKey) {
        return createAdminMessage(question, user, guestName, guestEmail, conversationKey);
    }

    public AiChatMessage createAdminMessage(String question, User user, String guestName, String guestEmail,
            String conversationKey) {
        if (user == null) {
            throw new IllegalArgumentException("Khách vãng lai không được gửi tin nhắn admin.");
        }
        String resolvedConversationKey = resolveScopedConversationKey(user, conversationKey, "ADMIN");
        AiChatMessage customerMessage = new AiChatMessage();
        customerMessage.setConversationKey(resolvedConversationKey);
        customerMessage.setSenderType(SENDER_CUSTOMER);
        customerMessage.setContent(normalize(question));
        customerMessage.setQuestion(normalize(question));
        customerMessage.setUser(user);
        customerMessage.setCustomerName(resolveName(user, guestName));
        customerMessage.setCustomerEmail(resolveEmail(user, guestEmail));
        customerMessage.setStatus(STATUS_WAITING_ADMIN);
        customerMessage = this.aiChatMessageRepository.save(customerMessage);
        this.notificationService.notifyAdmins("Khách hàng vừa nhắn tin",
                customerMessage.getCustomerName() + ": " + normalize(question),
                "/admin/ai-messages?conversationKey=" + resolvedConversationKey);
        this.aiChatRealtimeService.notifyConversationUpdated(resolvedConversationKey);
        return customerMessage;
    }

    public AiChatMessage createAiMessage(String question, User user, String guestName, String guestEmail,
            String conversationKey) {
        String resolvedConversationKey = resolveScopedConversationKey(user, conversationKey, "AI");

        AiChatMessage customerMessage = new AiChatMessage();
        customerMessage.setConversationKey(resolvedConversationKey);
        customerMessage.setSenderType(SENDER_CUSTOMER);
        customerMessage.setContent(normalize(question));
        customerMessage.setQuestion(normalize(question));
        customerMessage.setUser(user);
        customerMessage.setCustomerName(resolveName(user, guestName));
        customerMessage.setCustomerEmail(resolveEmail(user, guestEmail));
        customerMessage.setAiAnswer(generateAnswer(customerMessage.getQuestion()));
        customerMessage.setStatus(STATUS_AI_REPLIED);

        return customerMessage;
    }

    public List<AiChatMessage> fetchMessagesForAdmin() {
        return this.aiChatMessageRepository.findAllByOrderByCreatedAtDesc().stream()
                .filter(this::isAdminInboxMessage)
                .toList();
    }

    private boolean isAdminInboxMessage(AiChatMessage message) {
        String conversationKey = normalizeOrDefault(message.getConversationKey(), "");
        if (conversationKey.startsWith("AI_")) {
            return false;
        }
        if (conversationKey.startsWith("ADMIN_")) {
            return true;
        }

        // Du lieu cu truoc khi tach luong AI/Admin: chi giu lai hoi thoai admin that.
        String status = normalizeOrDefault(message.getStatus(), "");
        return SENDER_ADMIN.equals(message.getSenderType())
                || STATUS_WAITING_ADMIN.equals(status)
                || STATUS_REPLIED.equals(status);
    }

    public List<AiChatMessage> fetchMessagesForUser(User user) {
        if (user == null) {
            return List.of();
        }
        return this.aiChatMessageRepository.findByUserOrderByCreatedAtDesc(user);
    }

    public List<AiChatMessage> fetchConversation(String conversationKey, User user) {
        String resolvedConversationKey = resolveConversationKey(user, conversationKey);
        if (resolvedConversationKey.isBlank()) {
            return List.of();
        }
        return this.aiChatMessageRepository.findByConversationKeyOrderByCreatedAtAscIdAsc(resolvedConversationKey);
    }

    public List<AiChatMessage> fetchConversationForAdmin(String conversationKey) {
        List<AiChatMessage> messages = fetchConversation(conversationKey, null);
        markReadByAdmin(messages);
        return this.aiChatMessageRepository.findByConversationKeyOrderByCreatedAtAscIdAsc(
                normalizeOrDefault(conversationKey, ""));
    }

    public List<AiChatMessage> fetchConversationForCustomer(String conversationKey, User user) {
        String resolvedConversationKey = resolveConversationKey(user, conversationKey);
        List<AiChatMessage> messages = fetchConversation(resolvedConversationKey, user);
        markReadByCustomer(messages);
        return this.aiChatMessageRepository.findByConversationKeyOrderByCreatedAtAscIdAsc(resolvedConversationKey);
    }

    public Optional<AiChatMessage> findById(long id) {
        return this.aiChatMessageRepository.findById(id);
    }

    public void replyFromAdmin(long id, String adminReply) {
        Optional<AiChatMessage> optionalMessage = this.aiChatMessageRepository.findById(id);
        if (optionalMessage.isEmpty()) {
            return;
        }

        AiChatMessage baseMessage = optionalMessage.get();
        String conversationKey = normalizeOrDefault(baseMessage.getConversationKey(), "LEGACY_" + baseMessage.getId());

        baseMessage.setAdminReply(normalize(adminReply));
        baseMessage.setStatus(STATUS_REPLIED);
        baseMessage.setRepliedAt(LocalDateTime.now());
        baseMessage.setConversationKey(conversationKey);
        this.aiChatMessageRepository.save(baseMessage);

        AiChatMessage adminMessage = new AiChatMessage();
        adminMessage.setConversationKey(conversationKey);
        adminMessage.setSenderType(SENDER_ADMIN);
        adminMessage.setContent(normalize(adminReply));
        adminMessage.setAdminReply(normalize(adminReply));
        adminMessage.setUser(baseMessage.getUser());
        adminMessage.setCustomerName(baseMessage.getCustomerName());
        adminMessage.setCustomerEmail(baseMessage.getCustomerEmail());
        adminMessage.setStatus(STATUS_REPLIED);
        adminMessage.setRepliedAt(LocalDateTime.now());
        this.aiChatMessageRepository.save(adminMessage);
        this.notificationService.notify(baseMessage.getUser(), "Admin da tra loi tin nhan",
                normalize(adminReply), "/?openChat=1&conversationKey=" + conversationKey);
        this.aiChatRealtimeService.notifyConversationUpdated(conversationKey);
    }

    private void markReadByAdmin(List<AiChatMessage> messages) {
        LocalDateTime now = LocalDateTime.now();
        boolean changed = false;
        for (AiChatMessage message : messages) {
            if (SENDER_CUSTOMER.equals(message.getSenderType()) && message.getAdminReadAt() == null) {
                message.setAdminReadAt(now);
                changed = true;
            }
        }
        if (changed) {
            this.aiChatMessageRepository.saveAll(messages);
            messages.stream()
                    .map(AiChatMessage::getConversationKey)
                    .filter(key -> key != null && !key.isBlank())
                    .findFirst()
                    .ifPresent(this.aiChatRealtimeService::notifyConversationUpdated);
        }
    }

    private void markReadByCustomer(List<AiChatMessage> messages) {
        LocalDateTime now = LocalDateTime.now();
        boolean changed = false;
        for (AiChatMessage message : messages) {
            if (SENDER_ADMIN.equals(message.getSenderType()) && message.getCustomerReadAt() == null) {
                message.setCustomerReadAt(now);
                changed = true;
            }
        }
        if (changed) {
            this.aiChatMessageRepository.saveAll(messages);
            messages.stream()
                    .map(AiChatMessage::getConversationKey)
                    .filter(key -> key != null && !key.isBlank())
                    .findFirst()
                    .ifPresent(this.aiChatRealtimeService::notifyConversationUpdated);
        }
    }

    public boolean hasAdminJoined(String conversationKey) {
        if (conversationKey == null || conversationKey.isBlank()) {
            return false;
        }
        return this.aiChatMessageRepository.existsByConversationKeyAndSenderType(conversationKey, SENDER_ADMIN);
    }

    public String generateSessionAnswer(String question) {
        return generateAnswer(question);
    }

    public String summarizeConversation(List<AiChatMessage> messages) {
        if (messages == null || messages.isEmpty()) {
            return "Chưa có nội dung để tóm tắt.";
        }
        String lastCustomerNeed = messages.stream()
                .filter(message -> SENDER_CUSTOMER.equals(message.getSenderType()))
                .map(message -> normalizeOrDefault(message.getContent(), message.getQuestion()))
                .filter(content -> !content.isBlank())
                .reduce((first, second) -> second)
                .orElse("");
        if (lastCustomerNeed.isBlank()) {
            return "Khach chua neu ro nhu cau.";
        }
        return "Khach dang can: " + lastCustomerNeed;
    }

    public String suggestAdminReply(List<AiChatMessage> messages) {
        String summary = summarizeConversation(messages);
        String lastNeed = latestCustomerNeed(messages);
        List<ProductRecommendationDTO> recommendations = this.productAdvisorService.recommend(lastNeed, lastNeed, "", "");
        if (recommendations.isEmpty()) {
            return summary + ". Admin nen hoi them ngan sach, muc dich su dung chinh va goi y 1-2 mau phu hop trong shop.";
        }
        return summary + ". Co the goi y " + recommendations.get(0).getProduct().getName()
                + " vi " + recommendations.get(0).getReason() + ".";
    }

    public List<ProductRecommendationDTO> suggestProductsForConversation(List<AiChatMessage> messages) {
        String lastNeed = latestCustomerNeed(messages);
        if (lastNeed.isBlank()) {
            return List.of();
        }
        return this.productAdvisorService.recommend(lastNeed, lastNeed, "", "");
    }

    private String generateAnswer(String question) {
        if (question == null || question.isBlank()) {
            return "Bạn hãy nhập nhu cầu mua laptop để AI tư vấn chính xác hơn nhé.";
        }

        String productAnswer = buildProductAnswer(question);
        if (!productAnswer.isBlank()) {
            return productAnswer;
        }

        if (this.openAiApiKey == null || this.openAiApiKey.isBlank()) {
            return fallbackAnswer(question);
        }

        try {
            return callOpenAi(question);
        } catch (IOException ex) {
            return "AI hiện chưa phản hồi được. Bạn thử lại sau hoặc chuyển sang Chat admin để được hỗ trợ trực tiếp.";
        } catch (InterruptedException ex) {
            Thread.currentThread().interrupt();
            return "AI hiện chưa phản hồi được. Bạn thử lại sau hoặc chuyển sang Chat admin để được hỗ trợ trực tiếp.";
        }
    }

    private String callOpenAi(String question) throws IOException, InterruptedException {
        ObjectNode body = this.objectMapper.createObjectNode();
        body.put("model", this.openAiModel);
        body.put("instructions",
                "Ban la tro ly tu van laptop cho website LaptopShop. Tra loi bang tieng Viet, ngan gon, than thien. "
                        + "Tập trung hỏi hoặc tư vấn theo ngân sách, nhu cầu học tập, lập trình, đồ họa, gaming, văn phòng. "
                        + "Khong bia chinh sach bao hanh/gia chinh xac neu khong co du lieu.");
        body.put("input", question);

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create("https://api.openai.com/v1/responses"))
                .header("Authorization", "Bearer " + this.openAiApiKey)
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(this.objectMapper.writeValueAsString(body)))
                .build();

        HttpResponse<String> response = this.httpClient.send(request, HttpResponse.BodyHandlers.ofString());
        if (response.statusCode() < 200 || response.statusCode() >= 300) {
            return "AI chưa trả lời được lúc này. Bạn có thể chuyển sang Chat admin để được hỗ trợ thêm.";
        }

        JsonNode root = this.objectMapper.readTree(response.body());
        String outputText = root.path("output_text").asText("");
        if (!outputText.isBlank()) {
            return outputText.trim();
        }

        JsonNode output = root.path("output");
        if (output.isArray()) {
            for (JsonNode item : output) {
                JsonNode contentList = item.path("content");
                if (contentList.isArray()) {
                    for (JsonNode content : contentList) {
                        if ("output_text".equals(content.path("type").asText())) {
                            String text = content.path("text").asText("");
                            if (!text.isBlank()) {
                                return text.trim();
                            }
                        }
                    }
                }
            }
        }

        return "AI da nhan duoc cau hoi nhung chua tao duoc noi dung tra loi. Admin se kiem tra lai cho ban.";
    }

    private String fallbackAnswer(String question) {
        String lowerQuestion = question.toLowerCase();
        if (lowerQuestion.contains("game") || lowerQuestion.contains("gaming")) {
            return "Neu ban can laptop choi game, nen uu tien CPU hieu nang cao, RAM tu 16GB, GPU roi va tan nhiet tot. "
                    + recommendProducts("GAMING");
        }
        if (lowerQuestion.contains("do hoa") || lowerQuestion.contains("đồ họa")
                || lowerQuestion.contains("design") || lowerQuestion.contains("thiet ke")
                || lowerQuestion.contains("thiết kế")) {
            return "Voi nhu cau do hoa, ban nen chon laptop co man hinh mau tot, RAM tu 16GB va GPU roi. "
                    + recommendProducts("THIET-KE-DO-HOA");
        }
        if (lowerQuestion.contains("lap trinh") || lowerQuestion.contains("lập trình")
                || lowerQuestion.contains("code")) {
            return "Nếu dùng để lập trình, bạn nên chọn máy RAM tối thiểu 16GB, SSD từ 512GB và CPU Intel i5/Ryzen 5 trở lên. "
                    + recommendProducts("SINHVIEN-VANPHONG");
        }
        if (lowerQuestion.contains("van phong") || lowerQuestion.contains("văn phòng")
                || lowerQuestion.contains("hoc online") || lowerQuestion.contains("học online")) {
            return "Voi hoc tap va van phong, ban co the chon laptop mong nhe, pin tot, RAM 8GB tro len. "
                    + recommendProducts("SINHVIEN-VANPHONG");
        }
        return "Mình đã nhận câu hỏi của bạn. Bạn có thể cho biết thêm ngân sách, hãng yêu thích và nhu cầu chính như học tập, lập trình, đồ họa hay gaming để được tư vấn sát hơn nhé.";
    }

    private String buildProductAnswer(String question) {
        if (!looksLikeProductAdvice(question)) {
            return "";
        }
        List<ProductRecommendationDTO> recommendations = this.productAdvisorService.recommend(question, question, "", "");
        if (recommendations.isEmpty()) {
            return "";
        }

        StringBuilder builder = new StringBuilder();
        builder.append("AI da tim trong shop va goi y cho ban:\n");
        int index = 1;
        for (ProductRecommendationDTO item : recommendations) {
            Product product = item.getProduct();
            builder.append(index++)
                    .append(". ")
                    .append(product.getName())
                    .append(" - ")
                    .append(formatPrice(product.getPrice()))
                    .append(" d")
                    .append(" (/product/")
                    .append(product.getId())
                    .append(")\n")
                    .append("   Ly do: ")
                    .append(item.getReason())
                    .append(". Còn lại ")
                    .append(product.getQuantity())
                    .append(" sản phẩm.\n");
        }
        builder.append("Bạn có thể bấm link sản phẩm để xem chi tiết, hoặc gửi ngân sách/hãng yêu thích để AI lọc sát hơn.");
        return builder.toString();
    }

    private boolean looksLikeProductAdvice(String question) {
        String value = question == null ? "" : question.toLowerCase();
        return value.contains("laptop")
                || value.contains("may")
                || value.contains("máy")
                || value.matches(".*\\d+\\s*(trieu|triệu|tr|m)\\b.*")
                || value.replace(".", "").replace(",", "").replace(" ", "").matches(".*\\d{7,}.*")
                || value.contains("gaming")
                || value.contains("game")
                || value.contains("hoc")
                || value.contains("học")
                || value.contains("lap trinh")
                || value.contains("code")
                || value.contains("do hoa")
                || value.contains("đồ họa")
                || value.contains("van phong")
                || value.contains("văn phòng")
                || value.contains("trieu")
                || value.contains("triệu")
                || value.contains("asus")
                || value.contains("dell")
                || value.contains("macbook")
                || value.contains("lenovo")
                || value.contains("acer");
    }

    private String recommendProducts(String target) {
        List<Product> products = this.productService.fetchProducts().stream()
                .filter(product -> target.equalsIgnoreCase(product.getTarget()))
                .filter(product -> product.getQuantity() > 0)
                .limit(2)
                .toList();
        if (products.isEmpty()) {
            return "Hiện shop chưa có gợi ý sản phẩm phù hợp, admin sẽ tư vấn thêm.";
        }
        StringBuilder builder = new StringBuilder("Goi y trong shop: ");
        for (Product product : products) {
            builder.append(product.getName())
                    .append(" (/product/")
                    .append(product.getId())
                    .append("), ");
        }
        return builder.substring(0, builder.length() - 2) + ".";
    }

    private String latestCustomerNeed(List<AiChatMessage> messages) {
        if (messages == null || messages.isEmpty()) {
            return "";
        }
        return messages.stream()
                .filter(message -> SENDER_CUSTOMER.equals(message.getSenderType()))
                .map(message -> normalizeOrDefault(message.getContent(), message.getQuestion()))
                .filter(content -> !content.isBlank())
                .reduce((first, second) -> second)
                .orElse("");
    }

    private String formatPrice(double price) {
        return String.format("%,.0f", price).replace(",", ".");
    }

    private String resolveConversationKey(User user, String conversationKey) {
        if (user != null) {
            String normalized = normalize(conversationKey);
            if (normalized.startsWith("AI_USER_") || normalized.startsWith("ADMIN_USER_")) {
                return normalized;
            }
            return buildUserConversationKey(user);
        }
        return normalize(conversationKey);
    }

    private String resolveScopedConversationKey(User user, String conversationKey, String scope) {
        String normalized = normalize(conversationKey);
        String prefix = scope + "_";
        if (user != null) {
            String userKey = prefix + "USER_" + user.getId();
            return normalized.equals(userKey) ? normalized : userKey;
        }
        if (!normalized.isBlank() && normalized.startsWith(prefix)) {
            return normalized;
        }
        return prefix + "GUEST_" + System.currentTimeMillis();
    }

    private String buildUserConversationKey(User user) {
        return "USER_" + user.getId();
    }

    private String resolveName(User user, String guestName) {
        if (user != null && user.getFullName() != null && !user.getFullName().isBlank()) {
            return user.getFullName();
        }
        return normalizeOrDefault(guestName, "Khách vãng lai");
    }

    private String resolveEmail(User user, String guestEmail) {
        if (user != null && user.getEmail() != null && !user.getEmail().isBlank()) {
            return user.getEmail();
        }
        return normalizeOrDefault(guestEmail, "");
    }

    private String normalizeOrDefault(String value, String fallback) {
        String normalizedValue = normalize(value);
        return normalizedValue.isBlank() ? fallback : normalizedValue;
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim();
    }
}
