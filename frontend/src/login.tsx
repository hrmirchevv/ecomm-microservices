// src/Login.tsx
import { useState } from 'react';
import { fetchCustomerByEmail, fetchSubscriptionsByCustomer } from './api';
import type { Customer, Subscription } from './types';

interface LoginProps {
  onLoginData: (customer: Customer, subscriptions: Subscription[]) => void;
}

export const Login = ({ onLoginData }: LoginProps) => {
  const [email, setEmail] = useState('');

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const customer: Customer = await fetchCustomerByEmail(email);
      const subscriptions: Subscription[] = await fetchSubscriptionsByCustomer(customer.id);
      onLoginData(customer, subscriptions);
    } catch (err) {
      console.error(err);
      alert('Login failed: ' + (err as Error).message);
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <input
        type="email"
        placeholder="Enter your email"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        required
      />
      <button type="submit">Login</button>
    </form>
  );
};
