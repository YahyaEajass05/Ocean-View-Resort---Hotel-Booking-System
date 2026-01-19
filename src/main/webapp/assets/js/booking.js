/**
 * Ocean View Resort - Booking Module
 * Handles room booking, date selection, pricing calculation
 */

const Booking = {
    // Configuration
    config: {
        minNights: 1,
        maxNights: 30,
        taxRate: 0.10, // 10% tax
        serviceFee: 25,
        advanceBookingDays: 365,
        blockedDates: [],
        seasonalPricing: {}
    },

    // State
    state: {
        selectedRoom: null,
        checkInDate: null,
        checkOutDate: null,
        guests: 2,
        specialRequests: '',
        totalPrice: 0,
        basePrice: 0,
        taxes: 0,
        discounts: 0,
        promoCode: null
    },

    /**
     * Initialize booking system
     */
    init: function(options = {}) {
        this.config = { ...this.config, ...options };
        this.setupDatePickers();
        this.setupEventListeners();
        this.loadAvailableRooms();
    },

    /**
     * Setup date pickers
     */
    setupDatePickers: function() {
        const checkInInput = document.getElementById('checkIn');
        const checkOutInput = document.getElementById('checkOut');

        if (checkInInput) {
            const today = new Date();
            const maxDate = new Date();
            maxDate.setDate(today.getDate() + this.config.advanceBookingDays);

            checkInInput.min = this.formatDate(today);
            checkInInput.max = this.formatDate(maxDate);

            checkInInput.addEventListener('change', () => {
                this.handleCheckInChange(checkInInput.value);
            });
        }

        if (checkOutInput) {
            checkOutInput.addEventListener('change', () => {
                this.handleCheckOutChange(checkOutInput.value);
            });
        }
    },

    /**
     * Handle check-in date change
     */
    handleCheckInChange: function(date) {
        this.state.checkInDate = date;
        
        const checkOutInput = document.getElementById('checkOut');
        if (checkOutInput) {
            const minCheckOut = new Date(date);
            minCheckOut.setDate(minCheckOut.getDate() + this.config.minNights);
            checkOutInput.min = this.formatDate(minCheckOut);

            // Clear checkout if it's before new minimum
            if (checkOutInput.value && new Date(checkOutInput.value) < minCheckOut) {
                checkOutInput.value = '';
                this.state.checkOutDate = null;
            }
        }

        this.updateAvailability();
        this.calculatePrice();
    },

    /**
     * Handle check-out date change
     */
    handleCheckOutChange: function(date) {
        this.state.checkOutDate = date;
        
        if (this.state.checkInDate && this.state.checkOutDate) {
            const nights = this.calculateNights(this.state.checkInDate, this.state.checkOutDate);
            
            if (nights < this.config.minNights) {
                this.showError(`Minimum stay is ${this.config.minNights} night(s)`);
                document.getElementById('checkOut').value = '';
                this.state.checkOutDate = null;
                return;
            }

            if (nights > this.config.maxNights) {
                this.showError(`Maximum stay is ${this.config.maxNights} nights`);
                document.getElementById('checkOut').value = '';
                this.state.checkOutDate = null;
                return;
            }

            this.updateAvailability();
            this.calculatePrice();
        }
    },

    /**
     * Setup event listeners
     */
    setupEventListeners: function() {
        // Guest count
        const guestsSelect = document.getElementById('guests');
        if (guestsSelect) {
            guestsSelect.addEventListener('change', (e) => {
                this.state.guests = parseInt(e.target.value);
                this.filterRoomsByCapacity();
            });
        }

        // Room selection
        document.addEventListener('click', (e) => {
            if (e.target.matches('[data-room-id]')) {
                const roomId = e.target.dataset.roomId;
                this.selectRoom(roomId);
            }
        });

        // Promo code
        const promoInput = document.getElementById('promoCode');
        const promoBtn = document.getElementById('applyPromo');
        
        if (promoBtn) {
            promoBtn.addEventListener('click', () => {
                if (promoInput) {
                    this.applyPromoCode(promoInput.value);
                }
            });
        }

        // Special requests
        const requestsTextarea = document.getElementById('specialRequests');
        if (requestsTextarea) {
            requestsTextarea.addEventListener('input', (e) => {
                this.state.specialRequests = e.target.value;
            });
        }

        // Booking confirmation
        const confirmBtn = document.getElementById('confirmBooking');
        if (confirmBtn) {
            confirmBtn.addEventListener('click', () => {
                this.confirmBooking();
            });
        }
    },

    /**
     * Load available rooms
     */
    loadAvailableRooms: async function() {
        try {
            const params = new URLSearchParams();
            if (this.state.checkInDate) params.append('checkIn', this.state.checkInDate);
            if (this.state.checkOutDate) params.append('checkOut', this.state.checkOutDate);
            params.append('guests', this.state.guests);

            const response = await fetch(`/api/rooms/available?${params.toString()}`);
            
            if (!response.ok) {
                throw new Error('Failed to load rooms');
            }

            const rooms = await response.json();
            this.displayRooms(rooms);
        } catch (error) {
            console.error('Error loading rooms:', error);
            this.showError('Failed to load available rooms');
        }
    },

    /**
     * Display rooms
     */
    displayRooms: function(rooms) {
        const container = document.getElementById('roomsContainer');
        if (!container) return;

        if (rooms.length === 0) {
            container.innerHTML = `
                <div class="empty-state">
                    <i class="fas fa-bed"></i>
                    <h3>No rooms available</h3>
                    <p>Please try different dates or modify your search criteria.</p>
                </div>
            `;
            return;
        }

        container.innerHTML = rooms.map(room => this.createRoomCard(room)).join('');
    },

    /**
     * Create room card HTML
     */
    createRoomCard: function(room) {
        return `
            <div class="room-card" data-room-id="${room.id}">
                <div class="room-image">
                    <img src="/assets/images/rooms/${room.type.toLowerCase()}.jpg" alt="${room.type}">
                    ${room.featured ? '<span class="badge featured">Featured</span>' : ''}
                </div>
                <div class="room-details">
                    <h3>${room.name}</h3>
                    <p class="room-type">${room.type}</p>
                    <div class="room-features">
                        <span><i class="fas fa-users"></i> ${room.capacity} guests</span>
                        <span><i class="fas fa-bed"></i> ${room.bedType}</span>
                        <span><i class="fas fa-ruler-combined"></i> ${room.size} m²</span>
                    </div>
                    <div class="room-amenities">
                        ${room.amenities.map(a => `<span class="amenity"><i class="fas fa-check"></i> ${a}</span>`).join('')}
                    </div>
                    <div class="room-pricing">
                        <div class="price">
                            <span class="amount">$${room.price}</span>
                            <span class="period">/ night</span>
                        </div>
                        <button class="btn btn-primary" data-room-id="${room.id}" onclick="Booking.selectRoom(${room.id})">
                            Select Room
                        </button>
                    </div>
                </div>
            </div>
        `;
    },

    /**
     * Select room
     */
    selectRoom: function(roomId) {
        this.state.selectedRoom = roomId;
        
        // Highlight selected room
        document.querySelectorAll('.room-card').forEach(card => {
            card.classList.remove('selected');
        });
        
        const selectedCard = document.querySelector(`[data-room-id="${roomId}"]`);
        if (selectedCard) {
            selectedCard.classList.add('selected');
        }

        this.calculatePrice();
        this.showBookingSummary();
    },

    /**
     * Calculate total price
     */
    calculatePrice: function() {
        if (!this.state.checkInDate || !this.state.checkOutDate || !this.state.selectedRoom) {
            return;
        }

        const nights = this.calculateNights(this.state.checkInDate, this.state.checkOutDate);
        const room = this.getRoomById(this.state.selectedRoom);
        
        if (!room) return;

        // Base price
        this.state.basePrice = room.price * nights;

        // Apply seasonal pricing
        const seasonalMultiplier = this.getSeasonalMultiplier(this.state.checkInDate);
        this.state.basePrice *= seasonalMultiplier;

        // Calculate taxes
        this.state.taxes = this.state.basePrice * this.config.taxRate;

        // Add service fee
        const serviceFee = this.config.serviceFee;

        // Apply discounts
        this.applyDiscounts();

        // Calculate total
        this.state.totalPrice = this.state.basePrice + this.state.taxes + serviceFee - this.state.discounts;

        this.updatePriceSummary();
    },

    /**
     * Calculate number of nights
     */
    calculateNights: function(checkIn, checkOut) {
        const start = new Date(checkIn);
        const end = new Date(checkOut);
        const diffTime = Math.abs(end - start);
        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
        return diffDays;
    },

    /**
     * Get seasonal pricing multiplier
     */
    getSeasonalMultiplier: function(date) {
        const month = new Date(date).getMonth();
        
        // Peak season (June, July, August, December)
        if ([5, 6, 7, 11].includes(month)) {
            return 1.3;
        }
        
        // High season (March, April, May)
        if ([2, 3, 4].includes(month)) {
            return 1.15;
        }
        
        // Low season
        return 1.0;
    },

    /**
     * Apply discounts
     */
    applyDiscounts: function() {
        this.state.discounts = 0;

        // Early bird discount (30+ days in advance)
        const daysInAdvance = this.calculateDaysInAdvance(this.state.checkInDate);
        if (daysInAdvance >= 30) {
            this.state.discounts += this.state.basePrice * 0.1; // 10% off
        }

        // Extended stay discount (7+ nights)
        const nights = this.calculateNights(this.state.checkInDate, this.state.checkOutDate);
        if (nights >= 7) {
            this.state.discounts += this.state.basePrice * 0.05; // 5% off
        }

        // Promo code discount
        if (this.state.promoCode && this.state.promoCode.discount) {
            const promoDiscount = this.state.promoCode.type === 'PERCENTAGE'
                ? this.state.basePrice * (this.state.promoCode.value / 100)
                : this.state.promoCode.value;
            this.state.discounts += promoDiscount;
        }
    },

    /**
     * Calculate days in advance
     */
    calculateDaysInAdvance: function(checkIn) {
        const today = new Date();
        const checkInDate = new Date(checkIn);
        const diffTime = checkInDate - today;
        return Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    },

    /**
     * Update price summary display
     */
    updatePriceSummary: function() {
        const elements = {
            basePrice: document.getElementById('basePrice'),
            taxes: document.getElementById('taxes'),
            serviceFee: document.getElementById('serviceFee'),
            discounts: document.getElementById('discounts'),
            totalPrice: document.getElementById('totalPrice')
        };

        if (elements.basePrice) elements.basePrice.textContent = `$${this.state.basePrice.toFixed(2)}`;
        if (elements.taxes) elements.taxes.textContent = `$${this.state.taxes.toFixed(2)}`;
        if (elements.serviceFee) elements.serviceFee.textContent = `$${this.config.serviceFee.toFixed(2)}`;
        if (elements.discounts) elements.discounts.textContent = `-$${this.state.discounts.toFixed(2)}`;
        if (elements.totalPrice) elements.totalPrice.textContent = `$${this.state.totalPrice.toFixed(2)}`;
    },

    /**
     * Apply promo code
     */
    applyPromoCode: async function(code) {
        if (!code) {
            this.showError('Please enter a promo code');
            return;
        }

        try {
            const response = await fetch('/api/promo/validate', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ code: code })
            });

            if (!response.ok) {
                throw new Error('Invalid promo code');
            }

            const promo = await response.json();
            this.state.promoCode = promo;
            this.calculatePrice();
            this.showSuccess(`Promo code applied! You saved $${this.state.discounts.toFixed(2)}`);
        } catch (error) {
            this.showError('Invalid or expired promo code');
        }
    },

    /**
     * Show booking summary
     */
    showBookingSummary: function() {
        const modal = document.getElementById('bookingSummaryModal');
        if (modal) {
            modal.classList.add('active');
        }
    },

    /**
     * Confirm booking
     */
    confirmBooking: async function() {
        // Validate booking
        if (!this.validateBooking()) {
            return;
        }

        const bookingData = {
            roomId: this.state.selectedRoom,
            checkInDate: this.state.checkInDate,
            checkOutDate: this.state.checkOutDate,
            guests: this.state.guests,
            specialRequests: this.state.specialRequests,
            promoCode: this.state.promoCode ? this.state.promoCode.code : null,
            totalAmount: this.state.totalPrice
        };

        try {
            const response = await fetch('/api/bookings', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(bookingData)
            });

            if (!response.ok) {
                throw new Error('Booking failed');
            }

            const result = await response.json();
            this.showSuccess('Booking confirmed! Redirecting to confirmation page...');
            
            setTimeout(() => {
                window.location.href = `/bookings/${result.bookingId}/confirmation`;
            }, 2000);
        } catch (error) {
            console.error('Booking error:', error);
            this.showError('Failed to complete booking. Please try again.');
        }
    },

    /**
     * Validate booking
     */
    validateBooking: function() {
        if (!this.state.checkInDate) {
            this.showError('Please select check-in date');
            return false;
        }

        if (!this.state.checkOutDate) {
            this.showError('Please select check-out date');
            return false;
        }

        if (!this.state.selectedRoom) {
            this.showError('Please select a room');
            return false;
        }

        if (!this.state.guests || this.state.guests < 1) {
            this.showError('Please select number of guests');
            return false;
        }

        return true;
    },

    /**
     * Update room availability
     */
    updateAvailability: function() {
        if (this.state.checkInDate && this.state.checkOutDate) {
            this.loadAvailableRooms();
        }
    },

    /**
     * Filter rooms by capacity
     */
    filterRoomsByCapacity: function() {
        const rooms = document.querySelectorAll('.room-card');
        rooms.forEach(card => {
            const capacity = parseInt(card.dataset.capacity);
            if (capacity >= this.state.guests) {
                card.style.display = 'block';
            } else {
                card.style.display = 'none';
            }
        });
    },

    /**
     * Get room by ID (mock function - replace with actual API call)
     */
    getRoomById: function(roomId) {
        // This should fetch from your data source
        return {
            id: roomId,
            price: 150,
            type: 'DELUXE',
            capacity: 2
        };
    },

    /**
     * Format date
     */
    formatDate: function(date) {
        const d = new Date(date);
        const year = d.getFullYear();
        const month = String(d.getMonth() + 1).padStart(2, '0');
        const day = String(d.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
    },

    /**
     * Show success message
     */
    showSuccess: function(message) {
        if (window.OceanViewResort && window.OceanViewResort.showToast) {
            window.OceanViewResort.showToast(message, 'success');
        }
    },

    /**
     * Show error message
     */
    showError: function(message) {
        if (window.OceanViewResort && window.OceanViewResort.showToast) {
            window.OceanViewResort.showToast(message, 'error');
        }
    },

    /**
     * Reset booking state
     */
    reset: function() {
        this.state = {
            selectedRoom: null,
            checkInDate: null,
            checkOutDate: null,
            guests: 2,
            specialRequests: '',
            totalPrice: 0,
            basePrice: 0,
            taxes: 0,
            discounts: 0,
            promoCode: null
        };
    }
};

// Export
window.Booking = Booking;
