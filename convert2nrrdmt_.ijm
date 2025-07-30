/*
 * Fiji/ImageJ Macro: Batch Export to NRRD
 *
 * 描述:
 *
 * 使用方法:
 * 1. 在斐济 (Fiji) 中打开此宏 (Plugins > New > Macro)。
 * 2. 点击 "Run"。
 * 3. 选择包含源图像的输入文件夹。
 * 4. 选择用于保存 .nrrd 文件的输出文件夹。
 */

// 清除日志窗口以方便查看新的输出
print("\\Clear");

// 调用主函数
batchConvertWithRecordedCommand();

function batchConvertWithRecordedCommand() {
    // 弹出对话框让用户选择输入文件夹
    inputDir = getDirectory("选择源图像文件夹 (Input Folder)");
    // 弹出对话框让用户选择输出文件夹
    outputDir = getDirectory("选择保存NRRD文件的文件夹 (Output Folder)");

    // 检查用户是否取消了选择
    if (inputDir == "" || outputDir == "") {
        print("用户取消了操作。");
        return;
    }

    // 获取输入文件夹中的文件列表
    list = getFileList(inputDir);

    // 设置为批处理模式，以避免弹出不必要的对话框
    setBatchMode(true);

    print("开始批量处理...");
    print("输入文件夹: " + inputDir);
    print("输出文件夹: " + outputDir);

    // 循环处理文件列表中的每一个文件
    for (i = 0; i < list.length; i++) {
        path = inputDir + list[i];
        print("正在处理: " + path);

        // 记录打开图像前的窗口数量
        n_before = nImages;
        open(path);
        n_after = nImages;

        // 如果窗口数量没有增加，说明文件打开失败
        if (n_after == n_before) {
            print("  -> 跳过: 不是一个可识别的图像文件。");
            continue; // 继续处理下一个文件
        }
        
        // 获取当前打开图像的标题
        title = getTitle();
        
        // 移除原始文件的扩展名
        dotIndex = lastIndexOf(title, ".");
        if (dotIndex != -1) {
            baseName = substring(title, 0, dotIndex);
        } else {
            baseName = title;
        }

        // 构建输出文件的完整路径
        outputPath = outputDir + baseName + ".nrrd";

        // ** 使用您提供的精确命令格式来保存文件 **
        run("Nrrd ... ", "nrrd=[" + outputPath + "]");
        
        print("  -> 已保存为: " + outputPath);

        // 关闭当前图像以释放内存
        close();
    }

    // 恢复正常模式
    setBatchMode(false);
    
    // 显示完成信息
    print("-----------------------------");
    print("批量转换完成！");
    showMessage("完成", "所有图像已成功转换为 NRRD 格式。");
}
