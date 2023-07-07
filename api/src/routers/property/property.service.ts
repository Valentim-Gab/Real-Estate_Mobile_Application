import { BadRequestException, Injectable } from '@nestjs/common'
import { Prisma, property } from '@prisma/client'
import { PrismaService } from 'nestjs-prisma'
import { CreatePropertyDto } from './dto/create-property.dto'
import { UpdatePropertyDto } from './dto/update-property.dto'
import { ErrorConstants } from 'src/constants/ErrorConstants'
import { ImageUtil } from 'src/utils/image-util/image.util'
import { Response } from 'express'
import { CompressedImageSaveStrategy } from 'src/utils/image-util/strategies/compressed-image-save.strategy'
import { DefaultImageSaveStrategy } from 'src/utils/image-util/strategies/default-image-save.strategy'

@Injectable()
export class PropertyService {
  constructor(private prisma: PrismaService, private imageUtil: ImageUtil) {}

  async create(createPropertyDto: CreatePropertyDto, image: File) {
    let filename: string

    const newProperty = await this.performUserOperation('cadastrar', async () => {
      if (createPropertyDto.user) {
        const { user, ...propertyData } = createPropertyDto
        propertyData.img = filename
  
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

    if (newProperty.id && image) {
      const strategy =
      image.size > 1_000_000
        ? new CompressedImageSaveStrategy(this.imageUtil)
        : new DefaultImageSaveStrategy(this.imageUtil)

      this.imageUtil.setSaveStrategy(strategy)

      filename = await this.saveImg(image, newProperty.id)

      if (filename) {
        return this.updateImg(newProperty.id, filename)
      }
    }

    return null
  }

  async saveImg(image: File, id: number) {
    const filename = await this.imageUtil.save(image, id, 'property')

    return filename
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

  async findImg(img: string, res: Response) {
    try {
      const bytes =  await this.imageUtil.get(img, 'property')
      res.setHeader('Content-Type', 'image/*')
      res.send(bytes)
    } catch (error) {
      throw new BadRequestException(`Foto não encontrada`)
    }
  }

  async update(id: number, updatePropertyDto: UpdatePropertyDto, image: File) {
    const { user, ...propertyData } = updatePropertyDto
    const { img, ...propertyNoFileData } = propertyData

    if (image) {
      const strategy =
      image.size > 1_000_000
        ? new CompressedImageSaveStrategy(this.imageUtil)
        : new DefaultImageSaveStrategy(this.imageUtil)

      this.imageUtil.setSaveStrategy(strategy)
      
      propertyData.img = await this.saveImg(image, id)
    }

    return this.performUserOperation('atualizar', async () => {
      return this.prisma.property.update({
        where: { id },
        data: (image) ? propertyData : propertyNoFileData,
      })
    })
  }

  async updateImg(id: number, filename: string) {
    const propertyData: UpdatePropertyDto = {
      img: filename
    };
  
    return this.performUserOperation('receber', async () => {
      return this.prisma.property.update({
        where: { id },
        data: propertyData
      });
    });
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
