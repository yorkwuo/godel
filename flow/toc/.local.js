document.addEventListener("DOMContentLoaded", function() {
    const toc = document.getElementById('toc');
    const tocToggle = document.getElementById('toc-toggle');
    const tocList = document.getElementById('toc-list');
    const headers = document.querySelectorAll('h1, h2, h3');

    headers.forEach((header, index) => {
        // Create an ID for each header if it doesn't have one
        if (!header.id) {
            header.id = 'header-' + index;
        }

        // Create a list item for the TOC
        const li = document.createElement('li');
        
        // Indent based on header level
        li.style.marginLeft = (parseInt(header.tagName[1]) - 1) * 10 + 'px';

        // Create a link for the list item
        const a = document.createElement('a');
        a.href = '#' + header.id;
        a.textContent = header.textContent;

        // Append the link to the list item
        li.appendChild(a);

        // Append the list item to the TOC list
        tocList.appendChild(li);
    });

    // Toggle TOC visibility when the button is clicked
    tocToggle.addEventListener('click', function() {
        toc.classList.toggle('hidden');
    });
});



