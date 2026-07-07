package datt.nguyenthanhlong.laptopshop.service.validator;

import org.springframework.stereotype.Service;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import datt.nguyenthanhlong.laptopshop.domain.dto.RegisterDTO;
import datt.nguyenthanhlong.laptopshop.service.UserService;

@Service
public class RegisterValidator implements ConstraintValidator<RegisterChecked, RegisterDTO> {

    private UserService userService;

    public RegisterValidator(UserService userService) {
        this.userService = userService;
    }

    @Override
    public boolean isValid(RegisterDTO user, ConstraintValidatorContext context) {
        if (user == null) {
            return true;
        }

        boolean valid = true;
        String password = user.getPassword();
        String confirmPassword = user.getConfirmPassword();
        String email = user.getEmail();

        if (password != null && confirmPassword != null && !password.isBlank()
                && !confirmPassword.isBlank() && !password.equals(confirmPassword)) {
            addViolation(context, "confirmPassword", "Mat khau xac nhan khong khop");
            valid = false;
        }

        if (email != null && !email.isBlank() && this.userService.existsByEmail(email)) {
            addViolation(context, "email", "Email da ton tai");
            valid = false;
        }

        return valid;
    }

    private void addViolation(ConstraintValidatorContext context, String field, String message) {
        context.disableDefaultConstraintViolation();
        context.buildConstraintViolationWithTemplate(message)
                .addPropertyNode(field)
                .addConstraintViolation();
    }
}
