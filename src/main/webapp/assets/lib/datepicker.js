/**
 * Ocean View Resort - Custom Date Picker Library
 * Lightweight date picker without external dependencies
 */

(function(window) {
    'use strict';

    const DatePicker = function(element, options) {
        this.element = element;
        this.options = Object.assign({
            format: 'YYYY-MM-DD',
            minDate: null,
            maxDate: null,
            disabledDates: [],
            inline: false,
            startDay: 0, // 0 = Sunday
            monthNames: ['January', 'February', 'March', 'April', 'May', 'June', 
                        'July', 'August', 'September', 'October', 'November', 'December'],
            dayNames: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
            onChange: null,
            onOpen: null,
            onClose: null
        }, options);

        this.currentDate = new Date();
        this.selectedDate = null;
        this.isOpen = false;
        this.calendar = null;

        this.init();
    };

    DatePicker.prototype = {
        init: function() {
            this.element.readOnly = true;
            this.element.classList.add('datepicker-input');
            
            // Create calendar
            this.createCalendar();
            
            // Attach events
            this.attachEvents();
        },

        createCalendar: function() {
            this.calendar = document.createElement('div');
            this.calendar.className = 'datepicker-calendar';
            this.calendar.style.display = 'none';
            
            if (this.options.inline) {
                this.element.parentNode.appendChild(this.calendar);
            } else {
                document.body.appendChild(this.calendar);
            }
            
            this.renderCalendar();
        },

        renderCalendar: function() {
            const year = this.currentDate.getFullYear();
            const month = this.currentDate.getMonth();
            
            let html = `
                <div class="datepicker-header">
                    <button type="button" class="datepicker-prev">&lt;</button>
                    <div class="datepicker-title">
                        ${this.options.monthNames[month]} ${year}
                    </div>
                    <button type="button" class="datepicker-next">&gt;</button>
                </div>
                <div class="datepicker-body">
                    <div class="datepicker-days-header">
                        ${this.getDaysHeader()}
                    </div>
                    <div class="datepicker-days">
                        ${this.getDaysGrid(year, month)}
                    </div>
                </div>
            `;
            
            this.calendar.innerHTML = html;
            this.attachCalendarEvents();
        },

        getDaysHeader: function() {
            let html = '';
            for (let i = 0; i < 7; i++) {
                const dayIndex = (this.options.startDay + i) % 7;
                html += `<div class="datepicker-day-name">${this.options.dayNames[dayIndex]}</div>`;
            }
            return html;
        },

        getDaysGrid: function(year, month) {
            const firstDay = new Date(year, month, 1).getDay();
            const daysInMonth = new Date(year, month + 1, 0).getDate();
            const daysInPrevMonth = new Date(year, month, 0).getDate();
            
            let html = '';
            let dayCount = 1;
            let nextMonthDay = 1;
            
            // Calculate starting position
            const startPos = (firstDay - this.options.startDay + 7) % 7;
            
            // Generate 6 weeks
            for (let i = 0; i < 42; i++) {
                if (i < startPos) {
                    // Previous month days
                    const day = daysInPrevMonth - startPos + i + 1;
                    html += `<div class="datepicker-day other-month">${day}</div>`;
                } else if (dayCount <= daysInMonth) {
                    // Current month days
                    const date = new Date(year, month, dayCount);
                    const classes = ['datepicker-day'];
                    
                    if (this.isToday(date)) classes.push('today');
                    if (this.isSelected(date)) classes.push('selected');
                    if (this.isDisabled(date)) classes.push('disabled');
                    
                    html += `<div class="${classes.join(' ')}" data-date="${this.formatDate(date)}">${dayCount}</div>`;
                    dayCount++;
                } else {
                    // Next month days
                    html += `<div class="datepicker-day other-month">${nextMonthDay}</div>`;
                    nextMonthDay++;
                }
            }
            
            return html;
        },

        attachEvents: function() {
            // Input click
            this.element.addEventListener('click', () => {
                this.open();
            });
            
            // Input focus
            this.element.addEventListener('focus', () => {
                this.open();
            });
            
            // Document click (close calendar)
            document.addEventListener('click', (e) => {
                if (!this.element.contains(e.target) && !this.calendar.contains(e.target)) {
                    this.close();
                }
            });
        },

        attachCalendarEvents: function() {
            // Previous month
            this.calendar.querySelector('.datepicker-prev').addEventListener('click', () => {
                this.currentDate.setMonth(this.currentDate.getMonth() - 1);
                this.renderCalendar();
            });
            
            // Next month
            this.calendar.querySelector('.datepicker-next').addEventListener('click', () => {
                this.currentDate.setMonth(this.currentDate.getMonth() + 1);
                this.renderCalendar();
            });
            
            // Day selection
            this.calendar.querySelectorAll('.datepicker-day:not(.other-month):not(.disabled)').forEach(day => {
                day.addEventListener('click', () => {
                    const dateStr = day.getAttribute('data-date');
                    this.selectDate(new Date(dateStr));
                });
            });
        },

        open: function() {
            if (this.isOpen) return;
            
            this.calendar.style.display = 'block';
            this.isOpen = true;
            
            if (!this.options.inline) {
                this.positionCalendar();
            }
            
            if (this.options.onOpen) {
                this.options.onOpen(this);
            }
        },

        close: function() {
            if (!this.isOpen) return;
            
            this.calendar.style.display = 'none';
            this.isOpen = false;
            
            if (this.options.onClose) {
                this.options.onClose(this);
            }
        },

        positionCalendar: function() {
            const rect = this.element.getBoundingClientRect();
            const calendarHeight = 320;
            const spaceBelow = window.innerHeight - rect.bottom;
            
            this.calendar.style.position = 'fixed';
            this.calendar.style.left = rect.left + 'px';
            
            if (spaceBelow < calendarHeight && rect.top > calendarHeight) {
                // Show above
                this.calendar.style.top = (rect.top - calendarHeight) + 'px';
            } else {
                // Show below
                this.calendar.style.top = rect.bottom + 'px';
            }
        },

        selectDate: function(date) {
            if (this.isDisabled(date)) return;
            
            this.selectedDate = date;
            this.element.value = this.formatDate(date);
            this.renderCalendar();
            this.close();
            
            if (this.options.onChange) {
                this.options.onChange(date, this);
            }
            
            // Trigger input event
            const event = new Event('change', { bubbles: true });
            this.element.dispatchEvent(event);
        },

        isToday: function(date) {
            const today = new Date();
            return date.toDateString() === today.toDateString();
        },

        isSelected: function(date) {
            if (!this.selectedDate) return false;
            return date.toDateString() === this.selectedDate.toDateString();
        },

        isDisabled: function(date) {
            // Check min date
            if (this.options.minDate) {
                const minDate = new Date(this.options.minDate);
                minDate.setHours(0, 0, 0, 0);
                if (date < minDate) return true;
            }
            
            // Check max date
            if (this.options.maxDate) {
                const maxDate = new Date(this.options.maxDate);
                maxDate.setHours(23, 59, 59, 999);
                if (date > maxDate) return true;
            }
            
            // Check disabled dates
            if (this.options.disabledDates.length > 0) {
                const dateStr = this.formatDate(date);
                if (this.options.disabledDates.includes(dateStr)) return true;
            }
            
            return false;
        },

        formatDate: function(date) {
            const year = date.getFullYear();
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const day = String(date.getDate()).padStart(2, '0');
            
            return this.options.format
                .replace('YYYY', year)
                .replace('MM', month)
                .replace('DD', day);
        },

        setDate: function(date) {
            this.selectDate(new Date(date));
        },

        getDate: function() {
            return this.selectedDate;
        },

        destroy: function() {
            if (this.calendar && this.calendar.parentNode) {
                this.calendar.parentNode.removeChild(this.calendar);
            }
            this.element.classList.remove('datepicker-input');
            this.element.readOnly = false;
        }
    };

    // Export to window
    window.DatePicker = DatePicker;

    // Auto-initialize
    document.addEventListener('DOMContentLoaded', function() {
        document.querySelectorAll('[data-datepicker]').forEach(function(element) {
            new DatePicker(element, {
                minDate: element.getAttribute('min') || null,
                maxDate: element.getAttribute('max') || null
            });
        });
    });

})(window);
