<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Set demo parameters for components
    request.setAttribute("title", "Component Demo");
    request.setAttribute("css", "dashboard");
    request.setAttribute("active", "demo");
%>

<!-- Include Header -->
<jsp:include page="header.jsp">
    <jsp:param name="title" value="Component Demo" />
    <jsp:param name="css" value="dashboard" />
    <jsp:param name="active" value="demo" />
</jsp:include>

<!-- Demo Page Content -->
<div class="container py-4">
    <div class="page-header mb-4">
        <h1>Common Components Demo</h1>
        <p class="lead">This page demonstrates all the common components available in the Ocean View Resort application.</p>
    </div>
    
    <!-- Component Sections -->
    <div class="row">
        <!-- Header Component -->
        <div class="col-12 mb-4">
            <div class="card">
                <div class="card-header">
                    <h3><i class="fas fa-window-maximize"></i> Header Component</h3>
                </div>
                <div class="card-body">
                    <p><strong>Location:</strong> <code>src/main/webapp/views/common/header.jsp</code></p>
                    <p><strong>Features:</strong></p>
                    <ul>
                        <li>Responsive top bar with contact information</li>
                        <li>Logo and brand display</li>
                        <li>Dynamic navigation menu based on user role</li>
                        <li>User dropdown with profile actions</li>
                        <li>Alert message system (success, error, info)</li>
                        <li>Mobile-friendly hamburger menu</li>
                    </ul>
                    <p><strong>Usage:</strong></p>
                    <pre><code>&lt;jsp:include page="/views/common/header.jsp"&gt;
    &lt;jsp:param name="title" value="Page Title" /&gt;
    &lt;jsp:param name="css" value="page-specific-css" /&gt;
    &lt;jsp:param name="active" value="menu-item" /&gt;
&lt;/jsp:include&gt;</code></pre>
                </div>
            </div>
        </div>
        
        <!-- Footer Component -->
        <div class="col-12 mb-4">
            <div class="card">
                <div class="card-header">
                    <h3><i class="fas fa-window-minimize"></i> Footer Component</h3>
                </div>
                <div class="card-body">
                    <p><strong>Location:</strong> <code>src/main/webapp/views/common/footer.jsp</code></p>
                    <p><strong>Features:</strong></p>
                    <ul>
                        <li>Multi-column footer layout</li>
                        <li>About section with social media links</li>
                        <li>Quick links and services navigation</li>
                        <li>Contact information display</li>
                        <li>Newsletter subscription form</li>
                        <li>Copyright and legal links</li>
                    </ul>
                    <p><strong>Usage:</strong></p>
                    <pre><code>&lt;jsp:include page="/views/common/footer.jsp"&gt;
    &lt;jsp:param name="js" value="page-specific-js" /&gt;
&lt;/jsp:include&gt;</code></pre>
                </div>
            </div>
        </div>
        
        <!-- Navbar Component -->
        <div class="col-12 mb-4">
            <div class="card">
                <div class="card-header">
                    <h3><i class="fas fa-bars"></i> Navbar Component</h3>
                </div>
                <div class="card-body">
                    <p><strong>Location:</strong> <code>src/main/webapp/views/common/navbar.jsp</code></p>
                    <p><strong>Features:</strong></p>
                    <ul>
                        <li>Standalone sticky navigation bar</li>
                        <li>Role-based menu items (Admin, Staff, Guest, Public)</li>
                        <li>User profile dropdown with quick actions</li>
                        <li>Mobile-responsive with toggle menu</li>
                        <li>Authentication buttons for non-logged-in users</li>
                        <li>Active menu item highlighting</li>
                    </ul>
                    <p><strong>Usage:</strong></p>
                    <pre><code>&lt;jsp:include page="/views/common/navbar.jsp"&gt;
    &lt;jsp:param name="active" value="menu-item" /&gt;
&lt;/jsp:include&gt;</code></pre>
                    <p><strong>CSS:</strong> <code>src/main/webapp/assets/css/navbar.css</code></p>
                </div>
            </div>
        </div>
        
        <!-- Sidebar Component -->
        <div class="col-12 mb-4">
            <div class="card">
                <div class="card-header">
                    <h3><i class="fas fa-stream"></i> Sidebar Component</h3>
                </div>
                <div class="card-body">
                    <p><strong>Location:</strong> <code>src/main/webapp/views/common/sidebar.jsp</code></p>
                    <p><strong>Features:</strong></p>
                    <ul>
                        <li>Fixed left sidebar navigation</li>
                        <li>User profile section at top</li>
                        <li>Organized menu sections with icons</li>
                        <li>Role-based navigation (Admin, Staff, Guest)</li>
                        <li>Collapsible sidebar for space saving</li>
                        <li>Mobile-friendly with overlay</li>
                        <li>Settings and logout in footer</li>
                    </ul>
                    <p><strong>Usage:</strong></p>
                    <pre><code>&lt;jsp:include page="/views/common/sidebar.jsp"&gt;
    &lt;jsp:param name="active" value="page-identifier" /&gt;
