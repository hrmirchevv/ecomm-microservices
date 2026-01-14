import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Address } from './address.entity';
import { Repository } from 'typeorm';
import { Customer } from 'src/customers/customer.entity';
import { CreateAddressDto } from './dto/create-address.dto';
import { UpdateAddressDto } from './dto/update-address.dto';

@Injectable()
export class AddressesService {
  constructor(
    @InjectRepository(Address)
    private addressRepo: Repository<Address>,
    @InjectRepository(Customer)
    private customerRepo: Repository<Customer>,
  ) {}

  async create(customerId: string, dto: CreateAddressDto) {
    const customer = await this.customerRepo.findOneBy({ id: customerId });

    if (!customer) throw new NotFoundException('Customer not found');

    const address = this.addressRepo.create({
      ...dto,
      customer,
    });

    return this.addressRepo.save(address);
  }

  findByCustomer(customerId: string) {
    return this.addressRepo.find({
      where: { customer: { id: customerId } },
    });
  }

  async update(customerId: string, addressId: string, dto: UpdateAddressDto) {
    const address = await this.addressRepo.findOne({
      where: {
        id: addressId,
        customer: { id: customerId },
      },
      relations: ['customer'],
    });

    if (!address) {
      throw new NotFoundException('Address not found for this customer');
    }

    Object.assign(address, dto);
    return this.addressRepo.save(address);
  }

  async remove(customerId: string, addressId: string) {
    const address = await this.addressRepo.findOne({
      where: {
        id: addressId,
        customer: { id: customerId },
      },
    });

    if (!address) {
      throw new NotFoundException('Address not found for this customer');
    }

    await this.addressRepo.remove(address);
    return { message: 'Address deleted!' };
  }
}
