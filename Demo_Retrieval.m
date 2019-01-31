%% 
% Run This Demo to do the retreival and show retreival statistics
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2016. 
% Please acknowledge the use of our codes and cite our paper. 
% M. Alfarraj, Y. Alaudah, and G. AlRegib , "Content-adaptive Non-parametric
% Texture Similarity Measure," 2016 IEEE Workshop on Multimedia Signal 
% Processing (MMSP 2016), Montreal, Canada,  Sep. 21-23, 2016
% 
% Last updated: 11/11/2016
% by: Motaz Alfarraj 
% To report any bugs/error contact the author at: motaz@gatech.edu 



%%
function Demo_Retrieval()
    clc; 
    load images 
    NumOfClasses = 4; 
    M = size(images,2);
    S = M/NumOfClasses; %number of samples per class 
    SimilarityMatrix = zeros(M,M); 

    fprintf('Calculating Similarity: 0.00%%')
    Num = '0.00%%'; 
    c = 0; 
    for i=1:M
        for j = i:M
            SimilarityMatrix(i,j) = TextureSimilarity(images{i},images{j}); 
            c = c+1; 
            Str = repmat('\b',1,length(Num)-1); 
            Num = [num2str(c/(M*(M-1)/2+M)*100,'%0.2f'),'%%'];
            temp = [Str,Num];  
            fprintf(temp);
        end    
    end 
    SimilarityMatrix = SimilarityMatrix + triu(SimilarityMatrix,1)'; 
    results = CalcStatistics(SimilarityMatrix,NumOfClasses);
    fprintf('\n');
    fprintf('Precision @1 = %0.2f%%\n',results.PAn(1)*100)
    fprintf('Mean Reciprocal Rank = %0.2f%%\n',results.MRR*100)
    fprintf('Retrieval Accuracy = %0.2f%%\n',results.PAn(end)*100)
    fprintf('Mean Averge Precision = %0.2f%%\n',results.MAP*100)
    %%
    CC = hsv(NumOfClasses);
    C = CC(floor(([1:M]'-1)/(M/NumOfClasses))+1,:);
	[Y, E] = cmdscale(1-SimilarityMatrix,3);
    for i=1:NumOfClasses
        scatter3(Y((i-1)*S+1:i*S,1),Y((i-1)*S+1:i*S,2),Y((i-1)*S+1:i*S,3),30,'o','MarkerFaceColor','flat'); 
        title('Visualization of the data points');
        hold on 
    end
   
   legend('Class 1','Class 2','Class 3','Class 4') 
end 



