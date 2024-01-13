const ShellSpawn = require('./lib/ShellSpawn')
const ShellExec = require('./lib/ShellExec')
const GetFiles = require('./lib/GetFiles')

const path = require('path')
const fs = require('fs')

// convert a.tif -thumbnail 64x64^ -gravity center -extent 64x64 b.ico

let main = async function () {
  let files = GetFiles()
  for (let i = 0; i < files.length; i++) {
    let file = files[i]
    
    let filename = path.basename(file)
    let dirname = path.dirname(file)
    let filenameNoExt = path.parse(filename).name
    let ext = path.extname(filename)
    let isJPG = false

    console.log({ext, file})
    if (ext === '.pdf') {
      await ShellExec(`pdftoppm "${file}" "${filenameNoExt}" -png`)
      file = `${filenameNoExt}-1.png`
      ext = '.png'
    }

    if (ext === '.jpg' || ext === '.jpeg') { 
      isJPG = true
    }

    if (ext === '.jpg' || ext === '.jpeg' || ext === '.webp') { 
      ext = '.png'
    }

    // await ShellExec(`convert "${file}" -trim +repage "${path.resolve(dirname, filenameNoExt + '-cropped.' +ext)}"`)
    // await ShellExec(`convert "${file}" -transparent white -trim +repage "${path.resolve(dirname, filenameNoExt + '-cropped.' +ext)}"`)

    // let channels = await ShellExec(`identify -format '%[channels]' "${file}"`)
    let channels = '0'
    if (isJPG === false) {
      channels = await ShellExec(`convert "${file}" -channel a -separate -format "%[fx:mean]" info:`)
    }
    else {
      channels = '1'
    }
      

    // fs.writeFileSync(file + '-channels.txt', channels, 'utf8')
    // if (channels.indexOf('a') > -1) {
    dirname = '/output/'
    if (channels !== '1') {
      // await ShellExec(`convert "${file}" -alpha set -bordercolor transparent -border 1 -fill none -fuzz 3% -draw "color 0,0 floodfill" -shave 1x1 -trim +repage "${path.resolve(dirname, filenameNoExt + '-cropped' +ext)}"`)
      console.log(`convert "${file}" -trim +repage "${path.resolve(dirname, filenameNoExt + '-cropped' +ext)}"`)
      await ShellExec(`convert "${file}" -trim +repage "${path.resolve(dirname, filenameNoExt + '-cropped' +ext)}"`)
    }
    else {
      await ShellExec(`convert "${file}" -alpha set -bordercolor white -border 1 -fill none -fuzz 2% -draw "color 0,0 floodfill" -shave 1x1 -fuzz 5% -trim +repage "${path.resolve(dirname, filenameNoExt + '-cropped' +ext)}"`)
    }
    // convert -gravity center "c.png" -flatten -fuzz 1% -trim +repage -resize 64x64 -extent 64x64 "b.ico"
  }
}

main()