const svg = document.getElementById('svg')
svg.addEventListener('mousedown', mouseDown, false)
svg.addEventListener('mousemove', drag, false)
svg.addEventListener('mouseup', mouseUp, false)
svg.addEventListener('wheel', zoom, false)

