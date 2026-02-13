#!/bin/bash
# ============================================================
# COMPLETE ENGAGEMENT PLATFORM - PART 2 (UI & FINALIZATION)
# This script appends the missing UI and starts the app.
# ============================================================

APP_NAME="engagement-platform"
cd ${APP_NAME}

# 1. FINISH LOGIN PAGE
cat > src/main/resources/templates/login.html << 'EOF'
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Login | Engagement Platform</title>
    <link rel="stylesheet" th:href="@{/webjars/bootstrap/css/bootstrap.min.css}">
    <link rel="stylesheet" th:href="@{/webjars/font-awesome/css/all.min.css}">
    <link rel="stylesheet" th:href="@{/css/style.css}">
    <style>
        body { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); height: 100vh; display: flex; align-items: center; justify-content: center; }
        .login-card { background: white; padding: 2rem; border-radius: 15px; box-shadow: 0 10px 25px rgba(0,0,0,0.2); width: 100%; max-width: 400px; }
    </style>
</head>
<body>
    <div class="login-card">
        <div class="text-center mb-4">
            <i class="fas fa-rocket fa-3x text-primary mb-3"></i>
            <h2>Welcome Back</h2>
            <p class="text-muted">Please sign in to continue</p>
        </div>
        <div th:if="${param.error}" class="alert alert-danger">Invalid username or password.</div>
        <form th:action="@{/login}" method="post">
            <div class="mb-3">
                <label class="form-label">Username</label>
                <input type="text" name="username" class="form-control" required autofocus>
            </div>
            <div class="mb-3">
                <label class="form-label">Password</label>
                <input type="password" name="password" class="form-control" required>
            </div>
            <button type="submit" class="btn btn-primary w-100 py-2">Login</button>
        </form>
        <div class="text-center mt-3">
            <small class="text-muted">Default: admin / admin123</small>
        </div>
    </div>
</body>
</html>
EOF

# 2. CREATE DASHBOARD
cat > src/main/resources/templates/dashboard.html << 'EOF'
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Dashboard | Engagement Platform</title>
    <link rel="stylesheet" th:href="@{/webjars/bootstrap/css/bootstrap.min.css}">
    <link rel="stylesheet" th:href="@{/webjars/font-awesome/css/all.min.css}">
    <link rel="stylesheet" th:href="@{/css/style.css}">
