const svg = document.getElementById('svg')
if (typeof(svg) != 'undefined' && svg != null) {
  svg.addEventListener('mousedown', mouseDown, false)
  svg.addEventListener('mousemove', drag, false)
  svg.addEventListener('mouseup', mouseUp, false)
  svg.addEventListener('wheel', zoom, false)
}

