/**
 * Ocean View Resort - API Helper Library
 * Simplified fetch wrapper with error handling and interceptors
 */

const API = {
    config: {
        baseURL: '/api',
        timeout: 30000,
        headers: {
            'Content-Type': 'application/json'
        }
    },

    interceptors: {
        request: [],
        response: []
    },

    /**
     * Initialize API helper
     */
    init: function(options = {}) {
        this.config = { ...this.config, ...options };
    },

    /**
     * Add request interceptor
     */
    addRequestInterceptor: function(interceptor) {
        this.interceptors.request.push(interceptor);
    },

    /**
     * Add response interceptor
     */
    addResponseInterceptor: function(interceptor) {
        this.interceptors.response.push(interceptor);
    },

    /**
     * Build full URL
     */
    buildURL: function(endpoint) {
        if (endpoint.startsWith('http')) return endpoint;
        return this.config.baseURL + (endpoint.startsWith('/') ? endpoint : '/' + endpoint);
    },

    /**
     * Apply request interceptors
     */
    applyRequestInterceptors: function(config) {
        let modifiedConfig = { ...config };
        this.interceptors.request.forEach(interceptor => {
            modifiedConfig = interceptor(modifiedConfig) || modifiedConfig;
        });
        return modifiedConfig;
    },

    /**
     * Apply response interceptors
     */
    applyResponseInterceptors: function(response) {
        let modifiedResponse = response;
        this.interceptors.response.forEach(interceptor => {
            modifiedResponse = interceptor(modifiedResponse) || modifiedResponse;
        });
        return modifiedResponse;
    },

    /**
     * Make HTTP request
     */
    request: async function(endpoint, options = {}) {
        const url = this.buildURL(endpoint);
        
        const config = {
            method: options.method || 'GET',
            headers: { ...this.config.headers, ...options.headers },
            ...options
        };

        // Apply request interceptors
        const finalConfig = this.applyRequestInterceptors(config);

        // Add body if present
        if (finalConfig.body && typeof finalConfig.body === 'object') {
            finalConfig.body = JSON.stringify(finalConfig.body);
        }

        try {
            // Create timeout promise
            const timeoutPromise = new Promise((_, reject) => {
                setTimeout(() => reject(new Error('Request timeout')), this.config.timeout);
            });

            // Race between fetch and timeout
            const response = await Promise.race([
                fetch(url, finalConfig),
                timeoutPromise
            ]);

            // Apply response interceptors
            const finalResponse = this.applyResponseInterceptors(response);

            // Handle HTTP errors
            if (!finalResponse.ok) {
                const error = new Error(`HTTP ${finalResponse.status}: ${finalResponse.statusText}`);
                error.response = finalResponse;
                throw error;
            }

            // Parse response
            const contentType = finalResponse.headers.get('content-type');
            if (contentType && contentType.includes('application/json')) {
                const data = await finalResponse.json();
                return { data, response: finalResponse };
            }

            const text = await finalResponse.text();
            return { data: text, response: finalResponse };

        } catch (error) {
            console.error('API Request Error:', error);
            throw error;
        }
    },

    /**
     * GET request
     */
    get: function(endpoint, params = {}, options = {}) {
        let url = endpoint;
        
        // Add query parameters
        if (Object.keys(params).length > 0) {
            const queryString = new URLSearchParams(params).toString();
            url += (url.includes('?') ? '&' : '?') + queryString;
        }

        return this.request(url, { ...options, method: 'GET' });
    },

    /**
     * POST request
     */
    post: function(endpoint, data = {}, options = {}) {
        return this.request(endpoint, {
            ...options,
            method: 'POST',
            body: data
        });
    },

    /**
     * PUT request
     */
    put: function(endpoint, data = {}, options = {}) {
        return this.request(endpoint, {
            ...options,
            method: 'PUT',
            body: data
        });
    },

    /**
     * PATCH request
     */
    patch: function(endpoint, data = {}, options = {}) {
        return this.request(endpoint, {
            ...options,
            method: 'PATCH',
            body: data
        });
    },

    /**
     * DELETE request
     */
    delete: function(endpoint, options = {}) {
        return this.request(endpoint, {
            ...options,
            method: 'DELETE'
        });
    },

    /**
     * Upload file
     */
    upload: function(endpoint, file, additionalData = {}) {
        const formData = new FormData();
        formData.append('file', file);
        
        Object.keys(additionalData).forEach(key => {
            formData.append(key, additionalData[key]);
        });

        return this.request(endpoint, {
            method: 'POST',
            body: formData,
            headers: {} // Let browser set Content-Type for FormData
        });
    },

    /**
     * Download file
     */
    download: async function(endpoint, filename) {
        try {
            const { data, response } = await this.request(endpoint, {
                headers: { 'Accept': 'application/octet-stream' }
            });

            const blob = await response.blob();
            const url = window.URL.createObjectURL(blob);
            const link = document.createElement('a');
            link.href = url;
            link.download = filename || 'download';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
            window.URL.revokeObjectURL(url);

            return { success: true };
        } catch (error) {
            console.error('Download error:', error);
            throw error;
        }
    },

    /**
     * Batch requests
     */
    batch: async function(requests) {
        try {
            const promises = requests.map(req => 
                this.request(req.endpoint, req.options)
            );
            return await Promise.all(promises);
        } catch (error) {
            console.error('Batch request error:', error);
            throw error;
        }
    }
};

// Default error interceptor
API.addResponseInterceptor((response) => {
    if (response.status === 401) {
        // Unauthorized - redirect to login
        window.location.href = '/login';
    } else if (response.status === 403) {
        // Forbidden
        if (window.Notifications) {
            Notifications.error('Access denied');
        }
    } else if (response.status >= 500) {
        // Server error
        if (window.Notifications) {
            Notifications.error('Server error. Please try again later.');
        }
    }
    return response;
});

// CSRF token interceptor
API.addRequestInterceptor((config) => {
    const csrfToken = document.querySelector('meta[name="csrf-token"]');
    if (csrfToken) {
        config.headers['X-CSRF-Token'] = csrfToken.getAttribute('content');
    }
    return config;
});

// Export
window.API = API;
