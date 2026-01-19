/**
 * Ocean View Resort - Dashboard Module
 * Handles dashboard data loading, updates, and interactions
 */

const Dashboard = {
    // Configuration
    config: {
        refreshInterval: 30000, // 30 seconds
        animationDuration: 500,
        chartColors: {
            primary: '#006994',
            success: '#28A745',
            warning: '#FFC107',
            danger: '#DC3545',
            info: '#17A2B8'
        }
    },

    // State management
    state: {
        data: null,
        lastUpdate: null,
        autoRefresh: false,
        refreshTimer: null
    },

    /**
     * Initialize dashboard
     */
    init: function(options = {}) {
        this.config = { ...this.config, ...options };
        this.loadDashboardData();
        this.setupEventListeners();
        this.startAutoRefresh();
    },

    /**
     * Load dashboard data from server
     */
    loadDashboardData: async function() {
        try {
            const response = await fetch('/api/dashboard/data', {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json'
                }
            });

            if (!response.ok) {
                throw new Error('Failed to load dashboard data');
            }

            const data = await response.json();
            this.state.data = data;
            this.state.lastUpdate = new Date();
            
            this.updateDashboard(data);
            this.updateLastRefreshTime();
        } catch (error) {
            console.error('Error loading dashboard:', error);
            this.showError('Failed to load dashboard data');
        }
    },

    /**
     * Update dashboard with new data
     */
    updateDashboard: function(data) {
        this.updateStatCards(data.stats);
        this.updateCharts(data.charts);
        this.updateTables(data.tables);
        this.updateNotifications(data.notifications);
    },

    /**
     * Update stat cards with animation
     */
    updateStatCards: function(stats) {
        if (!stats) return;

        Object.keys(stats).forEach(key => {
            const element = document.getElementById(key);
            if (element) {
                const currentValue = parseInt(element.textContent) || 0;
                const newValue = stats[key];
                this.animateValue(element, currentValue, newValue, this.config.animationDuration);
            }
        });
    },

    /**
     * Animate number change
     */
    animateValue: function(element, start, end, duration) {
        const range = end - start;
        const increment = range / (duration / 16);
        let current = start;

        const timer = setInterval(() => {
            current += increment;
            if ((increment > 0 && current >= end) || (increment < 0 && current <= end)) {
                element.textContent = this.formatNumber(end);
                clearInterval(timer);
            } else {
                element.textContent = this.formatNumber(Math.round(current));
            }
        }, 16);
    },

    /**
     * Format number with commas
     */
    formatNumber: function(num) {
        return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    },

    /**
     * Update charts
     */
    updateCharts: function(chartData) {
        if (!chartData) return;

        // Update existing charts
        if (window.dashboardCharts) {
            Object.keys(chartData).forEach(chartId => {
                const chart = window.dashboardCharts[chartId];
                if (chart && chartData[chartId]) {
                    chart.data = chartData[chartId];
                    chart.update('none'); // Update without animation
                }
            });
        }
    },

    /**
     * Update tables
     */
    updateTables: function(tableData) {
        if (!tableData) return;

        Object.keys(tableData).forEach(tableId => {
            const tbody = document.querySelector(`#${tableId} tbody`);
            if (tbody && tableData[tableId]) {
                tbody.innerHTML = this.generateTableRows(tableData[tableId]);
            }
        });
    },

    /**
     * Generate table rows
     */
    generateTableRows: function(data) {
        return data.map(row => {
            const cells = Object.values(row).map(value => `<td>${value}</td>`).join('');
            return `<tr>${cells}</tr>`;
        }).join('');
    },

    /**
     * Update notifications
     */
    updateNotifications: function(notifications) {
        if (!notifications || notifications.length === 0) return;

        const container = document.getElementById('notificationsContainer');
        if (!container) return;

        notifications.forEach(notification => {
            this.showNotification(notification);
        });
    },

    /**
     * Show notification
     */
    showNotification: function(notification) {
        const type = notification.type || 'info';
        const message = notification.message;
        
        if (window.OceanViewResort && window.OceanViewResort.showToast) {
            window.OceanViewResort.showToast(message, type);
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
     * Setup event listeners
     */
    setupEventListeners: function() {
        // Refresh button
        const refreshBtn = document.getElementById('refreshDashboard');
        if (refreshBtn) {
            refreshBtn.addEventListener('click', () => {
                this.loadDashboardData();
                this.showNotification({ message: 'Dashboard refreshed', type: 'success' });
            });
        }

        // Auto-refresh toggle
        const autoRefreshToggle = document.getElementById('autoRefreshToggle');
        if (autoRefreshToggle) {
            autoRefreshToggle.addEventListener('change', (e) => {
                this.state.autoRefresh = e.target.checked;
                if (this.state.autoRefresh) {
                    this.startAutoRefresh();
                } else {
                    this.stopAutoRefresh();
                }
            });
        }

        // Export buttons
        document.querySelectorAll('[data-export]').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const type = e.target.dataset.export;
                this.exportData(type);
            });
        });

        // Date range filters
        const dateRangeInputs = document.querySelectorAll('[data-date-filter]');
        dateRangeInputs.forEach(input => {
            input.addEventListener('change', () => {
                this.applyFilters();
            });
        });
    },

    /**
     * Start auto-refresh
     */
    startAutoRefresh: function() {
        if (this.state.refreshTimer) {
            clearInterval(this.state.refreshTimer);
        }

        this.state.refreshTimer = setInterval(() => {
            this.loadDashboardData();
        }, this.config.refreshInterval);
    },

    /**
     * Stop auto-refresh
     */
    stopAutoRefresh: function() {
        if (this.state.refreshTimer) {
            clearInterval(this.state.refreshTimer);
            this.state.refreshTimer = null;
        }
    },

    /**
     * Update last refresh time display
     */
    updateLastRefreshTime: function() {
        const element = document.getElementById('lastRefreshTime');
        if (element && this.state.lastUpdate) {
            element.textContent = this.formatTime(this.state.lastUpdate);
        }
    },

    /**
     * Format time
     */
    formatTime: function(date) {
        return date.toLocaleTimeString('en-US', {
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit'
        });
    },

    /**
     * Apply filters
     */
    applyFilters: function() {
        const filters = {};
        
        document.querySelectorAll('[data-date-filter]').forEach(input => {
            if (input.value) {
                filters[input.name] = input.value;
            }
        });

        // Reload with filters
        this.loadDashboardData(filters);
    },

    /**
     * Export data
     */
    exportData: function(type) {
        if (!this.state.data) {
            this.showError('No data to export');
            return;
        }

        switch(type) {
            case 'csv':
                this.exportToCSV();
                break;
            case 'excel':
                this.exportToExcel();
                break;
            case 'pdf':
                this.exportToPDF();
                break;
            default:
                console.warn('Unknown export type:', type);
        }
    },

    /**
     * Export to CSV
     */
    exportToCSV: function() {
        // Implementation for CSV export
        console.log('Exporting to CSV...');
        this.showNotification({ message: 'Exporting to CSV...', type: 'info' });
    },

    /**
     * Export to Excel
     */
    exportToExcel: function() {
        // Implementation for Excel export
        console.log('Exporting to Excel...');
        this.showNotification({ message: 'Exporting to Excel...', type: 'info' });
    },

    /**
     * Export to PDF
     */
    exportToPDF: function() {
        // Implementation for PDF export
        console.log('Exporting to PDF...');
        this.showNotification({ message: 'Exporting to PDF...', type: 'info' });
    },

    /**
     * Get dashboard statistics
     */
    getStats: function() {
        return this.state.data ? this.state.data.stats : null;
    },

    /**
     * Destroy dashboard (cleanup)
     */
    destroy: function() {
        this.stopAutoRefresh();
        this.state = {
            data: null,
            lastUpdate: null,
            autoRefresh: false,
            refreshTimer: null
        };
    }
};

// Export
window.Dashboard = Dashboard;
