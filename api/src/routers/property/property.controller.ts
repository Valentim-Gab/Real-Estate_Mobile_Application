import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UseGuards,
  ParseIntPipe,
  UseInterceptors,
  UploadedFile,
  Res,
  ParseFilePipe,
  Req,
} from '@nestjs/common'
import { PropertyService } from './property.service'
import { CreatePropertyDto } from './dto/create-property.dto'
import { UpdatePropertyDto } from './dto/update-property.dto'
import { JwtAuthGuard } from 'src/security/guards/jwt-auth.guard'
import { ReqUser } from 'src/decorators/req-user.decorator'
import { users } from '@prisma/client'
import { ValidationPipe } from 'src/pipes/validation.pipe'
import { Role } from 'src/enums/Role'
import { FileInterceptor } from '@nestjs/platform-express'
import { Roles } from 'src/decorators/roles.decorator'
import { RolesGuard } from 'src/security/guards/roles.guard'
import { Response, Request } from 'express'
import { File } from 'multer';

@Controller('property')
export class PropertyController {
  constructor(private readonly propertyService: PropertyService) {}

  @Post()
  @UseInterceptors(FileInterceptor('image'))
  create(@Req() request: Request, @UploadedFile(ParseFilePipe) image: File) {
    const createPropertyDto: CreatePropertyDto = JSON.parse(request.body['property'])

    return this.propertyService.create(createPropertyDto, image)
  }

  @Get()
  findAll() {
    return this.propertyService.findAll()
  }

  @UseGuards(JwtAuthGuard)
  @Get('@me')
  findAllMe(@ReqUser() user: users) {
    return this.propertyService.findAllMe(user.id)
  }

  @Get(':id')
  findOne(@Param('id', ParseIntPipe) id: number) {
    return this.propertyService.findOne(id)
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.User, Role.Admin)
  @Get('main_img/:img')
  downloadImage(@Param('img') img: string, @Res() res: Response) {
    return this.propertyService.findImg(img, res)
  }

  @Patch(':id')
  @UseInterceptors(FileInterceptor('image'))
  update(
    @Param('id', ParseIntPipe) id: number,
    @Req() request: Request,
    @UploadedFile(ParseFilePipe) image: File
  ) {
    const updatePropertyDto: UpdatePropertyDto = JSON.parse(request.body['property'])

    return this.propertyService.update(id, updatePropertyDto, image)
  }

  @Delete(':id')
  delete(@Param('id', ParseIntPipe) id: number) {
    return this.propertyService.delete(id)
  }
}
