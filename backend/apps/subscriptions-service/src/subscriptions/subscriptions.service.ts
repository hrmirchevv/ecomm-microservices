import { Injectable, BadRequestException, NotFoundException } from "@nestjs/common";
import { InjectRepository } from "@nestjs/typeorm";
import { PimService } from "src/pim/pim.service";
import { Repository } from "typeorm";
import { CreateSubscriptionDto } from "./dto/create-subscription.dto";
import { Subscription, SubscriptionStatus } from "./subscription.entity";

@Injectable()
export class SubscriptionsService {
  constructor(
    @InjectRepository(Subscription)
    private repo: Repository<Subscription>,
    private readonly pimService: PimService,
  ) {}

  async create(dto: CreateSubscriptionDto) {
    if (!this.pimService.isValidSku(dto.sku)) {
      throw new BadRequestException('Invalid subscription!');
    }

    const subscription = this.repo.create({
      customerId: dto.customerId,
      sku: dto.sku,
      startDate: new Date(),
    });

    return this.repo.save(subscription);
  }

  findByCustomer(customerId: string) {
    return this.repo.find({ where: { customerId } });
  }

  async cancel(id: string) {
    const subscription = await this.repo.findOneBy({ id });

    if (!subscription) {
      throw new NotFoundException('Subscription not found!');
    }

    subscription.status = SubscriptionStatus.CANCELED;
    subscription.endDate = new Date();

    return this.repo.save(subscription);
  }
}
