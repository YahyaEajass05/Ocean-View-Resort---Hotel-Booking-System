package com.oceanview.controller;

import com.oceanview.dao.OfferDAO;
import com.oceanview.model.Offer;
import com.oceanview.model.User;
import com.oceanview.util.Constants;
import com.oceanview.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

/**
 * Offer Servlet
 * Handles special offers and promotions management
 * URL Mapping: /offer (configured in web.xml)
 * 
 * @author Ocean View Resort Development Team
 * @version 1.0.0
 */
public class OfferServlet extends HttpServlet {
    
    private static final Logger logger = LoggerFactory.getLogger(OfferServlet.class);
    private OfferDAO offerDAO;
    
    @Override
    public void init() throws ServletException {
        offerDAO = new OfferDAO();
        logger.info("OfferServlet initialized");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if (action == null) {
                action = "list";
            }
            
            switch (action) {
                case "list":
                    listOffers(request, response);
                    break;
                case "view":
                    viewOffer(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteOffer(request, response);
                    break;
                case "active":
                    listActiveOffers(request, response);
                    break;
                default:
                    listOffers(request, response);
            }
        } catch (Exception e) {
            logger.error("Error in OfferServlet doGet", e);
            request.setAttribute(Constants.ATTR_ERROR, "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        
        if (user == null || !user.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if ("create".equals(action)) {
                createOffer(request, response);
            } else if ("update".equals(action)) {
                updateOffer(request, response);
            } else if ("toggleStatus".equals(action)) {
                toggleStatus(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            logger.error("Error in OfferServlet doPost", e);
            request.setAttribute(Constants.ATTR_ERROR, "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * List all offers (Admin view)
     */
    private void listOffers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            List<Offer> offers = offerDAO.findAll();
            
            // Calculate statistics
            long activeCount = offers.stream()
                .filter(o -> o.getOfferStatus() == Offer.OfferStatus.ACTIVE)
                .count();
            long scheduledCount = offers.stream()
                .filter(o -> o.getOfferStatus() == Offer.OfferStatus.SCHEDULED)
                .count();
            long expiredCount = offers.stream()
                .filter(o -> o.getOfferStatus() == Offer.OfferStatus.EXPIRED)
                .count();
            int totalRedemptions = offers.stream()
                .mapToInt(Offer::getUsedCount)
                .sum();
            
            request.setAttribute("offers", offers);
            request.setAttribute("activeOffers", activeCount);
            request.setAttribute("scheduledOffers", scheduledCount);
            request.setAttribute("expiredOffers", expiredCount);
            request.setAttribute("totalRedemptions", totalRedemptions);
            
            request.getRequestDispatcher("/views/admin/offers.jsp").forward(request, response);
            
        } catch (SQLException e) {
            logger.error("Error listing offers", e);
            request.setAttribute(Constants.ATTR_ERROR, "Error loading offers");
            request.getRequestDispatcher("/views/admin/offers.jsp").forward(request, response);
        }
    }
    
    /**
     * List active offers (Guest view)
     */
    private void listActiveOffers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            List<Offer> offers = offerDAO.findActiveOffers();
            request.setAttribute("offers", offers);
            request.getRequestDispatcher("/views/guest/offers.jsp").forward(request, response);
            
        } catch (SQLException e) {
            logger.error("Error listing active offers", e);
            request.setAttribute(Constants.ATTR_ERROR, "Error loading offers");
            request.getRequestDispatcher("/views/guest/offers.jsp").forward(request, response);
        }
    }
    
    /**
     * View offer details
     */
    private void viewOffer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        
        if (!ValidationUtil.isValidInteger(idStr)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid offer ID");
            return;
        }
        
        try {
            int offerId = Integer.parseInt(idStr);
            Optional<Offer> offerOpt = offerDAO.findById(offerId);
            
            if (offerOpt.isPresent()) {
                request.setAttribute("offer", offerOpt.get());
                request.getRequestDispatcher("/views/offer-details.jsp").forward(request, response);
            } else {
                request.setAttribute(Constants.ATTR_ERROR, "Offer not found");
                response.sendRedirect(request.getContextPath() + "/offer?action=list");
            }
            
        } catch (SQLException e) {
            logger.error("Error viewing offer", e);
            request.setAttribute(Constants.ATTR_ERROR, "Error loading offer");
            response.sendRedirect(request.getContextPath() + "/offer?action=list");
        }
    }
    
    /**
     * Show edit form
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        
        if (!ValidationUtil.isValidInteger(idStr)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid offer ID");
            return;
        }
        
        try {
            int offerId = Integer.parseInt(idStr);
            Optional<Offer> offerOpt = offerDAO.findById(offerId);
            
            if (offerOpt.isPresent()) {
                request.setAttribute("offer", offerOpt.get());
                request.getRequestDispatcher("/views/admin/offer-form.jsp").forward(request, response);
            } else {
                request.setAttribute(Constants.ATTR_ERROR, "Offer not found");
                response.sendRedirect(request.getContextPath() + "/offer?action=list");
            }
            
        } catch (SQLException e) {
            logger.error("Error loading offer for edit", e);
            request.setAttribute(Constants.ATTR_ERROR, "Error loading offer");
            response.sendRedirect(request.getContextPath() + "/offer?action=list");
        }
    }
    
    /**
     * Create new offer
     */
    private void createOffer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            Offer offer = new Offer();
            offer.setOfferName(request.getParameter("offerName"));
            offer.setDescription(request.getParameter("description"));
            offer.setDiscountType(Offer.DiscountType.valueOf(request.getParameter("discountType")));
            offer.setDiscountValue(new BigDecimal(request.getParameter("discountValue")));
            offer.setStartDate(LocalDate.parse(request.getParameter("startDate")));
            offer.setEndDate(LocalDate.parse(request.getParameter("endDate")));
            
            String minStayStr = request.getParameter("minStay");
            if (minStayStr != null && !minStayStr.isEmpty()) {
                offer.setMinStayNights(Integer.parseInt(minStayStr));
            }
            
            String maxUsesStr = request.getParameter("maxUses");
            if (maxUsesStr != null && !maxUsesStr.isEmpty()) {
                offer.setMaxUses(Integer.parseInt(maxUsesStr));
            }
            
            offer.setPromoCode(request.getParameter("promoCode"));
            offer.setOfferStatus(Offer.OfferStatus.valueOf(request.getParameter("status")));
            offer.setUsedCount(0);
            
            int offerId = offerDAO.create(offer);
            
            if (offerId > 0) {
                logger.info("Offer created successfully: ID={}", offerId);
                request.getSession().setAttribute(Constants.ATTR_SUCCESS, "Offer created successfully!");
            } else {
                request.getSession().setAttribute(Constants.ATTR_ERROR, "Failed to create offer");
            }
            
            response.sendRedirect(request.getContextPath() + "/offer?action=list");
            
        } catch (Exception e) {
            logger.error("Error creating offer", e);
            request.getSession().setAttribute(Constants.ATTR_ERROR, "Error creating offer: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/offer?action=list");
        }
    }
    
