import { Module } from '@nestjs/common'
import { PropertyService } from './property.service'
import { PropertyController } from './property.controller'
import { PrismaService } from 'nestjs-prisma'

@Module({
  controllers: [PropertyController],
  providers: [PropertyService, PrismaService],
})
export class PropertyModule {}
