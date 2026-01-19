/**
 * Ocean View Resort - Modal Library
 * Advanced modal/dialog system
 */

const Modal = {
    modals: {},
    activeModal: null,
    
    config: {
        closeOnEscape: true,
        closeOnOverlay: true,
        animation: 'fade', // fade, slide, zoom
        backdrop: true
    },

    /**
     * Initialize modal system
     */
    init: function(options = {}) {
        this.config = { ...this.config, ...options };
        this.setupEventListeners();
        this.registerModals();
    },

    /**
     * Register all modals in DOM
     */
    registerModals: function() {
        document.querySelectorAll('[data-modal]').forEach(trigger => {
            const modalId = trigger.dataset.modal;
            trigger.addEventListener('click', (e) => {
                e.preventDefault();
                this.open(modalId);
            });
        });
    },

    /**
     * Create modal programmatically
     */
    create: function(options) {
        const id = options.id || 'modal-' + Date.now();
        
        const modalHTML = `
            <div class="modal-overlay" id="${id}" style="display: none;">
                <div class="modal modal-${options.size || 'medium'}" role="dialog" aria-modal="true">
                    ${options.header !== false ? `
                        <div class="modal-header">
                            <h2 class="modal-title">${options.title || ''}</h2>
                            ${options.closeButton !== false ? '<button class="modal-close" aria-label="Close">&times;</button>' : ''}
                        </div>
                    ` : ''}
                    <div class="modal-body">
                        ${options.content || ''}
                    </div>
                    ${options.footer ? `
                        <div class="modal-footer">
                            ${options.footer}
                        </div>
                    ` : ''}
                </div>
            </div>
        `;
        
        const container = document.createElement('div');
        container.innerHTML = modalHTML;
        const modalElement = container.firstElementChild;
        document.body.appendChild(modalElement);
        
        this.modals[id] = {
            element: modalElement,
            options: options
        };
        
        this.setupModalEvents(id);
        return id;
    },

    /**
     * Setup modal event listeners
     */
    setupModalEvents: function(id) {
        const modal = this.modals[id];
        if (!modal) return;
        
        const overlay = modal.element;
        const closeBtn = overlay.querySelector('.modal-close');
        
        // Close button
        if (closeBtn) {
            closeBtn.addEventListener('click', () => this.close(id));
        }
        
        // Click on overlay
        if (this.config.closeOnOverlay) {
            overlay.addEventListener('click', (e) => {
                if (e.target === overlay) {
                    this.close(id);
                }
            });
        }
        
        // Custom buttons
        overlay.querySelectorAll('[data-modal-action]').forEach(btn => {
            btn.addEventListener('click', () => {
                const action = btn.dataset.modalAction;
                if (action === 'close') {
                    this.close(id);
                } else if (modal.options.onAction) {
                    modal.options.onAction(action, this);
                }
            });
        });
    },

    /**
     * Setup global event listeners
     */
    setupEventListeners: function() {
        // Escape key
        if (this.config.closeOnEscape) {
            document.addEventListener('keydown', (e) => {
                if (e.key === 'Escape' && this.activeModal) {
                    this.close(this.activeModal);
                }
            });
        }
    },

    /**
     * Open modal
     */
    open: function(id) {
        let modal = this.modals[id];
        
        // If modal doesn't exist, try to find it in DOM
        if (!modal) {
            const element = document.getElementById(id);
            if (element && element.classList.contains('modal-overlay')) {
                this.modals[id] = { element: element, options: {} };
                this.setupModalEvents(id);
                modal = this.modals[id];
            } else {
                console.error('Modal not found:', id);
                return;
            }
        }
        
        // Close active modal if exists
        if (this.activeModal && this.activeModal !== id) {
            this.close(this.activeModal);
        }
        
        this.activeModal = id;
        modal.element.style.display = 'flex';
        document.body.style.overflow = 'hidden';
        
        // Animation
        setTimeout(() => {
            modal.element.classList.add('modal-active');
        }, 10);
        
        // Callback
        if (modal.options.onOpen) {
            modal.options.onOpen(this);
        }
        
        // Focus trap
        this.trapFocus(modal.element);
    },

    /**
     * Close modal
     */
    close: function(id) {
        const modal = this.modals[id];
        if (!modal) return;
        
        modal.element.classList.remove('modal-active');
        
        setTimeout(() => {
            modal.element.style.display = 'none';
            document.body.style.overflow = '';
            
            if (this.activeModal === id) {
                this.activeModal = null;
            }
            
            // Callback
            if (modal.options.onClose) {
                modal.options.onClose(this);
            }
        }, 300);
    },

    /**
     * Destroy modal
     */
    destroy: function(id) {
        const modal = this.modals[id];
        if (!modal) return;
        
        this.close(id);
        
        setTimeout(() => {
            if (modal.element.parentNode) {
                modal.element.parentNode.removeChild(modal.element);
            }
            delete this.modals[id];
        }, 350);
    },

    /**
     * Update modal content
     */
    updateContent: function(id, content) {
        const modal = this.modals[id];
        if (!modal) return;
        
        const body = modal.element.querySelector('.modal-body');
        if (body) {
            body.innerHTML = content;
        }
    },

    /**
     * Update modal title
     */
    updateTitle: function(id, title) {
        const modal = this.modals[id];
        if (!modal) return;
        
        const titleElement = modal.element.querySelector('.modal-title');
        if (titleElement) {
            titleElement.textContent = title;
        }
    },

    /**
     * Trap focus within modal
     */
    trapFocus: function(element) {
        const focusableElements = element.querySelectorAll(
            'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
        );
        
        if (focusableElements.length === 0) return;
        
        const firstElement = focusableElements[0];
        const lastElement = focusableElements[focusableElements.length - 1];
        
        element.addEventListener('keydown', function(e) {
            if (e.key !== 'Tab') return;
            
            if (e.shiftKey) {
                if (document.activeElement === firstElement) {
                    lastElement.focus();
                    e.preventDefault();
                }
            } else {
                if (document.activeElement === lastElement) {
                    firstElement.focus();
                    e.preventDefault();
                }
            }
        });
        
        firstElement.focus();
    },

    /**
     * Show confirmation dialog
     */
    confirm: function(options) {
        const id = this.create({
            title: options.title || 'Confirm',
            content: options.message || 'Are you sure?',
            footer: `
                <button class="btn btn-secondary" data-modal-action="cancel">
                    ${options.cancelText || 'Cancel'}
                </button>
                <button class="btn btn-primary" data-modal-action="confirm">
                    ${options.confirmText || 'Confirm'}
                </button>
            `,
            size: 'small',
            onAction: (action, modal) => {
                if (action === 'confirm' && options.onConfirm) {
                    options.onConfirm();
                } else if (action === 'cancel' && options.onCancel) {
                    options.onCancel();
                }
                modal.close(id);
            }
        });
        
        this.open(id);
        return id;
    },

    /**
     * Show alert dialog
     */
    alert: function(options) {
        const id = this.create({
            title: options.title || 'Alert',
            content: options.message || '',
            footer: `
                <button class="btn btn-primary" data-modal-action="ok">
                    ${options.okText || 'OK'}
                </button>
            `,
            size: 'small',
            onAction: (action, modal) => {
                if (options.onOk) {
                    options.onOk();
                }
                modal.close(id);
            }
        });
        
        this.open(id);
        return id;
    },

    /**
     * Show prompt dialog
     */
    prompt: function(options) {
        const inputId = 'prompt-input-' + Date.now();
        const id = this.create({
            title: options.title || 'Input',
            content: `
                <p>${options.message || ''}</p>
                <input type="text" id="${inputId}" class="form-control" 
                       placeholder="${options.placeholder || ''}" 
                       value="${options.default || ''}">
            `,
            footer: `
                <button class="btn btn-secondary" data-modal-action="cancel">
                    ${options.cancelText || 'Cancel'}
                </button>
                <button class="btn btn-primary" data-modal-action="submit">
                    ${options.submitText || 'Submit'}
                </button>
            `,
            size: 'small',
            onAction: (action, modal) => {
                if (action === 'submit') {
                    const input = document.getElementById(inputId);
                    if (options.onSubmit) {
                        options.onSubmit(input.value);
                    }
                } else if (action === 'cancel' && options.onCancel) {
                    options.onCancel();
                }
                modal.close(id);
            }
        });
        
        this.open(id);
        
        // Focus input
        setTimeout(() => {
            document.getElementById(inputId).focus();
        }, 100);
        
        return id;
    }
};

// Auto-initialize
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => Modal.init());
} else {
    Modal.init();
}

// Export
window.Modal = Modal;
