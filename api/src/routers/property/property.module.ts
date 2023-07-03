import { Module } from '@nestjs/common'
import { PropertyService } from './property.service'
import { PropertyController } from './property.controller'
import { PrismaService } from 'nestjs-prisma'
import { ImageUtil } from 'src/utils/image-util/image.util'

@Module({
  controllers: [PropertyController],
  providers: [PropertyService, PrismaService, ImageUtil],
})
export class PropertyModule {}
