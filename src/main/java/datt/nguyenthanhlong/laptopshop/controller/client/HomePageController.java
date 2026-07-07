package datt.nguyenthanhlong.laptopshop.controller.client;

import java.util.List;
import java.util.ArrayList;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import jakarta.validation.Valid;
import datt.nguyenthanhlong.laptopshop.domain.Product;
import datt.nguyenthanhlong.laptopshop.domain.User;
import datt.nguyenthanhlong.laptopshop.domain.dto.ProfileDTO;
import datt.nguyenthanhlong.laptopshop.domain.dto.RegisterDTO;
import datt.nguyenthanhlong.laptopshop.service.ProductService;
import datt.nguyenthanhlong.laptopshop.service.UploadService;
import datt.nguyenthanhlong.laptopshop.service.UserService;
import jakarta.servlet.http.HttpServletRequest;

@Controller
public class HomePageController {

    private final ProductService productService;
    private final UserService userService;
    private final PasswordEncoder passwordEncoder;
    private final UploadService uploadService;

    public HomePageController(ProductService productService, UserService userService, PasswordEncoder passwordEncoder,
            UploadService uploadService) {
        this.productService = productService;
        this.userService = userService;
        this.passwordEncoder = passwordEncoder;
        this.uploadService = uploadService;
    }

    @GetMapping("/")
    public String getHomePage(Model model, @RequestParam(value = "page", defaultValue = "1") int page) {
        Page<Product> products = this.productService.fetchProducts(PageRequest.of(page - 1, 12));
        List<Product> prs = products.getContent();
        model.addAttribute("prs", prs);
        model.addAttribute("totalPages", products.getTotalPages());
        model.addAttribute("currentPage", page);
        return "/client/homepage/show";
    }

    @GetMapping("/shop")
    public String getShopPage(
            Model model,
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value = "factory", required = false) List<String> factories,
            @RequestParam(value = "target", required = false) List<String> targets,
            @RequestParam(value = "price", required = false) List<String> prices,
            @RequestParam(value = "sort", required = false, defaultValue = "gia-nothing") String sort){
        Pageable pageable = buildShopPageable(page, sort);
        Page<Product> products = this.productService.fetchProductsWithFilters(
                pageable,
                keyword,
                safeList(factories),
                safeList(targets),
                safeList(prices));
        List<Product> prs = products.getContent();
        model.addAttribute("prs", prs);
        model.addAttribute("totalPages", products.getTotalPages());
        model.addAttribute("currentPage", page);
        model.addAttribute("selectedFactories", safeList(factories));
        model.addAttribute("selectedTargets", safeList(targets));
        model.addAttribute("selectedPrices", safeList(prices));
        model.addAttribute("selectedSort", sort);
        model.addAttribute("keyword", keyword == null ? "" : keyword.trim());
        return "/client/homepage/shop";
    }

    private Pageable buildShopPageable(int page, String sort) {
        if ("gia-tang-dan".equals(sort)) {
            return PageRequest.of(page - 1, 6, Sort.by("price").ascending());
        }
        if ("gia-giam-dan".equals(sort)) {
            return PageRequest.of(page - 1, 6, Sort.by("price").descending());
        }
        return PageRequest.of(page - 1, 6);
    }

    private List<String> safeList(List<String> values) {
        return values == null ? new ArrayList<>() : values;
    }

    @GetMapping("/contact")
    public String getContactPage() {
        return "/client/homepage/contact";
    }

    @GetMapping("/account")
    public String getAccountPage(Model model, HttpServletRequest request) {
        String email = request.getUserPrincipal().getName();
        User user = this.userService.getUserByEmail(email);
        ProfileDTO accountForm = new ProfileDTO();
        accountForm.setFullName(user.getFullName());
        accountForm.setPhone(user.getPhone());
        accountForm.setAddress(user.getAddress());
        model.addAttribute("accountForm", accountForm);
        return "/client/homepage/account";
    }

    @PostMapping("/account/update")
    public String updateAccountPage(
            Model model,
            HttpServletRequest request,
            @ModelAttribute("accountForm") ProfileDTO accountForm,
            @RequestParam("avatarFile") MultipartFile avatarFile) {
        String email = request.getUserPrincipal().getName();
        User currentUser = this.userService.getUserByEmail(email);

        if (accountForm.getFullName() == null || accountForm.getFullName().trim().length() < 2) {
            model.addAttribute("errorMessage", "Ho ten phai co it nhat 2 ky tu");
            return "/client/homepage/account";
        }

        currentUser.setFullName(accountForm.getFullName().trim());
        currentUser.setPhone(accountForm.getPhone() == null ? null : accountForm.getPhone().trim());
        currentUser.setAddress(accountForm.getAddress() == null ? null : accountForm.getAddress().trim());

        String avatar = this.uploadService.handleSaveUploadFile(avatarFile, "avatar");
        if (!avatar.isBlank()) {
            currentUser.setAvatar(avatar);
        }

        this.userService.handleSaveUser(currentUser);

        ProfileDTO refreshedForm = new ProfileDTO();
        refreshedForm.setFullName(currentUser.getFullName());
        refreshedForm.setPhone(currentUser.getPhone());
        refreshedForm.setAddress(currentUser.getAddress());
        model.addAttribute("accountForm", refreshedForm);
        model.addAttribute("successMessage", "Cập nhật tài khoản thành công");
        return "/client/homepage/account";
    }

    @GetMapping("/register")
    public String getRegisterPage(Model model) {
        model.addAttribute("registerUser", new RegisterDTO());
        return "/client/auth/register";
    }

    @PostMapping("/register")
    public String postRegisterPage(Model model, @ModelAttribute("registerUser") @Valid RegisterDTO registerUser, BindingResult bindingResult) {
        if(bindingResult.hasErrors()) {
            System.out.println(bindingResult.getAllErrors());
            return "/client/auth/register";
        }
        User user = this.userService.registerDTOtoUser(registerUser);
        user.setRole(this.userService.getRoleByName("USER"));
        String hashPassword = this.passwordEncoder.encode(user.getPassword());
        user.setPassword(hashPassword);
        this.userService.handleSaveUser(user);
        return "redirect:/login";
    }

    @GetMapping("/login")
    public String getLoginPage() {
        return "/client/auth/login";
    }
}
