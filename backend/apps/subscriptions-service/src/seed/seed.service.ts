import { Injectable, OnModuleInit } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { HttpService } from '@nestjs/axios';
import { firstValueFrom } from 'rxjs';
import {
  Subscription,
  SubscriptionStatus,
} from '../subscriptions/subscription.entity';

@Injectable()
export class SeedService implements OnModuleInit {
  constructor(
    @InjectRepository(Subscription)
    private repo: Repository<Subscription>,
    private http: HttpService,
  ) {}

  async onModuleInit() {
    const existing = await this.repo.count();
    if (existing > 0) {
      return;
    }

    const res = await firstValueFrom(
      this.http.get('http://localhost:3000/customers'),
    );
    // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
    const customer = res.data[0];

    if (!customer) {
      throw new Error('No customer found for seeding subscriptions');
    }

    await this.repo.save({
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
      customerId: customer.id,
      sku: 'BASIC_PLAN',
      status: SubscriptionStatus.ACTIVE,
      startDate: new Date(),
    });

    // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
    console.log('✅ Subscription seeded for customer:', customer.id);
  }
}
