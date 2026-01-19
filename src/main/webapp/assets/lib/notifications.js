/**
 * Ocean View Resort - Notifications Library
 * Advanced notification system with multiple types and animations
 */

const Notifications = {
    container: null,
    notifications: [],
    config: {
        position: 'top-right', // top-right, top-left, bottom-right, bottom-left, top-center, bottom-center
        duration: 5000,
        maxNotifications: 5,
        animations: true,
        closeButton: true
    },

    /**
     * Initialize notification system
     */
    init: function(options = {}) {
        this.config = { ...this.config, ...options };
        this.createContainer();
    },

    /**
     * Create notification container
     */
    createContainer: function() {
        if (this.container) return;

        this.container = document.createElement('div');
        this.container.className = 'notifications-container ' + this.config.position;
        document.body.appendChild(this.container);
    },

    /**
     * Show notification
     */
    show: function(message, type = 'info', options = {}) {
        const settings = { ...this.config, ...options };
        
        // Limit max notifications
        if (this.notifications.length >= this.config.maxNotifications) {
            this.close(this.notifications[0].id);
        }

        const notification = this.createNotification(message, type, settings);
        this.container.appendChild(notification.element);
        this.notifications.push(notification);

        // Auto-close
        if (settings.duration > 0) {
            notification.timer = setTimeout(() => {
                this.close(notification.id);
            }, settings.duration);
        }

        return notification.id;
    },

    /**
     * Create notification element
     */
    createNotification: function(message, type, settings) {
        const id = 'notif-' + Date.now() + '-' + Math.random().toString(36).substr(2, 9);
        const element = document.createElement('div');
        element.className = 'notification notification-' + type;
        element.id = id;

        const icon = this.getIcon(type);
        
        element.innerHTML = `
            <div class="notification-icon">
                <i class="${icon}"></i>
            </div>
            <div class="notification-content">
                ${settings.title ? `<div class="notification-title">${settings.title}</div>` : ''}
                <div class="notification-message">${message}</div>
            </div>
            ${settings.closeButton ? '<button class="notification-close">&times;</button>' : ''}
        `;

        // Add close button handler
        if (settings.closeButton) {
            element.querySelector('.notification-close').addEventListener('click', () => {
                this.close(id);
            });
        }

        // Add click handler
        if (settings.onClick) {
            element.style.cursor = 'pointer';
            element.addEventListener('click', (e) => {
                if (!e.target.classList.contains('notification-close')) {
                    settings.onClick();
                }
            });
        }

        // Animation
        if (settings.animations) {
            element.classList.add('notification-enter');
            setTimeout(() => {
                element.classList.remove('notification-enter');
                element.classList.add('notification-enter-active');
            }, 10);
        }

        return { id, element, timer: null };
    },

    /**
     * Get icon for notification type
     */
    getIcon: function(type) {
        const icons = {
            success: 'fas fa-check-circle',
            error: 'fas fa-exclamation-circle',
            warning: 'fas fa-exclamation-triangle',
            info: 'fas fa-info-circle'
        };
        return icons[type] || icons.info;
    },

    /**
     * Close notification
     */
    close: function(id) {
        const index = this.notifications.findIndex(n => n.id === id);
        if (index === -1) return;

        const notification = this.notifications[index];
        
        // Clear timer
        if (notification.timer) {
            clearTimeout(notification.timer);
        }

        // Animate out
        notification.element.classList.add('notification-exit');
        
        setTimeout(() => {
            if (notification.element.parentNode) {
                notification.element.parentNode.removeChild(notification.element);
            }
            this.notifications.splice(index, 1);
        }, 300);
    },

    /**
     * Close all notifications
     */
    closeAll: function() {
        [...this.notifications].forEach(notification => {
            this.close(notification.id);
        });
    },

    /**
     * Shorthand methods
     */
    success: function(message, options) {
        return this.show(message, 'success', options);
    },

    error: function(message, options) {
        return this.show(message, 'error', options);
    },

    warning: function(message, options) {
        return this.show(message, 'warning', options);
    },

    info: function(message, options) {
        return this.show(message, 'info', options);
    },

    /**
     * Show confirmation notification
     */
    confirm: function(message, onConfirm, onCancel) {
        const id = 'notif-confirm-' + Date.now();
        const element = document.createElement('div');
        element.className = 'notification notification-confirm';
        element.id = id;

        element.innerHTML = `
            <div class="notification-icon">
                <i class="fas fa-question-circle"></i>
            </div>
            <div class="notification-content">
                <div class="notification-message">${message}</div>
                <div class="notification-actions">
                    <button class="btn btn-sm btn-primary notification-confirm-btn">Confirm</button>
                    <button class="btn btn-sm btn-secondary notification-cancel-btn">Cancel</button>
                </div>
            </div>
        `;

        this.container.appendChild(element);
        
        // Confirm handler
        element.querySelector('.notification-confirm-btn').addEventListener('click', () => {
            if (onConfirm) onConfirm();
            this.removeElement(element);
        });

        // Cancel handler
        element.querySelector('.notification-cancel-btn').addEventListener('click', () => {
            if (onCancel) onCancel();
            this.removeElement(element);
        });

        return id;
    },

    /**
     * Remove element
     */
    removeElement: function(element) {
        element.classList.add('notification-exit');
        setTimeout(() => {
            if (element.parentNode) {
                element.parentNode.removeChild(element);
            }
        }, 300);
    }
};

// Auto-initialize
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => Notifications.init());
} else {
    Notifications.init();
}

// Export
window.Notifications = Notifications;
