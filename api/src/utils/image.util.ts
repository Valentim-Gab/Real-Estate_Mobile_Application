import { Injectable, InternalServerErrorException } from "@nestjs/common";
import { randomUUID } from "crypto";
import { Response } from "express";
import { createWriteStream } from "fs";
import { readdir, unlink, ensureDir, readFile } from "fs-extra";
import { File } from 'multer';
import { extname } from "path";

@Injectable()
export class ImageUtil {
  private readonly rootDirectory = 'src/resources/static'

  async save(multipartFile: File, id: number, lastDir: string): Promise<string> {
    const dir = `${this.rootDirectory}/${lastDir}`

    try {
      const filename = multipartFile.originalname
      const fileExternsion = extname(filename)
      const uuid = randomUUID()

      this.deleteImage(dir, id)

      const newFileName = `id=${id}-${lastDir}=${uuid}${fileExternsion}`
      await ensureDir(dir)
      
      const writeStream = createWriteStream(`${dir}/${newFileName}`)
      writeStream.write(multipartFile.buffer)
      writeStream.end()

      return newFileName
    } catch (error) {
      throw error
    }
  }

  async get(imgName: string, lastDir: string) {
    try {
      const dir = `${this.rootDirectory}/${lastDir}/${imgName}`
      const buffer = await readFile(dir)

      return Buffer.from(buffer)
    } catch (error) {
      throw error
    }
  }

  async deleteImage(dir: string, id: number) {
    const files = await readdir(dir)

    for (const image of files) {
      console.log(image)
      if (image.includes(`id=${id}`))
        await unlink (`${dir}/${image}`)
    }
  }
} 