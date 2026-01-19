/**
 * Ocean View Resort - Advanced Validation Module
 * Comprehensive form validation with real-time feedback
 */

const Validation = {
    // Validation rules
    rules: {
        email: /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/,
        phone: /^[\d\s\-\+\(\)]{10,}$/,
        password: /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/,
        alphanumeric: /^[a-zA-Z0-9]+$/,
        alphabetic: /^[a-zA-Z\s]+$/,
        numeric: /^\d+$/,
        url: /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/,
        creditCard: /^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|3[47][0-9]{13}|6(?:011|5[0-9]{2})[0-9]{12})$/
    },

    // Error messages
    messages: {
        required: 'This field is required',
        email: 'Please enter a valid email address',
        phone: 'Please enter a valid phone number',
        password: 'Password must be at least 8 characters with uppercase, lowercase, number and special character',
        minLength: 'Must be at least {min} characters',
        maxLength: 'Must not exceed {max} characters',
        min: 'Must be at least {min}',
        max: 'Must not exceed {max}',
        match: 'Fields do not match',
        date: 'Please enter a valid date',
        dateRange: 'End date must be after start date',
        creditCard: 'Please enter a valid credit card number'
    },

    /**
     * Initialize validation for all forms with data-validate attribute
     */
    init: function() {
        const forms = document.querySelectorAll('form[data-validate="true"]');
        forms.forEach(form => {
            this.bindForm(form);
        });
    },

    /**
     * Bind validation to a form
     */
    bindForm: function(form) {
        const inputs = form.querySelectorAll('input, select, textarea');
        
        // Real-time validation on blur
        inputs.forEach(input => {
            input.addEventListener('blur', () => {
                this.validateField(input);
            });

            // Clear error on focus
            input.addEventListener('focus', () => {
                this.clearError(input);
            });

            // Real-time validation for password strength
            if (input.type === 'password' && input.dataset.showStrength === 'true') {
                input.addEventListener('input', () => {
                    this.showPasswordStrength(input);
                });
            }
        });

        // Form submission validation
        form.addEventListener('submit', (e) => {
            if (!this.validateForm(form)) {
                e.preventDefault();
                this.focusFirstError(form);
            }
        });
    },

    /**
     * Validate entire form
     */
    validateForm: function(form) {
        const inputs = form.querySelectorAll('input:not([type="hidden"]), select, textarea');
        let isValid = true;

        inputs.forEach(input => {
            if (!this.validateField(input)) {
                isValid = false;
            }
        });

        return isValid;
    },

    /**
     * Validate individual field
     */
    validateField: function(field) {
        const value = field.value.trim();
        const type = field.type;
        const required = field.hasAttribute('required');
        const minLength = field.getAttribute('minlength');
        const maxLength = field.getAttribute('maxlength');
        const min = field.getAttribute('min');
        const max = field.getAttribute('max');
        const pattern = field.getAttribute('pattern');
        const match = field.dataset.match;
        const customValidation = field.dataset.validation;

        // Required check
        if (required && !value) {
            this.showError(field, this.messages.required);
            return false;
        }

        if (!value && !required) {
            return true; // Optional field, no value - valid
        }

        // Email validation
        if (type === 'email' || customValidation === 'email') {
            if (!this.rules.email.test(value)) {
                this.showError(field, this.messages.email);
                return false;
            }
        }

        // Phone validation
        if (type === 'tel' || customValidation === 'phone') {
            if (!this.rules.phone.test(value)) {
                this.showError(field, this.messages.phone);
                return false;
            }
        }

        // Password validation
        if (type === 'password' && field.dataset.validatePassword === 'true') {
            if (!this.rules.password.test(value)) {
                this.showError(field, this.messages.password);
                return false;
            }
        }

        // Min length
        if (minLength && value.length < parseInt(minLength)) {
            this.showError(field, this.messages.minLength.replace('{min}', minLength));
            return false;
        }

        // Max length
        if (maxLength && value.length > parseInt(maxLength)) {
            this.showError(field, this.messages.maxLength.replace('{max}', maxLength));
            return false;
        }

        // Number validations
        if (type === 'number') {
            const numValue = parseFloat(value);
            
            if (isNaN(numValue)) {
                this.showError(field, 'Please enter a valid number');
                return false;
            }

            if (min && numValue < parseFloat(min)) {
                this.showError(field, this.messages.min.replace('{min}', min));
                return false;
            }

            if (max && numValue > parseFloat(max)) {
                this.showError(field, this.messages.max.replace('{max}', max));
                return false;
            }
        }

        // Date validations
        if (type === 'date') {
            const dateValue = new Date(value);
            const today = new Date();
            today.setHours(0, 0, 0, 0);

            if (field.dataset.minDate === 'today' && dateValue < today) {
                this.showError(field, 'Date cannot be in the past');
                return false;
            }

            if (field.dataset.minDate === 'tomorrow') {
                const tomorrow = new Date(today);
                tomorrow.setDate(tomorrow.getDate() + 1);
                if (dateValue < tomorrow) {
                    this.showError(field, 'Date must be at least tomorrow');
                    return false;
                }
            }

            // Check date range
            if (match) {
                const matchField = document.getElementById(match);
                if (matchField && matchField.value) {
                    const startDate = new Date(field.value);
                    const endDate = new Date(matchField.value);
                    if (startDate >= endDate) {
                        this.showError(field, this.messages.dateRange);
                        return false;
                    }
                }
            }
        }

        // Pattern validation
        if (pattern) {
            const regex = new RegExp(pattern);
            if (!regex.test(value)) {
                this.showError(field, field.dataset.patternError || 'Invalid format');
                return false;
            }
        }

        // Match validation (confirm password, etc)
        if (match) {
            const matchField = document.getElementById(match);
            if (matchField && value !== matchField.value) {
                this.showError(field, this.messages.match);
                return false;
            }
        }

        // Credit card validation
        if (customValidation === 'creditCard') {
            const cleanedValue = value.replace(/\s/g, '');
            if (!this.rules.creditCard.test(cleanedValue) || !this.luhnCheck(cleanedValue)) {
                this.showError(field, this.messages.creditCard);
                return false;
            }
        }

        // Custom validation functions
        if (customValidation && typeof window[customValidation] === 'function') {
            const result = window[customValidation](value, field);
            if (result !== true) {
                this.showError(field, result);
                return false;
            }
        }

        this.clearError(field);
        return true;
    },

    /**
     * Luhn algorithm for credit card validation
     */
    luhnCheck: function(cardNumber) {
        let sum = 0;
        let isEven = false;

        for (let i = cardNumber.length - 1; i >= 0; i--) {
            let digit = parseInt(cardNumber.charAt(i));

            if (isEven) {
                digit *= 2;
                if (digit > 9) {
                    digit -= 9;
                }
            }

            sum += digit;
            isEven = !isEven;
        }

        return (sum % 10) === 0;
    },

    /**
     * Show error message
     */
    showError: function(field, message) {
        field.classList.add('error');
        field.setAttribute('aria-invalid', 'true');

        let errorElement = field.parentElement.querySelector('.error-message');
        
        if (!errorElement) {
            errorElement = document.createElement('span');
            errorElement.className = 'error-message';
            errorElement.setAttribute('role', 'alert');
            field.parentElement.appendChild(errorElement);
        }

        errorElement.textContent = message;
    },

    /**
     * Clear error message
     */
    clearError: function(field) {
        field.classList.remove('error');
        field.removeAttribute('aria-invalid');

        const errorElement = field.parentElement.querySelector('.error-message');
        if (errorElement) {
            errorElement.textContent = '';
        }
    },

    /**
     * Focus first error field
     */
    focusFirstError: function(form) {
        const firstError = form.querySelector('.error');
        if (firstError) {
            firstError.focus();
            firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
    },

    /**
     * Show password strength indicator
     */
    showPasswordStrength: function(field) {
        const password = field.value;
        let strength = 0;
        let strengthText = '';
        let strengthClass = '';

        // Calculate strength
        if (password.length >= 8) strength++;
        if (password.length >= 12) strength++;
        if (/[a-z]/.test(password)) strength++;
        if (/[A-Z]/.test(password)) strength++;
        if (/\d/.test(password)) strength++;
        if (/[@$!%*?&]/.test(password)) strength++;

        // Determine strength level
        if (strength <= 2) {
            strengthText = 'Weak';
            strengthClass = 'weak';
        } else if (strength <= 4) {
            strengthText = 'Medium';
            strengthClass = 'medium';
        } else {
            strengthText = 'Strong';
            strengthClass = 'strong';
        }

        // Get or create strength indicator
        let indicator = field.parentElement.querySelector('.password-strength');
        
        if (!indicator) {
            indicator = document.createElement('div');
            indicator.className = 'password-strength';
            indicator.innerHTML = `
                <div class="password-strength-bar"></div>
                <span class="password-strength-text"></span>
            `;
            field.parentElement.appendChild(indicator);
        }

        const bar = indicator.querySelector('.password-strength-bar');
        const text = indicator.querySelector('.password-strength-text');

        bar.className = 'password-strength-bar ' + strengthClass;
        text.textContent = password ? strengthText : '';
    },

    /**
     * Format credit card number with spaces
     */
    formatCreditCard: function(input) {
        let value = input.value.replace(/\s/g, '');
        let formatted = value.match(/.{1,4}/g);
        input.value = formatted ? formatted.join(' ') : value;
    },

    /**
     * Format phone number
     */
    formatPhoneNumber: function(input) {
        let value = input.value.replace(/\D/g, '');
        if (value.length >= 10) {
            input.value = value.replace(/(\d{3})(\d{3})(\d{4})/, '($1) $2-$3');
        }
    },

    /**
     * Sanitize input (prevent XSS)
     */
    sanitize: function(input) {
        const div = document.createElement('div');
        div.textContent = input;
        return div.innerHTML;
    },

    /**
     * Custom validators can be added here
     */
    customValidators: {
        // Example: Validate room number format
        roomNumber: function(value) {
            const pattern = /^\d{3}$/;
            if (!pattern.test(value)) {
                return 'Room number must be 3 digits';
            }
            return true;
        },

        // Example: Validate promo code
        promoCode: function(value) {
            const pattern = /^[A-Z0-9]{6,10}$/;
            if (!pattern.test(value)) {
                return 'Promo code must be 6-10 uppercase letters or numbers';
            }
            return true;
        },

        // Example: Validate age
        age: function(value) {
            const age = parseInt(value);
            if (age < 18 || age > 120) {
                return 'Age must be between 18 and 120';
            }
            return true;
        }
    }
};

// Auto-initialize on DOM ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => Validation.init());
} else {
    Validation.init();
}

// Export for use in other modules
window.Validation = Validation;
