run("Images to Stack", "name=Stack title=[] use");
run("Linear Stack Alignment with SIFT", "initial_gaussian_blur=1.60 steps_per_scale_octave=3 minimum_image_size=64 maximum_image_size=1024 feature_descriptor_size=4 feature_descriptor_orientation_bins=8 closest/next_closest_ratio=0.92 maximal_alignment_error=25 inlier_ratio=0.05 expected_transformation=Affine interpolate");
saveAs("Tiff", "/Volumes/My Passport for Mac/MICSSS/3_ImageJ/1_Aligned/i45_1N_DO_ROI_0");
close();
selectWindow("Stack");
close();
