package com.nexora.model;
import java.sql.Timestamp;

public class Product {
    private int productId;
    private int catId;
    private String productName;
    private String size;
    private String color;
    private long price;
    private int stock;
    private String image;
    private String productDesc;
    private boolean isHot;
    private String material;
    private String style;
    private String origin;
    private boolean isActive;
    private Timestamp createdAt;
    private String catName; 

    public Product() {}

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public int getCatId() { return catId; }
    public void setCatId(int catId) { this.catId = catId; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public String getSize() { return size; }
    public void setSize(String size) { this.size = size; }
    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }
    public long getPrice() { return price; }
    public void setPrice(long price) { this.price = price; }
    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }
    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
    public String getProductDesc() { return productDesc; }
    public void setProductDesc(String productDesc) { this.productDesc = productDesc; }
    public boolean isHot() { return isHot; }
    public void setHot(boolean isHot) { this.isHot = isHot; }
    public String getMaterial() { return material; }
    public void setMaterial(String material) { this.material = material; }
    public String getStyle() { return style; }
    public void setStyle(String style) { this.style = style; }
    public String getOrigin() { return origin; }
    public void setOrigin(String origin) { this.origin = origin; }
    public boolean isActive() { return isActive; }
    public void setActive(boolean isActive) { this.isActive = isActive; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public String getCatName() { return catName; }
    public void setCatName(String catName) { this.catName = catName; }

    private int status = 1; // 1: còn hàng/bình thường, 2: hết hàng, 3: đặt trước, 0: xóa
    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }

    public boolean isOutOfStock() {
        return status == 2 || (status != 3 && stock <= 0);
    }

    public boolean isPreOrder() {
        return status == 3;
    }

    private java.util.List<ProductVariant> variants = new java.util.ArrayList<>();
    public java.util.List<ProductVariant> getVariants() { return variants; }
    public void setVariants(java.util.List<ProductVariant> variants) { this.variants = variants; }
}
