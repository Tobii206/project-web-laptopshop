package datt.nguyenthanhlong.laptopshop.domain;

import java.util.Set;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;

@Entity
@Table(name = "products")
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @NotNull
    @NotEmpty(message = "Name cannot empty")
    private String name;

    @NotNull
    private double price;

    @NotNull
    private long quantity;

    private String image;

    @NotNull
    @NotEmpty(message = "Detail Desc cannot empty")
    @Column(columnDefinition = "TEXT")
    private String detailDesc;

    @NotNull
    @NotEmpty(message = "Short Desc cannot empty")
    @Column(columnDefinition = "TEXT")
    private String shortDesc;

    @NotNull
    private long sold;

    @NotNull
    @NotEmpty(message = "Factory cannot empty")
    private String factory;

    @NotNull
    @NotEmpty(message = "Target cannot empty")
    private String target;

    @OneToMany(mappedBy = "product")
    private Set<OrderDetail> orderDetails;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public long getQuantity() {
        return quantity;
    }

    public void setQuantity(long quantity) {
        this.quantity = quantity;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getDetailDesc() {
        return detailDesc;
    }

    public void setDetailDesc(String detailDesc) {
        this.detailDesc = detailDesc;
    }

    public String getShortDesc() {
        return shortDesc;
    }

    public void setShortDesc(String shortDesc) {
        this.shortDesc = shortDesc;
    }

    public long getSold() {
        return sold;
    }

    public void setSold(long sold) {
        this.sold = sold;
    }

    public String getFactory() {
        return factory;
    }

    public void setFactory(String factory) {
        this.factory = factory;
    }

    public String getTarget() {
        return target;
    }

    public void setTarget(String target) {
        this.target = target;
    }

    public String getDisplayTarget() {
        if (target == null) {
            return "";
        }
        return switch (target) {
            case "GAMING" -> "Gaming";
            case "MONG-NHE", "MongNhe" -> "Mỏng nhẹ";
            case "THIET-KE-DO-HOA" -> "Đồ họa";
            case "SINHVIEN-VANPHONG" -> "Văn phòng";
            case "DOANH-NHAN" -> "Doanh nhân";
            case "GiaRe" -> "Giá rẻ";
            default -> target;
        };
    }

    public String getDisplayShortDesc() {
        if (shortDesc == null) {
            return "";
        }
        return humanizeVietnamese(shortDesc);
    }

    public String getDisplayDetailDesc() {
        if (detailDesc == null) {
            return "";
        }
        return humanizeVietnamese(detailDesc);
    }

    private String humanizeVietnamese(String value) {
        return value
                .replace("pin tot", "pin tốt")
                .replace("thiet ke gon nhe", "thiết kế gọn nhẹ")
                .replace("thiet ke tre", "thiết kế trẻ")
                .replace("thiet ke do hoa", "thiết kế đồ họa")
                .replace("vien mong", "viền mỏng")
                .replace("man dep", "màn đẹp")
                .replace("man hinh", "màn hình")
                .replace("may gon", "máy gọn")
                .replace("chien game", "chiến game")
                .replace("choi game", "chơi game")
                .replace("lam viec da nhiem", "làm việc đa nhiệm")
                .replace("lam viec van phong", "làm việc văn phòng")
                .replace("can man rong nhung nhe", "cần màn rộng nhưng nhẹ")
                .replace("danh cho nguoi", "dành cho người")
                .replace("phu hop van phong va quan ly", "phù hợp văn phòng và quản lý")
                .replace("phu hop hoc tap va lam viec van phong", "phù hợp học tập và làm việc văn phòng")
                .replace("phu hop gaming va stream", "phù hợp gaming và stream")
                .replace("hieu nang on dinh", "hiệu năng ổn định")
                .replace("hieu nang kha", "hiệu năng khá")
                .replace("dung hinh", "dựng hình")
                .replace("do hoa", "đồ họa")
                .replace("lap trinh", "lập trình")
                .replace("hoc tap", "học tập")
                .replace("hoc IT", "học IT")
                .replace("mong nhe", "mỏng nhẹ");
    }

    @Override
    public String toString() {
        return "Product [Id=" + id + ", name=" + name + ", price=" + price + ", quantity=" + quantity + ", image="
                + image + ", detailDesc=" + detailDesc + ", shortDesc=" + shortDesc + ", sold=" + sold + ", factory="
                + factory + ", target=" + target + "]";
    }

}
