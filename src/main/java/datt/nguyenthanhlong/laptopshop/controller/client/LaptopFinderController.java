package datt.nguyenthanhlong.laptopshop.controller.client;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import datt.nguyenthanhlong.laptopshop.domain.dto.ProductRecommendationDTO;
import datt.nguyenthanhlong.laptopshop.service.ProductAdvisorService;

@Controller
public class LaptopFinderController {
    private final ProductAdvisorService productAdvisorService;

    public LaptopFinderController(ProductAdvisorService productAdvisorService) {
        this.productAdvisorService = productAdvisorService;
    }

    @GetMapping("/laptop-finder")
    public String showFinder() {
        return "client/ai/finder";
    }

    @PostMapping("/laptop-finder")
    public String findLaptop(Model model,
            @RequestParam(value = "need", required = false) String need,
            @RequestParam(value = "budget", required = false) String budget,
            @RequestParam(value = "purpose", required = false) String purpose,
            @RequestParam(value = "factory", required = false) String factory) {
        List<ProductRecommendationDTO> recommendations = this.productAdvisorService
                .recommend(need, budget, purpose, factory);
        model.addAttribute("recommendations", recommendations);
        model.addAttribute("advisorSummary", this.productAdvisorService.buildAdvisorSummary(recommendations, need));
        model.addAttribute("need", need);
        model.addAttribute("budget", budget);
        model.addAttribute("purpose", purpose);
        model.addAttribute("factory", factory);
        return "client/ai/finder";
    }
}
