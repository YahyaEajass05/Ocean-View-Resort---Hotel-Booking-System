package com.oceanview.service;

import com.oceanview.config.AppConfig;
import com.oceanview.model.Reservation;
import com.oceanview.model.User;
import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Properties;

/**
 * Email Service - Singleton Pattern
 * Handles email notifications
 * 
 * @author Ocean View Resort Development Team
 * @version 1.0.0
 */
public class EmailService {
    
    private static final Logger logger = LoggerFactory.getLogger(EmailService.class);
    private static EmailService instance;
    private final AppConfig config;
    private Session mailSession;
    
    /**
     * Private constructor for Singleton
     */
    private EmailService() {
        this.config = AppConfig.getInstance();
        initializeMailSession();
    }
    
    /**
     * Get singleton instance
     * @return EmailService instance
     */
    public static synchronized EmailService getInstance() {
        if (instance == null) {
            instance = new EmailService();
        }
        return instance;
    }
    
    /**
     * Initialize mail session
     */
    private void initializeMailSession() {
        if (!config.isEmailEnabled()) {
            logger.info("Email service is disabled");
            return;
        }
        
        Properties props = new Properties();
        props.put("mail.smtp.host", config.getEmailHost());
        props.put("mail.smtp.port", config.getEmailPort());
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        
        mailSession = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(
                    config.getEmailUsername(),
                    config.getEmailPassword()
                );
            }
        });
        
        logger.info("Email service initialized successfully");
    }
    
    /**
     * Send booking confirmation email
     * @param user User
     * @param reservation Reservation
     * @return true if successful
     */
    public boolean sendBookingConfirmation(User user, Reservation reservation) {
        if (!config.isEmailEnabled()) {
            logger.debug("Email service disabled, skipping booking confirmation");
            return false;
        }
        
        String subject = "Booking Confirmation - " + reservation.getReservationNumber();
        String body = buildBookingConfirmationEmail(user, reservation);
        
        return sendEmail(user.getEmail(), subject, body);
    }
    
    /**
     * Send cancellation email
     * @param user User
     * @param reservation Reservation
     * @return true if successful
     */
    public boolean sendCancellationEmail(User user, Reservation reservation) {
        if (!config.isEmailEnabled()) {
            logger.debug("Email service disabled, skipping cancellation email");
            return false;
        }
        
        String subject = "Booking Cancellation - " + reservation.getReservationNumber();
        String body = buildCancellationEmail(user, reservation);
        
        return sendEmail(user.getEmail(), subject, body);
    }
    
    /**
     * Send check-in reminder
     * @param user User
     * @param reservation Reservation
     * @return true if successful
     */
    public boolean sendCheckInReminder(User user, Reservation reservation) {
        if (!config.isEmailEnabled()) {
            logger.debug("Email service disabled, skipping check-in reminder");
            return false;
        }
        
        String subject = "Check-in Reminder - " + reservation.getReservationNumber();
        String body = buildCheckInReminderEmail(user, reservation);
        
        return sendEmail(user.getEmail(), subject, body);
    }
    
    /**
     * Send welcome email
     * @param user User
     * @return true if successful
     */
    public boolean sendWelcomeEmail(User user) {
        if (!config.isEmailEnabled()) {
            logger.debug("Email service disabled, skipping welcome email");
            return false;
        }
        
        String subject = "Welcome to Ocean View Resort";
        String body = buildWelcomeEmail(user);
        
        return sendEmail(user.getEmail(), subject, body);
    }
    
    /**
     * Send generic email
     * @param to Recipient email
     * @param subject Subject
     * @param body Body
     * @return true if successful
     */
    public boolean sendEmail(String to, String subject, String body) {
        if (!config.isEmailEnabled() || mailSession == null) {
            logger.debug("Email service not available");
            return false;
        }
        
        try {
            Message message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress(config.getEmailFrom()));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setContent(body, "text/html; charset=utf-8");
            
            Transport.send(message);
            
            logger.info("Email sent successfully to: {}", to);
            return true;
            
        } catch (MessagingException e) {
            logger.error("Failed to send email to: {}", to, e);
            return false;
        }
    }
    
    /**
     * Build booking confirmation email body
     */
    private String buildBookingConfirmationEmail(User user, Reservation reservation) {
        return String.format(
            "<!DOCTYPE html>" +
            "<html>" +
            "<head>" +
                "<meta charset=\"UTF-8\">" +
                "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">" +
            "</head>" +
            "<body style=\"margin: 0; padding: 0; font-family: Arial, Helvetica, sans-serif; background-color: #f4f4f4;\">" +
                "<table width=\"100%%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"background-color: #f4f4f4; padding: 20px 0;\">" +
                    "<tr>" +
                        "<td align=\"center\">" +
                            "<table width=\"600\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"background-color: #ffffff; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);\">" +
                                "<!-- Header -->" +
                                "<tr>" +
                                    "<td style=\"background: linear-gradient(135deg, #006994 0%%, #003d5c 100%%); padding: 30px; text-align: center; border-radius: 10px 10px 0 0;\">" +
                                        "<h1 style=\"margin: 0; color: #ffffff; font-size: 28px; font-weight: bold;\">Ocean View Resort</h1>" +
                                        "<p style=\"margin: 5px 0 0 0; color: #F5E6D3; font-size: 14px;\">Your Paradise by the Sea</p>" +
                                    "</td>" +
                                "</tr>" +
                                "<!-- Content -->" +
                                "<tr>" +
                                    "<td style=\"padding: 40px 30px;\">" +
                                        "<h2 style=\"margin: 0 0 20px 0; color: #006994; font-size: 24px;\">✓ Booking Confirmed!</h2>" +
                                        "<p style=\"margin: 0 0 20px 0; color: #333333; font-size: 16px; line-height: 1.6;\">Dear <strong>%s</strong>,</p>" +
                                        "<p style=\"margin: 0 0 30px 0; color: #333333; font-size: 16px; line-height: 1.6;\">Thank you for choosing Ocean View Resort! We're delighted to confirm your reservation. Get ready for an unforgettable experience!</p>" +
                                        
                                        "<!-- Reservation Details Box -->" +
                                        "<table width=\"100%%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"background-color: #f8f9fa; border-radius: 8px; margin-bottom: 30px;\">" +
                                            "<tr>" +
                                                "<td style=\"padding: 20px;\">" +
                                                    "<h3 style=\"margin: 0 0 15px 0; color: #006994; font-size: 18px;\">Reservation Details</h3>" +
                                                    "<table width=\"100%%\" cellpadding=\"8\" cellspacing=\"0\" border=\"0\">" +
                                                        "<tr>" +
                                                            "<td style=\"color: #666666; font-size: 14px; padding: 8px 0;\">Reservation Number:</td>" +
                                                            "<td style=\"color: #333333; font-size: 14px; font-weight: bold; text-align: right; padding: 8px 0;\">%s</td>" +
                                                        "</tr>" +
                                                        "<tr style=\"border-top: 1px solid #e0e0e0;\">" +
                                                            "<td style=\"color: #666666; font-size: 14px; padding: 8px 0;\">Check-in Date:</td>" +
                                                            "<td style=\"color: #333333; font-size: 14px; font-weight: bold; text-align: right; padding: 8px 0;\">%s</td>" +
                                                        "</tr>" +
                                                        "<tr style=\"border-top: 1px solid #e0e0e0;\">" +
                                                            "<td style=\"color: #666666; font-size: 14px; padding: 8px 0;\">Check-out Date:</td>" +
                                                            "<td style=\"color: #333333; font-size: 14px; font-weight: bold; text-align: right; padding: 8px 0;\">%s</td>" +
                                                        "</tr>" +
                                                        "<tr style=\"border-top: 1px solid #e0e0e0;\">" +
                                                            "<td style=\"color: #666666; font-size: 14px; padding: 8px 0;\">Number of Nights:</td>" +
                                                            "<td style=\"color: #333333; font-size: 14px; font-weight: bold; text-align: right; padding: 8px 0;\">%d</td>" +
                                                        "</tr>" +
                                                        "<tr style=\"border-top: 2px solid #006994;\">" +
                                                            "<td style=\"color: #006994; font-size: 16px; font-weight: bold; padding: 12px 0 0 0;\">Total Amount:</td>" +
                                                            "<td style=\"color: #006994; font-size: 18px; font-weight: bold; text-align: right; padding: 12px 0 0 0;\">$%.2f</td>" +
                                                        "</tr>" +
                                                    "</table>" +
                                                "</td>" +
                                            "</tr>" +
                                        "</table>" +
                                        
                                        "<!-- Important Info -->" +
                                        "<table width=\"100%%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"background-color: #e8f4f8; border-left: 4px solid #006994; border-radius: 5px; margin-bottom: 30px;\">" +
                                            "<tr>" +
                                                "<td style=\"padding: 15px 20px;\">" +
                                                    "<p style=\"margin: 0; color: #0c5460; font-size: 14px; line-height: 1.5;\"><strong>Check-in Time:</strong> 2:00 PM<br><strong>Check-out Time:</strong> 12:00 PM</p>" +
                                                "</td>" +
                                            "</tr>" +
                                        "</table>" +
                                        
                                        "<p style=\"margin: 0 0 20px 0; color: #333333; font-size: 16px; line-height: 1.6;\">We look forward to welcoming you and making your stay extraordinary!</p>" +
                                        "<p style=\"margin: 0; color: #333333; font-size: 16px; line-height: 1.6;\">Best regards,<br><strong style=\"color: #006994;\">Ocean View Resort Team</strong></p>" +
                                    "</td>" +
                                "</tr>" +
                                "<!-- Footer -->" +
                                "<tr>" +
                                    "<td style=\"background-color: #f8f9fa; padding: 20px 30px; text-align: center; border-radius: 0 0 10px 10px;\">" +
                                        "<p style=\"margin: 0 0 10px 0; color: #666666; font-size: 12px;\">Ocean View Resort | 123 Beach Road, Paradise Island</p>" +
                                        "<p style=\"margin: 0; color: #666666; font-size: 12px;\">Phone: +1 (555) 123-4567 | Email: info@oceanviewresort.com</p>" +
                                    "</td>" +
                                "</tr>" +
                            "</table>" +
                        "</td>" +
                    "</tr>" +
                "</table>" +
            "</body>" +
            "</html>",
            user.getFullName(),
            reservation.getReservationNumber(),
            reservation.getCheckInDate(),
            reservation.getCheckOutDate(),
            reservation.getNumberOfNights(),
            reservation.getFinalAmount()
        );
    }
    
    /**
     * Build cancellation email body
     */
    private String buildCancellationEmail(User user, Reservation reservation) {
        return String.format(
            "<!DOCTYPE html>" +
            "<html>" +
            "<head><meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"></head>" +
            "<body style=\"margin: 0; padding: 0; font-family: Arial, Helvetica, sans-serif; background-color: #f4f4f4;\">" +
                "<table width=\"100%%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"background-color: #f4f4f4; padding: 20px 0;\">" +
                    "<tr><td align=\"center\">" +
                        "<table width=\"600\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"background-color: #ffffff; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);\">" +
                            "<tr><td style=\"background: linear-gradient(135deg, #006994 0%%, #003d5c 100%%); padding: 30px; text-align: center; border-radius: 10px 10px 0 0;\">" +
                                "<h1 style=\"margin: 0; color: #ffffff; font-size: 28px; font-weight: bold;\">Ocean View Resort</h1>" +
                                "<p style=\"margin: 5px 0 0 0; color: #F5E6D3; font-size: 14px;\">Your Paradise by the Sea</p>" +
                            "</td></tr>" +
                            "<tr><td style=\"padding: 40px 30px;\">" +
                                "<h2 style=\"margin: 0 0 20px 0; color: #DC3545; font-size: 24px;\">Booking Cancelled</h2>" +
                                "<p style=\"margin: 0 0 20px 0; color: #333333; font-size: 16px; line-height: 1.6;\">Dear <strong>%s</strong>,</p>" +
                                "<p style=\"margin: 0 0 30px 0; color: #333333; font-size: 16px; line-height: 1.6;\">Your booking has been cancelled as per your request.</p>" +
                                "<table width=\"100%%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"background-color: #f8f9fa; border-radius: 8px; margin-bottom: 30px;\">" +
                                    "<tr><td style=\"padding: 20px;\">" +
                                        "<h3 style=\"margin: 0 0 15px 0; color: #DC3545; font-size: 18px;\">Cancelled Reservation</h3>" +
                                        "<table width=\"100%%\" cellpadding=\"8\" cellspacing=\"0\" border=\"0\">" +
                                            "<tr><td style=\"color: #666666; font-size: 14px;\">Reservation Number:</td><td style=\"color: #333333; font-size: 14px; font-weight: bold; text-align: right;\">%s</td></tr>" +
                                            "<tr style=\"border-top: 1px solid #e0e0e0;\"><td style=\"color: #666666; font-size: 14px;\">Check-in Date:</td><td style=\"color: #333333; font-size: 14px; font-weight: bold; text-align: right;\">%s</td></tr>" +
                                            "<tr style=\"border-top: 1px solid #e0e0e0;\"><td style=\"color: #666666; font-size: 14px;\">Check-out Date:</td><td style=\"color: #333333; font-size: 14px; font-weight: bold; text-align: right;\">%s</td></tr>" +
                                        "</table>" +
                                    "</td></tr>" +
                                "</table>" +
                                "<p style=\"margin: 0 0 20px 0; color: #333333; font-size: 16px; line-height: 1.6;\">We hope to have the opportunity to serve you in the future!</p>" +
                                "<p style=\"margin: 0; color: #333333; font-size: 16px;\">Best regards,<br><strong style=\"color: #006994;\">Ocean View Resort Team</strong></p>" +
                            "</td></tr>" +
                            "<tr><td style=\"background-color: #f8f9fa; padding: 20px 30px; text-align: center; border-radius: 0 0 10px 10px;\">" +
                                "<p style=\"margin: 0 0 10px 0; color: #666666; font-size: 12px;\">Ocean View Resort | 123 Beach Road, Paradise Island</p>" +
                                "<p style=\"margin: 0; color: #666666; font-size: 12px;\">Phone: +1 (555) 123-4567 | Email: info@oceanviewresort.com</p>" +
                            "</td></tr>" +
                        "</table>" +
                    "</td></tr>" +
                "</table>" +
            "</body></html>",
            user.getFullName(), reservation.getReservationNumber(),
            reservation.getCheckInDate(), reservation.getCheckOutDate()
        );
    }
    
    /**
     * Build check-in reminder email body
     */
    private String buildCheckInReminderEmail(User user, Reservation reservation) {
        return String.format(
            "<!DOCTYPE html><html><head><meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"></head>" +
            "<body style=\"margin: 0; padding: 0; font-family: Arial, Helvetica, sans-serif; background-color: #f4f4f4;\">" +
                "<table width=\"100%%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"background-color: #f4f4f4; padding: 20px 0;\">" +
                    "<tr><td align=\"center\"><table width=\"600\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"background-color: #ffffff; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);\">" +
                        "<tr><td style=\"background: linear-gradient(135deg, #006994 0%%, #003d5c 100%%); padding: 30px; text-align: center; border-radius: 10px 10px 0 0;\">" +
                            "<h1 style=\"margin: 0; color: #ffffff; font-size: 28px; font-weight: bold;\">Ocean View Resort</h1>" +
                            "<p style=\"margin: 5px 0 0 0; color: #F5E6D3; font-size: 14px;\">Your Paradise by the Sea</p>" +
                        "</td></tr>" +
                        "<tr><td style=\"padding: 40px 30px;\">" +
                            "<h2 style=\"margin: 0 0 20px 0; color: #FFC107; font-size: 24px;\">⏰ Check-in Reminder</h2>" +
                            "<p style=\"margin: 0 0 20px 0; color: #333333; font-size: 16px; line-height: 1.6;\">Dear <strong>%s</strong>,</p>" +
                            "<p style=\"margin: 0 0 30px 0; color: #333333; font-size: 16px; line-height: 1.6;\">We're excited to welcome you tomorrow! This is a friendly reminder about your upcoming check-in.</p>" +
                            "<table width=\"100%%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"background-color: #FFF8E1; border-left: 4px solid #FFC107; border-radius: 5px; margin-bottom: 20px;\">" +
                                "<tr><td style=\"padding: 20px;\">" +
                                    "<h3 style=\"margin: 0 0 15px 0; color: #F57C00; font-size: 18px;\">Your Reservation</h3>" +
                                    "<table width=\"100%%\" cellpadding=\"8\" cellspacing=\"0\" border=\"0\">" +
                                        "<tr><td style=\"color: #666666; font-size: 14px;\">Reservation Number:</td><td style=\"color: #333333; font-size: 14px; font-weight: bold; text-align: right;\">%s</td></tr>" +
                                        "<tr style=\"border-top: 1px solid #FFE082;\"><td style=\"color: #666666; font-size: 14px;\">Check-in Date:</td><td style=\"color: #333333; font-size: 14px; font-weight: bold; text-align: right;\">%s</td></tr>" +
                                        "<tr style=\"border-top: 1px solid #FFE082;\"><td style=\"color: #666666; font-size: 14px;\">Check-out Date:</td><td style=\"color: #333333; font-size: 14px; font-weight: bold; text-align: right;\">%s</td></tr>" +
                                    "</table>" +
                                "</td></tr>" +
                            "</table>" +
                            "<table width=\"100%%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"background-color: #e8f4f8; border-radius: 5px; margin-bottom: 20px;\">" +
                                "<tr><td style=\"padding: 15px 20px; text-align: center;\">" +
                                    "<p style=\"margin: 0; color: #0c5460; font-size: 16px; font-weight: bold;\">Check-in Time: 2:00 PM | Check-out Time: 12:00 PM</p>" +
                                "</td></tr>" +
                            "</table>" +
                            "<p style=\"margin: 0 0 20px 0; color: #333333; font-size: 16px; line-height: 1.6;\">We look forward to welcoming you and ensuring you have a memorable stay!</p>" +
                            "<p style=\"margin: 0; color: #333333; font-size: 16px;\">Best regards,<br><strong style=\"color: #006994;\">Ocean View Resort Team</strong></p>" +
                        "</td></tr>" +
                        "<tr><td style=\"background-color: #f8f9fa; padding: 20px 30px; text-align: center; border-radius: 0 0 10px 10px;\">" +
                            "<p style=\"margin: 0 0 10px 0; color: #666666; font-size: 12px;\">Ocean View Resort | 123 Beach Road, Paradise Island</p>" +
                            "<p style=\"margin: 0; color: #666666; font-size: 12px;\">Phone: +1 (555) 123-4567 | Email: info@oceanviewresort.com</p>" +
                        "</td></tr>" +
                    "</table></td></tr>" +
                "</table>" +
            "</body></html>",
            user.getFullName(), reservation.getReservationNumber(),
            reservation.getCheckInDate(), reservation.getCheckOutDate()
        );
    }
    
    /**
     * Build welcome email body
     */
    private String buildWelcomeEmail(User user) {
        return String.format(
            "<!DOCTYPE html><html><head><meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"></head>" +
            "<body style=\"margin: 0; padding: 0; font-family: Arial, Helvetica, sans-serif; background-color: #f4f4f4;\">" +
                "<table width=\"100%%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"background-color: #f4f4f4; padding: 20px 0;\">" +
                    "<tr><td align=\"center\"><table width=\"600\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"background-color: #ffffff; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);\">" +
                        "<tr><td style=\"background: linear-gradient(135deg, #006994 0%%, #003d5c 100%%); padding: 30px; text-align: center; border-radius: 10px 10px 0 0;\">" +
                            "<h1 style=\"margin: 0; color: #ffffff; font-size: 28px; font-weight: bold;\">🌊 Ocean View Resort</h1>" +
                            "<p style=\"margin: 5px 0 0 0; color: #F5E6D3; font-size: 14px;\">Your Paradise by the Sea</p>" +
                        "</td></tr>" +
                        "<tr><td style=\"padding: 40px 30px;\">" +
                            "<h2 style=\"margin: 0 0 20px 0; color: #28A745; font-size: 24px;\">Welcome to Ocean View Resort!</h2>" +
                            "<p style=\"margin: 0 0 20px 0; color: #333333; font-size: 16px; line-height: 1.6;\">Dear <strong>%s</strong>,</p>" +
                            "<p style=\"margin: 0 0 30px 0; color: #333333; font-size: 16px; line-height: 1.6;\">Thank you for joining Ocean View Resort! We're thrilled to have you as part of our family. Your account has been created successfully and you're ready to start exploring.</p>" +
                            "<table width=\"100%%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"background-color: #f8f9fa; border-radius: 8px; margin-bottom: 30px;\">" +
                                "<tr><td style=\"padding: 25px;\">" +
                                    "<h3 style=\"margin: 0 0 15px 0; color: #006994; font-size: 18px;\">What You Can Do Now:</h3>" +
                                    "<table width=\"100%%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\">" +
                                        "<tr><td style=\"padding: 10px 0;\">" +
                                            "<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\"><tr>" +
                                                "<td style=\"width: 30px; vertical-align: top;\"><span style=\"color: #28A745; font-size: 20px; font-weight: bold;\">✓</span></td>" +
                                                "<td style=\"color: #333333; font-size: 15px; line-height: 1.5;\">Search and book available rooms with instant confirmation</td>" +
                                            "</tr></table>" +
                                        "</td></tr>" +
                                        "<tr><td style=\"padding: 10px 0; border-top: 1px solid #e0e0e0;\">" +
                                            "<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\"><tr>" +
                                                "<td style=\"width: 30px; vertical-align: top;\"><span style=\"color: #28A745; font-size: 20px; font-weight: bold;\">✓</span></td>" +
                                                "<td style=\"color: #333333; font-size: 15px; line-height: 1.5;\">View and manage your booking history</td>" +
                                            "</tr></table>" +
                                        "</td></tr>" +
                                        "<tr><td style=\"padding: 10px 0; border-top: 1px solid #e0e0e0;\">" +
                                            "<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\"><tr>" +
                                                "<td style=\"width: 30px; vertical-align: top;\"><span style=\"color: #28A745; font-size: 20px; font-weight: bold;\">✓</span></td>" +
                                                "<td style=\"color: #333333; font-size: 15px; line-height: 1.5;\">Update your profile and preferences</td>" +
                                            "</tr></table>" +
                                        "</td></tr>" +
                                        "<tr><td style=\"padding: 10px 0; border-top: 1px solid #e0e0e0;\">" +
                                            "<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\"><tr>" +
                                                "<td style=\"width: 30px; vertical-align: top;\"><span style=\"color: #28A745; font-size: 20px; font-weight: bold;\">✓</span></td>" +
                                                "<td style=\"color: #333333; font-size: 15px; line-height: 1.5;\">Rate and review your stays to help others</td>" +
                                            "</tr></table>" +
                                        "</td></tr>" +
                                    "</table>" +
                                "</td></tr>" +
                            "</table>" +
                            "<table width=\"100%%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"background: linear-gradient(135deg, #e8f4f8 0%%, #d4ebf5 100%%); border-radius: 8px; margin-bottom: 30px;\">" +
                                "<tr><td style=\"padding: 20px; text-align: center;\">" +
                                    "<p style=\"margin: 0 0 10px 0; color: #006994; font-size: 18px; font-weight: bold;\">Experience Luxury by the Beach!</p>" +
                                    "<p style=\"margin: 0; color: #0c5460; font-size: 14px;\">Special offers and exclusive deals await you</p>" +
                                "</td></tr>" +
                            "</table>" +
                            "<p style=\"margin: 0 0 20px 0; color: #333333; font-size: 16px; line-height: 1.6;\">We're excited to be part of your travel journey!</p>" +
                            "<p style=\"margin: 0; color: #333333; font-size: 16px;\">Warm regards,<br><strong style=\"color: #006994;\">Ocean View Resort Team</strong></p>" +
                        "</td></tr>" +
                        "<tr><td style=\"background-color: #f8f9fa; padding: 20px 30px; text-align: center; border-radius: 0 0 10px 10px;\">" +
                            "<p style=\"margin: 0 0 10px 0; color: #666666; font-size: 12px;\">Ocean View Resort | 123 Beach Road, Paradise Island</p>" +
                            "<p style=\"margin: 0; color: #666666; font-size: 12px;\">Phone: +1 (555) 123-4567 | Email: info@oceanviewresort.com</p>" +
                        "</td></tr>" +
                    "</table></td></tr>" +
                "</table>" +
            "</body></html>",
            user.getFullName()
        );
    }
}
