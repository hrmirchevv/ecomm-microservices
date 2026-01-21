import { Module } from '@nestjs/common';
import { HttpModule } from '@nestjs/axios';
import { TypeOrmModule } from '@nestjs/typeorm';
import { SubscriptionsController } from './subscriptions.controller';
import { SubscriptionsService } from './subscriptions.service';
import { Subscription } from './subscription.entity';
import { PimService } from '../pim/pim.service';

@Module({
  imports: [TypeOrmModule.forFeature([Subscription]), HttpModule],
  controllers: [SubscriptionsController],
  providers: [SubscriptionsService, PimService],
})
export class SubscriptionsModule {}
