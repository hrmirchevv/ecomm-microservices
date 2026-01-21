import { useState } from 'react';
import type { Customer, Subscription } from './types';
import { Login } from './login';

function App() {
  const [customer, setCustomer] = useState<Customer | null>(null);
  const [subscriptions, setSubscriptions] = useState<Subscription[]>([]);

  if (!customer) {
    return <Login onLoginData={(cust, subs) => { setCustomer(cust); setSubscriptions(subs); }} />;
  }

  return (
    <div>
      <h2>Welcome, {customer.firstName} {customer.lastName}</h2>
      <p>Email: {customer.email}</p>

      <h3>Addresses:</h3>
      <ul>
        {customer.addresses.map(a => (
          <li key={a.id}>{a.street}, {a.city}, {a.country}</li>
        ))}
      </ul>

      <h3>Subscriptions:</h3>
      <ul>
        {subscriptions.map(s => (
          <li key={s.id}>{s.sku} - {s.status}</li>
        ))}
      </ul>
    </div>
  );
}

export default App;
