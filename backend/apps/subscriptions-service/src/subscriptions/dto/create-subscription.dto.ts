import { IsUUID, IsNotEmpty } from 'class-validator';

export class CreateSubscriptionDto {
  @IsUUID()
  customerId: string;

  @IsNotEmpty()
  sku: string;
}
