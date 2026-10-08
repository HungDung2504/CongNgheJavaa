package com.nexora.test;
import com.nexora.db.DBUtil;
import java.sql.Connection;

public class TestDB {
    public static void main(String[] args) {
        try {
            Connection conn = DBUtil.getConnection();
            if (conn != null) {
                System.out.println("KET_NOI_THANH_CONG!");
                conn.close();
            } else {
                System.out.println("KET_NOI_THAT_BAI!");
            }
        } catch (Exception e) {
            System.out.println("KET_NOI_LOI: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
