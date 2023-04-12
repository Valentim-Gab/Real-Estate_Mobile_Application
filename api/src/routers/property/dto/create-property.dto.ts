import { users } from '@prisma/client'
import { IsNotEmpty, IsNumber, IsObject, IsString } from 'class-validator'

export class CreatePropertyDto {
  @IsString()
  identifierName: string

  @IsString()
  ownerName: string

  @IsNumber()
  numberProperty: string

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

  @IsNotEmpty()
  @IsObject()
  user: users
}
