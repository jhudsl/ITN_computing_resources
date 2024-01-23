#!/usr/bin/env Rscript

library(magrittr)
library(tidyverse)
library(DT)
library(here)

formatTheTables <- function(tableOI, keywordOI, non_resource = FALSE){
  
  #check that it's tibble, if not, make it a tibble
  
  #Mutate the tibble to alter three of the columns
  if (non_resource) {
    generalData <- tableOI %>%
      mutate(`Link (Hyperlinked Over Name)` = paste0('<a href="',`Link (Hyperlinked Over Name)`,'"style="color: #be3b2a"',' target="_blank"','<div title="Main Link"> </div>','<img src="resources/images/Hyperlink2.png"  height="30"> </img>', '</a>'),
             Documentation = paste0('<a href="',Documentation,'"style="color: #be3b2a"','target="_blank"','<div title="Documentation"> </div>','<img src="resources/images/Documentation2.png" height="30"> </img>', '</a>'),
             Publications = paste0('<a href="',Publications,'"style="color: #be3b2a"', 'target="_blank"','<div title="Publications"> </div>','<img src="resources/images/Publication2.png" height="30"> </img>', '</a>'))
  } else {
    generalData <- tableOI %>%
    mutate(Name = paste0('<a href="',Link,'"style="color:#be3b2a"',
   'target="_blank"','<div title="Main Link"> </div>',Name,'</a>'))
  }
    
  #Mutate generalData's Name to be bolded.
  generalData %<>%
    mutate(Name = paste0('<b>', Name, "</b>"))
  
  #Mutate the pricing column to have a link & Mutate the tibble to combine all three columns into a general "Platform" column.
  if (non_resource){
    generalData %<>%
      mutate(Price = paste0('<a href="',PLink,'"style="color: #be3b2a"',' target="_blank"','<div title="Pricing Link"> </div>', Price,'</a>')) %>%
      mutate(Platform = paste0(Name, ":",'<br></br>', `Link (Hyperlinked Over Name)`, Documentation, Publications))
  }
  
  #Mutate Platform to contain an ITCR logo if the Platform is funded by ITCR.
  #If non-resource table, also shift the location of the "Platform" column and create html version of links in resources
  if (non_resource){
    for (row in 1:nrow(generalData)){
      status <- generalData[row, "Funding"]
      target <- generalData[row, "Platform"]
      
      if(status == "Yes"){
        target %<>%
          mutate(Platform = paste0(Platform,'<br></br>','<img src="ITCRLogo.png" height="40"></img>'))
        
        generalData[row, "Platform"] <- target
      }
    }
    
    generalData %<>%
      relocate(Platform, .after = `Link (Hyperlinked Over Name)`)
    
    resource <- read_csv(file = here::here("data/itcr_table_resources_identifier.csv"))
    
    resource %<>% 
      mutate(Link = paste0('<a href="', Link,'"style="color: #be3b2a"',
                           ' target="_blank"','<div title="Resource Link"> </div>',identifier,'</a>'))
    
    LinkUpdater <- bind_cols(Name = pull(generalData, Name),
                             read.table(text = as.character(generalData$`Data Provided`), sep = ",", 
                                        as.is = TRUE, fill = TRUE, na.strings = "")) %>%
      pivot_longer(cols = -Name, names_to = "vars", values_to = "vals") %>%
      filter(!is.na(vals)) %>%
      mutate(vals = str_trim(vals, side = "both")) %>%
      select(-vars, identifier = vals) %>%
      left_join(y = resource %>% select(identifier, Link), by = "identifier") %>%
      mutate(Link = if_else(is.na(Link), identifier, Link)) %>%
      select(-identifier) %>%
      group_by(Name) %>% mutate(var = paste0("var", 1:n() )) %>% ungroup() %>%
      relocate(var) %>%
      pivot_wider(names_from = var, values_from = Link) %>%
      unite(col = "Data Provided2", -Name, sep = ", ", na.rm = T, remove = T)
    
  generalData %<>% left_join(LinkUpdater, by = "Name") %>%
    relocate(`Data Provided2`, .before = `Data Provided`) %>%
    select(-`Data Provided`) %>% rename("Data Provided" = `Data Provided2`)
    
  } else {
    for (row in 1:nrow(generalData)) {
      status <- generalData[row, "Funding"]
      target <- generalData[row, "Name"]
    
      if(status == "Yes") {
        target %<>%
          mutate(Name = paste0(Name, '<br></br>', '<img src="ITCRLogo.png" height="40"></img>'))
      
        generalData[row, "Name"] <- target
      }
    }
  }
  
  #Create a trimmed version of the data by removing the non-consolidated columns
  ##For non-resource Table want to keep columns "Platform", "Subcategories", "Unique Factor", "Data Types (Clean)", "Price", "Data Provided", "Summary"
  ##For Resource Table Want to keep columns "Name", "Subcategories", "Summary", "Unique Factors", "Data Type", and "Price"
  if (non_resource){
    trimmedData <- generalData[ c("Platform", "Subcategories", "Unique Factor", "Data Types (Clean)", "Price", "Data Provided", "Summary")] %>%
      relocate(Summary, .after = Subcategories) %>%
      mutate(Category = keywordOI) %>% 
      relocate(Category, .after = Platform)
  } else {
    trimmedData <- generalData[ c("Name", "Subcategories", "Data Type", "Unique Factors", "Price", "Summary") ] %>%
      relocate(Summary, .after = Subcategories) %>%
      relocate(`Unique Factors`, .after = Summary)
  }
  
  return(trimmedData)
}

setup_dt_datatable <- function(modified_data, columnDefsListOfLists){
  ITCR_table <- modified_data %>%
    select(-any_of("Category")) %>%
    DT::datatable(
      style = 'default',
      width="100%",
      colnames = c('Unique Factor' = 4, 'Types of Data' = 5, 'Summary' =3),
      rownames = FALSE,
      escape = FALSE,
      filter = "top",
      options = list(scrollX = TRUE, autoWidth = TRUE, pageLength = 10,
                     scrollCollapse = TRUE, fillContainer = TRUE,
                     order = (list(0, 'asc')),
                     columnDefs = columnDefsListOfLists,
                     initComplete = JS(
                       "function(settings, json) {",
                       #"$('body').css({'font-family': 'Calibri'});",
                       "$(this.api().table().header()).css({'backgroundColor': '#3f546f'});",
                       "$(this.api().table().header()).css({'color': '#fff'});",
                       "}")
                     )
      )
  return(ITCR_table)
}