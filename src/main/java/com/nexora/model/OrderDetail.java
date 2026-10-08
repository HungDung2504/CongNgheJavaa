package com.nexora.model;

public class OrderDetail {
    private int id;
    private int orderId;
    private int productId;
    private String productName;
    private String size;
    private String color;
    private int quantity;
    private long price;
    private long total;

    private String productImage;
    private int currentStock;
    private int productStatus = 1;

    public OrderDetail() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public String getProductImage() { return productImage; }
    public void setProductImage(String productImage) { this.productImage = productImage; }
    public String getSize() { return size; }
    public void setSize(String size) { this.size = size; }
    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public long getPrice() { return price; }
    public void setPrice(long price) { this.price = price; }
    public long getTotal() { return total; }
    public long gettotal() { return total; }
    public void setTotal(long total) { this.total = total; }
    public void settotal(long total) { this.total = total; }
    public int getCurrentStock() { return currentStock; }
    public void setCurrentStock(int currentStock) { this.currentStock = currentStock; }
    public int getProductStatus() { return productStatus; }
    public void setProductStatus(int productStatus) { this.productStatus = productStatus; }
}