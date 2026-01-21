// src/types.ts
export interface Customer {
  id: string;
  firstName: string;
  lastName: string;
  email: string;
  addresses: Address[];
}

export interface Address {
  id: string;
  street: string;
  city: string;
  country: string;
}

export interface Subscription {
  id: string;
  sku: string;
  status: string;
}
