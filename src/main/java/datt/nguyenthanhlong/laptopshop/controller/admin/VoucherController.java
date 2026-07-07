package datt.nguyenthanhlong.laptopshop.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import datt.nguyenthanhlong.laptopshop.domain.DiscountVoucher;
import datt.nguyenthanhlong.laptopshop.repository.DiscountVoucherRepository;

@Controller
public class VoucherController {
    private final DiscountVoucherRepository discountVoucherRepository;

    public VoucherController(DiscountVoucherRepository discountVoucherRepository) {
        this.discountVoucherRepository = discountVoucherRepository;
    }

    @GetMapping("/admin/voucher")
    public String showVouchers(Model model) {
        model.addAttribute("vouchers", this.discountVoucherRepository.findAll());
        model.addAttribute("voucher", new DiscountVoucher());
        return "admin/voucher/show";
    }

    @PostMapping("/admin/voucher/save")
    public String saveVoucher(@ModelAttribute("voucher") DiscountVoucher voucher) {
        voucher.setCode(normalizeCode(voucher.getCode()));
        voucher.setDiscountType(normalizeType(voucher.getDiscountType()));
        this.discountVoucherRepository.save(voucher);
        return "redirect:/admin/voucher";
    }

    @GetMapping("/admin/voucher/update/{id}")
    public String updateVoucherPage(@PathVariable long id, Model model) {
        DiscountVoucher voucher = this.discountVoucherRepository.findById(id).orElse(new DiscountVoucher());
        model.addAttribute("voucher", voucher);
        model.addAttribute("vouchers", this.discountVoucherRepository.findAll());
        return "admin/voucher/show";
    }

    @PostMapping("/admin/voucher/toggle/{id}")
    public String toggleVoucher(@PathVariable long id) {
        this.discountVoucherRepository.findById(id).ifPresent(voucher -> {
            voucher.setActive(!voucher.isActive());
            this.discountVoucherRepository.save(voucher);
        });
        return "redirect:/admin/voucher";
    }

    @PostMapping("/admin/voucher/delete")
    public String deleteVoucher(@RequestParam("id") long id) {
        this.discountVoucherRepository.deleteById(id);
        return "redirect:/admin/voucher";
    }

    private String normalizeCode(String code) {
        return code == null ? "" : code.trim().toUpperCase();
    }

    private String normalizeType(String type) {
        return "FIXED".equalsIgnoreCase(type) ? "FIXED" : "PERCENT";
    }
}
