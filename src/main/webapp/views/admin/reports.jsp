<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>

<jsp:include page="../common/header.jsp">
    <jsp:param name="title" value="Reports & Analytics" />
    <jsp:param name="css" value="admin" />
    <jsp:param name="active" value="admin" />
</jsp:include>

<div class="page-header">
    <div class="container">
        <h1>Reports & Analytics</h1>
        <p>Comprehensive business insights and analytics</p>
    </div>
</div>

<div class="admin-page">
    <div class="container">
        <!-- Report Filters -->
        <div class="admin-section mb-4">
            <div class="row">
                <div class="col-3">
                    <div class="form-group">
                        <label class="form-label">Report Type</label>
                        <select id="reportType" class="form-control">
                            <option value="revenue">Revenue Report</option>
                            <option value="occupancy">Occupancy Report</option>
                            <option value="reservations">Reservations Report</option>
                            <option value="guests">Guest Analytics</option>
                        </select>
                    </div>
                </div>
                
                <div class="col-3">
                    <div class="form-group">
                        <label class="form-label">Date Range</label>
                        <select id="dateRange" class="form-control" onchange="updateDateRange()">
                            <option value="today">Today</option>
                            <option value="week">This Week</option>
                            <option value="month" selected>This Month</option>
                            <option value="quarter">This Quarter</option>
                            <option value="year">This Year</option>
                            <option value="custom">Custom Range</option>
                        </select>
                    </div>
                </div>
                
                <div class="col-3" id="customDateFields" style="display:none;">
                    <div class="form-group">
                        <label class="form-label">Start Date</label>
                        <input type="date" id="startDate" class="form-control">
                    </div>
                </div>
                
                <div class="col-3" id="customDateFields2" style="display:none;">
                    <div class="form-group">
                        <label class="form-label">End Date</label>
                        <input type="date" id="endDate" class="form-control">
                    </div>
                </div>
                
                <div class="col-3">
                    <div class="form-group">
                        <label class="form-label">&nbsp;</label>
                        <button class="btn btn-primary w-100" onclick="generateReport()">
                            <i class="fas fa-chart-bar"></i> Generate Report
                        </button>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Key Metrics Overview -->
        <div class="metrics-grid mb-4">
            <div class="metric-card">
                <div class="metric-icon" style="background: linear-gradient(135deg, #28A745, #20c997);">
                    <i class="fas fa-dollar-sign"></i>
                </div>
                <div class="metric-content">
                    <h3 id="totalRevenue">$0</h3>
                    <p>Total Revenue</p>
                    <span class="metric-change positive" id="revenueChange">
                        <i class="fas fa-arrow-up"></i> 0%
                    </span>
                </div>
            </div>
            
            <div class="metric-card">
                <div class="metric-icon" style="background: linear-gradient(135deg, #17A2B8, #138496);">
                    <i class="fas fa-calendar-check"></i>
                </div>
                <div class="metric-content">
                    <h3 id="totalBookings">0</h3>
                    <p>Total Bookings</p>
                    <span class="metric-change positive" id="bookingsChange">
                        <i class="fas fa-arrow-up"></i> 0%
                    </span>
                </div>
            </div>
            
            <div class="metric-card">
                <div class="metric-icon" style="background: linear-gradient(135deg, #FFC107, #FF9800);">
                    <i class="fas fa-percentage"></i>
                </div>
                <div class="metric-content">
                    <h3 id="avgOccupancy">0%</h3>
                    <p>Avg Occupancy Rate</p>
                    <span class="metric-change positive" id="occupancyChange">
                        <i class="fas fa-arrow-up"></i> 0%
                    </span>
                </div>
            </div>
            
            <div class="metric-card">
                <div class="metric-icon" style="background: linear-gradient(135deg, #DC3545, #c82333);">
                    <i class="fas fa-dollar-sign"></i>
                </div>
                <div class="metric-content">
                    <h3 id="avgRevenue">$0</h3>
                    <p>Avg Revenue per Booking</p>
                    <span class="metric-change negative" id="avgRevenueChange">
                        <i class="fas fa-arrow-down"></i> 0%
                    </span>
                </div>
            </div>
        </div>
        
        <!-- Charts Section -->
        <div class="row mb-4">
            <div class="col-8">
                <div class="chart-card">
                    <div class="chart-header">
                        <h3 id="chartTitle">Revenue Trend</h3>
                        <div>
                            <button class="btn btn-sm btn-secondary" onclick="exportChart()">
                                <i class="fas fa-download"></i> Export
                            </button>
                        </div>
                    </div>
                    <div class="chart-body" style="height: 400px;">
                        <canvas id="mainChart"></canvas>
                    </div>
                </div>
            </div>
            
            <div class="col-4">
                <div class="chart-card">
                    <div class="chart-header">
                        <h3>Room Type Distribution</h3>
                    </div>
                    <div class="chart-body" style="height: 400px;">
                        <canvas id="pieChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Detailed Data Table -->
        <div class="admin-section">
            <div class="section-header">
                <h2><i class="fas fa-table"></i> Detailed Report Data</h2>
                <button class="btn btn-success btn-sm" onclick="exportToExcel()">
                    <i class="fas fa-file-excel"></i> Export to Excel
                </button>
            </div>
            
            <div class="table-responsive">
                <table class="table" id="reportTable">
                    <thead id="tableHead">
                        <tr>
                            <th>Date</th>
                            <th>Revenue</th>
                            <th>Bookings</th>
                            <th>Occupancy</th>
                            <th>Avg Rate</th>
                        </tr>
                    </thead>
                    <tbody id="tableBody">
                        <tr>
                            <td colspan="5" class="text-center">
                                <div class="loading-spinner">
                                    <i class="fas fa-spinner fa-spin"></i> Loading data...
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        
        <!-- Quick Report Actions -->
        <div class="admin-section mt-4">
            <div class="section-header">
                <h2><i class="fas fa-download"></i> Quick Reports</h2>
            </div>
            
            <div class="quick-actions-grid">
                <button class="quick-action-card" onclick="downloadReport('daily')">
                    <i class="fas fa-calendar-day"></i>
                    <h4>Daily Report</h4>
                    <p>Download today's report</p>
                </button>
                
                <button class="quick-action-card" onclick="downloadReport('weekly')">
                    <i class="fas fa-calendar-week"></i>
                    <h4>Weekly Report</h4>
                    <p>Download this week's report</p>
                </button>
                
                <button class="quick-action-card" onclick="downloadReport('monthly')">
                    <i class="fas fa-calendar-alt"></i>
                    <h4>Monthly Report</h4>
                    <p>Download this month's report</p>
                </button>
                
                <button class="quick-action-card" onclick="downloadReport('yearly')">
                    <i class="fas fa-calendar"></i>
                    <h4>Annual Report</h4>
                    <p>Download year-end report</p>
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"></script>
<script>
let mainChart, pieChart;

