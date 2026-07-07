package datt.nguyenthanhlong.laptopshop
.domain.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import datt.nguyenthanhlong.laptopshop.service.validator.RegisterChecked;
import datt.nguyenthanhlong.laptopshop.service.validator.StrongPassword;

@RegisterChecked
public class RegisterDTO {
    @NotBlank(message = "Vui long nhap ho")
    @Size(min = 2, max = 50, message = "Ho phai tu 2 den 50 ky tu")
    private String firstName;

    @NotBlank(message = "Vui long nhap ten")
    @Size(min = 1, max = 50, message = "Ten phai tu 1 den 50 ky tu")
    private String lastName;

    @NotBlank(message = "Vui long nhap email")
    @Email(message = "Email không đúng định dạng")
    private String email;

    @NotBlank(message = "Vui lòng nhập mật khẩu")
    @Size(min = 8, max = 100, message = "Mat khau phai tu 8 den 100 ky tu")
    @StrongPassword(message = "Mat khau phai co chu hoa, chu thuong, so va ky tu dac biet")
    private String password;

    @NotBlank(message = "Vui lòng nhập lại mật khẩu")
    private String confirmPassword;

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getConfirmPassword() {
        return confirmPassword;
    }

    public void setConfirmPassword(String confirmPassword) {
        this.confirmPassword = confirmPassword;
    }
}
