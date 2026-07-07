package datt.nguyenthanhlong.laptopshop.domain.dto;

import datt.nguyenthanhlong.laptopshop.domain.Product;

public class ProductRecommendationDTO {
    private Product product;
    private int score;
    private String reason;

    public ProductRecommendationDTO(Product product, int score, String reason) {
        this.product = product;
        this.score = score;
        this.reason = reason;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public int getScore() {
        return score;
    }

    public void setScore(int score) {
        this.score = score;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }
}
