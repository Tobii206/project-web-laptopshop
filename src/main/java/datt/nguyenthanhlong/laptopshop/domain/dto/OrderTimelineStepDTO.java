package datt.nguyenthanhlong.laptopshop.domain.dto;

import java.time.LocalDateTime;

public class OrderTimelineStepDTO {
    private String code;
    private String label;
    private String note;
    private boolean active;
    private LocalDateTime time;

    public OrderTimelineStepDTO(String code, String label, String note, boolean active, LocalDateTime time) {
        this.code = code;
        this.label = label;
        this.note = note;
        this.active = active;
        this.time = time;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public LocalDateTime getTime() {
        return time;
    }

    public void setTime(LocalDateTime time) {
        this.time = time;
    }
}
