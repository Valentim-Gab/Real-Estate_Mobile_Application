import { FilesDestinationConstants } from "src/constants/files-destination.constants";
import { ImageSaveStrategy } from "src/interfaces/ImageSaveStrategy";
import { Injectable } from "@nestjs/common";
import { randomUUID } from "crypto";
import { createWriteStream } from "fs";
import { ensureDir } from "fs-extra";
import { File } from 'multer';
import { extname } from "path";
import { ImageUtil } from "../image.util";

@Injectable()
export class DefaultImageSaveStrategy implements ImageSaveStrategy {
  private readonly rootDirectory = FilesDestinationConstants.rootDirectory
  
  constructor(private imageUtil: ImageUtil) {}

  async save(multipartFile: File, id: number, lastDir: string): Promise<string> {
    const dir = `${this.rootDirectory}/${lastDir}`

    try {
      const filename = multipartFile.originalname
      const fileExternsion = extname(filename)
      const uuid = randomUUID()
      const newFileName = `id=${id}-${lastDir}=${uuid}${fileExternsion}`

      this.imageUtil.deleteImage(dir, id)      
      await ensureDir(dir)
      
      const writeStream = createWriteStream(`${dir}/${newFileName}`)
      
      writeStream.write(multipartFile.buffer)
      writeStream.end()

      return newFileName
    } catch (error) {
      throw error
    }
  }
}