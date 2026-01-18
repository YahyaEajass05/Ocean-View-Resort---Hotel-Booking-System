package com.oceanview.factory;

import com.oceanview.service.*;

/**
 * Service Factory - Factory Pattern
 * Creates Service instances
 * 
 * @author Ocean View Resort Development Team
 * @version 1.0.0
 */
public class ServiceFactory {
    
    /**
     * Get AuthenticationService instance
     * @return AuthenticationService
     */
    public static AuthenticationService getAuthenticationService() {
        return new AuthenticationService();
    }
    
    /**
     * Get ReservationService instance
     * @return ReservationService
     */
    public static ReservationService getReservationService() {
        return new ReservationService();
    }
    
    /**
     * Get RoomService instance
     * @return RoomService
     */
    public static RoomService getRoomService() {
        return new RoomService();
    }
    
    /**
     * Get BillingService instance
     * @return BillingService
     */
    public static BillingService getBillingService() {
        return new BillingService();
    }
    
    /**
     * Get EmailService instance (Singleton)
     * @return EmailService
     */
    public static EmailService getEmailService() {
        return EmailService.getInstance();
    }
    
    /**
     * Get PDFService instance (Singleton)
     * @return PDFService
     */
    public static PDFService getPDFService() {
        return PDFService.getInstance();
    }
    
    /**
     * Get AnalyticsService instance
     * @return AnalyticsService
     */
    public static AnalyticsService getAnalyticsService() {
        return new AnalyticsService();
    }
}
