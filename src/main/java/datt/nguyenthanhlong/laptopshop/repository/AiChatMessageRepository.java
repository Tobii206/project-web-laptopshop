package datt.nguyenthanhlong.laptopshop.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import datt.nguyenthanhlong.laptopshop
.domain.AiChatMessage;
import datt.nguyenthanhlong.laptopshop
.domain.User;

public interface AiChatMessageRepository extends JpaRepository<AiChatMessage, Long> {
    List<AiChatMessage> findAllByOrderByCreatedAtDesc();

    List<AiChatMessage> findByUserOrderByCreatedAtDesc(User user);

    List<AiChatMessage> findByConversationKeyOrderByCreatedAtAscIdAsc(String conversationKey);

    boolean existsByConversationKeyAndSenderType(String conversationKey, String senderType);
}
