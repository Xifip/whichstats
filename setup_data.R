###
### Data Setup
###

ensure.installed <- function(package){
  if (!package %in% installed.packages()) install.packages(package)
}


ensure.installed("ggplot2");
library(ggplot2);

ensure.installed("likert");
library(likert);

ensure.installed("reshape2");
library(reshape2);

ensure.installed("reshape");
library(reshape);

ensure.installed("plyr");
library(plyr);

ensure.installed("kohonen");
library(kohonen);
