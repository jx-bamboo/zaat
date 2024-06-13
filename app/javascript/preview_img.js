function uploadImg(file, preview){
  console.log('-- uploadImg --');
  var fileDom = document.getElementById(file);
  var previewDom = document.getElementById(preview);
  fileDom.addEventListener("change", e => {
    var file = fileDom.files[0];
    if (!file || file.type.indexOf("image/") < 0) {
      fileDom.value = "";
      previewDom.src = "";
      return;
    }
    var fileReader = new FileReader();
    fileReader.onload = e => {
      previewDom.src = e.target.result;
    };
    fileReader.readAsDataURL(file);
  });
}