import { Injectable } from '@nestjs/common'
import { property, users } from '@prisma/client'
import { PrismaService } from 'nestjs-prisma'
import { CreatePropertyDto } from './dto/create-property.dto'
import { UpdatePropertyDto } from './dto/update-property.dto'

@Injectable()
export class PropertyService {
  constructor(private prisma: PrismaService) {}

  create(createPropertyDto: CreatePropertyDto) {
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
  }

  findAll() {
    return this.prisma.property.findMany()
  }

  findOne(id: number) {
    return this.prisma.property.findFirst({ where: { id } })
  }

  findAllMe(idAgent: number) {
    return this.prisma.property.findMany({
      where: { id_real_estate_agent: idAgent },
      include: { users: true },
    })
  }

  update(id: number, updatePropertyDto: UpdatePropertyDto) {
    const { user, ...propertyData } = updatePropertyDto

    return this.prisma.property.update({
      where: { id },
      data: propertyData,
    })
  }

  remove(id: number) {
    return this.prisma.property.delete({ where: { id } })
  }
}
