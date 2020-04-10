% display ROI
% slice need to change slice amount
% direction 
% optimize
% maxSlice
function display_roi(img, n, roi_type, others)
%     if slice <= 0 || slice > maxSlice
%         slice = maxSlice;
%     end
%     if maxSlice <= 0
%         disp('display_roi maxSlice is not right');
%         return
%     end
%     if currentSlice < 0 || currentSlice > maxSlice
%         disp('display_roi currentSlice is not right');
%         return
%     end
%         
    if roi_type == 1
%         if optimize
%             display_roi_optimize(roipoly, currentSlice, img, slice, direction, maxSlice)
%         else
            display_roi_un_optimize(roipoly, img, n);
%         end
    elseif roi_type == 2
        h = drawassisted('LineWidth', 1);
        if optimize
            display_roi_optimize(createMask(h), currentSlice, img, slice, direction, maxSlice)
        else
            display_roi_un_optimize(createMask(h), currentSlice, img, slice, direction, maxSlice)
        end
        delete(h);
    elseif roi_type == 3
        h = drawcircle('LineWidth', 1);
        if optimize
            display_roi_optimize(createMask(h), currentSlice, img, slice, direction, maxSlice)
        else
            display_roi_un_optimize(createMask(h), currentSlice, img, slice, direction, maxSlice)
        end
        delete(h);
    elseif roi_type == 4
        h = drawellipse('LineWidth', 1);
        if optimize
            display_roi_optimize(createMask(h), currentSlice, img, slice, direction, maxSlice)
        else
            display_roi_un_optimize(createMask(h), currentSlice, img, slice, direction, maxSlice)
        end
        delete(h);
    elseif roi_type == 5
        display_roi_mean_optimize(roipoly, img, n);
    elseif roi_type == 6
        display_pixel_optimize(roipoly, img, n, others.pixel);
    end
    return
end

function display_roi_un_optimize(BW, img, n)
%     global toshow
    tmp = img.CData;
%     tmp(BW == 1) = 0;
    for i = 1:size(BW, 1)
        for j = 1:size(BW, 2)
            if BW(i, j) == 1
                tmp(i, j, n) = 0;
            end
        end
    end
%     toshow(:, :, currentSlice) = tmp;
%     next = currentSlice + 1;
%     pre = currentSlice - 1;
%     flag = 1;
%     while next <= maxSlice  && flag && direction && slice > 0 && slice <= maxSlice
%         flag = 0;
%         for i = 1:size(BW, 1)
%             for j = 1:size(BW, 2)
%                 if BW(i, j) == 1
%                     if (toshow(i, j, next) > 0) 
%                         toshow(i, j, next) = 0;
%                         flag = 1;
%                     end
%                 end
%             end
%         end
%         next = next + 1;
%         if slice ~= 0
%             slice = slice - 1;
%         end
%     end
%     flag = 1;
%     while pre >= 1 && flag && ~direction && slice > 0 && slice <= maxSlice
%         flag = 0;
%         for i = 1:size(BW, 1)
%             for j = 1:size(BW, 2)
%                 if BW(i, j) == 1
%                     if (toshow(i, j, pre) > 0) 
%                         toshow(i, j, pre) = 0;
%                         flag = 1;
%                     end
%                 end
%             end
%         end
%         pre = pre - 1;
%         if slice ~= 0
%             slice = slice - 1;
%         end
%     end
    display_refresh(img, tmp);
    save_history(tmp, n);
    return
end

function display_roi_mean_optimize(BW, img, n)
    tmp = img.CData;
    O = double(tmp(:, :, n));
    M = O(BW == 1);
    avg = mean2(nonzeros(M));
    for i = 1:size(BW, 1)
        for j = 1:size(BW, 2)
            if BW(i, j) == 1 && tmp(i, j, n) < avg
                tmp(i, j, n) = 0;
            end
        end
    end
    display_refresh(img, tmp);
    save_history(tmp, n);
    return
end

function display_pixel_optimize(BW, img, n, pixel)
    tmp = img.CData;
    for i = 1:size(BW, 1)
        for j = 1:size(BW, 2)
            if BW(i, j) == 1 && tmp(i, j, n) < pixel
                tmp(i, j, n) = 0;
            end
        end
    end
    display_refresh(img, tmp);
    save_history(tmp, n);
    return
end
% function display_roi_optimize(BW, currentSlice, img, slice, direction, maxSlice)
%     global toshow
%     tmp = img.CData;
%     roiValue = 0; % ROI mean value
%     roiStd = 0;
%     meanList = [];
%     for i = 1:size(BW, 1)
%         for j = 1:size(BW, 2)
%             if BW(i, j) == 1
%                 tmp(i, j) = 0;
%                 if toshow(i, j, currentSlice) > 0
%                     meanList = [meanList toshow(i, j, currentSlice)];
%                 end
%             end
%         end
%     end
%     roiValue = mean(meanList);
%     roiStd = std(meanList);
%     disp(roiValue);
%     disp(roiStd);
%     toshow(:, :, currentSlice) = tmp;
%     next = currentSlice + 1;
%     pre = currentSlice - 1;
%     flag = 1;
%     while next <= maxSlice  && flag && direction && slice > 0 && slice <= maxSlice
%         flag = 0;
%         for i = 1:size(BW, 1)
%             for j = 1:size(BW, 2)
%                 if BW(i, j) == 1
%                     if (toshow(i, j, next) > 0 && ...
%                             (toshow(i, j, next) <= roiValue + roiStd && toshow(i, j, next) >= roiValue - roiStd)) 
%                         toshow(i, j, next) = 0;
%                         flag = 1;
%                     end
%                 end
%             end
%         end
%         next = next + 1;
%         if slice ~= 0
%             slice = slice - 1;
%         end
%     end
%     flag = 1;
%     while pre >= 1 && flag && ~direction && slice > 0 && slice <= maxSlice
%         flag = 0;
%         for i = 1:size(BW, 1)
%             for j = 1:size(BW, 2)
%                 if BW(i, j) == 1
%                     if (toshow(i, j, pre) > 0 && ...
%                             (toshow(i, j, next) <= roiValue + roiStd && toshow(i, j, next) >= roiValue - roiStd)) 
%                         toshow(i, j, pre) = 0;
%                         flag = 1;
%                     end
%                 end
%             end
%         end
%         pre = pre - 1;
%         if slice ~= 0
%             slice = slice - 1;
%         end
%     end
%     display_refresh(img, tmp);
%     save_history(1);
%     return
% end
