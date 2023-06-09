import { BadRequestException, Injectable } from '@nestjs/common'
import { CreateUserDto } from './dto/create-user.dto'
import { UpdateUserDto } from './dto/update-user.dto'
import { PrismaService } from 'nestjs-prisma'
import { BCryptService } from 'src/security/private/bcrypt.service'
import { Prisma, users } from '@prisma/client'
import { ErrorConstants } from 'src/constants/ErrorConstants'
import { ImageUtil } from 'src/utils/image-util/image.util'
import { Response } from 'express'
import { CompressedImageSaveStrategy } from 'src/utils/image-util/strategies/compressed-image-save.strategy'
import { DefaultImageSaveStrategy } from 'src/utils/image-util/strategies/default-image-save.strategy'

@Injectable()
export class UserService {
  private selectColumns = {
    id: true,
    name: true,
    email: true,
    role: true,
    img: true,
  }

  constructor(
    private prisma: PrismaService,
    private bcrypt: BCryptService,
    private imageUtil: ImageUtil,
  ) {}

  async create(createUserDto: CreateUserDto) {
    return this.performUserOperation('cadastrar', async () => {
      const encryptPassword = await this.bcrypt.encryptPassword(
        createUserDto.password,
      )
      const userDto = {
        ...createUserDto,
        password: encryptPassword,
        role: ['user'],
      }

      return this.prisma.users.create({
        data: userDto,
        select: this.selectColumns,
      })
    })
  }

  async findAll() {
    return this.performUserOperation('receber', async () => {
      return await this.prisma.users.findMany({
        select: this.selectColumns,
      })
    })
  }

  async findOne(id: number) {
    return this.performUserOperation('receber', async () => {
      return this.prisma.users.findFirst({
        where: { id },
        select: this.selectColumns,
      })
    })
  }

  async findImg(user: users, res: Response) {
    user = await this.findOne(user.id)

    try {
      const bytes = await this.imageUtil.get(user.img, 'user')
      res.setHeader('Content-Type', 'image/*')
      res.send(bytes)
    } catch (error) {
      throw new BadRequestException(`Foto não encontrada`)
    }
  }

  findByEmail(email: string) {
    return this.performUserOperation('receber', async () => {
      return this.prisma.users.findFirst({ where: { email } })
    })
  }

  async update(id: number, updateUserDto: UpdateUserDto) {
    return this.performUserOperation('atualizar', async () => {
      const encryptPassword = await this.bcrypt.encryptPassword(
        updateUserDto.password,
      )
      const userDto = {
        ...updateUserDto,
        password: encryptPassword,
        role: ['user'],
      }

      return this.prisma.users.update({
        where: { id },
        data: userDto,
        select: this.selectColumns,
      })
    })
  }

  async updateImg(image: File, user: users) {
    const { id } = user
    const strategy =
      image.size > 1_000_000
        ? new CompressedImageSaveStrategy(this.imageUtil)
        : new DefaultImageSaveStrategy(this.imageUtil)

    this.imageUtil.setSaveStrategy(strategy)

    const filename = await this.imageUtil.save(image, id, 'user')
    const userUpdate = { img: filename }

    return this.performUserOperation('atualizar', async () => {
      return this.prisma.users.update({
        where: { id: user.id },
        data: userUpdate,
        select: this.selectColumns,
      })
    })
  }

  async delete(id: number) {
    return this.performUserOperation('deletar', async () => {
      return this.prisma.users.delete({
        where: { id },
        select: {
          id: true,
        },
      })
    })
  }

  private async performUserOperation(
    action: string,
    operation: () => Promise<any>,
  ) {
    try {
      return await this.prisma.$transaction(async () => {
        return await operation()
      })
    } catch (error) {
      if (
        error instanceof Prisma.PrismaClientKnownRequestError &&
        error.code === ErrorConstants.UNIQUE_VIOLATED
      ) {
        let uniqueColumn = error.meta.target[0]
        throw new BadRequestException(`Campo ${uniqueColumn} em uso!`)
      }
      throw new BadRequestException(`Erro ao ${action} o usuário`)
    }
  }
}
