function display_save_img(img, folderInfo)
    global MergesFolders;
    global currentImage;
    disp('saved');
    disp([folderInfo.datadir folderInfo.seperator ...
        MergesFolders(currentImage).name folderInfo.seperator 'r_' ...
        folderInfo.type folderInfo.Merge]);
    imwrite(img.CData, [folderInfo.datadir folderInfo.seperator ...
        MergesFolders(currentImage).name folderInfo.seperator 'r_' ...
        folderInfo.type folderInfo.Merge]);
    return
end