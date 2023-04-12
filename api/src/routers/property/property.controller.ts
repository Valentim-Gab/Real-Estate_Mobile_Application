import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  Request,
  Header,
  Headers,
} from '@nestjs/common'
import { PropertyService } from './property.service'
import { CreatePropertyDto } from './dto/create-property.dto'
import { UpdatePropertyDto } from './dto/update-property.dto'
import { IncomingHttpHeaders } from 'http2'

@Controller('property')
export class PropertyController {
  constructor(private readonly propertyService: PropertyService) {}

  @Post()
  create(@Body() createPropertyDto: CreatePropertyDto) {
    return this.propertyService.create(createPropertyDto)
  }

  @Get()
  findAll() {
    return this.propertyService.findAll()
  }

  @Get('@me')
  findAllMe(@Headers() headers: IncomingHttpHeaders) {
    const [type, token] = headers.authorization?.split(' ') ?? []
    console.log(type === 'Bearer' ? token : undefined)
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.propertyService.findOne(+id)
  }

  @Patch(':id')
  update(
    @Param('id') id: string,
    @Body() updatePropertyDto: UpdatePropertyDto,
  ) {
    return this.propertyService.update(+id, updatePropertyDto)
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.propertyService.remove(+id)
  }
}
