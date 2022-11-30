// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
// import "@hotwired/turbo-rails"
// import 'controllers'

import 'flowbite'
import jQuery from 'jquery'
window.$ = window.jQuery = jQuery

$('form').on('submit', function (event) {
  $(this).find('button[type=submit]').prop('disabled', true)
  $(this).find('button[type=submit]').html('Please wait...')
})

var fileSelect = document.getElementById('dropzone-file')
var fileDrag = document.getElementById('file-drag')
var body = document.getElementById('body')

fileSelect.addEventListener('change', fileSelectHandler, false)

// File Drop
fileDrag.addEventListener('dragover', fileDragHover, false)
fileDrag.addEventListener('dragleave', fileDragHover, false)
fileDrag.addEventListener('drop', fileSelectHandler, false)

function fileDragHover(e) {
  document.getElementById('upload-btn').setAttribute('disabled', true)
  document.getElementById('response').classList.add('hidden')
  output('')
  e.stopPropagation()
  e.preventDefault()
}

function fileSelectHandler(e) {
  // Fetch FileList object
  var files = e.target.files || e.dataTransfer.files

  // Cancel event and hover styling
  fileDragHover(e)
  for (var i = 0, f; (f = files[i]); i++) {
    parseFile(f)
  }
}

function parseFile(file) {
  document.getElementById('upload-btn').removeAttribute('disabled')
  document.getElementById('response').classList.remove('hidden')
  console.log(file.name)
  output('<p class="text-xs text-green mb-2">' + encodeURI(file.name) + '</p>')
}

function output(msg) {
  // Response
  var m = document.getElementById('messages')
  m.innerHTML = msg
}
