import { Injectable } from "@nestjs/common";
import { JwtService } from "@nestjs/jwt";
import { InjectRepository } from "@nestjs/typeorm";
import { User } from "../users/user.entity";
import { Repository } from "typeorm";

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(User)
    private userRepo: Repository<User>,
    private jwtService: JwtService,
  ) {}

  async loginWithGoogle(googleUser: any) {
    let user: any = await this.userRepo.findOne({
      where: { googleId: googleUser.googleId },
    });

    if (!user) {
      const newUser = this.userRepo.create(googleUser);
      user = await this.userRepo.save(newUser);
    }

    const payload = {
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
      sub: user.id,
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
      email: user.email,
    };

    return {
      access_token: this.jwtService.sign(payload),
    };
  }
}
