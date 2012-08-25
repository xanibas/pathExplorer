filename = '../js/structureList.js';

structureList = {
    'F','M','H',...
    'SP','D','PPH','PH','PMH','MH',...
    'RSP','CSP','p1','p2','p3','m1','m2','is','r1','r2','r3','r4','r5','r6','r7','r8','r9','r10','r11',...
    'POTel','PPHy','Tel','PedHy','PTh','PThTg','Th','ThTg','Pt','PtTg','MTt','MTg','PIsTt','PIsTg'};

[structureList,idx]=sort(structureList);

fid = fopen(filename, 'w');
fprintf(fid, '%s', 'var structureList=[');
for g=1:size(structureList,2)
    if g>1
        fprintf(fid, '%s', ',');
    end
    s = ['''',structureList{g},''''];
    fprintf(fid, '%s', s);
end
fprintf(fid, '%s', ']');
fclose(fid);

filename = '../js/colorList.js';

colorList = {
    'ED905C','5CED5C','5D71FF',...
    'ED5C69','EDD15C','C85DFF','745DFF','5D8BFF','5DFFFE',...
    'ED5CD8','ED5C6E','EDB15C','E7CD5C','EAED5C','1FF25C','27F21E','D95CED','BC5CED','9F5CED','7F5CED','615CED','5C75ED','5C93ED','5CB1ED','5CCFED','5CEDEC','5CEDCE','5CEDB0',...
    'ED5CE7','ED5CC6','ED805C','ED5CA2','E2ED5C','EDE95C','EDD95C','EDC85C','EDB85C','EDA85C','1EF26E','1FF24B','1EF227','39F21E'};

fid = fopen(filename, 'w');
fprintf(fid, '%s', 'var colorList=[');
for g=1:size(colorList,2)
    if g>1
        fprintf(fid, '%s', ',');
    end
    s = ['''',colorList{idx(g)},''''];
    fprintf(fid, '%s', s);
end
fprintf(fid, '%s', ']');
fclose(fid);

