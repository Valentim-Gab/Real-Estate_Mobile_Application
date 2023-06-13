import { Injectable } from '@nestjs/common'
import { CreateUserDto } from './dto/create-user.dto'
import { UpdateUserDto } from './dto/update-user.dto'
import { PrismaService } from 'nestjs-prisma'
import { BCryptService } from 'src/security/private/bcrypt.service'

@Injectable()
export class UserService {
  constructor(private prisma: PrismaService, private bcrypt: BCryptService) {}

  async create(createUserDto: CreateUserDto) {
    createUserDto.password = await this.bcrypt.encryptPassword(
      createUserDto.password,
    )
    createUserDto.role = ['user'];
    return this.prisma.users.create({ data: createUserDto })
  }

  findAll() {
    return this.prisma.users.findMany()
  }

  findOne(id: number) {
    return this.prisma.users.findFirst({ where: { id } })
  }

  findByEmail(email: string) {
    return this.prisma.users.findFirst({ where: { email } })
  }

  update(id: number, updateUserDto: UpdateUserDto) {
    return this.prisma.users.update({ where: { id }, data: updateUserDto })
  }

  remove(id: number) {
    return this.prisma.users.delete({ where: { id } })
  }
}