&lt;/jsp:include&gt;

&lt;!-- Wrap main content --&gt;
&lt;div class="content-with-sidebar"&gt;
    &lt;!-- Your page content --&gt;
&lt;/div&gt;</code></pre>
                    <p><strong>CSS:</strong> <code>src/main/webapp/assets/css/sidebar.css</code></p>
                </div>
            </div>
        </div>
        
        <!-- Integration Examples -->
        <div class="col-12 mb-4">
            <div class="card">
                <div class="card-header">
                    <h3><i class="fas fa-puzzle-piece"></i> Integration Examples</h3>
                </div>
                <div class="card-body">
                    <h4>Example 1: Simple Page with Header and Footer</h4>
                    <pre><code>&lt;%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%&gt;
&lt;jsp:include page="/views/common/header.jsp"&gt;
    &lt;jsp:param name="title" value="My Page" /&gt;
    &lt;jsp:param name="active" value="home" /&gt;
&lt;/jsp:include&gt;

&lt;div class="container py-4"&gt;
    &lt;h1&gt;My Page Content&lt;/h1&gt;
&lt;/div&gt;

&lt;jsp:include page="/views/common/footer.jsp" /&gt;</code></pre>
                    
                    <h4 class="mt-4">Example 2: Dashboard with Sidebar</h4>
                    <pre><code>&lt;%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%&gt;
&lt;jsp:include page="/views/common/header.jsp"&gt;
    &lt;jsp:param name="title" value="Dashboard" /&gt;
    &lt;jsp:param name="css" value="dashboard" /&gt;
&lt;/jsp:include&gt;

&lt;jsp:include page="/views/common/sidebar.jsp"&gt;
    &lt;jsp:param name="active" value="dashboard" /&gt;
&lt;/jsp:include&gt;

&lt;div class="content-with-sidebar"&gt;
    &lt;div class="container py-4"&gt;
        &lt;h1&gt;Dashboard Content&lt;/h1&gt;
    &lt;/div&gt;
&lt;/div&gt;

&lt;jsp:include page="/views/common/footer.jsp" /&gt;</code></pre>
                    
                    <h4 class="mt-4">Example 3: Using Standalone Navbar</h4>
                    <pre><code>&lt;%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%&gt;
&lt;!DOCTYPE html&gt;
&lt;html&gt;
&lt;head&gt;
    &lt;title&gt;My Page&lt;/title&gt;
    &lt;link rel="stylesheet" href="&lt;%= request.getContextPath() %&gt;/assets/css/main.css"&gt;
    &lt;link rel="stylesheet" href="&lt;%= request.getContextPath() %&gt;/assets/css/navbar.css"&gt;
&lt;/head&gt;
&lt;body&gt;
    &lt;jsp:include page="/views/common/navbar.jsp"&gt;
        &lt;jsp:param name="active" value="home" /&gt;
    &lt;/jsp:include&gt;
    
    &lt;main&gt;
        &lt;!-- Your content --&gt;
    &lt;/main&gt;
&lt;/body&gt;
&lt;/html&gt;</code></pre>
                </div>
            </div>
        </div>
        
        <!-- Key Features -->
        <div class="col-12 mb-4">
            <div class="card">
                <div class="card-header">
                    <h3><i class="fas fa-star"></i> Key Features</h3>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <h5><i class="fas fa-check-circle text-success"></i> No JSTL Dependencies</h5>
                            <p>All components use pure JSP scriptlets (<%% %>) instead of JSTL tags, reducing dependencies and improving compatibility.</p>
                        </div>
                        <div class="col-md-6">
                            <h5><i class="fas fa-mobile-alt text-primary"></i> Fully Responsive</h5>
                            <p>All components are mobile-first and responsive, working seamlessly across all device sizes.</p>
                        </div>
                        <div class="col-md-6">
                            <h5><i class="fas fa-users text-info"></i> Role-Based Access</h5>
                            <p>Navigation automatically adapts based on user role (Admin, Staff, Guest, or Public).</p>
                        </div>
                        <div class="col-md-6">
                            <h5><i class="fas fa-palette text-warning"></i> Consistent Styling</h5>
                            <p>Uses the project's design system with CSS variables for easy customization.</p>
                        </div>
                        <div class="col-md-6">
                            <h5><i class="fas fa-universal-access text-success"></i> Accessible</h5>
                            <p>Built with ARIA attributes and semantic HTML for better accessibility.</p>
                        </div>
                        <div class="col-md-6">
                            <h5><i class="fas fa-bolt text-danger"></i> Performance Optimized</h5>
                            <p>Lightweight JavaScript with no external dependencies.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Include Footer -->
<jsp:include page="footer.jsp">
    <jsp:param name="js" value="dashboard" />
</jsp:include>
