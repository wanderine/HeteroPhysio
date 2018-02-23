close all
clear all
clc

addpath('/flush/berwe/nifti_matlab')

%basepath = '/flush/berwe/HomoGauss/Results/HCPraw/MOTOR/stc_mc_smoothed_AR10_nonstationary_iota1.0/';
%basepath_physio = '/flush/berwe/HomoGauss/Results/HCPrawphysio/MOTOR/stc_mc_smoothed_AR10_nonstationary_iota1.0/';

basepath = '/flush/berwe/HomoGauss/Results/HCPraw/LANGUAGE/stc_mc_smoothed_AR10_nonstationary_iota3.0/';
basepath_physio = '/flush/berwe/HomoGauss/Results/HCPrawphysio/LANGUAGE/stc_mc_smoothed_AR10_nonstationary_iota3.0/';


sy = 70; sx = 80;

differences = zeros(sy,sx,9);

raw = zeros(sy,sx,9);
physio = zeros(sy,sx,9);

rawtotal = zeros(sy,sx);
physiototal = zeros(sy,sx);

for AR = 1:9
    
   % Load results
   nii = load_untouch_nii([basepath 'bold_HCP_1_sm_Irho_arcoefficient000' num2str(AR) '.nii.gz' ]);
   data = double(nii.img);
   rawtotal = rawtotal + data;
   raw(:,:,AR) = data;
   
   % Load physio results
   nii = load_untouch_nii([basepath_physio 'bold_HCPphysio_1_sm_Irho_arcoefficient000' num2str(AR) '.nii.gz' ]);
   data_physio = double(nii.img); 
   physiototal = physiototal + data_physio;
   physio(:,:,AR) = data_physio;
   
   difference = data - data_physio;   
   sum(abs(difference(:)))
   differences(:,:,AR) = difference;

   nii.img = single(difference);
   save_untouch_nii(nii,['AR' num2str(AR) '_order_difference.nii.gz'])

end

maxraw = zeros(sy,sx);
maxphysio = zeros(sy,sx);

for x = 1:sx
    for y = 1:sy
   
        max = 0;
        for AR = 1:9
            if raw(y,x,AR) > 0.5
               %max = AR; 
               max = max + 1;
            end
        end
        maxraw(y,x) = max;
        
        max = 0;
        for AR = 1:9
            if physio(y,x,AR) > 0.5
               %max = AR; 
               max = max + 1;
            end
        end
        maxphysio(y,x) = max;
        
    end
end


nii.img = single(maxraw);
save_untouch_nii(nii,['AR_max_order_raw.nii.gz'])

nii.img = single(maxphysio);
save_untouch_nii(nii,['AR_max_order_physio.nii.gz'])

maxdifference = maxraw-maxphysio;
sum(maxdifference(:) > 2)
sum(maxdifference(:) < -2)

nii.img = single(maxdifference);
save_untouch_nii(nii,['AR_max_order_difference.nii.gz'])


%---

nii.img = single(rawtotal);
save_untouch_nii(nii,['AR_raw_order_total.nii.gz'])

nii.img = single(physiototal);
save_untouch_nii(nii,['AR_physio_order_total.nii.gz'])

%sum(rawtotal(:))

%sum(physiototal(:))













%%

differences = zeros(sy,sx,9);

raw = zeros(sy,sx,9);
physio = zeros(sy,sx,9);

rawtotal = zeros(sy,sx);
physiototal = zeros(sy,sx);

for AR = 1:9
    
   % Load results
   nii = load_untouch_nii([basepath 'bold_HCP_1_sm_rho_arcoefficient000' num2str(AR) '.nii.gz' ]);
   data = double(nii.img);
   rawtotal = rawtotal + data;
   raw(:,:,AR) = data;
   
   % Load physio results
   nii = load_untouch_nii([basepath_physio 'bold_HCPphysio_1_sm_rho_arcoefficient000' num2str(AR) '.nii.gz' ]);
   data_physio = double(nii.img); 
   physiototal = physiototal + data_physio;
   physio(:,:,AR) = data_physio;
   
   difference = data - data_physio;   
   sum(abs(difference(:)))
   differences(:,:,AR) = difference;

   nii.img = single(difference);
   save_untouch_nii(nii,['AR' num2str(AR) '_magnitude_difference.nii.gz'])

end


%---

nii.img = single(rawtotal);
save_untouch_nii(nii,['AR_raw_magnitude_total.nii.gz'])

nii.img = single(physiototal);
save_untouch_nii(nii,['AR_physio_magnitude_total.nii.gz'])


nii.img = single(rawtotal - physiototal);
save_untouch_nii(nii,['AR_magnitude_difference_total.nii.gz'])

