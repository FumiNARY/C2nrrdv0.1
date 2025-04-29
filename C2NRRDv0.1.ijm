#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".czi") suffix
#@ String (label = "Import options", value = "autoscale color_mode=Default view=Hyperstack stack_order=XYCZT", style = "text-area") options

processFolder(input, output);

// 递归处理文件夹
function processFolder(input, output) {
    list = getFileList(input);
    Array.sort(list);
    for (i=0; i<list.length; i++) {
        currentPath = input + File.separator + list[i];
        if (File.isDirectory(currentPath)) {
            newOutput = output + File.separator + list[i];
            File.makeDirectory(newOutput);
            processFolder(currentPath, newOutput);
        } else if (endsWith(list[i], suffix)) {
            processFile(input, output, list[i]);
        }
    }
}

// 处理单个文件
function processFile(input, output, file) {
    inputPath = input + File.separator + file;
    
    // 静默模式打开文件
    run("Bio-Formats Importer", 
        "open=[" + inputPath + "] " + options + " windowless=true showrois=false");
    
    // 获取图像标题并处理扩展名
    fullTitle = getTitle();
    dotPos = lastIndexOf(fullTitle, ".");
    if (dotPos > 0) {
        imageName = substring(fullTitle, 0, dotPos);  // 精确截取最后扩展名
    } else {
        imageName = fullTitle;  // 没有扩展名时保留原名
    }
    
    // 保存为NRRD
    outputPath = output + File.separator + imageName + ".nrrd";
    run("Nrrd ... ", "nrrd=[" + outputPath + "]");
    close();
}