import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Post,
  Put,
} from '@nestjs/common';
import { AddressesService } from './addresses.service';
import { CreateAddressDto } from './dto/create-address.dto';
import { UpdateAddressDto } from './dto/update-address.dto';

@Controller('customers/:customerId/addresses')
export class AddressesController {
  constructor(private readonly service: AddressesService) {}

  @Post()
  create(
    @Param('customerId') customerId: string,
    @Body() dto: CreateAddressDto,
  ) {
    return this.service.create(customerId, dto);
  }

  @Get()
  findAll(@Param('customerId') customerId: string) {
    return this.service.findByCustomer(customerId);
  }

  @Put(':addressId')
  update(
    @Param('customerId') customerId: string,
    @Param('addressId') addressId: string,
    @Body() dto: UpdateAddressDto,
  ) {
    return this.service.update(customerId, addressId, dto);
  }

  @Delete(':addressId')
  remove(
    @Param('customerId') customerId: string,
    @Param('addressId') addressId: string,
  ) {
    return this.service.remove(customerId, addressId);
  }
}
