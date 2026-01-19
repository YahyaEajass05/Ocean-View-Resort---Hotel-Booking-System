<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>

<jsp:include page="../common/header.jsp">
    <jsp:param name="title" value="Manage Reviews" />
    <jsp:param name="css" value="admin" />
    <jsp:param name="active" value="admin" />
</jsp:include>

<div class="page-header">
    <div class="container">
        <h1>Manage Reviews</h1>
        <p>Moderate and respond to guest reviews</p>
    </div>
</div>

<div class="admin-page">
    <div class="container">
        <!-- Statistics -->
        <div class="stats-grid mb-4">
            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(135deg, #FFC107, #FF9800);">
                    <i class="fas fa-clock"></i>
                </div>
                <div class="stat-info">
                    <h3 id="pendingReviews">0</h3>
                    <p>Pending Reviews</p>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(135deg, #28A745, #20c997);">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="stat-info">
                    <h3 id="approvedReviews">0</h3>
                    <p>Approved Reviews</p>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(135deg, #D4AF37, #FFD700);">
                    <i class="fas fa-star"></i>
                </div>
                <div class="stat-info">
                    <h3 id="avgRating">0.0</h3>
                    <p>Average Rating</p>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(135deg, #DC3545, #c82333);">
                    <i class="fas fa-ban"></i>
                </div>
                <div class="stat-info">
                    <h3 id="rejectedReviews">0</h3>
                    <p>Rejected Reviews</p>
                </div>
            </div>
        </div>
        
        <!-- Filters -->
        <div class="search-filter-section">
            <form class="search-form-admin">
                <div class="form-group">
                    <input type="text" id="searchReview" class="form-control" 
                           placeholder="Search by guest name or review content...">
                </div>
                
                <div class="form-group">
                    <select id="filterStatus" class="form-control">
                        <option value="">All Status</option>
                        <option value="PENDING">Pending</option>
                        <option value="APPROVED">Approved</option>
                        <option value="REJECTED">Rejected</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <select id="filterRating" class="form-control">
                        <option value="">All Ratings</option>
                        <option value="5">5 Stars</option>
                        <option value="4">4 Stars</option>
                        <option value="3">3 Stars</option>
                        <option value="2">2 Stars</option>
                        <option value="1">1 Star</option>
                    </select>
                </div>
            </form>
        </div>
        
        <!-- Reviews List -->
        <div class="admin-section">
            <div class="reviews-moderation-list" id="reviewsList">
                <div class="loading-spinner">
                    <i class="fas fa-spinner fa-spin fa-3x"></i>
                    <p>Loading reviews...</p>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Response Modal -->
<div class="modal-overlay" id="responseModal">
    <div class="modal">
        <div class="modal-header">
            <h2 class="modal-title">Respond to Review</h2>
            <button class="modal-close" onclick="closeResponseModal()">&times;</button>
        </div>
        <div class="modal-body">
            <form id="responseForm" onsubmit="submitResponse(event)">
                <input type="hidden" id="reviewId">
                
                <div class="review-summary" id="reviewSummary"></div>
                
                <div class="form-group">
                    <label for="responseText" class="form-label">Your Response *</label>
                    <textarea id="responseText" class="form-control" rows="5" required
                              placeholder="Write your response to the guest..."></textarea>
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeResponseModal()">
                        Cancel
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-paper-plane"></i> Send Response
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<style>
.reviews-moderation-list {
    display: flex;
    flex-direction: column;
    gap: 1.5rem;
}

.review-moderation-card {
    background: white;
    border-radius: 1rem;
    padding: 1.5rem;
    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
    transition: all 0.3s;
}

.review-moderation-card:hover {
    box-shadow: 0 8px 12px rgba(0,0,0,0.15);
}

.review-mod-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 1rem;
    padding-bottom: 1rem;
    border-bottom: 2px solid #f8f9fa;
}

.guest-details {
    display: flex;
    align-items: center;
    gap: 1rem;
}

.guest-avatar-large {
    width: 60px;
    height: 60px;
    border-radius: 50%;
    background: linear-gradient(135deg, #006994, #4A90A4);
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: bold;
    font-size: 1.25rem;
}

.review-status-badge {
    padding: 0.5rem 1rem;
    border-radius: 2rem;
    font-weight: 600;
    font-size: 0.875rem;
}

.review-status-badge.pending { background: #fff3cd; color: #856404; }
.review-status-badge.approved { background: #d4edda; color: #155724; }
.review-status-badge.rejected { background: #f8d7da; color: #721c24; }

.rating-stars {
    display: flex;
    gap: 0.25rem;
    font-size: 1.5rem;
    color: #D4AF37;
    margin: 1rem 0;
}

.review-content {
    margin: 1.5rem 0;
}

.review-content h4 {
    margin-bottom: 0.5rem;
    color: #006994;
}

.review-text {
    color: #495057;
    line-height: 1.6;
}

.review-meta {
    display: flex;
    gap: 1.5rem;
    margin: 1rem 0;
    font-size: 0.875rem;
    color: #6c757d;
}

.review-meta-item {
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.management-response-section {
    margin-top: 1.5rem;
    padding: 1rem;
    background: #f8f9fa;
    border-left: 4px solid #006994;
    border-radius: 0.5rem;
}

.review-actions {
    display: flex;
    gap: 0.5rem;
    margin-top: 1rem;
    padding-top: 1rem;
    border-top: 1px solid #eee;
}

.review-summary {
    background: #f8f9fa;
    padding: 1rem;
    border-radius: 0.5rem;
    margin-bottom: 1rem;
}
</style>

<script>
let reviews = [];

document.addEventListener('DOMContentLoaded', function() {
    loadReviews();
});

function loadReviews() {
    setTimeout(() => {
        reviews = [
            {
                id: 1,
                guestName: 'John Doe',
                guestInitials: 'JD',
                rating: 5,
                title: 'Amazing Stay!',
                comment: 'The resort exceeded all expectations. Staff was friendly, rooms were spotless, and the ocean view was breathtaking!',
                roomType: 'Deluxe',
                checkInDate: '2024-01-15',
                status: 'PENDING',
                createdAt: '2024-01-20',
                hasResponse: false
            },
            {
                id: 2,
                guestName: 'Jane Smith',
                guestInitials: 'JS',
                rating: 4,
                title: 'Great Experience',
                comment: 'Wonderful resort with excellent amenities. Only minor issue was the pool hours.',
                roomType: 'Suite',
                checkInDate: '2024-01-10',
                status: 'APPROVED',
                createdAt: '2024-01-18',
                hasResponse: true,
                responseText: 'Thank you for your feedback! We have extended our pool hours.'
            },
            {
                id: 3,
                guestName: 'Mike Johnson',
                guestInitials: 'MJ',
                rating: 2,
                title: 'Could be better',
                comment: 'Room was not as clean as expected. Service was slow.',
                roomType: 'Standard',
                checkInDate: '2024-01-12',
                status: 'PENDING',
                createdAt: '2024-01-19',
                hasResponse: false
            }
        ];
        
        displayReviews();
        updateStatistics();
    }, 500);
}

function displayReviews() {
    const container = document.getElementById('reviewsList');
    
    if (reviews.length === 0) {
        container.innerHTML = '<div class="empty-state"><i class="fas fa-comments"></i><h3>No Reviews Found</h3></div>';
        return;
    }
    
    container.innerHTML = reviews.map(review => `
        <div class="review-moderation-card">
            <div class="review-mod-header">
                <div class="guest-details">
                    <div class="guest-avatar-large">${review.guestInitials}</div>
                    <div>
                        <h3 style="margin:0;">${review.guestName}</h3>
                        <small style="color:#6c757d;">${review.roomType} Room - Stayed ${review.checkInDate}</small>
                    </div>
                </div>
                <span class="review-status-badge ${review.status.toLowerCase()}">${review.status}</span>
            </div>
            
            <div class="rating-stars">
                ${Array(5).fill(0).map((_, i) => 
                    `<i class="fas fa-star ${i < review.rating ? '' : 'far'}"></i>`
                ).join('')}
            </div>
            
            <div class="review-content">
                <h4>${review.title}</h4>
                <p class="review-text">${review.comment}</p>
            </div>
            
            <div class="review-meta">
                <div class="review-meta-item">
                    <i class="fas fa-calendar"></i>
                    <span>Posted on ${review.createdAt}</span>
                </div>
                <div class="review-meta-item">
                    <i class="fas fa-bed"></i>
                    <span>${review.roomType} Room</span>
                </div>
            </div>
            
            ${review.hasResponse ? `
                <div class="management-response-section">
                    <h5 style="margin:0 0 0.5rem 0;"><i class="fas fa-reply"></i> Management Response</h5>
                    <p style="margin:0;">${review.responseText}</p>
                </div>
            ` : ''}
            
            <div class="review-actions">
                ${review.status === 'PENDING' ? `
                    <button class="btn btn-sm btn-success" onclick="approveReview(${review.id})">
                        <i class="fas fa-check"></i> Approve
                    </button>
                    <button class="btn btn-sm btn-danger" onclick="rejectReview(${review.id})">
                        <i class="fas fa-times"></i> Reject
                    </button>
                ` : ''}
                <button class="btn btn-sm btn-primary" onclick="openResponseModal(${review.id})">
                    <i class="fas fa-reply"></i> ${review.hasResponse ? 'Edit Response' : 'Respond'}
                </button>
                <button class="btn btn-sm btn-secondary" onclick="deleteReview(${review.id})">
                    <i class="fas fa-trash"></i> Delete
                </button>
            </div>
        </div>
    `).join('');
}

function updateStatistics() {
    const pending = reviews.filter(r => r.status === 'PENDING').length;
    const approved = reviews.filter(r => r.status === 'APPROVED').length;
    const rejected = reviews.filter(r => r.status === 'REJECTED').length;
    const avgRating = reviews.length > 0 
        ? (reviews.reduce((sum, r) => sum + r.rating, 0) / reviews.length).toFixed(1)
        : 0;
    
    document.getElementById('pendingReviews').textContent = pending;
    document.getElementById('approvedReviews').textContent = approved;
    document.getElementById('rejectedReviews').textContent = rejected;
    document.getElementById('avgRating').textContent = avgRating;
}

function approveReview(reviewId) {
    const review = reviews.find(r => r.id === reviewId);
    if (review) {
        review.status = 'APPROVED';
        displayReviews();
        updateStatistics();
        OceanViewResort.showToast('Review approved', 'success');
    }
}

function rejectReview(reviewId) {
    if (confirm('Are you sure you want to reject this review?')) {
        const review = reviews.find(r => r.id === reviewId);
        if (review) {
            review.status = 'REJECTED';
            displayReviews();
            updateStatistics();
            OceanViewResort.showToast('Review rejected', 'info');
        }
    }
}

function openResponseModal(reviewId) {
    const review = reviews.find(r => r.id === reviewId);
    if (!review) return;
    
    document.getElementById('reviewId').value = reviewId;
    document.getElementById('reviewSummary').innerHTML = `
        <strong>${review.guestName}</strong> - ${review.title}<br>
        <small>${review.comment}</small>
    `;
    document.getElementById('responseText').value = review.responseText || '';
    document.getElementById('responseModal').classList.add('active');
}

function closeResponseModal() {
    document.getElementById('responseModal').classList.remove('active');
}

function submitResponse(event) {
    event.preventDefault();
    
    const reviewId = parseInt(document.getElementById('reviewId').value);
    const responseText = document.getElementById('responseText').value;
    
    const review = reviews.find(r => r.id === reviewId);
    if (review) {
        review.responseText = responseText;
        review.hasResponse = true;
        
        closeResponseModal();
        displayReviews();
        OceanViewResort.showToast('Response saved successfully', 'success');
    }
}

function deleteReview(reviewId) {
    if (confirm('Are you sure you want to delete this review permanently?')) {
        reviews = reviews.filter(r => r.id !== reviewId);
        displayReviews();
        updateStatistics();
        OceanViewResort.showToast('Review deleted', 'success');
    }
}

// Filter functionality
document.getElementById('searchReview')?.addEventListener('input', filterReviews);
document.getElementById('filterStatus')?.addEventListener('change', filterReviews);
document.getElementById('filterRating')?.addEventListener('change', filterReviews);

function filterReviews() {
    const search = document.getElementById('searchReview').value.toLowerCase();
    const status = document.getElementById('filterStatus').value;
    const rating = document.getElementById('filterRating').value;
    
    const cards = document.querySelectorAll('.review-moderation-card');
    cards.forEach((card, index) => {
        const review = reviews[index];
        if (!review) return;
        
        const matchesSearch = review.guestName.toLowerCase().includes(search) || 
                            review.comment.toLowerCase().includes(search) ||
                            review.title.toLowerCase().includes(search);
        const matchesStatus = !status || review.status === status;
        const matchesRating = !rating || review.rating === parseInt(rating);
        
        card.style.display = matchesSearch && matchesStatus && matchesRating ? 'block' : 'none';
    });
}
</script>

<jsp:include page="../common/footer.jsp" />
