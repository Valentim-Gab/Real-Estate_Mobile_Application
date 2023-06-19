import { BadRequestException, Injectable } from '@nestjs/common'
import { CreateUserDto } from './dto/create-user.dto'
import { UpdateUserDto } from './dto/update-user.dto'
import { PrismaService } from 'nestjs-prisma'
import { BCryptService } from 'src/security/private/bcrypt.service'
import { Prisma, users } from '@prisma/client'
import { ErrorConstants } from 'src/constants/ErrorConstants'

@Injectable()
export class UserService {
  private selectColumns = {
    id: true,
    name: true,
    email: true,
    role: true,
  }

  constructor(private prisma: PrismaService, private bcrypt: BCryptService) {}

  async create(createUserDto: CreateUserDto) {
    return this.performUserOperation('cadastrar', async () => {
      const encryptPassword = await this.bcrypt.encryptPassword(createUserDto.password)
      const userDto = { ...createUserDto, password: encryptPassword, role: ['user'] }
  
      return this.prisma.users.create({ data: userDto, select: this.selectColumns })
    });
  }

  async findAll() {
    return await this.prisma.users.findMany({
      select: this.selectColumns
    });
  }

  async findOne(id: number) {
    return this.performUserOperation('receber', async () => {
      return this.prisma.users.findFirst({ where: { id }, select: this.selectColumns })
    })
  }

  findByEmail(email: string) {
    return this.performUserOperation('receber', async () => {
      return this.prisma.users.findFirst({ where: { email } })
    })
  }

  async update(id: number, updateUserDto: UpdateUserDto) {
    return this.performUserOperation('atualizar', async () => {
      const encryptPassword = await this.bcrypt.encryptPassword(updateUserDto.password)
      const userDto = { ...updateUserDto, password: encryptPassword, role: ['user'] }

      return this.prisma.users.update({ where: { id }, data: userDto, select: this.selectColumns})
    })
  }

  async delete(id: number) {
    return this.performUserOperation('deletar', async () => {
      return this.prisma.users.delete({ where: { id },
        select: {
          id: true,
        }
      })
    })
  }

  private async performUserOperation(action: string, operation: () => Promise<any>) {
    try {
      return await this.prisma.$transaction(async () => {
        return await operation()
      })
    } catch (error) {
      if (error instanceof Prisma.PrismaClientKnownRequestError && error.code === ErrorConstants.UNIQUE_VIOLATED) {
        let uniqueColumn = error.meta.target[0]
        throw new BadRequestException(`Campo ${uniqueColumn} em uso!`)
      }
      throw new BadRequestException(`Erro ao ${action} o usuário`)
    }
  }
}
