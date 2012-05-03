function [e, cnfig]=getfilenums(sess_dat)
cmnt = lower(char(sess_dat.GlobalStim.Text));

disp(cmnt);
e=[];
e1=0;
e2=0;
cnfig = '';
posall = findstr(cmnt,'-');
if isempty(posall),
    disp('single or no files specified');
    pos =1;
    pos1 = 0;
    pos2 = 0;
    while pos <= length(cmnt),
        if double(cmnt(pos)) >= double('0') && double(cmnt(pos)) <= double('9'),
            pos1 = pos;
            pos2 = pos1;
            pos = length(cmnt)+1;
        else
            pos = pos+1;
        end
    end
    if pos1,
        pos = pos1;
        while pos <= length(cmnt),
            if double(cmnt(pos)) >= double('0') && double(cmnt(pos)) <= double('9'),
                pos2 = pos;
                pos = pos+1;
            else
                pos = length(cmnt)+1;
            end
        end
        e1 = str2num(cmnt(pos1:pos2));
        e2 = e1;
        disp(e1);
        disp(e2);
        e=[e e1:e2];
        disp(e);
        %         pause
    end
    return
end

for pos=posall,
    if isempty(findstr(cmnt(1:pos),' ')),
        pos1 = 1;
    else
        pos1 = max(findstr(cmnt(1:pos),' '));
    end
    e1 = str2num(cmnt(pos1:pos-1));
    if isempty(findstr(cmnt(pos+1:end),' ')),
        pos1 = length(cmnt);
    else
        pos1 = min(findstr(cmnt(pos+1:end),' '))+pos;
    end
    e2 = str2num(cmnt(pos+1:pos1));
    disp(e1);
    disp(e2);
    e=[e e1:e2];
    disp(e);
    cnfig = cmnt;
end