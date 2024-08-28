# source me for all analyses 

library(tidyverse)
library(lme4)
library(knitr) # for kable
# library(ggrepel)
# library(ggthemes)
# library(viridis)
# library(cowplot)
# remotes::install_github("jmgirard/agreement")
# library(agreement)
# library(tictoc)

# Seed for random number generation
set.seed(42)
knitr::opts_chunk$set(cache.extra = knitr::rand_seed, cache = TRUE, 
                      message=FALSE, warning=FALSE, error=FALSE)
options(dplyr.summarise.inform = FALSE)

