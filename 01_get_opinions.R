co_api_key <- paste("SUBSCRIPTION_KEY", Sys.getenv("co_api_key"))
library(httr)
library(curl)
library(xml2)
library(tidyr)
library(lubridate)
library(dplyr)
library(purrr)

###############################################################################
tidy_opinions <- function(opinion_list = list()) {
  # Turns a list of opinions into a dataframe of opinions.
  # 
  # Args:
  #   opinion_list: Content downloaded through the Care Opinion API comes in 
  #   nested lists. Dataframes are much easier to work with.
  # 
  # Returns:
  #   A dataframe with certain important fields from opinion_list
  
  opinions_df <- data.frame(
    "criticality" = map(opinion_list, "criticality") %>%
      map_if(is.null, ~ NA_character_) %>% flatten_chr(),
    "date_of_publication" = map(opinion_list, "dateOfPublication") %>%
  map_if(is.null, ~ NA_character_) %>% flatten_chr() %>% substr(1, 10) %>%
  as.Date()
  )
  
  return(opinions_df)
}

###############################################################################
get_opinions <- function(submittedonafter = "2000-01-01",
                         file_location = "path/to/file.csv") {
  # Fetches all opinions from Care Opinion submitted on or after the parameter 
  # submittedonafter and saves them to a .csv file at file_location.
  # 
  # Args:
  #   submittedonafter: The cut off point for stories. If not assigned all 
  #   stories will be fetched (this will take a significant amount of time).
  #   file_location: Stories will be saved here.
  # 
  # Returns:
  #   NULL
  
  stopifnot(file_location != "path/to/file.csv")
  skip        <- 0
  
  while(TRUE){
    # The Care Opinion API returns a maximum of 100 opinions per request. A 
    # simple way to work with this is to loop over many requests; appending 
    # responses to a file on disk.
    
    opinion_content <- GET(paste0("https://www.careopinion.org.uk/api/v2/",
                                  "opinions?take=100&skip=", skip, 
                                  "&submittedonafter=", submittedonafter),
                           add_headers(Authorization = co_api_key)) %>%
      content() %>%
      tidy_opinions()
    if(nrow(opinion_content) == 0) break  # Stop once we run out of opinions

    write.table(opinion_content, file_location, sep = ",", col.names = FALSE,
                append = TRUE, row.names = FALSE)
    
    print(paste0("Fetching stories up until ", 
                 opinion_content[["date_of_publication"]] %>% max(),
                 " (story count = ", skip + nrow(opinion_content), ")"
                 ))
    skip <- skip + 100
  }
}
