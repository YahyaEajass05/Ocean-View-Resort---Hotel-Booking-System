/**
 * Ocean View Resort - Charts Module
 * Handles all chart creation and updates using Chart.js
 */

const Charts = {
    // Chart instances storage
    instances: {},

    // Default configuration
    defaults: {
        colors: {
            primary: '#006994',
            success: '#28A745',
            warning: '#FFC107',
            danger: '#DC3545',
            info: '#17A2B8',
            secondary: '#6C757D',
            gold: '#D4AF37'
        },
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: {
                display: true,
                position: 'bottom'
            }
        }
    },

    /**
     * Initialize all charts on page
     */
    init: function() {
        this.createRevenueChart();
        this.createOccupancyChart();
        this.createBookingsChart();
        this.createRoomTypeChart();
        this.createGuestDemographicsChart();
    },

    /**
     * Create revenue line chart
     */
    createRevenueChart: function() {
        const canvas = document.getElementById('revenueChart');
        if (!canvas) return;

        const ctx = canvas.getContext('2d');
        
        this.instances.revenueChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: this.getLast7Days(),
                datasets: [{
                    label: 'Revenue',
                    data: [12000, 19000, 15000, 22000, 28000, 32000, 29000],
                    borderColor: this.defaults.colors.primary,
                    backgroundColor: this.hexToRgba(this.defaults.colors.primary, 0.1),
                    tension: 0.4,
                    fill: true,
                    pointRadius: 4,
                    pointHoverRadius: 6
                }]
            },
            options: {
                ...this.defaults,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return '$' + value.toLocaleString();
                            }
                        }
                    }
                },
                plugins: {
                    ...this.defaults.plugins,
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return 'Revenue: $' + context.parsed.y.toLocaleString();
                            }
                        }
                    }
                }
            }
        });
    },

    /**
     * Create occupancy rate chart
     */
    createOccupancyChart: function() {
        const canvas = document.getElementById('occupancyChart');
        if (!canvas) return;

        const ctx = canvas.getContext('2d');
        
        this.instances.occupancyChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: this.getLast7Days(),
                datasets: [{
                    label: 'Occupancy Rate (%)',
                    data: [75, 82, 68, 91, 85, 78, 88],
                    backgroundColor: this.defaults.colors.success,
                    borderRadius: 8
                }]
            },
            options: {
                ...this.defaults,
                scales: {
                    y: {
                        beginAtZero: true,
                        max: 100,
                        ticks: {
                            callback: function(value) {
                                return value + '%';
                            }
                        }
                    }
                },
                plugins: {
                    ...this.defaults.plugins,
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return 'Occupancy: ' + context.parsed.y + '%';
                            }
                        }
                    }
                }
            }
        });
    },

    /**
     * Create bookings status chart
     */
    createBookingsChart: function() {
        const canvas = document.getElementById('bookingsChart');
        if (!canvas) return;

        const ctx = canvas.getContext('2d');
        
        this.instances.bookingsChart = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Confirmed', 'Pending', 'Checked In', 'Cancelled'],
                datasets: [{
                    data: [45, 15, 25, 15],
                    backgroundColor: [
                        this.defaults.colors.success,
                        this.defaults.colors.warning,
                        this.defaults.colors.info,
                        this.defaults.colors.danger
                    ],
                    borderWidth: 2,
                    borderColor: '#fff'
                }]
            },
            options: {
                ...this.defaults,
                plugins: {
                    ...this.defaults.plugins,
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });
    },

    /**
     * Create room type distribution chart
     */
    createRoomTypeChart: function() {
        const canvas = document.getElementById('roomTypeChart');
        if (!canvas) return;

        const ctx = canvas.getContext('2d');
        
        this.instances.roomTypeChart = new Chart(ctx, {
            type: 'pie',
            data: {
                labels: ['Standard', 'Deluxe', 'Suite', 'Presidential'],
                datasets: [{
                    data: [25, 35, 30, 10],
                    backgroundColor: [
                        this.defaults.colors.secondary,
                        this.defaults.colors.primary,
                        this.defaults.colors.info,
                        this.defaults.colors.gold
                    ],
                    borderWidth: 2,
                    borderColor: '#fff'
                }]
            },
            options: {
                ...this.defaults,
                plugins: {
                    ...this.defaults.plugins,
                    legend: {
                        position: 'right'
                    }
                }
            }
        });
    },

    /**
     * Create guest demographics chart
     */
    createGuestDemographicsChart: function() {
        const canvas = document.getElementById('demographicsChart');
        if (!canvas) return;

        const ctx = canvas.getContext('2d');
        
        this.instances.demographicsChart = new Chart(ctx, {
            type: 'polarArea',
            data: {
                labels: ['Couples', 'Families', 'Business', 'Groups', 'Solo'],
                datasets: [{
                    data: [35, 28, 18, 12, 7],
                    backgroundColor: [
                        this.hexToRgba(this.defaults.colors.primary, 0.7),
                        this.hexToRgba(this.defaults.colors.success, 0.7),
                        this.hexToRgba(this.defaults.colors.warning, 0.7),
                        this.hexToRgba(this.defaults.colors.info, 0.7),
                        this.hexToRgba(this.defaults.colors.secondary, 0.7)
                    ]
                }]
            },
            options: {
                ...this.defaults
            }
        });
    },

    /**
     * Update chart data
     */
    updateChart: function(chartId, newData) {
        const chart = this.instances[chartId];
        if (!chart) return;

        if (newData.labels) {
            chart.data.labels = newData.labels;
        }

        if (newData.datasets) {
            chart.data.datasets = newData.datasets;
        }

        chart.update();
    },

    /**
     * Destroy chart
     */
    destroyChart: function(chartId) {
        const chart = this.instances[chartId];
        if (chart) {
            chart.destroy();
            delete this.instances[chartId];
        }
    },

    /**
     * Destroy all charts
     */
    destroyAll: function() {
        Object.keys(this.instances).forEach(chartId => {
            this.destroyChart(chartId);
        });
    },

    /**
     * Get last 7 days labels
     */
    getLast7Days: function() {
        const days = [];
        const today = new Date();
        
        for (let i = 6; i >= 0; i--) {
            const date = new Date(today);
            date.setDate(date.getDate() - i);
            days.push(date.toLocaleDateString('en-US', { weekday: 'short' }));
        }
        
        return days;
    },

    /**
     * Convert hex color to rgba
     */
    hexToRgba: function(hex, alpha) {
        const r = parseInt(hex.slice(1, 3), 16);
        const g = parseInt(hex.slice(3, 5), 16);
        const b = parseInt(hex.slice(5, 7), 16);
        return `rgba(${r}, ${g}, ${b}, ${alpha})`;
    },

    /**
     * Export chart as image
     */
    exportChart: function(chartId) {
        const chart = this.instances[chartId];
        if (!chart) return;

        const url = chart.toBase64Image();
        const link = document.createElement('a');
        link.download = `${chartId}.png`;
        link.href = url;
        link.click();
    }
};

// Auto-initialize if Chart.js is loaded
if (typeof Chart !== 'undefined') {
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => Charts.init());
    } else {
        Charts.init();
    }
}

// Export
window.Charts = Charts;