    /**
     * Update existing offer
     */
    private void updateOffer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int offerId = Integer.parseInt(request.getParameter("id"));
            Optional<Offer> offerOpt = offerDAO.findById(offerId);
            
            if (!offerOpt.isPresent()) {
                request.getSession().setAttribute(Constants.ATTR_ERROR, "Offer not found");
                response.sendRedirect(request.getContextPath() + "/offer?action=list");
                return;
            }
            
            Offer offer = offerOpt.get();
            offer.setOfferName(request.getParameter("offerName"));
            offer.setDescription(request.getParameter("description"));
            offer.setDiscountType(Offer.DiscountType.valueOf(request.getParameter("discountType")));
            offer.setDiscountValue(new BigDecimal(request.getParameter("discountValue")));
            offer.setStartDate(LocalDate.parse(request.getParameter("startDate")));
            offer.setEndDate(LocalDate.parse(request.getParameter("endDate")));
            
            String minStayStr = request.getParameter("minStay");
            if (minStayStr != null && !minStayStr.isEmpty()) {
                offer.setMinStayNights(Integer.parseInt(minStayStr));
            }
            
            String maxUsesStr = request.getParameter("maxUses");
            if (maxUsesStr != null && !maxUsesStr.isEmpty()) {
                offer.setMaxUses(Integer.parseInt(maxUsesStr));
            }
            
