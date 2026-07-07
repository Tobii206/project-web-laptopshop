package datt.nguyenthanhlong.laptopshop.controller.client;

import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpServletRequest;
import datt.nguyenthanhlong.laptopshop.domain.AiChatMessage;
import datt.nguyenthanhlong.laptopshop.domain.User;
import datt.nguyenthanhlong.laptopshop.service.AiChatService;
import datt.nguyenthanhlong.laptopshop.service.UserService;

@Controller
public class AiChatController {
    private final AiChatService aiChatService;
    private final UserService userService;

    public AiChatController(AiChatService aiChatService, UserService userService) {
        this.aiChatService = aiChatService;
        this.userService = userService;
    }

    @GetMapping("/ai-chat")
    public String getAiChatPage(Model model, HttpServletRequest request) {
        model.addAttribute("messages", List.of());
        model.addAttribute("latestMessage", null);
        return "client/ai/chat";
    }

    @PostMapping("/ai-chat")
    public String submitAiChat(Model model,
            HttpServletRequest request,
            @RequestParam("question") String question,
            @RequestParam(value = "budget", required = false) String budget,
            @RequestParam(value = "need", required = false) String need,
            @RequestParam(value = "preferredBrand", required = false) String preferredBrand,
            @RequestParam(value = "priority", required = false) String priority,
            @RequestParam(value = "guestName", required = false) String guestName,
            @RequestParam(value = "guestEmail", required = false) String guestEmail) {
        String fullQuestion = buildQuickQuestion(question, budget, need, preferredBrand, priority);
        AiChatMessage latestMessage = new AiChatMessage();
        latestMessage.setQuestion(fullQuestion);
        latestMessage.setContent(fullQuestion);
        latestMessage.setAiAnswer(this.aiChatService.generateSessionAnswer(fullQuestion));
        latestMessage.setSenderType(AiChatService.SENDER_AI);
        model.addAttribute("messages", List.of());
        model.addAttribute("latestMessage", latestMessage);
        return "client/ai/chat";
    }

    @PostMapping("/ai-chat/api")
    @ResponseBody
    public Map<String, String> submitAiChatApi(HttpServletRequest request,
            @RequestParam("question") String question,
            @RequestParam(value = "conversationKey", required = false) String conversationKey,
            @RequestParam(value = "chatMode", defaultValue = "admin") String chatMode,
            @RequestParam(value = "guestName", required = false) String guestName,
            @RequestParam(value = "guestEmail", required = false) String guestEmail) {
        User currentUser = getCurrentUser(request);
        boolean aiMode = "ai".equalsIgnoreCase(chatMode);
        if (aiMode) {
            return Map.of(
                    "question", question == null ? "" : question.trim(),
                    "answer", this.aiChatService.generateSessionAnswer(question),
                    "adminMode", "false",
                    "conversationKey", conversationKey == null ? "" : conversationKey.trim());
        }

        if (currentUser == null) {
            return Map.of(
                    "question", question == null ? "" : question.trim(),
                    "answer", "Bạn cần đăng nhập để chat trực tiếp với admin. Khách vãng lai chỉ có thể dùng AI tư vấn.",
                    "adminMode", "false",
                    "conversationKey", "");
        }

        AiChatMessage latestMessage = this.aiChatService.createAdminMessage(
                question, currentUser, guestName, guestEmail, conversationKey);
        boolean adminMode = !aiMode;
        return Map.of(
                "question", latestMessage.getQuestion(),
                "answer", adminMode ? "Tin nhắn đã gửi cho admin. Admin sẽ phản hồi trực tiếp tại đây." : latestMessage.getAiAnswer(),
                "adminMode", String.valueOf(adminMode),
                "conversationKey", latestMessage.getConversationKey());
    }

    @GetMapping("/ai-chat/api/history")
    @ResponseBody
    public Map<String, Object> getAiChatHistory(HttpServletRequest request,
            @RequestParam(value = "conversationKey", required = false) String conversationKey) {
        if (conversationKey != null && conversationKey.startsWith("AI_")) {
            Map<String, Object> response = new HashMap<>();
            response.put("messages", List.of());
            response.put("adminMode", false);
            response.put("conversationKey", conversationKey);
            return response;
        }

        User currentUser = getCurrentUser(request);
        if (currentUser == null) {
            Map<String, Object> response = new HashMap<>();
            response.put("messages", List.of());
            response.put("adminMode", false);
            response.put("conversationKey", "");
            return response;
        }

        List<AiChatMessage> messages = this.aiChatService.fetchConversationForCustomer(conversationKey, currentUser);
        List<Map<String, String>> items = new ArrayList<>();
        boolean adminMode = false;
        for (AiChatMessage message : messages) {
            if (AiChatService.SENDER_ADMIN.equals(message.getSenderType())) {
                adminMode = true;
            }
            String content = message.getContent();
            if ((content == null || content.isBlank()) && message.getQuestion() != null) {
                content = message.getQuestion();
            }
            if ((content == null || content.isBlank()) && message.getAiAnswer() != null) {
                content = message.getAiAnswer();
            }
            if ((content == null || content.isBlank()) && message.getAdminReply() != null) {
                content = message.getAdminReply();
            }
            if (content == null || content.isBlank()) {
                continue;
            }

            Map<String, String> item = new HashMap<>();
            item.put("senderType", message.getSenderType() == null ? "CUSTOMER" : message.getSenderType());
            item.put("content", content);
            item.put("receiptLabel", receiptLabelForCustomer(message));
            items.add(item);
        }

        Map<String, Object> response = new HashMap<>();
        response.put("messages", items);
        response.put("adminMode", adminMode);
        response.put("conversationKey", messages.isEmpty() ? conversationKey : messages.get(0).getConversationKey());
        return response;
    }

    private String receiptLabelForCustomer(AiChatMessage message) {
        if (!AiChatService.SENDER_CUSTOMER.equals(message.getSenderType())) {
            return "";
        }
        return message.getAdminReadAt() == null ? "Đã gửi" : "Đã xem";
    }

    private User getCurrentUser(HttpServletRequest request) {
        if (request.getUserPrincipal() == null) {
            return null;
        }
        return this.userService.getUserByEmail(request.getUserPrincipal().getName());
    }

    private String buildQuickQuestion(String question, String budget, String need, String preferredBrand,
            String priority) {
        StringBuilder builder = new StringBuilder(question == null ? "" : question.trim());
        if (budget != null && !budget.isBlank()) {
            builder.append(" Ngan sach: ").append(budget.trim()).append(".");
        }
        if (need != null && !need.isBlank()) {
            builder.append(" Nhu cau: ").append(need.trim()).append(".");
        }
        if (preferredBrand != null && !preferredBrand.isBlank()) {
            builder.append(" Hang thich: ").append(preferredBrand.trim()).append(".");
        }
        if (priority != null && !priority.isBlank()) {
            builder.append(" Uu tien: ").append(priority.trim()).append(".");
        }
        return builder.toString().trim();
    }
}
