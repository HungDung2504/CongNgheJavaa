package com.nexora.servlet.customer;

import com.nexora.dao.PostDAO;
import com.nexora.model.Post;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet({"/posts", "/post"})
public class PostServlet extends HttpServlet {
    private PostDAO postDAO;

    @Override
    public void init() {
        postDAO = new PostDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idParam = req.getParameter("id");
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idParam.trim());
                Post post = postDAO.getById(id);
                if (post != null) {
                    req.setAttribute("post", post);
                    // Lấy thêm vài bài viết gợi ý khác
                    List<Post> otherPosts = postDAO.getAll();
                    otherPosts.removeIf(p -> p.getPostId() == id);
                    if (otherPosts.size() > 3) otherPosts = otherPosts.subList(0, 3);
                    req.setAttribute("otherPosts", otherPosts);
                    req.getRequestDispatcher("/views/customer/postDetail.jsp").forward(req, resp);
                    return;
                }
            } catch (NumberFormatException ignored) {}
        }

        List<Post> posts = postDAO.getAll();
        req.setAttribute("posts", posts);
        req.getRequestDispatcher("/views/customer/posts.jsp").forward(req, resp);
    }
}
