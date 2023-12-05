// Initialize the box color on page load
document.addEventListener('DOMContentLoaded', function () {
  var colors = ['white', 'red', 'yellow', 'green'];
  var boxes = document.getElementsByClassName('myBox');
  for (var k = 0; k < boxes.length; k++) {
    var name = boxes[k].getAttribute('name')
    var coloridx = localStorage.getItem(name)
    if (coloridx) {
      boxes[k].style.backgroundColor = colors[coloridx]
    }
  }  
});

var boxes = document.getElementsByClassName("myBox");
if (typeof(boxes) != 'undefined' && boxes != null) {
  var colors = ['white', 'red', 'yellow', 'green'];

  for (var k = 0; k < boxes.length; k++) {

// left click
    boxes[k].addEventListener('click', function(){
      var vv = this.getAttribute('name')
      var coloridx = localStorage.getItem(vv);
      console.log('incr')
      if (coloridx) {
        if (coloridx == 3) {
          coloridx = 0;
        } else {
          coloridx++;
        }
          this.style.backgroundColor = colors[coloridx];
          localStorage.setItem(vv, coloridx);
      } else {
        console.log('no color')
        this.style.backgroundColor = colors[1];
        localStorage.setItem(vv,'1');
      }
    })


  }
}

