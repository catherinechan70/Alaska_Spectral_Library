library(spectrolab)
library(tidyverse)
setwd("/Alaska_Spectral_Library")

####Read in data as spectra
Murph_lib_spectra<-read_spectra("original_data/20180729/M_Dome",
                                format="sed")

##Remove eightmileflight1 scans
Murph_lib_spectra<-Murph_lib_spectra[grep("M_Dome_T1",invert=TRUE,names(Murph_lib_spectra))]


#######Fix Names
names(Murph_lib_spectra)<-gsub(".sed","",names(Murph_lib_spectra))
names(Murph_lib_spectra)<-gsub("_00","_Murph_",names(Murph_lib_spectra))
names(Murph_lib_spectra)<-gsub("arctoparmelia","arctop",names(Murph_lib_spectra))
names(Murph_lib_spectra)<-gsub("bareMin","br",names(Murph_lib_spectra))
names(Murph_lib_spectra)<-gsub("bare","br",names(Murph_lib_spectra))
names(Murph_lib_spectra)<-gsub("loisleuria","loisla",names(Murph_lib_spectra))
names(Murph_lib_spectra)<-gsub("DRY","",names(Murph_lib_spectra))
names(Murph_lib_spectra)<-gsub("orangePorpidia","Prpdia",names(Murph_lib_spectra))
names(Murph_lib_spectra)<-gsub("polytrichum","polytr",names(Murph_lib_spectra))
names(Murph_lib_spectra)<-gsub("rhizocarponGREY","rhzGRY",names(Murph_lib_spectra))
names(Murph_lib_spectra)<-gsub("sal_wooly","salwol",names(Murph_lib_spectra))
names(Murph_lib_spectra)<-gsub("tofeldia","tfldia",names(Murph_lib_spectra))

###Create Metadata
Murph_lib_metadata<-as.data.frame(names(Murph_lib_spectra))
names(Murph_lib_metadata)[1]<-"ScanID"

###Create column PFT and column area
Murph_lib_metadata<-Murph_lib_metadata%>%mutate(PFT= substr(Murph_lib_metadata$ScanID,start=1,stop=6))
Murph_lib_metadata$PFT[Murph_lib_metadata$PFT=="brSoil"] <- "bare_soil"
Murph_lib_metadata$PFT[Murph_lib_metadata$PFT=="brrock"] <- "bare rock"
Murph_lib_metadata$PFT[Murph_lib_metadata$PFT=="Prpdia"] <- "orange_Porpidia"
Murph_lib_metadata$PFT[Murph_lib_metadata$PFT=="polytr"] <- "polytrichum"
Murph_lib_metadata$PFT[Murph_lib_metadata$PFT=="rhzGRY"] <- "grey_rhizocarpon"
Murph_lib_metadata$PFT[Murph_lib_metadata$PFT=="salwol"] <- "wooly_salix"
Murph_lib_metadata$PFT[Murph_lib_metadata$PFT=="tfldia"] <- "toefeldia"
Murph_lib_metadata$PFT[Murph_lib_metadata$PFT=="rhwrug"] <-"rhyrug"
Murph_lib_metadata$PFT[Murph_lib_metadata$PFT=="kwarts"] <-"quartz"
Murph_lib_metadata$PFT[Murph_lib_metadata$PFT=="loisla"] <-"loipro"
Murph_lib_metadata$PFT[Murph_lib_metadata$PFT=="melhap"] <-"melhep"
Murph_lib_metadata$PFT[Murph_lib_metadata$PFT=="perdac"] <-"pedrac"
Murph_lib_metadata$PFT[Murph_lib_metadata$PFT=="petfer"] <-"petfri"
Murph_lib_metadata$area<- "Murphy"
                       
###Set metadata
meta(Murph_lib_spectra) = data.frame(Murph_lib_metadata, stringsAsFactors = FALSE)

## Trim ends and resample every 5nm
Murph_lib_spectra_5nm = resample(Murph_lib_spectra, seq(350, 2500, 5))
Murph_lib_spectra_10nm = resample(Murph_lib_spectra, seq(350, 2500, 10))
Murph_lib_spectra_50nm = resample(Murph_lib_spectra, seq(350, 2500, 50))
Murph_lib_spectra_100nm = resample(Murph_lib_spectra, seq(350, 2500, 100))

###save spectra
saveRDS(Murph_lib_spectra,"processed spec//Murph_Lib/Murph_lib_spectra.rds")
saveRDS(Murph_lib_spectra_5nm,"processed spec/Murph_Lib/Murph_lib_spectra_5nm.rds")
saveRDS(Murph_lib_spectra_10nm,"processed spec/Murph_Lib/Murph_lib_spectra_10nm.rds")
saveRDS(Murph_lib_spectra_50nm,"processed spec/Murph_Lib/Murph_lib_spectra_50nm.rds")
saveRDS(Murph_lib_spectra_100nm,"processed spec/Murph_Lib/Murph_lib_spectra_100nm.rds")

