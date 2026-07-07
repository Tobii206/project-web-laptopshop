package datt.nguyenthanhlong.laptopshop.controller.client;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpServletRequest;
import datt.nguyenthanhlong.laptopshop.domain.User;
import datt.nguyenthanhlong.laptopshop.service.UserService;
import datt.nguyenthanhlong.laptopshop.service.WarrantyService;

@Controller
public class WarrantyController {
    private final WarrantyService warrantyService;
    private final UserService userService;

    public WarrantyController(WarrantyService warrantyService, UserService userService) {
        this.warrantyService = warrantyService;
        this.userService = userService;
    }

    @PostMapping("/warranty/request/{orderDetailId}")
    public String requestWarranty(@PathVariable long orderDetailId,
            @RequestParam("issueDescription") String issueDescription,
            HttpServletRequest request) {
        User currentUser = request.getUserPrincipal() == null
                ? null
                : this.userService.getUserByEmail(request.getUserPrincipal().getName());
        this.warrantyService.requestWarranty(orderDetailId, currentUser, issueDescription);
        return "redirect:/order-history";
    }
}
