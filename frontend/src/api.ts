// src/api.ts
export const fetchCustomerByEmail = async (email: string) => {
  const url = `${import.meta.env.VITE_CUSTOMERS_API}/customers?email=${email}`;
  const res = await fetch(url);
  if (!res.ok) throw new Error('Customer not found');
  return res.json();
};

export const fetchSubscriptionsByCustomer = async (customerId: string) => {
  const url = `${import.meta.env.VITE_SUBSCRIPTIONS_API}/subscriptions/customer/${customerId}`;
  const res = await fetch(url);
  if (!res.ok) throw new Error('Failed to fetch subscriptions');
  return res.json();
};
