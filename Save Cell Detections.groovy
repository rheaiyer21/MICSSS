def name = getProjectEntry().getImageName() - '.tif' + '.xls'
def path = buildFilePath(PROJECT_BASE_DIR, 'Annotation Results')
mkdirs(path)
path = buildFilePath(path,name)
saveDetectionMeasurements(path)
print 'Results exported to' + path