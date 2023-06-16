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
} from '@nestjs/common'
import { PropertyService } from './property.service'
import { CreatePropertyDto } from './dto/create-property.dto'
import { UpdatePropertyDto } from './dto/update-property.dto'
import { JwtAuthGuard } from 'src/security/guards/jwt-auth.guard'
import { ReqUser } from 'src/decorators/req-user.decorator'
import { users } from '@prisma/client'
import { ValidationPipe } from 'src/pipes/validation.pipe'

@Controller('property')
export class PropertyController {
  constructor(private readonly propertyService: PropertyService) {}

  @Post()
  create(@Body(new ValidationPipe()) createPropertyDto: CreatePropertyDto) {
    return this.propertyService.create(createPropertyDto)
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

  @Patch(':id')
  update(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ValidationPipe()) updatePropertyDto: UpdatePropertyDto,
  ) {
    return this.propertyService.update(id, updatePropertyDto)
  }

  @Delete(':id')
  remove(@Param('id', ParseIntPipe) id: number) {
    return this.propertyService.remove(id)
  }
}
