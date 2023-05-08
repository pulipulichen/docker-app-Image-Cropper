const ShellSpawn = require('./app/lib/ShellExec')
// const ShellSpawn = require('./app/lib/ShellSpawn')
const GetExistedArgv = require('./app/lib/GetExistedArgv')
const SetDockerComposeYML = require('./app/lib/SetDockerComposeYML')

// const dialog = require('node-file-dialog')

const fs = require('fs')
const path = require('path')

let main = async function () {
  // 1. 先取得輸入檔案的列表
  let files = GetExistedArgv()

  // console.log('gogogo', files)
  for (let i = 0; i < files.length; i++) {
    let file = files[i]

		// ------------

		// let filename = path.basename(file)
		// let dirname = path.dirname(file)
		// let tempFilename = Math.floor(Math.random() * 100000) + '.zip'
		
		// let tempFilePath = path.resolve(dirname, tempFilename)
		// // console.log(tempFilePath)
		// // console.log(path.resolve(dirname, filename.slice(0, -4) + '.txt'))

		// fs.renameSync(file, tempFilePath)

		// ------------
    
    // SetDockerComposeYML(tempFilePath)
    // console.log(file)
		SetDockerComposeYML(file)
		// console.log(file)
		
		// await ShellSpawn('pwd')
		// await ShellSpawn('ls -la')
		// await ShellSpawn('echo $USER')
		// await ShellSpawn('systemctl --user status docker.service')
		// await ShellSpawn('which docker-compose')

    // await ShellSpawn('docker-compose up')
		await ShellSpawn('docker-compose up')

		// --------------
 
		// fs.renameSync(tempFilePath, file)
		// if (fs.existsSync(path.resolve(dirname, tempFilename.slice(0, -4)) + '.pdf')) {
		// 	fs.renameSync(path.resolve(dirname, tempFilename.slice(0, -4)) + '.pdf', path.resolve(dirname, filename.slice(0, -4)) + '.pdf')
		// }
  }

}

main()
