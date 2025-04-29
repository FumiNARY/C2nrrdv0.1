// 保留512x512图像
macro "Keep 512x512 Windows" {
	dir = getDirectory("Choose a Directory");
    ids = getList("image.titles");;
    for (i=0; i<ids.length; i++) {
        id = ids[i];
        selectImage(id);
        if (getWidth() != 512 || getHeight() != 512) {
            close();
        }
    }

for (i=0;i<nImages;i++) {
        selectImage(i+1);
        title = getTitle;
        print(title);
        

        run("Nrrd ... ", "nrrd=["+dir+title+"]");
} 
run("Close All");
}


