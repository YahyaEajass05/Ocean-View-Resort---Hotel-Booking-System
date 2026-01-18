package com.oceanview.controller;

import com.oceanview.dao.ReviewDAO;
import com.oceanview.model.Review;
import com.oceanview.model.User;
import com.oceanview.util.Constants;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

/**
 * Review Servlet
 * Handles guest reviews and ratings
 * 
 * @author Ocean View Resort Development Team
 * @version 1.0.0
 */
@WebServlet("/review")
public class ReviewServlet extends HttpServlet {
    
    private static final Logger logger = LoggerFactory.getLogger(ReviewServlet.class);
    private ReviewDAO reviewDAO;
    
    @Override
    public void init() throws ServletException {
        reviewDAO = new ReviewDAO();
        logger.info("ReviewServlet initialized");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null || action.isEmpty()) {
            action = "list";
        }
        
        try {
            switch (action) {
                case "list":
                    listReviews(request, response);
                    break;
                case "view":
                    viewReview(request, response);
                    break;
                case "create":
                    showCreateForm(request, response);
                    break;
                case "myReviews":
                    showMyReviews(request, response);
                    break;
                case "pending":
                    showPendingReviews(request, response);
                    break;
                default:
                    listReviews(request, response);
                    break;
            }
        } catch (Exception e) {
            logger.error("Error in ReviewServlet GET", e);
            request.setAttribute(Constants.ATTR_ERROR, "Error processing request");
            request.getRequestDispatcher("/views/error/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null || action.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action parameter is required");
            return;
        }
        
        try {
            switch (action) {
                case "create":
                    createReview(request, response);
                    break;
                case "update":
                    updateReview(request, response);
                    break;
                case "approve":
                    approveReview(request, response);
                    break;
                case "reject":
                    rejectReview(request, response);
                    break;
                case "respond":
                    respondToReview(request, response);
                    break;
                case "delete":
                    deleteReview(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
                    break;
            }
        } catch (Exception e) {
            logger.error("Error in ReviewServlet POST", e);
            request.setAttribute(Constants.ATTR_ERROR, "Error processing request");
            request.getRequestDispatcher("/views/error/error.jsp").forward(request, response);
        }
    }
    
    /**
     * List all approved reviews
     */
    private void listReviews(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        // Default limit of 100 approved reviews
        List<Review> reviews = reviewDAO.findApprovedReviews(100);
        request.setAttribute("reviews", reviews);
        
        logger.info("Loaded {} approved reviews", reviews.size());
        
        request.getRequestDispatcher("/views/reviews/list.jsp").forward(request, response);
    }
    
    /**
     * View review details
     */
    private void viewReview(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        String reviewIdStr = request.getParameter("id");
        
        if (reviewIdStr == null || reviewIdStr.isEmpty()) {
            request.setAttribute(Constants.ATTR_ERROR, "Review ID is required");
            listReviews(request, response);
            return;
        }
        
        try {
            int reviewId = Integer.parseInt(reviewIdStr);
            Optional<Review> reviewOpt = reviewDAO.findById(reviewId);
            
            if (reviewOpt.isPresent()) {
                request.setAttribute("review", reviewOpt.get());
                request.getRequestDispatcher("/views/reviews/view.jsp").forward(request, response);
            } else {
                request.setAttribute(Constants.ATTR_ERROR, "Review not found");
                listReviews(request, response);
            }
        } catch (NumberFormatException e) {
            logger.error("Invalid review ID: {}", reviewIdStr);
            request.setAttribute(Constants.ATTR_ERROR, "Invalid review ID");
            listReviews(request, response);
        }
    }
    
    /**
     * Show create review form
     */
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String reservationIdStr = request.getParameter("reservationId");
        
        if (reservationIdStr == null || reservationIdStr.isEmpty()) {
            request.setAttribute(Constants.ATTR_ERROR, "Reservation ID is required");
            response.sendRedirect(request.getContextPath() + "/reservation?action=list");
            return;
        }
        
