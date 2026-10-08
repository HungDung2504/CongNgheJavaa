package com.nexora.test;
import com.nexora.model.Order;
import java.beans.Introspector;
import java.beans.BeanInfo;
import java.beans.PropertyDescriptor;

public class TestBean {
    public static void main(String[] args) throws Exception {
        BeanInfo info = Introspector.getBeanInfo(Order.class);
        for(PropertyDescriptor pd : info.getPropertyDescriptors()) {
            System.out.println("Property: " + pd.getName());
        }
    }
}