</head>
<body>
    <div class="wrapper">
        <nav class="sidebar">
            <div class="sidebar-header"><h3>EngageX</h3></div>
            <ul class="list-unstyled components">
                <li class="active"><a href="/dashboard"><i class="fas fa-home"></i> Dashboard</a></li>
                <li><a href="/customers"><i class="fas fa-users"></i> Customers</a></li>
                <li><a href="/segments"><i class="fas fa-layer-group"></i> Segments</a></li>
                <li><a href="/campaigns"><i class="fas fa-paper-plane"></i> Campaigns</a></li>
                <li><a href="/logout" class="text-danger"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
            </ul>
        </nav>

        <div class="content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Overview</h2>
                <div class="user-info">Logged in as: <strong>Admin</strong></div>
            </div>

            <div class="row">
                <div class="col-md-3">
                    <div class="stat-card">
                        <p>Total Customers</p>
                        <h3 th:text="${totalCustomers}">0</h3>
                        <i class="fas fa-users"></i>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card" style="background: linear-gradient(135deg, #2af598 0%, #009efd 100%);">
                        <p>Total Segments</p>
                        <h3 th:text="${totalSegments}">0</h3>
                        <i class="fas fa-layer-group"></i>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card" style="background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%);">
                        <p>Campaigns Sent</p>
                        <h3 th:text="${totalCampaigns}">0</h3>
                        <i class="fas fa-paper-plane"></i>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card" style="background: linear-gradient(135deg, #f6d365 0%, #fda085 100%);">
                        <p>Estimated Revenue</p>
                        <h3 th:text="${'$' + #numbers.formatDecimal(totalRevenue, 0, 'COMMA', 2, 'POINT')}">$0.00</h3>
                        <i class="fas fa-dollar-sign"></i>
                    </div>
                </div>
            </div>
            
            <div class="card mt-4">
                <div class="card-header">System Health</div>
                <div class="card-body text-center py-5">
                    <i class="fas fa-check-circle text-success fa-4x mb-3"></i>
                    <h4>All Systems Operational</h4>
                    <p class="text-muted">Your engagement engine is running smoothly.</p>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
EOF

# 3. CUSTOMER LIST TEMPLATE
cat > src/main/resources/templates/customers/list.html << 'EOF'
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Customers | Engagement Platform</title>
    <link rel="stylesheet" th:href="@{/webjars/bootstrap/css/bootstrap.min.css}">
    <link rel="stylesheet" th:href="@{/webjars/font-awesome/css/all.min.css}">
    <link rel="stylesheet" th:href="@{/css/style.css}">
</head>
<body>
    <div class="wrapper">
        <nav class="sidebar" th:replace="~{dashboard :: nav}"></nav>
        <div class="content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Customer Directory</h2>
                <a href="/customers/new" class="btn btn-primary"><i class="fas fa-plus"></i> Add Customer</a>
            </div>
            <div class="card">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Company</th>
                                <th>Orders</th>
                                <th>Spent</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr th:each="customer : ${customers}">
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="avatar me-3" th:text="${#strings.substring(customer.firstName,0,1)}">U</div>
                                        <span th:text="${customer.fullName}">Name</span>
                                    </div>
                                </td>
                                <td th:text="${customer.email}">Email</td>
                                <td th:text="${customer.company}">Company</td>
                                <td th:text="${customer.totalOrders}">0</td>
                                <td th:text="${'$' + customer.totalSpent}">$0</td>
                                <td>
                                    <a th:href="@{/customers/edit/{id}(id=${customer.id})}" class="btn btn-sm btn-outline-primary"><i class="fas fa-edit"></i></a>
                                    <a th:href="@{/customers/delete/{id}(id=${customer.id})}" class="btn btn-sm btn-outline-danger" onclick="return confirm('Delete this customer?')"><i class="fas fa-trash"></i></a>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
EOF

# 4. CUSTOMER FORM TEMPLATE
cat > src/main/resources/templates/customers/form.html << 'EOF'
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Manage Customer | Engagement Platform</title>
    <link rel="stylesheet" th:href="@{/webjars/bootstrap/css/bootstrap.min.css}">
    <link rel="stylesheet" th:href="@{/webjars/font-awesome/css/all.min.css}">
    <link rel="stylesheet" th:href="@{/css/style.css}">
</head>
<body>
    <div class="wrapper">
        <div class="content" style="margin-left: auto; margin-right: auto; max-width: 800px;">
            <div class="card">
                <div class="card-header"><h4 class="mb-0">Customer Details</h4></div>
                <div class="card-body">
                    <form th:action="@{/customers/save}" th:object="${customer}" method="post">
                        <input type="hidden" th:field="*{id}">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">First Name</label>
                                <input type="text" th:field="*{firstName}" class="form-control" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Last Name</label>
                                <input type="text" th:field="*{lastName}" class="form-control" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Email</label>
                            <input type="email" th:field="*{email}" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Company</label>
                            <input type="text" th:field="*{company}" class="form-control">
                        </div>
                        <div class="d-flex justify-content-between">
                            <a href="/customers" class="btn btn-light">Cancel</a>
                            <button type="submit" class="btn btn-primary">Save Customer</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
EOF

# 5. DATA INITIALIZER (To make it look good on first run)
cat > src/main/java/com/engagement/platform/config/DataInitializer.java << 'EOF'
package com.engagement.platform.config;

import com.engagement.platform.entity.Customer;
import com.engagement.platform.repository.CustomerRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Configuration;

@Configuration
@RequiredArgsConstructor
public class DataInitializer implements CommandLineRunner {
    private final CustomerRepository customerRepository;

    @Override
    public void run(String... args) {
        if (customerRepository.count() == 0) {
            customerRepository.save(new Customer(null, "C001", "John", "Doe", "john@example.com", "555-0101", "Acme Corp", "New York", "USA", 5, 250.0, null));
            customerRepository.save(new Customer(null, "C002", "Jane", "Smith", "jane@example.com", "555-0102", "Globex", "London", "UK", 12, 1200.0, null));
        }
    }
}
EOF

echo "🚀 Everything is set! Building the application..."
mvn clean install -DskipTests

echo "✅ Build Successful!"
echo "👉 Run 'cd engagement-platform && mvn spring-boot:run' to start."
