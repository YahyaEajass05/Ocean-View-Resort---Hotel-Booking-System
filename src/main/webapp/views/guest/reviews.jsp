<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:include page="../common/header.jsp">
    <jsp:param name="title" value="My Reviews" />
    <jsp:param name="css" value="reviews" />
    <jsp:param name="active" value="guest" />
</jsp:include>

<div class="page-header">
    <div class="container">
        <h1>My Reviews</h1>
        <p>Share your experience and read guest reviews</p>
    </div>
</div>

<div class="reviews-page">
    <div class="container">
        <!-- Write Review Button -->
        <div class="page-actions">
            <a href="${pageContext.request.contextPath}/guest/reviews/new" class="btn btn-primary">
                <i class="fas fa-pen"></i> Write a Review
            </a>
        </div>
        
        <!-- My Reviews Section -->
        <div class="reviews-section">
            <h2><i class="fas fa-user-edit"></i> My Reviews</h2>
            
            <c:choose>
                <c:when test="${not empty myReviews}">
                    <div class="reviews-list">
                        <c:forEach items="${myReviews}" var="review">
                            <div class="review-item">
                                <div class="review-header-full">
                                    <div class="review-room-info">
                                        <img src="${pageContext.request.contextPath}/assets/images/rooms/${review.reservation.room.roomType.name().toLowerCase()}.jpg" 
                                             alt="${review.reservation.room.roomType}">
                                        <div>
                                            <h4>${review.reservation.room.roomType} - Room ${review.reservation.room.roomNumber}</h4>
                                            <p>Stayed: <fmt:formatDate value="${review.reservation.checkInDate}" pattern="MMM dd, yyyy" /> - 
                                               <fmt:formatDate value="${review.reservation.checkOutDate}" pattern="MMM dd, yyyy" /></p>
                                        </div>
                                    </div>
                                    <span class="badge badge-${review.status == 'APPROVED' ? 'success' : 
                                                              review.status == 'PENDING' ? 'warning' : 'secondary'}">
                                        ${review.status}
                                    </span>
                                </div>
                                
                                <div class="review-content-full">
                                    <div class="review-rating-display">
                                        <div class="stars-large">
                                            <c:forEach begin="1" end="5" var="i">
                                                <i class="fas fa-star ${i <= review.rating ? 'filled' : ''}"></i>
                                            </c:forEach>
                                        </div>
                                        <span class="rating-value">${review.rating}.0</span>
                                    </div>
                                    
                                    <h3>${review.title}</h3>
                                    <p class="review-text">${review.comment}</p>
                                    
                                    <div class="review-meta">
                                        <span><i class="fas fa-calendar"></i> 
                                            <fmt:formatDate value="${review.createdAt}" pattern="MMMM dd, yyyy" />
                                        </span>
                                        <c:if test="${review.status == 'APPROVED' && review.responseText != null}">
                                            <span><i class="fas fa-reply"></i> Management Responded</span>
                                        </c:if>
                                    </div>
                                    
                                    <c:if test="${review.status == 'APPROVED' && review.responseText != null}">
                                        <div class="management-response">
                                            <h5><i class="fas fa-user-tie"></i> Management Response</h5>
                                            <p>${review.responseText}</p>
                                            <span class="response-date">
                                                <fmt:formatDate value="${review.responseDate}" pattern="MMMM dd, yyyy" />
                                            </span>
                                        </div>
                                    </c:if>
                                    
                                    <div class="review-actions">
                                        <c:if test="${review.status == 'PENDING'}">
                                            <button class="btn btn-sm btn-warning" onclick="editReview(${review.id})">
                                                <i class="fas fa-edit"></i> Edit
                                            </button>
                                            <button class="btn btn-sm btn-danger" onclick="deleteReview(${review.id})">
                                                <i class="fas fa-trash"></i> Delete
                                            </button>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state-small">
                        <i class="fas fa-star"></i>
                        <h3>No Reviews Yet</h3>
                        <p>You haven't written any reviews. Complete a stay and share your experience!</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        
        <!-- All Reviews Section -->
        <div class="reviews-section">
            <h2><i class="fas fa-comments"></i> Guest Reviews</h2>
            
            <c:choose>
                <c:when test="${not empty allReviews}">
                    <div class="reviews-list">
                        <c:forEach items="${allReviews}" var="review">
                            <div class="review-item-public">
                                <div class="reviewer-info">
                                    <div class="reviewer-avatar">
                                        ${review.guest.firstName.charAt(0)}${review.guest.lastName.charAt(0)}
                                    </div>
                                    <div>
                                        <h4>${review.guest.firstName} ${review.guest.lastName.charAt(0)}.</h4>
                                        <p class="review-date">
                                            <fmt:formatDate value="${review.createdAt}" pattern="MMMM dd, yyyy" />
                                        </p>
                                    </div>
                                </div>
                                
                                <div class="review-content-public">
                                    <div class="review-rating-display">
                                        <div class="stars-large">
                                            <c:forEach begin="1" end="5" var="i">
                                                <i class="fas fa-star ${i <= review.rating ? 'filled' : ''}"></i>
                                            </c:forEach>
                                        </div>
                                        <span class="rating-value">${review.rating}.0</span>
                                    </div>
                                    
                                    <h3>${review.title}</h3>
                                    <p class="review-text">${review.comment}</p>
                                    
                                    <p class="room-type-small">
                                        <i class="fas fa-door-open"></i> ${review.reservation.room.roomType}
                                    </p>
                                    
                                    <c:if test="${review.responseText != null}">
                                        <div class="management-response">
                                            <h5><i class="fas fa-user-tie"></i> Management Response</h5>
                                            <p>${review.responseText}</p>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state-small">
                        <i class="fas fa-comments"></i>
                        <p>No reviews available yet.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script>
function editReview(reviewId) {
    window.location.href = '${pageContext.request.contextPath}/guest/reviews/' + reviewId + '/edit';
}

function deleteReview(reviewId) {
    if (confirm('Are you sure you want to delete this review? This action cannot be undone.')) {
        fetch('${pageContext.request.contextPath}/guest/reviews/' + reviewId, {
            method: 'DELETE',
            headers: {
                'Content-Type': 'application/json'
            }
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('Review deleted successfully');
                location.reload();
            } else {
                alert('Failed to delete review: ' + data.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('An error occurred. Please try again.');
        });
    }
}
</script>

<jsp:include page="../common/footer.jsp" />
