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
            "<html>" +
            "<body style=\"font-family: Arial, sans-serif;\">" +
                "<h2>Booking Confirmation</h2>" +
                "<p>Dear %s,</p>" +
                "<p>Thank you for choosing Ocean View Resort! Your booking has been confirmed.</p>" +
                "<h3>Reservation Details:</h3>" +
                "<ul>" +
                    "<li><strong>Reservation Number:</strong> %s</li>" +
                    "<li><strong>Check-in Date:</strong> %s</li>" +
                    "<li><strong>Check-out Date:</strong> %s</li>" +
                    "<li><strong>Number of Nights:</strong> %d</li>" +
                    "<li><strong>Total Amount:</strong> $%.2f</li>" +
                "</ul>" +
                "<p>We look forward to welcoming you!</p>" +
                "<p>Best regards,<br>Ocean View Resort Team</p>" +
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
            "<html>" +
            "<body style=\"font-family: Arial, sans-serif;\">" +
                "<h2>Booking Cancellation</h2>" +
                "<p>Dear %s,</p>" +
                "<p>Your booking has been cancelled as per your request.</p>" +
                "<h3>Cancelled Reservation:</h3>" +
                "<ul>" +
                    "<li><strong>Reservation Number:</strong> %s</li>" +
                    "<li><strong>Check-in Date:</strong> %s</li>" +
                    "<li><strong>Check-out Date:</strong> %s</li>" +
                "</ul>" +
                "<p>We hope to serve you in the future!</p>" +
                "<p>Best regards,<br>Ocean View Resort Team</p>" +
            "</body>" +
            "</html>",
            user.getFullName(),
            reservation.getReservationNumber(),
            reservation.getCheckInDate(),
            reservation.getCheckOutDate()
        );
    }
    
    /**
     * Build check-in reminder email body
     */
    private String buildCheckInReminderEmail(User user, Reservation reservation) {
        return String.format(
            "<html>" +
            "<body style=\"font-family: Arial, sans-serif;\">" +
                "<h2>Check-in Reminder</h2>" +
                "<p>Dear %s,</p>" +
                "<p>This is a reminder that your check-in is scheduled for tomorrow.</p>" +
                "<h3>Reservation Details:</h3>" +
                "<ul>" +
                    "<li><strong>Reservation Number:</strong> %s</li>" +
                    "<li><strong>Check-in Date:</strong> %s</li>" +
                    "<li><strong>Check-out Date:</strong> %s</li>" +
                "</ul>" +
                "<p>Check-in time: 2:00 PM<br>Check-out time: 12:00 PM</p>" +
                "<p>We look forward to welcoming you!</p>" +
                "<p>Best regards,<br>Ocean View Resort Team</p>" +
            "</body>" +
            "</html>",
            user.getFullName(),
            reservation.getReservationNumber(),
            reservation.getCheckInDate(),
            reservation.getCheckOutDate()
        );
    }
    
    /**
     * Build welcome email body
     */
    private String buildWelcomeEmail(User user) {
        return String.format(
            "<html>" +
            "<body style=\"font-family: Arial, sans-serif;\">" +
                "<h2>Welcome to Ocean View Resort!</h2>" +
                "<p>Dear %s,</p>" +
                "<p>Thank you for registering with Ocean View Resort.</p>" +
                "<p>Your account has been created successfully. You can now:</p>" +
                "<ul>" +
                    "<li>Search and book available rooms</li>" +
                    "<li>View your booking history</li>" +
                    "<li>Manage your profile</li>" +
                    "<li>Rate and review your stays</li>" +
                "</ul>" +
                "<p>Experience luxury by the beach!</p>" +
                "<p>Best regards,<br>Ocean View Resort Team</p>" +
            "</body>" +
            "</html>",
            user.getFullName()
        );
    }
}
