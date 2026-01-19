<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // Authentication check
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !"ADMIN".equals(currentUser.getRole().toString())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    String contextPath = request.getContextPath();
    
    // Get data from servlet
    List<User> users = (List<User>) request.getAttribute("users");
    Long totalUsersCount = (Long) request.getAttribute("totalUsers");
    Long adminCountValue = (Long) request.getAttribute("adminCount");
    Long staffCountValue = (Long) request.getAttribute("staffCount");
    Long guestCountValue = (Long) request.getAttribute("guestCount");
    
    // Default values if null
    if (totalUsersCount == null) totalUsersCount = 0L;
    if (adminCountValue == null) adminCountValue = 0L;
    if (staffCountValue == null) staffCountValue = 0L;
    if (guestCountValue == null) guestCountValue = 0L;
%>

<jsp:include page="../common/header.jsp">
    <jsp:param name="title" value="Manage Users" />
    <jsp:param name="css" value="admin,dashboard" />
    <jsp:param name="active" value="admin" />
</jsp:include>

<jsp:include page="../common/sidebar.jsp">
    <jsp:param name="active" value="users" />
</jsp:include>

<div class="content-with-sidebar">
    <div class="admin-page">
        <div class="container-fluid py-4">
            <!-- Page Header -->
            <div class="page-header mb-4">
                <div>
                    <h1><i class="fas fa-users"></i> Manage Users</h1>
                    <p class="text-muted">View and manage all system users</p>
                </div>
                <div class="header-actions">
                    <button class="btn btn-primary" onclick="openAddUserModal()">
                        <i class="fas fa-user-plus"></i> Add New User
                    </button>
                    <button class="btn btn-outline" onclick="exportUsers()">
                        <i class="fas fa-download"></i> Export
                    </button>
                </div>
            </div>
            
            <!-- Statistics Cards -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon bg-primary">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="stat-details">
                            <div class="stat-value"><%= totalUsersCount %></div>
                            <div class="stat-label">Total Users</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon bg-danger">
                            <i class="fas fa-shield-alt"></i>
                        </div>
                        <div class="stat-details">
                            <div class="stat-value"><%= adminCountValue %></div>
                            <div class="stat-label">Admins</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon bg-info">
                            <i class="fas fa-user-tie"></i>
                        </div>
                        <div class="stat-details">
                            <div class="stat-value"><%= staffCountValue %></div>
                            <div class="stat-label">Staff</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon bg-success">
                            <i class="fas fa-user"></i>
                        </div>
                        <div class="stat-details">
                            <div class="stat-value"><%= guestCountValue %></div>
                            <div class="stat-label">Guests</div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Search and Filters -->
            <div class="card mb-4">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-4">
                            <input type="text" id="searchUser" class="form-control" placeholder="Search users...">
                        </div>
                        <div class="col-md-3">
                            <select id="filterRole" class="form-control">
                                <option value="">All Roles</option>
                                <option value="ADMIN">Admin</option>
                                <option value="STAFF">Staff</option>
                                <option value="GUEST">Guest</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <select id="filterStatus" class="form-control">
                                <option value="">All Status</option>
                                <option value="ACTIVE">Active</option>
                                <option value="INACTIVE">Inactive</option>
                                <option value="SUSPENDED">Suspended</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Users Table -->
            <div class="card">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Role</th>
                                    <th>Status</th>
                                    <th>Registered</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                if (users != null && !users.isEmpty()) {
                                    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
                                    for (User user : users) {
                                        String statusBadge = "";
                                        if (user.getStatus() == User.Status.ACTIVE) statusBadge = "badge-success";
                                        else if (user.getStatus() == User.Status.INACTIVE) statusBadge = "badge-secondary";
                                        else statusBadge = "badge-danger";
                                        
                                        String roleBadge = "";
                                        if (user.getRole() == User.Role.ADMIN) roleBadge = "badge-danger";
                                        else if (user.getRole() == User.Role.STAFF) roleBadge = "badge-info";
                                        else roleBadge = "badge-primary";
                                %>
                                <tr>
                                    <td><strong>#<%= user.getUserId() %></strong></td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="avatar-sm">
                                                <%= user.getFirstName().substring(0, 1) + user.getLastName().substring(0, 1) %>
                                            </div>
                                            <div class="ml-2">
                                                <strong><%= user.getFirstName() %> <%= user.getLastName() %></strong>
                                            </div>
                                        </div>
                                    </td>
                                    <td><%= user.getEmail() %></td>
                                    <td><span class="badge <%= roleBadge %>"><%= user.getRole() %></span></td>
                                    <td><span class="badge <%= statusBadge %>"><%= user.getStatus() %></span></td>
                                    <td><%= user.getCreatedAt() != null ? dateFormat.format(user.getCreatedAt()) : "N/A" %></td>
                                    <td>
                                        <div class="btn-group">
                                            <a href="<%= contextPath %>/user?action=view&id=<%= user.getUserId() %>" 
                                               class="btn btn-sm btn-info" title="View">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                            <a href="<%= contextPath %>/user?action=edit&id=<%= user.getUserId() %>" 
                                               class="btn btn-sm btn-warning" title="Edit">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <% if (user.getUserId() != currentUser.getUserId()) { %>
                                            <a href="<%= contextPath %>/user?action=delete&id=<%= user.getUserId() %>" 
                                               class="btn btn-sm btn-danger" title="Delete"
                                               onclick="return confirm('Are you sure you want to delete this user?')">
                                                <i class="fas fa-trash"></i>
                                            </a>
                                            <% } %>
                                        </div>
                                    </td>
                                </tr>
                                <%
                                    }
                                } else {
                                %>
                                <tr>
                                    <td colspan="7" class="text-center py-4">
                                        <i class="fas fa-users fa-3x text-muted mb-3"></i>
                                        <h5 class="text-muted">No users found</h5>
                                    </td>
                                </tr>
                                <%
                                }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
