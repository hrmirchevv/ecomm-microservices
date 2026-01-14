import { Controller, Post, Body, Get } from '@nestjs/common';
import { AuthService } from './auth.service';
import { GoogleAuthService } from './google-auth.service';

@Controller('auth')
export class AuthController {
  constructor(
    private googleAuth: GoogleAuthService,
    private authService: AuthService,
  ) {}

  @Post('google')
  async googleLogin(@Body('token') token: string) {
    const googleUser = await this.googleAuth.verify(token);
    return this.authService.loginWithGoogle(googleUser);
  }

  @Get()
  hi() {
    return 'hi';
  }
}
