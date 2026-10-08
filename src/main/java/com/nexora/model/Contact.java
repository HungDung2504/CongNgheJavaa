package com.nexora.model;

import java.sql.Timestamp;

public class Contact {
    private int contactId;
    private Integer userId;
    private String fullname;
    private String email;
    private String message;
    private String reply;
    private Timestamp createdAt;
    private Timestamp processedAt;
    private String status;

    public Contact() {}

    public int getContactId() { return contactId; }
    public void setContactId(int contactId) { this.contactId = contactId; }

    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }

    public String getFullname() { return fullname; }
    public void setFullname(String fullname) { this.fullname = fullname; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public String getReply() { return reply; }
    public void setReply(String reply) { this.reply = reply; }
    public String getPhanHoi() { return reply; }
    public void setPhanHoi(String reply) { this.reply = reply; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getProcessedAt() { return processedAt; }
    public void setProcessedAt(Timestamp processedAt) { this.processedAt = processedAt; }
    public Timestamp getNgayXuLy() { return processedAt; }
    public void setNgayXuLy(Timestamp processedAt) { this.processedAt = processedAt; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    // Aliases
    public int getId() { return contactId; }
    public void setId(int id) { this.contactId = id; }
    public String getName() { return fullname; }
    public void setName(String name) { this.fullname = name; }
}