.avatar-sm {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background: linear-gradient(135deg, #006994, #4A90A4);
    color: white;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    font-weight: bold;
    font-size: 0.875rem;
}

.badge {
    padding: 0.35rem 0.65rem;
    font-size: 0.75rem;
    font-weight: 600;
    border-radius: 0.25rem;
}

.badge-success { background: #28A745; color: white; }
.badge-danger { background: #DC3545; color: white; }
.badge-warning { background: #FFC107; color: #000; }
.badge-info { background: #17A2B8; color: white; }
.badge-primary { background: #006994; color: white; }
.badge-secondary { background: #6c757d; color: white; }

.btn-group {
    display: flex;
    gap: 0.25rem;
}
</style>

<script>
// Filter functionality
document.getElementById('searchUser')?.addEventListener('input', filterUsers);
document.getElementById('filterRole')?.addEventListener('change', filterUsers);
document.getElementById('filterStatus')?.addEventListener('change', filterUsers);

function filterUsers() {
    const search = document.getElementById('searchUser').value.toLowerCase();
    const role = document.getElementById('filterRole').value;
    const status = document.getElementById('filterStatus').value;
    
    const rows = document.querySelectorAll('tbody tr');
    rows.forEach(row => {
        const cells = row.cells;
        if (cells.length < 7) return; // Skip empty state row
        
        const name = cells[1].textContent.toLowerCase();
        const email = cells[2].textContent.toLowerCase();
        const userRole = cells[3].textContent.trim();
        const userStatus = cells[4].textContent.trim();
        
        const matchesSearch = name.includes(search) || email.includes(search);
        const matchesRole = !role || userRole === role;
        const matchesStatus = !status || userStatus === status;
        
        row.style.display = matchesSearch && matchesRole && matchesStatus ? '' : 'none';
    });
}

function openAddUserModal() {
    // Redirect to registration page or open modal
    window.location.href = '<%= contextPath %>/register';
}

function exportUsers() {
    alert('Export functionality will be implemented soon!');
}
</script>

<jsp:include page="../common/footer.jsp" />