            offer.setPromoCode(request.getParameter("promoCode"));
            offer.setOfferStatus(Offer.OfferStatus.valueOf(request.getParameter("status")));
            
            boolean success = offerDAO.update(offer);
            
            if (success) {
                logger.info("Offer updated successfully: ID={}", offerId);
                request.getSession().setAttribute(Constants.ATTR_SUCCESS, "Offer updated successfully!");
            } else {
                request.getSession().setAttribute(Constants.ATTR_ERROR, "Failed to update offer");
            }
            
            response.sendRedirect(request.getContextPath() + "/offer?action=list");
            
        } catch (Exception e) {
            logger.error("Error updating offer", e);
            request.getSession().setAttribute(Constants.ATTR_ERROR, "Error updating offer: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/offer?action=list");
        }
    }
    
    /**
     * Toggle offer status
     */
    private void toggleStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        
        if (!ValidationUtil.isValidInteger(idStr)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid offer ID");
            return;
        }
        
        try {
            int offerId = Integer.parseInt(idStr);
            Optional<Offer> offerOpt = offerDAO.findById(offerId);
            
            if (offerOpt.isPresent()) {
                Offer offer = offerOpt.get();
                
                // Toggle between ACTIVE and INACTIVE
                if (offer.getOfferStatus() == Offer.OfferStatus.ACTIVE) {
                    offer.setOfferStatus(Offer.OfferStatus.INACTIVE);
                } else {
                    offer.setOfferStatus(Offer.OfferStatus.ACTIVE);
                }
                
                boolean success = offerDAO.update(offer);
                
                if (success) {
                    logger.info("Offer status toggled: ID={}", offerId);
                    request.getSession().setAttribute(Constants.ATTR_SUCCESS, "Offer status updated!");
                } else {
                    request.getSession().setAttribute(Constants.ATTR_ERROR, "Failed to update status");
                }
            }
            
            response.sendRedirect(request.getContextPath() + "/offer?action=list");
            
        } catch (SQLException e) {
            logger.error("Error toggling offer status", e);
            request.getSession().setAttribute(Constants.ATTR_ERROR, "Error updating status");
            response.sendRedirect(request.getContextPath() + "/offer?action=list");
        }
    }
    
    /**
     * Delete offer
     */
    private void deleteOffer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        
        if (!ValidationUtil.isValidInteger(idStr)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid offer ID");
            return;
        }
        
        try {
            int offerId = Integer.parseInt(idStr);
            boolean success = offerDAO.delete(offerId);
            
            if (success) {
                logger.info("Offer deleted: ID={}", offerId);
                request.getSession().setAttribute(Constants.ATTR_SUCCESS, "Offer deleted successfully!");
            } else {
                request.getSession().setAttribute(Constants.ATTR_ERROR, "Failed to delete offer");
            }
            
            response.sendRedirect(request.getContextPath() + "/offer?action=list");
            
        } catch (SQLException e) {
            logger.error("Error deleting offer", e);
            request.getSession().setAttribute(Constants.ATTR_ERROR, "Error deleting offer");
            response.sendRedirect(request.getContextPath() + "/offer?action=list");
        }
    }
}
