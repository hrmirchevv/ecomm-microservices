import { Injectable } from "@nestjs/common";

@Injectable()
export class PimService {
  private readonly subscriptions = ['BASIC', 'PRO', 'ENTERPRISE'];

  isValidSku(sub: string): boolean {
    return this.subscriptions.includes(sub);
  }

  listSkus() {
    return this.subscriptions;
  }
}
