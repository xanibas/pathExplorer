function writeXgmml(data, geneList, D, Y, filename)

structureList={'CSP','D','F','H','M','MH','MTg','MTt','PH','PIsTg','PIsTt','PMH','POTel','PPH','PPHy','PTh','PThTg','PedHy','Pt','PtTg','RSP','SP','Tel','Th','ThTg','is','m1','m2','p1','p2','p3','r1','r10','r11','r2','r3','r4','r5','r6','r7','r8','r9'};
group=        { 1,    1,  1,  3,  2,  3,   2,    2,    3,   1,      1,      3,    1,      3,    1,     1,    1,      1,      1,   1,     1,    1,   1,    1,   1,     3,   2,   2,   1,   1,   1,   3,   3,    3,    3,   3,   3,   3,   3,   3,   3,   3};
ageList = {'E11.5','E13.5','E15.5','E18.5','P4','P14','P28','P56'};
ageList2 = {'11.5','13.5','15.5','18.5','25','35','50','77','80'};

colorList={'ED5C6E','EDD15C','ED905C','5D71FF','5CED5C','5DFFFE','1FF24B','1EF26E','745DFF','39F21E','1EF227','5D8BFF','ED5CE7','C85DFF','ED5CC6','E2ED5C','EDE95C','ED5CA2','EDB85C','EDA85C','ED5CD8','ED5C69','ED805C','EDD95C','EDC85C','D95CED','1FF25C','27F21E','EDB15C','E7CD5C','EAED5C','BC5CED','5CEDCE','5CEDB0','9F5CED','7F5CED','615CED','5C75ED','5C93ED','5CB1ED','5CCFED','5CEDEC'};

%Open file
fid = fopen(filename, 'w');

% Header
fprintf(fid, '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n');
fprintf(fid, '<!-- Created by Sabina Sara Pfister, %s -->\n', date);

fprintf(fid, ['<graph label="', 'MouseBrainDev','"\n']);
fprintf(fid, '    directed="1">\n');

fprintf(fid, '    <graphics fill="#000000"/>\n');

% Write nodes
for i=1:size(data,1)
    
    if (data(i,3)+2<8)
    timestart = ageList2{data(i,3)+1};
    timeend = ageList2{data(i,3)+2};
    
    fprintf(fid, '  <node label="%s" id="%i" start="%s" end="%s">\n', structureList{data(i,1)+1}, data(i,1), timestart, timeend);
    fprintf(fid, '    <graphics type="CIRCLE" h="%g" w="%g" fill="#%s"/>\n',100-10*data(i,2),100-10*data(i,2),colorList{data(i,1)+1});
    fprintf(fid, '    <att name="age" type="real" value="%s" start="%s" end="%s"/>\n', timestart, timestart, timeend);
    fprintf(fid, '    <att name="group" type="integer" value="%i" start="%s" end="%s"/>\n', group{data(i,1)+1}, timestart, timeend);
    fprintf(fid, '    <att name="depth" type="real" value="%g" start="%s" end="%s"/>\n', 100-10*data(i,2), timestart, timeend);
    fprintf(fid, '    <att name="all" type="real" value="%g" start="%s" end="%s"/>\n', 1, timestart, timeend);
    
%     for g=1:size(geneList,2)
%         if data(i,g+3)==-1
%             fprintf(fid, '    <att name="%s" type="real" value="%g" start="%s" end="%s"/>\n', geneList{g}, 0, timestart, timeend);
%         else
%             fprintf(fid, '    <att name="%s" type="real" value="%g" start="%s" end="%s"/>\n', geneList{g}, data(i,g+3)*10, timestart, timeend);
%         end
%     end
    
    fprintf(fid, '  </node>\n');
    end
    
end

% Write links
index = 1;
for aSource=1:(size(ageList,2)-1)
    aTarget = aSource+1;
    for sSource=1:size(structureList,2)
        indexSource = getIndex(aSource-1,sSource-1);
        for sTarget=1:size(structureList,2)
            indexTargetCorr = getIndex(aTarget-2,sTarget-1);
            indexTargetLink = getIndex(aTarget-1,sTarget-1);
            if (~isnan(Y(indexSource,indexTargetCorr)) && data(indexSource,1)<data(indexTargetLink,1) && Y(indexSource,indexTargetCorr)<0.3)
                
                timestart = ageList2{data(indexSource,3)+1};
                timeend = ageList2{data(indexTargetLink,3)+1};
                
                if (data(indexSource,3)+1<8)
                
                s = ['e',num2str(data(indexSource,1)),'_',num2str(data(indexTargetLink,1))];
                
                fprintf(fid, '  <edge label="%s" source="%i" target="%i" start="%s" end="%s">\n', s, data(indexSource,1), data(indexTargetLink,1), timestart, timeend);
                fprintf(fid, '    <graphics width="2"/>\n');
                fprintf(fid, '    <att name="all" type="real" value="%g" start="%s" end="%s"/>\n', Y(indexSource,indexTargetCorr), timestart, timeend);
                
                for g=1:size(geneList,2)
                    fprintf(fid, '    <att name="%s" type="real" value="%g" start="%s" end="%s"/>\n', geneList{g}, getSingleCorr(g,indexSource,indexTargetCorr), timestart, timeend);
                end
                
                fprintf(fid, '  </edge>\n');
                index = index+1;
                end
            end
        end
    end
end

% End
fprintf(fid, '</graph>\n');

% Close file
fclose(fid);

    function index = getIndex(ageId, structureId)
        index = 1 + ageId + size(ageList,2)*structureId;
    end

    function corr = getSingleCorr(g,i,j)
        if (isnan(D(i,g)) || isnan(D(j,g)))
            corr = 1;
        else
            corr = pdist([D(i,g);D(j,g)]);
        end
    end


end