import { fileIo } from '@kit.CoreFileKit'

export class FileOperate {
  // 创建一个文件 并返回路径
  static createAudioFile(userId: string) {
    // 判断有无路径,没有就创建
    let dirPath = getContext().filesDir + '/' + userId
    let flag = fileIo.accessSync(dirPath)
    if (!flag) {
      fileIo.mkdirSync(dirPath)
    }
    //每个用户的文件隔离，方便删除
    let filePath = dirPath + '/' + Date.now() + '.wav'
    const file = fileIo.openSync(filePath, fileIo.OpenMode.CREATE)
    fileIo.closeSync(file)
    return filePath // 创建文件
  }
  // 删除某个文件
  static delFilePath(filePath: string) {
    if (filePath) {
      fileIo.unlinkSync(filePath)
    }
  }
  // 删除整个人的目录
  static delUserPath(userId: string) {
    if (userId) {
      let dirPath = getContext().filesDir + '/' + userId
      let flag = fileIo.accessSync(dirPath)
      if (flag) {
        fileIo.rmdirSync(dirPath)
      }
    }
  }
}