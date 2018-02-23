#!/bin/bash

export OMP_NUM_THREADS=72 #max 72

datadir=/flush/berwe/HomoGauss/Data/HCP

one=1
two=2
three=3
four=4

rm bold_HCP*

#task=MOTOR
task=LANGUAGE

for subject in {1..4}
do

	if [ "$subject" -eq "$one" ]; then
		subjectID=100307
	elif [ "$subject" -eq "$two" ]; then
		subjectID=162733
	elif [ "$subject" -eq "$three" ]; then
		subjectID=103111
	elif [ "$subject" -eq "$four" ]; then
		subjectID=124422
	fi

	echo "Copying data"
	cp $datadir/${subjectID}/unprocessed/3T/tfMRI_${task}_LR/${subjectID}_3T_tfMRI_${task}_LR.nii.gz   bold_HCP_${subject}.nii.gz

	echo -e "\nPerforming slice timing correction using AFNI \n"
	3dTshift -prefix bold_HCP_${subject}_stc.nii.gz -tzero 0 -tpattern @SliceTimingSeconds.txt bold_HCP_${subject}.nii.gz

	echo -e "\nPerforming motion correction using AFNI \n"
	3dvolreg -prefix bold_HCP_${subject}_mc.nii.gz -1Dfile bold_HCP_${subject}_headmotion.1D bold_HCP_${subject}_stc.nii.gz

	echo -e "\nPerforming smoothing using AFNI \n"
	3dmerge -quiet -1blur_fwhm 4.0 -doall -prefix bold_HCP_${subject}_sm.nii.gz bold_HCP_${subject}_mc.nii.gz

	echo -e "\nCreating brain mask using AFNI \n"
	3dAutomask -prefix bold_HCP_${subject}_mask.nii.gz bold_HCP_${subject}_mc.nii.gz

	# Trim data
	fslroi bold_HCP_${subject}_sm.nii.gz bold_HCP_${subject}_sm.nii.gz 10 70 12 80 19 45 0 -1

	# Trim mask
	fslroi bold_HCP_${subject}_mask.nii.gz bold_HCP_${subject}_mask.nii.gz 10 70 12 80 19 45 

	# Calculate motion derivative
	1d_tool.py -infile bold_HCP_${subject}_headmotion.1D -set_nruns 1 -derivative -write bold_HCP_${subject}_headmotion_deriv.1D

	# Trim to one slice
	#fslroi bold_HCP_${subject}_sm.nii.gz bold_HCP_${subject}_sm.nii.gz 0 -1 0 -1 27 1 0 -1

	# Trim mask to one slice
	#fslroi bold_HCP_${subject}_mask.nii.gz bold_HCP_${subject}_mask.nii.gz 0 -1 0 -1 27 1

	# LANGUAGE
	cp $datadir/${subjectID}/unprocessed/3T/tfMRI_${task}_LR/LINKED_DATA/EPRIME/EVs/cue.txt .
	cp $datadir/${subjectID}/unprocessed/3T/tfMRI_${task}_LR/LINKED_DATA/EPRIME/EVs/math.txt .
	cp $datadir/${subjectID}/unprocessed/3T/tfMRI_${task}_LR/LINKED_DATA/EPRIME/EVs/story.txt .
	cp $datadir/${subjectID}/unprocessed/3T/tfMRI_${task}_LR/LINKED_DATA/EPRIME/EVs/response_story.txt .
	cp $datadir/${subjectID}/unprocessed/3T/tfMRI_${task}_LR/LINKED_DATA/EPRIME/EVs/response_math.txt .
	cp $datadir/${subjectID}/unprocessed/3T/tfMRI_${task}_LR/LINKED_DATA/EPRIME/EVs/question_story.txt .
	cp $datadir/${subjectID}/unprocessed/3T/tfMRI_${task}_LR/LINKED_DATA/EPRIME/EVs/question_math.txt .
	cp $datadir/${subjectID}/unprocessed/3T/tfMRI_${task}_LR/LINKED_DATA/EPRIME/EVs/present_story.txt .
	cp $datadir/${subjectID}/unprocessed/3T/tfMRI_${task}_LR/LINKED_DATA/EPRIME/EVs/present_math.txt .

	eventsCue=`cat cue.txt | wc -l`
	eventsMath=`cat math.txt | wc -l`
	eventsStory=`cat story.txt | wc -l`

	eventsResponseStory=`cat response_story.txt | wc -l`
	eventsResponseMath=`cat response_math.txt | wc -l`

	eventsQuestionStory=`cat question_story.txt | wc -l`
	eventsQuestionMath=`cat question_math.txt | wc -l`

	eventsPresentStory=`cat present_story.txt | wc -l`
	eventsPresentMath=`cat present_math.txt | wc -l`

	sed -i "1s/^/NumEvents $eventsCue \n\n/" cue.txt
	sed -i "1s/^/NumEvents $eventsMath \n\n/" math.txt
	sed -i "1s/^/NumEvents $eventsStory \n\n/" story.txt

	sed -i "1s/^/NumEvents $eventsResponseStory \n\n/" response_story.txt
	sed -i "1s/^/NumEvents $eventsResponseMath \n\n/" response_math.txt

	sed -i "1s/^/NumEvents $eventsQuestionStory \n\n/" question_story.txt
	sed -i "1s/^/NumEvents $eventsQuestionMath \n\n/" question_math.txt

	sed -i "1s/^/NumEvents $eventsPresentStory \n\n/" present_story.txt
	sed -i "1s/^/NumEvents $eventsPresentMath \n\n/" present_math.txt

	echo -e "\n\n\n\n"

	# MOTOR

	#cp $datadir/${subjectID}/unprocessed/3T/tfMRI_${task}_LR/LINKED_DATA/EPRIME/EVs/cue.txt .
	#cp $datadir/${subjectID}/unprocessed/3T/tfMRI_${task}_LR/LINKED_DATA/EPRIME/EVs/lf.txt .
	#cp $datadir/${subjectID}/unprocessed/3T/tfMRI_${task}_LR/LINKED_DATA/EPRIME/EVs/lh.txt .
	#cp $datadir/${subjectID}/unprocessed/3T/tfMRI_${task}_LR/LINKED_DATA/EPRIME/EVs/rf.txt .
	#cp $datadir/${subjectID}/unprocessed/3T/tfMRI_${task}_LR/LINKED_DATA/EPRIME/EVs/rh.txt .
	#cp $datadir/${subjectID}/unprocessed/3T/tfMRI_${task}_LR/LINKED_DATA/EPRIME/EVs/t.txt .

	#eventsCue=`cat cue.txt | wc -l`
	#eventsLf=`cat lf.txt | wc -l`
	#eventsLh=`cat lh.txt | wc -l`
	#eventsRf=`cat rf.txt | wc -l`
	#eventsRh=`cat rh.txt | wc -l`
	#eventsT=`cat t.txt | wc -l`

	#sed -i "1s/^/NumEvents $eventsCue \n\n/" cue.txt
	#sed -i "1s/^/NumEvents $eventsLf \n\n/" lf.txt
	#sed -i "1s/^/NumEvents $eventsLh \n\n/" lh.txt
	#sed -i "1s/^/NumEvents $eventsRf \n\n/" rf.txt
	#sed -i "1s/^/NumEvents $eventsRh \n\n/" rh.txt
	#sed -i "1s/^/NumEvents $eventsT \n\n/" t.txt

	#echo -e "\n\n\n\n"



	./HeteroGLM_physio bold_HCP_${subject}_sm.nii.gz -designfiles regressors_HCP_${task}.txt -contrasts contrasts_HCP_${task}.txt -ontrialbeta allbeta_HCP_${task}.txt -gammaregressors gammaintercept_HCP_${task}.txt -ontrialrho allrho_AR10.txt -mask bold_HCP_${subject}_mask.nii.gz -regressmotion bold_HCP_${subject}_headmotion.1D -regressmotionderiv bold_HCP_${subject}_headmotion_deriv.1D  -saveoriginaldesignmatrix -savedesignmatrix -draws 1000 -burnin 1000 -verbose -savefullposterior -arorder 10 -iota 3.0 -taurho 1.0 

	mv bold_HCP_${subject}* Results/HCPraw/${task}/stc_mc_smoothed_AR10_nonstationary_iota3.0
	#mv bold_HCP_${subject}* Results/HCPraw/${task}/stc_mc_smoothed_AR10_stationary_iota3.0

done





