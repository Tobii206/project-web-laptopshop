package datt.nguyenthanhlong.laptopshop.service;

import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import datt.nguyenthanhlong.laptopshop.domain.OrderDetail;
import datt.nguyenthanhlong.laptopshop.domain.Product;
import datt.nguyenthanhlong.laptopshop.domain.Review;
import datt.nguyenthanhlong.laptopshop.domain.User;
import datt.nguyenthanhlong.laptopshop.repository.OrderDetailRepository;
import datt.nguyenthanhlong.laptopshop.repository.ReviewRepository;

@Service
public class ReviewService {
    private final ReviewRepository reviewRepository;
    private final OrderDetailRepository orderDetailRepository;

    public ReviewService(ReviewRepository reviewRepository, OrderDetailRepository orderDetailRepository) {
        this.reviewRepository = reviewRepository;
        this.orderDetailRepository = orderDetailRepository;
    }

    public List<Review> fetchReviewsByProduct(Product product) {
        return this.reviewRepository.findByProductOrderByCreatedAtDesc(product);
    }

    public boolean hasReviewed(Product product, User user) {
        return this.reviewRepository.findByProductAndUser(product, user).isPresent();
    }

    public long countAvailableReviewTurns(Product product, User user) {
        if (product == null || user == null) {
            return 0;
        }
        return this.orderDetailRepository
                .findByProductIdAndOrderUserIdAndOrderCustomerConfirmedReceivedTrueOrderByOrderReceivedAtDescIdDesc(
                        product.getId(), user.getId())
                .stream()
                .filter(orderDetail -> !this.reviewRepository.existsByOrderDetail(orderDetail))
                .count();
    }

    public boolean saveReviewForCompletedOrder(Product product, User user, int rating, String comment) {
        Optional<OrderDetail> orderDetail = fetchNextReviewableOrderDetail(product.getId(), user.getId());
        if (orderDetail.isEmpty()) {
            return false;
        }

        Review review = new Review();
        review.setProduct(product);
        review.setUser(user);
        review.setOrderDetail(orderDetail.get());
        review.setRating(rating);
        review.setComment(comment);
        this.reviewRepository.save(review);
        return true;
    }

    private Optional<OrderDetail> fetchNextReviewableOrderDetail(long productId, long userId) {
        return this.orderDetailRepository
                .findByProductIdAndOrderUserIdAndOrderCustomerConfirmedReceivedTrueOrderByOrderReceivedAtDescIdDesc(
                        productId, userId)
                .stream()
                .filter(orderDetail -> !this.reviewRepository.existsByOrderDetail(orderDetail))
                .findFirst();
    }
}
