library(spectrolab)
library(tidyverse)
setwd("/Alaska_Spectral_Library")

####Read in data as spectra
yKDeltLib_spectra<-read_spectra("original_data/YKDeltLib",
                                format="sed")

##Remove eightmileflight1 scans
yKDeltLib_spectra<-yKDeltLib_spectra[grep("site21clasticprobe",invert=TRUE,names(yKDeltLib_spectra))]


#######Fix Names
names(yKDeltLib_spectra)<-gsub(".sed","",names(yKDeltLib_spectra))
names(yKDeltLib_spectra)<-gsub("lclip+[0-9]","",names(yKDeltLib_spectra))
names(yKDeltLib_spectra)<-gsub("clip+[0-9]","",names(yKDeltLib_spectra))
names(yKDeltLib_spectra)<-gsub("lclip","",names(yKDeltLib_spectra))
names(yKDeltLib_spectra)<-gsub("clip","",names(yKDeltLib_spectra))
names(yKDeltLib_spectra)<-gsub("site+[0-9]+[0-9]","",names(yKDeltLib_spectra))
names(yKDeltLib_spectra)<-gsub("lcli2","",names(yKDeltLib_spectra))
names(yKDeltLib_spectra)<-gsub("cli2","",names(yKDeltLib_spectra))
names(yKDeltLib_spectra)<-gsub("probe","",names(yKDeltLib_spectra))

##Create metadata
yKDeltLib_metadata<-as.data.frame(names(yKDeltLib_spectra))
names(yKDeltLib_metadata)[1]<-"ScanID"

###Create column PFT and column area
yKDeltLib_metadata<-yKDeltLib_metadata%>%mutate(PFT= substr(yKDeltLib_metadata$ScanID,start=1,stop = 6))
names(yKDeltLib_metadata)<-gsub("Salova","salova",names(yKDeltLib_metadata))
yKDeltLib_metadata$area<- "Yukon_Delta"

####ensure all scans are different
yKDeltLib_metadata<-yKDeltLib_metadata %>%
  group_by(PFT, area) %>%
  mutate(
    ScanID = as.character(ScanID),
    ScanID = as.character(paste0(substr(ScanID, 1, nchar(ScanID) - 1), row_number())))

###Set metadata
meta(yKDeltLib_spectra) = data.frame(yKDeltLib_metadata, stringsAsFactors = FALSE)

## Smooth spectra
yKDeltLib_spectra_smooth = smooth(yKDeltLib_spectra)

## Trim ends and resample every 5nm
yKDeltLib_spectra_smooth_5nm = resample(yKDeltLib_spectra_smooth, seq(350, 2500, 5))
yKDeltLib_spectra_smooth_10nm = resample(yKDeltLib_spectra_smooth, seq(350, 2500, 10))
yKDeltLib_spectra_smooth_50nm = resample(yKDeltLib_spectra_smooth, seq(350, 2500, 50))
yKDeltLib_spectra_smooth_100nm = resample(yKDeltLib_spectra_smooth, seq(350, 2500, 100))

###save spectra
saveRDS(yKDeltLib_spectra,"processed spec/yKDeltLib/yKDeltLib_spectra.rds")
saveRDS(yKDeltLib_spectra_smooth,"processed spec/yKDeltLib/yKDeltLib_spectra_smooth.rds")
saveRDS(yKDeltLib_spectra_smooth_5nm,"processed spec/yKDeltLib/yKDeltLib_spectra_smooth_5nm.rds")
saveRDS(yKDeltLib_spectra_smooth_10nm,"processed spec/yKDeltLib/yKDeltLib_spectra_smooth_10nm.rds")
saveRDS(yKDeltLib_spectra_smooth_50nm,"processed spec/yKDeltLib/yKDeltLib_spectra_smooth_50nm.rds")
saveRDS(yKDeltLib_spectra_smooth_100nm,"processed spec/yKDeltLib/yKDeltLib_spectra_smooth_100nm.rds")

