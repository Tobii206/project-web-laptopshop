package datt.nguyenthanhlong.laptopshop
.service;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import datt.nguyenthanhlong.laptopshop.domain.OrderDetail;
import datt.nguyenthanhlong.laptopshop.domain.User;
import datt.nguyenthanhlong.laptopshop.domain.WarrantyClaim;
import datt.nguyenthanhlong.laptopshop.repository.OrderDetailRepository;
import datt.nguyenthanhlong.laptopshop.repository.OrderRepository;
import datt.nguyenthanhlong.laptopshop.repository.WarrantyClaimRepository;

@Service
public class WarrantyService {
    private final WarrantyClaimRepository warrantyClaimRepository;
    private final OrderDetailRepository orderDetailRepository;
    private final OrderRepository orderRepository;
    private final NotificationService notificationService;

    public WarrantyService(WarrantyClaimRepository warrantyClaimRepository,
            OrderDetailRepository orderDetailRepository,
            OrderRepository orderRepository,
            NotificationService notificationService) {
        this.warrantyClaimRepository = warrantyClaimRepository;
        this.orderDetailRepository = orderDetailRepository;
        this.orderRepository = orderRepository;
        this.notificationService = notificationService;
    }

    public List<WarrantyClaim> fetchAllClaims() {
        return this.warrantyClaimRepository.findAllByOrderByRequestedAtDescIdDesc();
    }

    public List<WarrantyClaim> fetchClaimsByUser(User user) {
        if (user == null) {
            return List.of();
        }
        return this.warrantyClaimRepository.findByUserOrderByRequestedAtDescIdDesc(user);
    }

    public Map<Long, WarrantyClaim> fetchClaimMap(Collection<OrderDetail> orderDetails) {
        if (orderDetails == null || orderDetails.isEmpty()) {
            return Map.of();
        }
        return this.warrantyClaimRepository.findByOrderDetailIn(orderDetails).stream()
                .collect(Collectors.toMap(claim -> claim.getOrderDetail().getId(), claim -> claim,
                        (first, second) -> first));
    }

    public boolean requestWarranty(long orderDetailId, User user, String issueDescription) {
        Optional<OrderDetail> orderDetailOptional = this.orderDetailRepository.findById(orderDetailId);
        if (orderDetailOptional.isEmpty() || user == null) {
            return false;
        }
        OrderDetail orderDetail = orderDetailOptional.get();
        if (orderDetail.getOrder() == null || orderDetail.getOrder().getUser() == null
                || orderDetail.getOrder().getUser().getId() != user.getId()
                || !orderDetail.getOrder().isCustomerConfirmedReceived()) {
            return false;
        }
        if (this.warrantyClaimRepository.findByOrderDetail(orderDetail).isPresent()) {
            return false;
        }

        String issue = issueDescription == null ? "" : issueDescription.trim();
        if (issue.isBlank()) {
            return false;
        }

        WarrantyClaim claim = new WarrantyClaim();
        claim.setOrderDetail(orderDetail);
        claim.setUser(user);
        claim.setIssueDescription(issue);
        claim.setStatus("PENDING");
        this.warrantyClaimRepository.save(claim);
        return true;
    }

    public boolean updateStatus(long claimId, String status, String adminNote) {
        Optional<WarrantyClaim> claimOptional = this.warrantyClaimRepository.findById(claimId);
        if (claimOptional.isEmpty()) {
            return false;
        }
        WarrantyClaim claim = claimOptional.get();
        if ("COMPLETED".equalsIgnoreCase(claim.getStatus())) {
            return false;
        }
        claim.setStatus(status == null || status.isBlank() ? "PENDING" : status.trim());
        claim.setAdminNote(adminNote == null ? "" : adminNote.trim());
        this.warrantyClaimRepository.save(claim);
        if ("COMPLETED".equalsIgnoreCase(claim.getStatus())
                && claim.getOrderDetail() != null
                && claim.getOrderDetail().getOrder() != null) {
            claim.getOrderDetail().getOrder().setWarrantyCompleted(true);
            this.orderRepository.save(claim.getOrderDetail().getOrder());
        }
        this.notificationService.notify(claim.getUser(), "Bao hanh da cap nhat",
                "Phieu BH" + claim.getId() + " hien la " + claim.getStatusLabel(), "/order-history");
        return true;
    }
}
