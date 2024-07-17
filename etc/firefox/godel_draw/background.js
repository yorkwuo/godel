chrome.browserAction.onClicked.addListener((tab) => {

  browser.tabs.query({active: true, currentWindow: true}, function(tabs) {
    var activeTab = tabs[0];
    var activeTabUrl = activeTab.url;
  
    console.log(activeTabUrl);
  
    // Given URL
    const url = activeTabUrl;
    
    // Create a URL object
    const urlObject = new URL(url);
    
    // Get the pathname from the URL object
    const pathname = urlObject.pathname;
    
    // Remove the file name to get the directory path
    const directoryPath = pathname.substring(0, pathname.lastIndexOf('/'));
    
    // Log the result
    console.log(directoryPath); // Output: /home/york/pages/unix_tools/firefox/002
    
    cmdline(directoryPath,'tclsh','/home/github/godel/tools/server/tcl/draw.tcl');
  });

});

// cmdline
function cmdline(fullpath, cmd, param) {
  console.log('kk')
  const url = 'http://127.0.0.1:5000/cmdline?fullpath='+fullpath+'&cmd='+cmd+'&param='+param;

  fetch(url);
}
