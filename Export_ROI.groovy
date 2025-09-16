//Mark each ROI

//This could still have the limitation of small size ROIs (the 600MB limit Luisanna mentioned today) but I run it with larger images and it works!!

//This may need some small changes to run in a MAC

 

def imageName = GeneralTools.getNameWithoutExtension(getCurrentImageData().getServer().getMetadata().getName())

//Make sure the location you want to save the files to exists - requires a Project

def pathOutput = buildFilePath(PROJECT_BASE_DIR, 'ROI_Export')

mkdirs(pathOutput)

 

unclassifiedAnnotations = getAnnotationObjects().findAll{it.getPathClass() == null}

 

unclassifiedAnnotations.eachWithIndex{anno,x->

    //If image is called mCherry L5, this will generateone image for each ROI called "mCherry L5_ROI_1...X.tif

    //If .png or .ome image needed, just change extension in line14

    fileName = pathOutput+"//"+imageName+ "_ROI_"+x+".tif"

    def roi = anno.getROI()

    def requestROI = RegionRequest.createInstance(getCurrentServer().getPath(), 1, roi)

    writeImageRegion(getCurrentServer(), requestROI, fileName)

}