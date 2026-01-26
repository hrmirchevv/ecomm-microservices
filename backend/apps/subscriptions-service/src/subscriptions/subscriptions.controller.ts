import { Controller, Post, Body, Get, Param, Delete } from "@nestjs/common";
import { CreateSubscriptionDto } from "./dto/create-subscription.dto";
import { SubscriptionsService } from "./subscriptions.service";

@Controller('subscriptions')
export class SubscriptionsController {
  constructor(private readonly service: SubscriptionsService) {}

  @Post()
  create(@Body() dto: CreateSubscriptionDto) {
    return this.service.create(dto);
  }

  @Get('customer/:customerId')
  findByCustomer(@Param('customerId') customerId: string) {
    return this.service.findByCustomer(customerId);
  }

  @Delete(':id')
  cancel(@Param('id') id: string) {
    return this.service.cancel(id);
  }

  @Get('test')
  sayHi() {
    return 'Hi!';
  }
}
