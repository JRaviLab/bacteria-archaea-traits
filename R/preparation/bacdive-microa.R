# BacDive - Microaerophiles only!
library(stringr)
# Open original dataset, combine all cells into one long vector, clean and attempt to extract species names (i.e., strings >10 characters)
# bac <- read_csv("data/raw/bacdive-microa/bacdive-microa.csv", local = locale(encoding = "latin1"))
bac <- readLines("data/raw/bacdive-microa/bacdive-microa.csv")

# bac <- c(t(bac))
bac <- bac[bac != ""]
#bac <- iconv(bac, from = "latin1", to = "UTF-8") # convert latin1 to UTF-8
#bac <- gsub("\"", "", bac) 
bac <- stringr::str_replace_all(bac, r"(")", "")
bac <- gsub("DSM [1-9]|[0-9]|KCTC|CIP|CCUG|LMG|JCM|NCTC|NCDO|ATCC [A-Z]*|攼㸹", "", bac) 
bac <- unlist(strsplit(bac, ";"))
# bac <- bac[nchar(bac) > 10]
  # why was this commented out? 
  # Quick scroll through bac shows no bacterial names <10
  # by commenting out nchar filter we keep the following: 
  # NY microaerophilic 2 5116 type material (chestnut blight fungus?)
  # SL microaerophilic 2 1490994 SL type material (another fungus)
  # Paris microaerophilic 5 49669 scientific name (A PLANT?)
# recommendation: bac <- bac[nchar(bac) >= 10]

bac <- unique(bac)

# Add metabolism
bac <- data.frame(org_name=bac, metabolism="microaerophilic")

# Merge tax_id, this step removes junk strings not caught above.
bac <- bac %>% left_join(nam, by=c("org_name"="name_txt")) %>%
  select(tax_id, org_name, metabolism) %>%
  filter(!is.na(tax_id))

#Add reference
bac <- bac %>% mutate(ref_type = "doi", reference = "doi.org/10.1093/nar/gky879") 

#Save master data
write.csv(bac, "output/prepared_data/bacdive-microa.csv", row.names=FALSE)