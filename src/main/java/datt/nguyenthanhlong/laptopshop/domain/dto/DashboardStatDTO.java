package datt.nguyenthanhlong.laptopshop.domain.dto;

public class DashboardStatDTO {
    private long totalOrders;
    private double totalRevenue;

    public DashboardStatDTO() {
    }

    public DashboardStatDTO(long totalOrders, double totalRevenue) {
        this.totalOrders = totalOrders;
        this.totalRevenue = totalRevenue;
    }

    public long getTotalOrders() {
        return totalOrders;
    }

    public void setTotalOrders(long totalOrders) {
        this.totalOrders = totalOrders;
    }

    public double getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(double totalRevenue) {
        this.totalRevenue = totalRevenue;
    }
}
