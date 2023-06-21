import { BadRequestException, Injectable } from '@nestjs/common'
import { Prisma, property, users } from '@prisma/client'
import { PrismaService } from 'nestjs-prisma'
import { CreatePropertyDto } from './dto/create-property.dto'
import { UpdatePropertyDto } from './dto/update-property.dto'
import { ErrorConstants } from 'src/constants/ErrorConstants'

@Injectable()
export class PropertyService {
  constructor(private prisma: PrismaService) {}

  create(createPropertyDto: CreatePropertyDto) {
    return this.performUserOperation('cadastrar', async () => {
      if (createPropertyDto.user) {
        const { user, ...propertyData } = createPropertyDto
  
        return this.prisma.property.create({
          data: { ...propertyData, users: { connect: { id: user.id } } },
          include: { users: true },
        })
      } else {
        return this.prisma.property.create({
          data: { ...createPropertyDto },
          include: { users: true },
        })
      }
    });
  }

  findAll() {
    return this.performUserOperation('receber', async () => {
      return this.prisma.property.findMany()
    })
  }

  findOne(id: number) {
    return this.performUserOperation('receber', async () => {
      return this.prisma.property.findFirst({ where: { id } })
    })
  }

  findAllMe(idAgent: number) {
    return this.performUserOperation('receber', async () => {
      return this.prisma.property.findMany({
        where: { id_real_estate_agent: idAgent },
        include: { users: true },
      })
    })
  }

  update(id: number, updatePropertyDto: UpdatePropertyDto) {
    return this.performUserOperation('receber', async () => {
      const { user, ...propertyData } = updatePropertyDto

      return this.prisma.property.update({
        where: { id },
        data: propertyData,
      })
    })
  }

  delete(id: number) {
    return this.performUserOperation('deletar', async () => {
      return this.prisma.property.delete({ where: { id },
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
      throw new BadRequestException(`Erro ao ${action} o imóvel`)
    }
  }
}
