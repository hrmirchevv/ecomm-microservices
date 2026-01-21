import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Customer } from './customer.entity';
import { CreateCustomerDto } from './dto/create-customer.dto';
import { Repository } from 'typeorm';
import { UpdateCustomerDto } from './dto/update-customer.dto';

@Injectable()
export class CustomersService {
  constructor(
    @InjectRepository(Customer)
    private customerRepo: Repository<Customer>,
  ) {}

  create(dto: CreateCustomerDto) {
    const customer = this.customerRepo.create(dto);
    return this.customerRepo.save(customer);
  }

  findOne(id: string) {
    return this.customerRepo.findOne({
      where: { id },
      relations: ['addresses'],
    });
  }

  async update(id: string, dto: UpdateCustomerDto) {
    const customer = await this.customerRepo.findOneBy({ id });

    if (!customer) {
      throw new NotFoundException('Customer not found!');
    }

    Object.assign(customer, dto);
    return this.customerRepo.save(customer);
  }

  remove(id: string) {
    return this.customerRepo.delete(id);
  }

  findByEmail(email: string) {
    return this.customerRepo.findOne({
      where: { email },
      relations: ['addresses'],
    });
  }

  findAll() {
    return this.customerRepo.find({
      relations: ['addresses'],
    });
  }
}
