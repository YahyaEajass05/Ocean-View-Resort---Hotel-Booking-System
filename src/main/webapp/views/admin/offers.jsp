<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.oceanview.model.*" %>
<%
    // Authentication check
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !"ADMIN".equals(currentUser.getRole().toString())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    // Get data from servlet
    @SuppressWarnings("unchecked")
    List<Offer> offers = (List<Offer>) request.getAttribute("offers");
    if (offers == null) {
        offers = new ArrayList<>();
    }
    
    Long activeOffers = (Long) request.getAttribute("activeOffers");
    Long scheduledOffers = (Long) request.getAttribute("scheduledOffers");
    Long expiredOffers = (Long) request.getAttribute("expiredOffers");
    Integer totalRedemptions = (Integer) request.getAttribute("totalRedemptions");
    
    if (activeOffers == null) activeOffers = 0L;
    if (scheduledOffers == null) scheduledOffers = 0L;
    if (expiredOffers == null) expiredOffers = 0L;
    if (totalRedemptions == null) totalRedemptions = 0;
%>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>

<jsp:include page="../common/header.jsp">
    <jsp:param name="title" value="Manage Offers" />
    <jsp:param name="css" value="admin" />
    <jsp:param name="active" value="admin" />
</jsp:include>

<div class="page-header">
    <div class="container">
        <h1>Manage Special Offers</h1>
        <p>Create and manage promotional offers and discounts</p>
    </div>
</div>

