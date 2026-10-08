package com.nexora.model;
import java.sql.Timestamp;

public class Order {
    private int orderId;
    private int userId;
    private int addressId;
    private Timestamp orderDate;
    private long totalGoods;
    private long shippingFee;
    private long totalMoney;
    private String channel;
    private String status;
    private String note;
    
    // extra info for display
    private String customerName;
    private String customerPhone;
    private String addressDetail;

    public Order() {}

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getAddressId() { return addressId; }
    public void setAddressId(int addressId) { this.addressId = addressId; }
    public Timestamp getOrderDate() { return orderDate; }
    public void setOrderDate(Timestamp orderDate) { this.orderDate = orderDate; }
    public Timestamp getCreatedAt() { return orderDate; }
    public void setCreatedAt(Timestamp createdAt) { this.orderDate = createdAt; }

    public long getTotalGoods() { return totalGoods; }
    public long gettotalGoods() { return totalGoods; }
    public void setTotalGoods(long totalGoods) { this.totalGoods = totalGoods; }
    public void settotalGoods(long totalGoods) { this.totalGoods = totalGoods; }

    public long getShippingFee() { return shippingFee; }
    public void setShippingFee(long shippingFee) { this.shippingFee = shippingFee; }

    public long getTotalMoney() { return totalMoney; }
    public long gettotalMoney() { return totalMoney; }
    public void setTotalMoney(long totalMoney) { this.totalMoney = totalMoney; }
    public void settotalMoney(long totalMoney) { this.totalMoney = totalMoney; }
    public String getChannel() { return channel; }
    public void setChannel(String channel) { this.channel = channel; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    public String getCustomerPhone() { return customerPhone; }
    public void setCustomerPhone(String customerPhone) { this.customerPhone = customerPhone; }
    public String getAddressDetail() { return addressDetail; }
    public void setAddressDetail(String addressDetail) { this.addressDetail = addressDetail; }

    private String paymentMethod;
    private String paymentStatus;

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    private java.util.List<OrderDetail> items;
    public java.util.List<OrderDetail> getItems() { return items; }
    public void setItems(java.util.List<OrderDetail> items) { this.items = items; }

    public boolean isHasOutOfStock() {
        if (items == null) return false;
        for (OrderDetail item : items) {
            if (item.getCurrentStock() <= 0 || item.getProductStatus() == 2 || item.getProductStatus() == 3) {
                return true;
            }
        }
        return false;
    }
}