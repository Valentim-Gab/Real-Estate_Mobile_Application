import { Injectable } from "@nestjs/common";
import { readdir, unlink, readFile } from "fs-extra";
import { File } from 'multer';
import { FilesDestinationConstants } from "src/constants/files-destination.constants";
import { ImageSaveStrategy } from "src/interfaces/ImageSaveStrategy";
import { DefaultImageSaveStrategy } from "./strategies/default-image-save.strategy";
import * as path from 'path'

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
      const dir = path.join(this.rootDirectory, lastDir, imgName)
      const buffer = await readFile(dir)

      return Buffer.from(buffer)
    } catch (error) {
      throw error
    }
  }

  async deleteImage(dir: string, id: number): Promise<void> {
    try {
      const files = await readdir(dir)
      const filesToDelete = files.filter(image => image.includes(`id=${id}`))

      for (const image of filesToDelete) {
        const imagePath = path.join(dir, image)
        await unlink(imagePath)
      }
    } catch (error) {
      console.error('Error deleting images:', error)
    }
  }
} 