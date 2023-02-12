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
    if (ext === '.jpg' || ext === '.jpeg') {
      ext = '.png'
    }

    // await ShellExec(`convert "${file}" -trim +repage "${path.resolve(dirname, filenameNoExt + '-cropped.' +ext)}"`)
    // await ShellExec(`convert "${file}" -transparent white -trim +repage "${path.resolve(dirname, filenameNoExt + '-cropped.' +ext)}"`)
    await ShellExec(`convert "${file}"  -alpha set -bordercolor white -border 1 -fill none -fuzz 3% -draw "color 0,0 floodfill" -shave 1x1 -trim +repage "${path.resolve(dirname, filenameNoExt + '-cropped' +ext)}"`)
    // convert -gravity center "c.png" -flatten -fuzz 1% -trim +repage -resize 64x64 -extent 64x64 "b.ico"
  }
}

main()