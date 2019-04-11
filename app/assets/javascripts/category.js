function previewCategoryPicture()
{
    var img = document.getElementById("CategoryPictureImg");

    var file = document.getElementById("category_category_picture_filepath").files[0];
    var reader = new FileReader();
    reader.onload = (function(aImg){
        return function(e){
            aImg.src = e.target.result;
        };
    })(img);
    reader.readAsDataURL(file);
}