document.addEventListener('DOMContentLoaded', function() {
    initializeCharts();
    generateReport();
});

function updateDateRange() {
    const range = document.getElementById('dateRange').value;
    const customFields = document.getElementById('customDateFields');
    const customFields2 = document.getElementById('customDateFields2');
    
    if (range === 'custom') {
        customFields.style.display = 'block';
        customFields2.style.display = 'block';
    } else {
        customFields.style.display = 'none';
        customFields2.style.display = 'none';
    }
}

function initializeCharts() {
    // Main Chart
    const mainCtx = document.getElementById('mainChart').getContext('2d');
    mainChart = new Chart(mainCtx, {
        type: 'line',
        data: {
            labels: [],
            datasets: [{
                label: 'Revenue',
                data: [],
                borderColor: '#006994',
                backgroundColor: 'rgba(0, 105, 148, 0.1)',
                tension: 0.4,
                fill: true
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: true },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            return '$' + context.parsed.y.toLocaleString();
                        }
                    }
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        callback: function(value) {
                            return '$' + value.toLocaleString();
                        }
                    }
                }
            }
        }
    });
    
    // Pie Chart
    const pieCtx = document.getElementById('pieChart').getContext('2d');
    pieChart = new Chart(pieCtx, {
        type: 'doughnut',
        data: {
            labels: ['Standard', 'Deluxe', 'Suite', 'Presidential'],
            datasets: [{
                data: [25, 35, 30, 10],
                backgroundColor: ['#6C757D', '#006994', '#4A90A4', '#D4AF37']
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { position: 'bottom' }
            }
        }
    });
}

