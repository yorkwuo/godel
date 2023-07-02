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

