
var boxes = document.getElementsByClassName("alink");

if (typeof(boxes) != 'undefined' && boxes != null) {

  function singleClickHandler() {
    var delay = 250; // Adjust the delay as needed
    var page = this.getAttribute('alink')

    clickCount++;
    setTimeout(function () {
      if (clickCount === 1) {
        window.open(page);
      }
      clickCount = 0;
    }, delay);
  }

  for (var k = 0; k < boxes.length; k++) {
    var clickCount = 0;

// single click
    boxes[k].addEventListener('click', singleClickHandler)

// double click
    boxes[k].addEventListener('dblclick', function(){
      this.removeEventListener('click', singleClickHandler);
      this.setAttribute('contenteditable','true')
      this.focus()
    })

  }
}
