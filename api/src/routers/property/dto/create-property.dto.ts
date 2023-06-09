import { users } from '@prisma/client'
import { IsInt, IsNotEmpty, IsNumber, IsObject, IsString } from 'class-validator'

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

  @IsString()
  img: string

  @IsNotEmpty()
  @IsObject()
  user: users;
}
