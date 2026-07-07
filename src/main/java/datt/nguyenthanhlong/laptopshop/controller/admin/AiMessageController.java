package datt.nguyenthanhlong.laptopshop.controller.admin;

import java.util.List;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import datt.nguyenthanhlong.laptopshop.domain.AiChatMessage;
import datt.nguyenthanhlong.laptopshop.service.AiChatService;

@Controller
public class AiMessageController {
    private final AiChatService aiChatService;

    public AiMessageController(AiChatService aiChatService) {
        this.aiChatService = aiChatService;
    }

    @GetMapping("/admin/ai-messages")
    public String getAiMessages(Model model,
            @RequestParam(value = "conversationKey", required = false) String conversationKey) {
        List<AiChatMessage> messages = this.aiChatService.fetchMessagesForAdmin();
        List<AiChatMessage> conversations = buildConversationList(messages);
        String activeConversationKey = resolveActiveConversationKey(conversationKey, conversations);
        List<AiChatMessage> activeMessages = this.aiChatService.fetchConversationForAdmin(activeConversationKey);
        AiChatMessage activeConversation = conversations.stream()
                .filter(message -> activeConversationKey != null
                        && activeConversationKey.equals(message.getConversationKey()))
                .findFirst()
                .orElse(null);

        model.addAttribute("conversations", conversations);
        model.addAttribute("activeConversation", activeConversation);
        model.addAttribute("activeMessages", activeMessages);
        model.addAttribute("activeConversationKey", activeConversationKey);
        model.addAttribute("conversationSummary", this.aiChatService.summarizeConversation(activeMessages));
        model.addAttribute("suggestedReply", this.aiChatService.suggestAdminReply(activeMessages));
        model.addAttribute("suggestedProducts", this.aiChatService.suggestProductsForConversation(activeMessages));
        return "admin/ai-message/show";
    }

    @PostMapping("/admin/ai-messages/{id}/reply")
    public String replyToMessage(@PathVariable long id,
            @RequestParam("adminReply") String adminReply) {
        this.aiChatService.replyFromAdmin(id, adminReply);
        return "redirect:/admin/ai-messages";
    }

    @GetMapping("/admin/ai-messages/poll")
    @ResponseBody
    public Map<String, Object> pollAiMessages(
            @RequestParam(value = "conversationKey", required = false) String conversationKey) {
        List<AiChatMessage> messages = this.aiChatService.fetchMessagesForAdmin();
        List<AiChatMessage> conversations = buildConversationList(messages);
        String activeConversationKey = resolveActiveConversationKey(conversationKey, conversations);
        List<AiChatMessage> activeMessages = this.aiChatService.fetchConversationForAdmin(activeConversationKey);

        Map<String, Object> response = new LinkedHashMap<>();
        response.put("activeConversationKey", activeConversationKey);
        response.put("conversations", conversations.stream().map(this::toConversationDto).toList());
        response.put("messages", activeMessages.stream().map(this::toMessageDto).toList());
        response.put("conversationSummary", this.aiChatService.summarizeConversation(activeMessages));
        response.put("suggestedReply", this.aiChatService.suggestAdminReply(activeMessages));
        return response;
    }

    private List<AiChatMessage> buildConversationList(List<AiChatMessage> messages) {
        Map<String, AiChatMessage> conversations = new LinkedHashMap<>();
        for (AiChatMessage message : messages) {
            String key = message.getConversationKey();
            if (key == null || key.isBlank()) {
                key = "LEGACY_" + message.getId();
            }
            conversations.putIfAbsent(key, message);
        }
        return new ArrayList<>(conversations.values());
    }

    private String resolveActiveConversationKey(String requestedKey, List<AiChatMessage> conversations) {
        if (requestedKey != null && !requestedKey.isBlank()) {
            return requestedKey;
        }
        if (conversations.isEmpty()) {
            return "";
        }
        return conversations.get(0).getConversationKey();
    }

    private Map<String, Object> toConversationDto(AiChatMessage message) {
        Map<String, Object> dto = new LinkedHashMap<>();
        dto.put("id", message.getId());
        dto.put("conversationKey", message.getConversationKey());
        dto.put("customerName", message.getCustomerName());
        dto.put("customerEmail", message.getCustomerEmail());
        dto.put("preview", messageText(message));
        return dto;
    }

    private Map<String, Object> toMessageDto(AiChatMessage message) {
        Map<String, Object> dto = new LinkedHashMap<>();
        dto.put("id", message.getId());
        dto.put("senderType", message.getSenderType());
        dto.put("senderLabel", senderLabel(message));
        dto.put("content", messageText(message));
        dto.put("createdAt", message.getCreatedAt() == null ? "" : message.getCreatedAt().toString());
        dto.put("receiptLabel", receiptLabelForAdmin(message));
        return dto;
    }

    private String receiptLabelForAdmin(AiChatMessage message) {
        if (!AiChatService.SENDER_ADMIN.equals(message.getSenderType())) {
            return "";
        }
        return message.getCustomerReadAt() == null ? "Đã gửi" : "Đã xem";
    }

    private String senderLabel(AiChatMessage message) {
        if (AiChatService.SENDER_ADMIN.equals(message.getSenderType())) {
            return "Quan tri";
        }
        if (AiChatService.SENDER_AI.equals(message.getSenderType())) {
            return "AI";
        }
        return message.getCustomerName() == null || message.getCustomerName().isBlank()
                ? "Khách hàng"
                : message.getCustomerName();
    }

    private String messageText(AiChatMessage message) {
        if (message.getContent() != null && !message.getContent().isBlank()) {
            return message.getContent();
        }
        if (message.getQuestion() != null && !message.getQuestion().isBlank()) {
            return message.getQuestion();
        }
        if (message.getAiAnswer() != null && !message.getAiAnswer().isBlank()) {
            return message.getAiAnswer();
        }
        if (message.getAdminReply() != null && !message.getAdminReply().isBlank()) {
            return message.getAdminReply();
        }
        return "";
    }
}
