import { Module } from '@nestjs/common'
import { UserService } from './user.service'
import { UserController } from './user.controller'
import { PrismaService } from 'nestjs-prisma'
import { BCryptService } from 'src/security/private/bcrypt.service'

@Module({
  controllers: [UserController],
  providers: [UserService, PrismaService, BCryptService],
  exports: [UserService],
})
export class UserModule {}
