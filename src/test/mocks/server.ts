import { setupServer } from 'msw/node';
import { http, HttpResponse } from 'msw';

// Mock API handlers
export const handlers = [
  // Health check endpoint
  http.get('/api/health', () => {
    return HttpResponse.json({ status: 'ok' });
  }),
  
  // Authentication endpoints
  http.post('/api/auth/login', async ({ request }) => {
    const body = await request.json() as { email?: string; password?: string };
    // Mock successful login
    return HttpResponse.json({
      success: true,
      token: 'mock-jwt-token',
      user: { id: 'test-user-id', email: body?.email || 'test@example.com' }
    });
  }),
  
  http.post('/api/auth/logout', () => {
    return HttpResponse.json({ success: true });
  }),
  
  // Add more API mocks as needed
];

export const server = setupServer(...handlers);
