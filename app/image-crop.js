const ShellSpawn = require('./lib/ShellSpawn')
const ShellExec = require('./lib/ShellExec')
const GetExistedArgv = require('./lib/GetExistedArgv')

const path = require('path')
const fs = require('fs')

// convert a.tif -thumbnail 64x64^ -gravity center -extent 64x64 b.ico

let main = async function () {
  let files = GetExistedArgv()
  for (let i = 0; i < files.length; i++) {
    let file = files[i]
    
    let filename = path.basename(file)
    let dirname = path.dirname(file)
    let filenameNoExt = path.parse(filename).name
    let ext = path.extname(filename)

    await ShellExec(`convert -gravity center "${file}" -fuzz 1% -trim +repage "${path.resolve(dirname, filenameNoExt + '-cropped.' +ext)}"`)
    // convert -gravity center "c.png" -flatten -fuzz 1% -trim +repage -resize 64x64 -extent 64x64 "b.ico"
  }
}

main()