function generateReport() {
    const reportType = document.getElementById('reportType').value;
    
    // Simulate data generation
    const sampleData = generateSampleData(reportType);
    updateMetrics(sampleData.metrics);
    updateChart(sampleData.chartData);
    updateTable(sampleData.tableData);
}

function generateSampleData(type) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    
    return {
        metrics: {
            totalRevenue: 125000 + Math.random() * 50000,
            totalBookings: 450 + Math.floor(Math.random() * 100),
            avgOccupancy: 75 + Math.random() * 20,
            avgRevenue: 280 + Math.random() * 100,
            revenueChange: (Math.random() * 20 - 5).toFixed(1),
            bookingsChange: (Math.random() * 15 - 3).toFixed(1),
            occupancyChange: (Math.random() * 10 - 2).toFixed(1),
            avgRevenueChange: (Math.random() * 8 - 4).toFixed(1)
        },
        chartData: {
            labels: days,
            values: days.map(() => 15000 + Math.random() * 10000)
        },
        tableData: days.map((day, i) => ({
            date: day,
            revenue: (15000 + Math.random() * 10000).toFixed(2),
            bookings: 60 + Math.floor(Math.random() * 30),
            occupancy: (70 + Math.random() * 25).toFixed(1),
            avgRate: (250 + Math.random() * 100).toFixed(2)
        }))
    };
}

function updateMetrics(metrics) {
    document.getElementById('totalRevenue').textContent = '$' + metrics.totalRevenue.toLocaleString('en-US', {maximumFractionDigits: 0});
    document.getElementById('totalBookings').textContent = metrics.totalBookings;
    document.getElementById('avgOccupancy').textContent = metrics.avgOccupancy.toFixed(1) + '%';
    document.getElementById('avgRevenue').textContent = '$' + metrics.avgRevenue.toFixed(0);
    
    updateChangeIndicator('revenueChange', metrics.revenueChange);
    updateChangeIndicator('bookingsChange', metrics.bookingsChange);
    updateChangeIndicator('occupancyChange', metrics.occupancyChange);
    updateChangeIndicator('avgRevenueChange', metrics.avgRevenueChange);
}

function updateChangeIndicator(elementId, value) {
    const element = document.getElementById(elementId);
    const isPositive = parseFloat(value) >= 0;
    
    element.className = 'metric-change ' + (isPositive ? 'positive' : 'negative');
    element.innerHTML = `<i class="fas fa-arrow-${isPositive ? 'up' : 'down'}"></i> ${Math.abs(value)}%`;
}

function updateChart(chartData) {
    mainChart.data.labels = chartData.labels;
    mainChart.data.datasets[0].data = chartData.values;
    mainChart.update();
}

function updateTable(tableData) {
    const tbody = document.getElementById('tableBody');
    tbody.innerHTML = tableData.map(row => `
        <tr>
            <td>${row.date}</td>
            <td>$${parseFloat(row.revenue).toLocaleString('en-US', {minimumFractionDigits: 2})}</td>
            <td>${row.bookings}</td>
            <td>${row.occupancy}%</td>
            <td>$${parseFloat(row.avgRate).toLocaleString('en-US', {minimumFractionDigits: 2})}</td>
        </tr>
    `).join('');
}

function exportChart() {
    const url = mainChart.toBase64Image();
    const link = document.createElement('a');
    link.download = 'chart.png';
    link.href = url;
    link.click();
    
    OceanViewResort.showToast('Chart exported successfully', 'success');
}

function exportToExcel() {
    OceanViewResort.showToast('Exporting to Excel...', 'info');
    // Implement actual export logic here
    setTimeout(() => {
        OceanViewResort.showToast('Export completed', 'success');
    }, 1000);
}

function downloadReport(period) {
    OceanViewResort.showToast('Downloading ' + period + ' report...', 'info');
    // Implement actual download logic here
}
</script>

<jsp:include page="../common/footer.jsp" />
