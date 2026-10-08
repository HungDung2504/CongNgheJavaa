package com.nexora.test;
import com.nexora.dao.CustomerDAO;
import com.nexora.model.Customer;

public class TestLogin {
    public static void main(String[] args) {
        CustomerDAO dao = new CustomerDAO();
        try {
            Customer c = dao.findByEmail("admin@nexora.com");
            System.out.println("Customer found: " + (c != null));
            
            c = dao.findByEmail("khachhang1@gmail.com");
            System.out.println("KhachHang found: " + (c != null));
            
            boolean ok = dao.register("Test", "test@test.com", "123456", "0123");
            System.out.println("Register OK: " + ok);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
