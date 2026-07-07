package datt.nguyenthanhlong.laptopshop.controller.client;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

import jakarta.servlet.http.HttpSession;
import datt.nguyenthanhlong.laptopshop.domain.Product;
import datt.nguyenthanhlong.laptopshop.service.ProductAdvisorService;
import datt.nguyenthanhlong.laptopshop.service.ProductService;

@Controller
public class CompareController {
    private final ProductService productService;
    private final ProductAdvisorService productAdvisorService;

    public CompareController(ProductService productService, ProductAdvisorService productAdvisorService) {
        this.productService = productService;
        this.productAdvisorService = productAdvisorService;
    }

    @PostMapping("/compare/add/{id}")
    public String addCompare(@PathVariable long id, HttpSession session) {
        List<Long> ids = getCompareIds(session);
        if (!ids.contains(id)) {
            if (ids.size() >= 3) {
                ids.remove(0);
            }
            ids.add(id);
        }
        session.setAttribute("compareProductIds", ids);
        return "redirect:/compare";
    }

    @PostMapping("/compare/remove/{id}")
    public String removeCompare(@PathVariable long id, HttpSession session) {
        List<Long> ids = getCompareIds(session);
        ids.remove(id);
        session.setAttribute("compareProductIds", ids);
        return "redirect:/compare";
    }

    @GetMapping("/compare")
    public String showCompare(Model model, HttpSession session) {
        List<Product> products = getCompareIds(session).stream()
                .map(this.productService::findProductById)
                .filter(product -> product != null)
                .toList();
        model.addAttribute("products", products);
        model.addAttribute("comparisonSummary", this.productAdvisorService.buildComparisonSummary(products));
        return "client/compare/show";
    }

    @SuppressWarnings("unchecked")
    private List<Long> getCompareIds(HttpSession session) {
        Object value = session.getAttribute("compareProductIds");
        if (value instanceof List<?>) {
            return new ArrayList<>((List<Long>) value);
        }
        return new ArrayList<>();
    }
}