<div class="admin-page">
    <div class="container">
        <!-- Statistics -->
        <div class="stats-grid mb-4">
            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(135deg, #28A745, #20c997);">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="stat-info">
                    <h3><%= activeOffers %></h3>
                    <p>Active Offers</p>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(135deg, #FFC107, #FF9800);">
                    <i class="fas fa-clock"></i>
                </div>
                <div class="stat-info">
                    <h3><%= scheduledOffers %></h3>
                    <p>Scheduled Offers</p>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(135deg, #17A2B8, #138496);">
                    <i class="fas fa-users"></i>
                </div>
                <div class="stat-info">
                    <h3><%= totalRedemptions %></h3>
                    <p>Total Redemptions</p>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(135deg, #6C757D, #495057);">
                    <i class="fas fa-history"></i>
                </div>
                <div class="stat-info">
                    <h3><%= expiredOffers %></h3>
                    <p>Expired Offers</p>
                </div>
            </div>
        </div>
        
        <!-- Actions -->
        <div class="search-filter-section">
            <form class="search-form-admin">
                <div class="form-group">
                    <input type="text" id="searchOffer" class="form-control" 
                           placeholder="Search offers...">
                </div>
                
                <div class="form-group">
                    <select id="filterStatus" class="form-control">
                        <option value="">All Status</option>
                        <option value="ACTIVE">Active</option>
                        <option value="SCHEDULED">Scheduled</option>
                        <option value="EXPIRED">Expired</option>
                        <option value="INACTIVE">Inactive</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <select id="filterType" class="form-control">
                        <option value="">All Types</option>
                        <option value="PERCENTAGE">Percentage</option>
                        <option value="FIXED">Fixed Amount</option>
                        <option value="BOGO">Buy One Get One</option>
                    </select>
                </div>
            </form>
            
            <button class="btn btn-success" onclick="openOfferModal()">
                <i class="fas fa-plus"></i> Create New Offer
            </button>
        </div>
        
        <!-- Offers Grid -->
        <div class="admin-section">
            <div class="offers-grid" id="offersGrid">
                <%
                if (offers != null && !offers.isEmpty()) {
                    for (Offer offer : offers) {
                        String discountDisplay = "";
                        if (offer.getDiscountType() == Offer.DiscountType.PERCENTAGE) {
                            discountDisplay = offer.getDiscountValue() + "%";
                        } else if (offer.getDiscountType() == Offer.DiscountType.FIXED) {
                            discountDisplay = "Rs. " + offer.getDiscountValue();
                        } else {
                            discountDisplay = "BOGO";
                        }
                %>
                <div class="offer-card">
                    <div class="offer-card-header">
                        <span class="offer-badge"><%= offer.getOfferStatus() %></span>
                        <h3><%= offer.getOfferName() %></h3>
                        <div class="offer-discount"><%= discountDisplay %> OFF</div>
                        <p><%= offer.getDescription() %></p>
                    </div>
                    <div class="offer-card-body">
                        <div class="offer-validity">
                            <i class="fas fa-calendar"></i>
                            <span><%= offer.getStartDate() %> to <%= offer.getEndDate() %></span>
                        </div>
                        
                        <% if (offer.getPromoCode() != null && !offer.getPromoCode().isEmpty()) { %>
                        <div class="promo-code-display">
                            <strong>Promo Code:</strong> 
                            <code style="background:#f8f9fa;padding:0.25rem 0.5rem;border-radius:0.25rem;">
                                <%= offer.getPromoCode() %>
                            </code>
                        </div>
                        <% } %>
                        
                        <div class="offer-stats">
                            <div class="offer-stat">
                                <div class="offer-stat-value"><%= offer.getUsedCount() %></div>
                                <div class="offer-stat-label">Used</div>
                            </div>
                            <div class="offer-stat">
                                <div class="offer-stat-value"><%= offer.getMaxUses() != null ? offer.getMaxUses() : "∞" %></div>
                                <div class="offer-stat-label">Max Uses</div>
                            </div>
                        </div>
                    </div>
                    <div class="offer-card-footer">
                        <a href="<%= request.getContextPath() %>/offer?action=edit&id=<%= offer.getOfferId() %>" 
                           class="btn btn-sm btn-primary flex-1">
                            <i class="fas fa-edit"></i> Edit
                        </a>
                        <form action="<%= request.getContextPath() %>/offer" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="toggleStatus">
                            <input type="hidden" name="id" value="<%= offer.getOfferId() %>">
                            <button type="submit" class="btn btn-sm btn-<%= offer.getOfferStatus() == Offer.OfferStatus.ACTIVE ? "warning" : "success" %>">
                                <i class="fas fa-<%= offer.getOfferStatus() == Offer.OfferStatus.ACTIVE ? "pause" : "play" %>"></i>
                            </button>
                        </form>
                        <a href="<%= request.getContextPath() %>/offer?action=delete&id=<%= offer.getOfferId() %>" 
                           class="btn btn-sm btn-danger"
                           onclick="return confirm('Are you sure you want to delete this offer?')">
                            <i class="fas fa-trash"></i>
                        </a>
                    </div>
                </div>
                <%
                    }
                } else {
                %>
                <div class="empty-state" style="grid-column: 1 / -1; text-align: center; padding: 3rem;">
                    <i class="fas fa-tags fa-3x text-muted mb-3"></i>
                    <h3 class="text-muted">No Offers Found</h3>
                    <p class="text-muted">Click "Create New Offer" to add your first promotional offer</p>
                </div>
                <%
                }
                %>
            </div>
        </div>
    </div>
</div>

<!-- Offer Modal -->
<div class="modal-overlay" id="offerModal">
    <div class="modal modal-large">
        <div class="modal-header">
            <h2 class="modal-title" id="modalTitle">Create New Offer</h2>
            <button class="modal-close" onclick="closeOfferModal()">&times;</button>
        </div>
        <div class="modal-body">
            <form id="offerForm" onsubmit="saveOffer(event)">
                <input type="hidden" id="offerId">
                
                <div class="form-group">
                    <label for="offerName" class="form-label">Offer Name *</label>
                    <input type="text" id="offerName" class="form-control" required
                           placeholder="e.g., Summer Special 2024">
                </div>
                
                <div class="form-group">
                    <label for="description" class="form-label">Description *</label>
                    <textarea id="description" class="form-control" rows="3" required
                              placeholder="Describe the offer details..."></textarea>
                </div>
                
                <div class="row">
                    <div class="col-6">
                        <div class="form-group">
                            <label for="discountType" class="form-label">Discount Type *</label>
                            <select id="discountType" class="form-control" onchange="updateDiscountField()" required>
                                <option value="">Select Type</option>
                                <option value="PERCENTAGE">Percentage</option>
                                <option value="FIXED">Fixed Amount</option>
                                <option value="BOGO">Buy One Get One</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="col-6">
                        <div class="form-group">
                            <label for="discountValue" class="form-label">Discount Value *</label>
                            <input type="number" id="discountValue" class="form-control" 
                                   min="0" step="0.01" required>
                            <span class="form-text" id="discountHelp"></span>
                        </div>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-6">
                        <div class="form-group">
                            <label for="startDate" class="form-label">Start Date *</label>
                            <input type="date" id="startDate" class="form-control" required>
                        </div>
                    </div>
                    
                    <div class="col-6">
                        <div class="form-group">
                            <label for="endDate" class="form-label">End Date *</label>
                            <input type="date" id="endDate" class="form-control" required>
                        </div>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-6">
                        <div class="form-group">
                            <label for="minStay" class="form-label">Minimum Stay (nights)</label>
                            <input type="number" id="minStay" class="form-control" min="1" value="1">
                        </div>
                    </div>
                    
                    <div class="col-6">
                        <div class="form-group">
                            <label for="maxUses" class="form-label">Maximum Uses</label>
                            <input type="number" id="maxUses" class="form-control" min="1" 
                                   placeholder="Leave empty for unlimited">
                        </div>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="promoCode" class="form-label">Promo Code</label>
                    <div class="input-group">
                        <input type="text" id="promoCode" class="form-control" 
                               placeholder="e.g., SUMMER2024">
                        <button type="button" class="btn btn-secondary" onclick="generatePromoCode()">
                            <i class="fas fa-random"></i> Generate
                        </button>
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Applicable Room Types</label>
                    <div class="room-types-checkboxes">
                        <label class="checkbox-label">
                            <input type="checkbox" name="roomType" value="STANDARD" checked> Standard
                        </label>
                        <label class="checkbox-label">
                            <input type="checkbox" name="roomType" value="DELUXE" checked> Deluxe
                        </label>
                        <label class="checkbox-label">
                            <input type="checkbox" name="roomType" value="SUITE" checked> Suite
                        </label>
                        <label class="checkbox-label">
                            <input type="checkbox" name="roomType" value="PRESIDENTIAL" checked> Presidential
                        </label>
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="checkbox-label">
                        <input type="checkbox" id="isActive" checked>
                        <span>Activate offer immediately</span>
                    </label>
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeOfferModal()">
                        Cancel
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> Save Offer
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<style>
.offers-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
    gap: 1.5rem;
}

.offer-card {
    background: white;
    border-radius: 1rem;
    overflow: hidden;
    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
    transition: all 0.3s;
    position: relative;
}

.offer-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 20px rgba(0,0,0,0.15);
}

.offer-card-header {
    padding: 1.5rem;
    background: linear-gradient(135deg, #FF6B6B, #D4AF37);
    color: white;
    position: relative;
}

.offer-badge {
    position: absolute;
    top: 1rem;
    right: 1rem;
    padding: 0.25rem 0.75rem;
    border-radius: 1rem;
    font-size: 0.75rem;
    font-weight: 600;
    text-transform: uppercase;
    background: rgba(255,255,255,0.3);
}

.offer-discount {
    font-size: 2.5rem;
    font-weight: bold;
    margin: 0.5rem 0;
}

.offer-card-body {
    padding: 1.5rem;
}

.offer-validity {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    margin-bottom: 1rem;
    padding: 0.75rem;
    background: #f8f9fa;
    border-radius: 0.5rem;
    font-size: 0.875rem;
}

.offer-stats {
    display: flex;
    justify-content: space-around;
    margin: 1rem 0;
    padding: 1rem 0;
    border-top: 1px solid #eee;
    border-bottom: 1px solid #eee;
}

.offer-stat {
    text-align: center;
}

.offer-stat-value {
    font-size: 1.5rem;
    font-weight: bold;
    color: #006994;
}

.offer-stat-label {
    font-size: 0.75rem;
    color: #6c757d;
}

.offer-card-footer {
    padding: 1rem 1.5rem;
    background: #f8f9fa;
    display: flex;
    gap: 0.5rem;
}

.room-types-checkboxes {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 0.75rem;
}

.input-group {
    display: flex;
    gap: 0.5rem;
}

.input-group .form-control {
    flex: 1;
}
</style>

<script>
function openOfferModal() {
    window.location.href = '<%= request.getContextPath() %>/offer?action=new';
}

// Filter functionality
document.getElementById('searchOffer')?.addEventListener('input', filterOffers);
document.getElementById('filterStatus')?.addEventListener('change', filterOffers);
document.getElementById('filterType')?.addEventListener('change', filterOffers);

function filterOffers() {
    const search = document.getElementById('searchOffer').value.toLowerCase();
    const status = document.getElementById('filterStatus').value;
    const type = document.getElementById('filterType').value;
    
    const cards = document.querySelectorAll('.offer-card');
    cards.forEach(card => {
        const cardText = card.textContent.toLowerCase();
        const cardStatus = card.querySelector('.offer-badge')?.textContent.trim();
        
        const matchesSearch = cardText.includes(search);
        const matchesStatus = !status || cardStatus === status;
        const matchesType = !type || cardText.includes(type.toLowerCase());
        
        card.style.display = matchesSearch && matchesStatus && matchesType ? 'block' : 'none';
    });
}
</script>

<jsp:include page="../common/footer.jsp" />
