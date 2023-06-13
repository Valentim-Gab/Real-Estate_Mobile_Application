import { users } from '@prisma/client'
import { Type } from 'class-transformer'
import { IsInt, IsNotEmpty, IsNumber, IsObject, IsString, ValidateNested } from 'class-validator'
import { CreateUserDto } from 'src/routers/user/dto/create-user.dto'

export class CreatePropertyDto {
  @IsString()
  identifierName: string

  @IsNumber()
  value: number

  @IsString()
  ownerName: string

  @IsInt()
  numberProperty: number

  @IsString()
  road: string

  @IsString()
  neighborhood: string

  @IsString()
  city: string

  @IsString()
  state: string

  @IsString()
  country: string

  @IsString()
  zipCode: string

  @IsString()
  description: string

  @IsString()
  typeUse: string

  @IsString()
  typeMarketing: string

  @IsInt()
  idRealEstateAgent: number

  @IsNotEmpty()
  @IsObject()
  user: users;
}
