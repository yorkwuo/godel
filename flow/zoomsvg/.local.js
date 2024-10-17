const svg = document.getElementById('svg')
if (typeof(svg) != 'undefined' && svg != null) {
  svg.addEventListener('mousedown', mouseDown, false)
  svg.addEventListener('mousemove', drag, false)
  svg.addEventListener('mouseup', mouseUp, false)
  svg.addEventListener('wheel', zoom, false)
}

var rects = document.getElementsByTagName('rect');
if(typeof(rects) != 'undefined' && rects != null){
  for (var k = 0; k < rects.length; k++) {
  
        rects[k].addEventListener('click', function(){
          this.style.fill = "yellow";
          this.style.opacity = "0.01";
        })

        rects[k].addEventListener('dblclick', function(){
          this.style.fill = "red";
          this.style.opacity = "0.3";
        })

  }
}

function scores() {

  var results = document.getElementById("results");
  var rects = document.getElementsByTagName('rect');
  var size = rects.length

  var redcount = 0
  if(typeof(rects) != 'undefined' && rects != null){
    for (var k = 0; k < rects.length; k++) {
      let c = rects[k].style.fill
      if (c === "red") {
        redcount ++;
      }
  
    }
  }
  console.log(redcount)
  results.innerHTML = `${redcount}/${size}`
}
