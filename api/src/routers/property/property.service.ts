import { Injectable } from '@nestjs/common'
import { users } from '@prisma/client'
import { PrismaService } from 'nestjs-prisma'
import { CreatePropertyDto } from './dto/create-property.dto'
import { UpdatePropertyDto } from './dto/update-property.dto'

@Injectable()
export class PropertyService {
  constructor(private prisma: PrismaService) {}

  create(createPropertyDto: CreatePropertyDto) {
    return this.prisma.property.create({ data: createPropertyDto })
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
    })
  }

  update(id: number, updatePropertyDto: UpdatePropertyDto) {
    return this.prisma.property.update({
      where: { id },
      data: updatePropertyDto,
    })
  }

  remove(id: number) {
    return this.prisma.property.delete({ where: { id } })
  }
}
