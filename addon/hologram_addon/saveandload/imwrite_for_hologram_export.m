function imwrite_for_hologram_export(pattern, RGB_on, filename)
global RGB_switch; %

    if RGB_on == 1
    imwrite(pattern.*uint8(reshape(RGB_switch,[1 1 3])),filename);
    elseif RGB_on == 0
     imwrite(repmat(pattern,[1 1 3]),filename);                  
    end   

end