import { FilesDestinationConstants } from "src/constants/files-destination.constants";
import { ImageSaveStrategy } from "src/interfaces/ImageSaveStrategy";
import { randomUUID } from "crypto";
import { createWriteStream } from "fs";
import { ensureDir } from "fs-extra";
import { File } from 'multer';
import { extname } from "path";
import { ImageUtil } from "../image.util";
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
      const newFileName = `id=${id}-${lastDir}=${uuid}${fileExternsion}`

      this.imageUtil.deleteImage(dir, id)      
      await ensureDir(dir)
      
      const writeStream = createWriteStream(`${dir}/${newFileName}`)
      
      writeStream.write(multipartFile.buffer)
      writeStream.end()
      this.compressImage(`${dir}/${newFileName}`)

      return newFileName
    } catch (error) {
      throw error
    }
  }

  async compressImage(imagePath: string): Promise<void> {
    try {
      const rootDirectory = 'src\\utils\\python\\dist'
      const command = `${rootDirectory}\\compressImage.exe ${imagePath}`
  
      await new Promise<void>((resolve, reject) => {
        exec(command, (error, stdout, stderr) => {
          if (error)
            reject(new Error('Erro ao comprimir a imagem.'))
          else
            resolve()
        })
      })
    } catch (error) {
      throw error
    }
  }
}