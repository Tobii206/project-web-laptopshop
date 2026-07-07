package datt.nguyenthanhlong.laptopshop.service;

import java.util.Comparator;
import java.util.Optional;

import org.springframework.stereotype.Service;

import datt.nguyenthanhlong.laptopshop.domain.DiscountVoucher;
import datt.nguyenthanhlong.laptopshop.repository.DiscountVoucherRepository;

@Service
public class DiscountVoucherService {
    private final DiscountVoucherRepository discountVoucherRepository;

    public DiscountVoucherService(DiscountVoucherRepository discountVoucherRepository) {
        this.discountVoucherRepository = discountVoucherRepository;
    }

    public Optional<DiscountVoucher> findBestVoucher(double subtotal) {
        return this.discountVoucherRepository.findByActiveTrue().stream()
                .filter(voucher -> subtotal >= voucher.getMinOrderValue())
                .max(Comparator.comparingDouble(voucher -> calculateDiscount(voucher, subtotal)));
    }

    public double calculateDiscount(DiscountVoucher voucher, double subtotal) {
        if (voucher == null || subtotal <= 0) {
            return 0;
        }

        double discount = "PERCENT".equalsIgnoreCase(voucher.getDiscountType())
                ? subtotal * voucher.getDiscountValue() / 100
                : voucher.getDiscountValue();

        if (voucher.getMaxDiscount() > 0) {
            discount = Math.min(discount, voucher.getMaxDiscount());
        }

        return Math.max(0, Math.min(discount, subtotal));
    }
}
