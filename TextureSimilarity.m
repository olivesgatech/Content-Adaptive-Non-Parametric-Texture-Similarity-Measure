function sim = TextureSimilarity(img1,img2)
% This function calculated texture similarity metric between the input images.
% The metric was proposed in this paper: 
% M. Alfarraj, Y. Alaudah, and G. AlRegib , "Content-adaptive Non-parametric
% Texture Similarity Measure," 2016 IEEE Workshop on Multimedia Signal 
% Processing (MMSP 2016), Montreal, Canada,  Sep. 21-23, 2016
% 
%
% The metric uses CurveLab toolbox that can be found at this link:
% http://www.curvelet.org/software.html.
% In order to use the code, you need to set up the toolbox and add it to
% the search path in MATLAB. 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input: 
% img1, img2: two gray-scale images of the same size. If the images are not
% gray-scale, they will converted and only the luminance channel is used. 
%
% Output:
% sim : Similarity score between the input images in [0,1]. 
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2016. 
% Please acknowledge the use of our codes and cite the paper above. 
% 
% Last updated: 11/11/2016
% by: Motaz Alfarraj 
% To report any bugs/error contact the author at: motaz@gatech.edu 

%% Input validation 
if nargin~=2 
    error('The function takes two images as input'); 
end 

if size(img1,1)~=size(img2,1) || size(img1,2)~=size(img2,2) 
    error('Input images must be of the same size');
end

%% Real-valued Curvelet transform 
curvelet_coefficients_1 = fdct_wrapping(img1,1);
curvelet_coefficients_2 = fdct_wrapping(img2,1);

%% Feature vector 
NumOfScales = size(curvelet_coefficients_1,2);
features_1 = []; % feature vector for img1 
features_2 = []; % feature vector for img2 
    for j = 1:NumOfScales
            NumOfWedges = ceil(size(curvelet_coefficients_1{j},2)/2); 
            
            %features of img1 in scale j
            scale_features_1 = [];
            
            %features of img2 in scale j
            scale_features_2 = []; 
            
            %half the wedges are needed due to symmetry of spectrum
            for k = 1:NumOfWedges;
               wedge1 = (curvelet_coefficients_1{j}{k});
               wedge2 = (curvelet_coefficients_2{j}{k});
               
               %finding the singular values 
               s1 = svd(wedge1,'econ')';
               s2 = svd(wedge2,'econ')';
               
               % truncation based on the effective rank
               scale_features_1 = [scale_features_1, TruncateFeature(s1)];

               scale_features_2 = [scale_features_2, TruncateFeature(s2)];
            end

            features_1 = [features_1,scale_features_1]; 
            features_2 = [features_2,scale_features_2]; 
    end 
    
sim =1-norm(features_1-features_2,1)/norm(features_1+features_2,1);
end

function Trunc_feature = TruncateFeature(f)
    Trunc_feature = f; 
    if sum(Trunc_feature)~=0
       w = Trunc_feature/sum(Trunc_feature);
       w(w==0) = []; 
       Q = floor(exp(sum(-w.*log(w)))); 
       Trunc_feature(Q+1:end)  = 0; 
    end 
end 