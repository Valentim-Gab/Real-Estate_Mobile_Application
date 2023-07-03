import { Injectable, InternalServerErrorException } from "@nestjs/common";
import { randomUUID } from "crypto";
import { Response } from "express";
import { createWriteStream } from "fs";
import { readdir, unlink, ensureDir, readFile } from "fs-extra";
import { File } from 'multer';
import { extname } from "path";
import { FilesDestinationConstants } from "src/constants/files-destination.constants";
import { ImageSaveStrategy } from "src/interfaces/ImageSaveStrategy";
import { DefaultImageSaveStrategy } from "./strategies/default-image-save.strategy";

@Injectable()
export class ImageUtil {
  private readonly rootDirectory = FilesDestinationConstants.rootDirectory
  private saveStrategy: ImageSaveStrategy

  constructor() {
    this.saveStrategy = new DefaultImageSaveStrategy(this)
  }

  setSaveStrategy(strategy: ImageSaveStrategy) {
    this.saveStrategy = strategy
  }

  async save(multipartFile: File, id: number, lastDir: string): Promise<string> {
    return this.saveStrategy.save(multipartFile, id, lastDir);
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