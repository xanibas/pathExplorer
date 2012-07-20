function writeJson(data, geneList, Y, filename)

    structureList = {'RSP','Tel','PedHy','p3','p2','p1','M','PPH','PH','PMH','MH','CSPall','DPall','MPall'};
    ageList = {'E11.5','E13.5','E15.5','E18.5','P4','P14','P28','P56'};

    %Open file
    fid = fopen(filename, 'w');
    fprintf(fid, '%s', '{"nodes":[');
    
    % Get differentials
    D = getDifferences(data);
    
    % Write nodes
    for i=1:size(data,1)
        
        s = ['{"name":"', structureList{data(i,1)+1},'_',ageList{data(i,2)+1},'","id":',num2str(i-1),',"struct":"',structureList{data(i,1)+1},'","age":"',ageList{data(i,2)+1},'","group":',num2str(data(i,2)+1)];
        fprintf(fid, '%s', s);
        
        fprintf(fid, '%s', ',"genes":[{');
        if (all(data(i,3:end)==-1))
            fprintf(fid, '%s', '"name":"All","measured":"false","expression":5,"difference":0}');
        else
            fprintf(fid, '%s', '"name":"All","measured":"true","expression":5,"difference":0}');
        end
        for g=1:size(geneList,2)
            if data(i,g+2)==-1
                s = [',{"name":"',geneList{g},'","measured":"false","expression":0,"difference":0}'];
            else
                if (isnan(D(i,g)))
                    s = [',{"name":"',geneList{g},'","measured":"true","expression":',num2str(data(i,g+2)),',"difference":0}'];
                else
                    s = [',{"name":"',geneList{g},'","measured":"true","expression":',num2str(data(i,g+2)),',"difference":',num2str(D(i,g)),'}'];
                end
            end
            fprintf(fid, '%s', s);
        end
        fprintf(fid, '%s', ']');
        
        if (i<size(data,1))
            fprintf(fid, '%s', '},');
        else
            fprintf(fid, '%s', '}');
        end
    end
    fprintf(fid, '%s', '],"links":[');
    
    % Write links
    index = 1;
    for aSource=1:(size(ageList,2)-1)
        aTarget = aSource+1;
        for sSource=1:size(structureList,2)
            indexSource = getIndex(aSource-1,sSource-1);
            for sTarget=1:size(structureList,2)
                indexTargetCorr = getIndex(aTarget-2,sTarget-1);
                indexTargetLink = getIndex(aTarget-1,sTarget-1);
                if (~isnan(Y(indexSource,indexTargetCorr)) && Y(indexSource,indexTargetCorr)>0)
                    if (index>1)
                        fprintf(fid, '%s', ',');
                    end
                    s = ['{"name":"', structureList{data(indexSource,1)+1},'_',ageList{data(indexSource,2)+1},'-',structureList{data(indexTargetLink,1)+1},'_',ageList{data(indexTargetLink,2)+1},'","source":',num2str(indexSource-1),',"target":',num2str(indexTargetLink-1),',"value":',num2str(Y(indexSource,indexTargetCorr)),'}'];
                    fprintf(fid, '%s', s);
                    index = index+1;
                end
            end
        end
    end
    fprintf(fid, '%s', ']}');
    
    % Close file
    fclose(fid);
    
    function index = getIndex(ageId, structureId)
        index = 1 + ageId + size(ageList,2)*structureId;
    end
    
end