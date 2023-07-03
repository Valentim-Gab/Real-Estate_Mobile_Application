import { FilesDestinationConstants } from "src/constants/files-destination.constants";
import { ImageSaveStrategy } from "src/interfaces/ImageSaveStrategy";
import { randomUUID } from "crypto";
import { createWriteStream } from "fs";
import { ensureDir } from "fs-extra";
import { File } from 'multer';
import { extname } from "path";
import { ImageUtil } from "../image.util";
import { promisify } from "util";
import { exec } from "child_process";


export class CompressedImageSaveStrategy implements ImageSaveStrategy {
  private readonly rootDirectory = FilesDestinationConstants.rootDirectory
  
  constructor(private imageUtil: ImageUtil) {}

  async save(multipartFile: File, id: number, lastDir: string): Promise<string> {
    console.log('Comprimir imagem')
    const dir = `${this.rootDirectory}/${lastDir}`

    try {
      const filename = multipartFile.originalname
      const fileExternsion = extname(filename)
      const uuid = randomUUID()

      this.imageUtil.deleteImage(dir, id)

      const newFileName = `id=${id}-${lastDir}=${uuid}${fileExternsion}`
      await ensureDir(dir)
      const fileAbsolutePath = `${dir}/${newFileName}`
      
      const writeStream = createWriteStream(fileAbsolutePath)
      writeStream.write(multipartFile.buffer)
      writeStream.end()
      this.compressImage(fileAbsolutePath)

      return newFileName
    } catch (error) {
      throw error
    }
  }

  async compressImage(imagePath: string): Promise<void> {
    try {
      const rootDirectory = 'src/main/java/site/my/planet/util/python/dist'
      const execPromise = promisify(exec)
      await execPromise(`${rootDirectory}/compressImage.exe ${imagePath}`)
    } catch (error) {
      throw new Error('Erro ao comprimir a imagem.')
    }
  }
}