        request.setAttribute("reservationId", reservationIdStr);
        request.getRequestDispatcher("/views/reviews/create.jsp").forward(request, response);
    }
    
    /**
     * Show user's reviews
     */
    private void showMyReviews(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Note: Assuming we have a method to get reviews by user
        // For now, we'll get all reviews and filter later
        List<Review> reviews = reviewDAO.findAll();
        request.setAttribute("reviews", reviews);
        
        request.getRequestDispatcher("/views/guest/reviews/my-reviews.jsp").forward(request, response);
    }
    
    /**
     * Show pending reviews (Admin/Staff only)
     */
    private void showPendingReviews(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Only admin and staff can view pending reviews
        if (!user.isAdmin() && !user.isStaff()) {
            request.setAttribute(Constants.ATTR_ERROR, Constants.MSG_ACCESS_DENIED);
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        
        List<Review> pendingReviews = reviewDAO.findPendingReviews();
        request.setAttribute("reviews", pendingReviews);
        
        logger.info("Loaded {} pending reviews", pendingReviews.size());
        
        if (user.isAdmin()) {
            request.getRequestDispatcher("/views/admin/reviews/pending.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/views/staff/reviews/pending.jsp").forward(request, response);
        }
    }
    
    /**
     * Create a new review
     */
    private void createReview(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get form parameters
        String reservationIdStr = request.getParameter("reservationId");
        String guestIdStr = request.getParameter("guestId");
        String ratingStr = request.getParameter("rating");
        String cleanlinessRatingStr = request.getParameter("cleanlinessRating");
        String serviceRatingStr = request.getParameter("serviceRating");
        String valueRatingStr = request.getParameter("valueRating");
        String comment = request.getParameter("comment");
        
        // Validate input
        if (reservationIdStr == null || reservationIdStr.isEmpty()) {
            request.setAttribute(Constants.ATTR_ERROR, "Reservation ID is required");
            showCreateForm(request, response);
            return;
        }
        
        if (ratingStr == null || ratingStr.isEmpty()) {
            request.setAttribute(Constants.ATTR_ERROR, "Overall rating is required");
            showCreateForm(request, response);
            return;
        }
        
        try {
            int reservationId = Integer.parseInt(reservationIdStr);
            int guestId = Integer.parseInt(guestIdStr);
            int rating = Integer.parseInt(ratingStr);
            
            // Validate rating range
            if (rating < 1 || rating > 5) {
                request.setAttribute(Constants.ATTR_ERROR, "Rating must be between 1 and 5");
                showCreateForm(request, response);
                return;
            }
            
            // Create review object
            Review review = new Review();
            review.setReservationId(reservationId);
            review.setGuestId(guestId);
            review.setRating(rating);
            
            if (cleanlinessRatingStr != null && !cleanlinessRatingStr.isEmpty()) {
                review.setCleanlinessRating(Integer.parseInt(cleanlinessRatingStr));
            }
            
            if (serviceRatingStr != null && !serviceRatingStr.isEmpty()) {
                review.setServiceRating(Integer.parseInt(serviceRatingStr));
            }
            
            if (valueRatingStr != null && !valueRatingStr.isEmpty()) {
                review.setValueRating(Integer.parseInt(valueRatingStr));
            }
            
            review.setComment(comment);
            review.setStatus(Review.ReviewStatus.PENDING);
            
            // Save review
            int reviewId = reviewDAO.create(review);
            
            if (reviewId > 0) {
                logger.info("Review created successfully: ID={}", reviewId);
                request.setAttribute(Constants.ATTR_SUCCESS, Constants.MSG_REVIEW_SUBMITTED);
                response.sendRedirect(request.getContextPath() + "/review?action=myReviews");
            } else {
                request.setAttribute(Constants.ATTR_ERROR, "Failed to create review");
                showCreateForm(request, response);
            }
            
        } catch (NumberFormatException e) {
            logger.error("Invalid input parameters", e);
            request.setAttribute(Constants.ATTR_ERROR, "Invalid input values");
            showCreateForm(request, response);
        }
    }
    
    /**
     * Update an existing review
     */
    private void updateReview(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        String reviewIdStr = request.getParameter("id");
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");
        
        if (reviewIdStr == null || reviewIdStr.isEmpty()) {
            request.setAttribute(Constants.ATTR_ERROR, "Review ID is required");
            response.sendRedirect(request.getContextPath() + "/review?action=myReviews");
            return;
        }
        
        try {
            int reviewId = Integer.parseInt(reviewIdStr);
            Optional<Review> reviewOpt = reviewDAO.findById(reviewId);
            
            if (reviewOpt.isPresent()) {
                Review review = reviewOpt.get();
                
                if (ratingStr != null && !ratingStr.isEmpty()) {
                    review.setRating(Integer.parseInt(ratingStr));
                }
                
                review.setComment(comment);
                
                boolean success = reviewDAO.update(review);
                
                if (success) {
                    logger.info("Review updated successfully: ID={}", reviewId);
                    request.setAttribute(Constants.ATTR_SUCCESS, "Review updated successfully");
                } else {
                    request.setAttribute(Constants.ATTR_ERROR, "Failed to update review");
                }
                
                viewReview(request, response);
            } else {
                request.setAttribute(Constants.ATTR_ERROR, "Review not found");
                response.sendRedirect(request.getContextPath() + "/review?action=myReviews");
            }
        } catch (NumberFormatException e) {
            logger.error("Invalid review ID: {}", reviewIdStr);
            request.setAttribute(Constants.ATTR_ERROR, "Invalid review ID");
            response.sendRedirect(request.getContextPath() + "/review?action=myReviews");
        }
    }
    
    /**
     * Approve a review (Admin/Staff only)
     */
    private void approveReview(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        String reviewIdStr = request.getParameter("id");
        
        if (reviewIdStr == null || reviewIdStr.isEmpty()) {
            request.setAttribute(Constants.ATTR_ERROR, "Review ID is required");
            showPendingReviews(request, response);
            return;
        }
        
        try {
            int reviewId = Integer.parseInt(reviewIdStr);
            boolean success = reviewDAO.updateStatus(reviewId, Review.ReviewStatus.APPROVED);
            
            if (success) {
                logger.info("Review approved: ID={}", reviewId);
                request.setAttribute(Constants.ATTR_SUCCESS, "Review approved successfully");
            } else {
                request.setAttribute(Constants.ATTR_ERROR, "Failed to approve review");
            }
            
            showPendingReviews(request, response);
            
        } catch (NumberFormatException e) {
            logger.error("Invalid review ID: {}", reviewIdStr);
            request.setAttribute(Constants.ATTR_ERROR, "Invalid review ID");
            showPendingReviews(request, response);
        }
    }
    
    /**
     * Reject a review (Admin/Staff only)
     */
    private void rejectReview(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        String reviewIdStr = request.getParameter("id");
        
        if (reviewIdStr == null || reviewIdStr.isEmpty()) {
            request.setAttribute(Constants.ATTR_ERROR, "Review ID is required");
            showPendingReviews(request, response);
            return;
        }
        
        try {
            int reviewId = Integer.parseInt(reviewIdStr);
            boolean success = reviewDAO.updateStatus(reviewId, Review.ReviewStatus.REJECTED);
            
            if (success) {
                logger.info("Review rejected: ID={}", reviewId);
                request.setAttribute(Constants.ATTR_SUCCESS, "Review rejected successfully");
            } else {
                request.setAttribute(Constants.ATTR_ERROR, "Failed to reject review");
            }
            
            showPendingReviews(request, response);
            
        } catch (NumberFormatException e) {
            logger.error("Invalid review ID: {}", reviewIdStr);
            request.setAttribute(Constants.ATTR_ERROR, "Invalid review ID");
            showPendingReviews(request, response);
        }
    }
    
    /**
     * Respond to a review (Admin/Staff only)
     */
    private void respondToReview(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        String reviewIdStr = request.getParameter("id");
        String responseText = request.getParameter("response");
        
        if (reviewIdStr == null || reviewIdStr.isEmpty()) {
            request.setAttribute(Constants.ATTR_ERROR, "Review ID is required");
            showPendingReviews(request, response);
            return;
        }
        
        if (responseText == null || responseText.trim().isEmpty()) {
            request.setAttribute(Constants.ATTR_ERROR, "Response text is required");
            viewReview(request, response);
            return;
        }
        
        try {
            int reviewId = Integer.parseInt(reviewIdStr);
            Optional<Review> reviewOpt = reviewDAO.findById(reviewId);
            
            if (reviewOpt.isPresent()) {
                Review review = reviewOpt.get();
                review.setResponse(responseText.trim());
                
                boolean success = reviewDAO.update(review);
                
                if (success) {
                    logger.info("Response added to review: ID={}", reviewId);
                    request.setAttribute(Constants.ATTR_SUCCESS, "Response added successfully");
                } else {
                    request.setAttribute(Constants.ATTR_ERROR, "Failed to add response");
                }
                
                viewReview(request, response);
            } else {
                request.setAttribute(Constants.ATTR_ERROR, "Review not found");
                showPendingReviews(request, response);
            }
        } catch (NumberFormatException e) {
            logger.error("Invalid review ID: {}", reviewIdStr);
            request.setAttribute(Constants.ATTR_ERROR, "Invalid review ID");
            showPendingReviews(request, response);
        }
    }
    
    /**
     * Delete a review
     */
    private void deleteReview(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        String reviewIdStr = request.getParameter("id");
        
        if (reviewIdStr == null || reviewIdStr.isEmpty()) {
            request.setAttribute(Constants.ATTR_ERROR, "Review ID is required");
            response.sendRedirect(request.getContextPath() + "/review?action=myReviews");
            return;
        }
        
        try {
            int reviewId = Integer.parseInt(reviewIdStr);
            boolean success = reviewDAO.delete(reviewId);
            
            if (success) {
                logger.info("Review deleted: ID={}", reviewId);
                request.setAttribute(Constants.ATTR_SUCCESS, "Review deleted successfully");
            } else {
                request.setAttribute(Constants.ATTR_ERROR, "Failed to delete review");
            }
            
            response.sendRedirect(request.getContextPath() + "/review?action=myReviews");
            
        } catch (NumberFormatException e) {
            logger.error("Invalid review ID: {}", reviewIdStr);
            request.setAttribute(Constants.ATTR_ERROR, "Invalid review ID");
            response.sendRedirect(request.getContextPath() + "/review?action=myReviews");
        }
    }
}
