import { Injectable, OnModuleInit } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Customer } from '../customers/customer.entity';
import { Address } from '../addresses/address.entity';

@Injectable()
export class SeedService implements OnModuleInit {
  constructor(
    @InjectRepository(Customer)
    private customerRepo: Repository<Customer>,
    @InjectRepository(Address)
    private addressRepo: Repository<Address>,
  ) {}

  async onModuleInit() {
    const existing = await this.customerRepo.count();
    if (existing > 0) {
      return;
    }

    const customer = this.customerRepo.create({
      firstName: 'Jo',
      lastName: 'Jo',
      email: 'jo@test.com',
    });

    const savedCustomer = await this.customerRepo.save(customer);

    const addresses = this.addressRepo.create([
      {
        street: 'Main Street 1',
        city: 'Berlin',
        country: 'Germany',
        customer: savedCustomer,
      },
      {
        street: 'Second Street 5',
        city: 'Munich',
        country: 'Germany',
        customer: savedCustomer,
      },
    ]);

    await this.addressRepo.save(addresses);

    console.log('✅ Seed data created');
  }
}
