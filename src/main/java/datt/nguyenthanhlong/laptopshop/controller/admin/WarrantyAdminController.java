package datt.nguyenthanhlong.laptopshop.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import datt.nguyenthanhlong.laptopshop.service.WarrantyService;

@Controller
public class WarrantyAdminController {
    private final WarrantyService warrantyService;

    public WarrantyAdminController(WarrantyService warrantyService) {
        this.warrantyService = warrantyService;
    }

    @GetMapping("/admin/warranty")
    public String showWarrantyClaims(Model model) {
        model.addAttribute("claims", this.warrantyService.fetchAllClaims());
        return "admin/warranty/show";
    }

    @PostMapping("/admin/warranty/{id}/status")
    public String updateWarrantyStatus(@PathVariable long id,
            @RequestParam("status") String status,
            @RequestParam(value = "adminNote", required = false) String adminNote) {
        this.warrantyService.updateStatus(id, status, adminNote);
        return "redirect:/admin/warranty";
    }
}
