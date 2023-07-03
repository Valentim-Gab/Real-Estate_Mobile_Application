import { File } from 'multer';

export interface ImageSaveStrategy {
  save(multipartFile: File, id: number, lastDir: string): Promise<string>
}