library(tidyr)
library(dplyr)
library(lubridate)
library(ggplot2)

###############################################################################
read_opinions <- function(file_location = "path/to/file.csv") {
  
  # Reads opinions from a csv file (downloaded earlier) into a dataframe.
  # Adds some extra columns for plotting.
  # 
  # Args:
  #   file_location: Location of Care Opinion data downloaded earlier.
  # 
  # Returns:
  #   opinions: Original downloaded data - plus some extra columns for plotting.  
  
  opinions <- read.csv(file_location, header = FALSE,
                     col.names = c("criticality", "date_of_publication")) %>%
  filter(!is.na(criticality)) %>%
  filter(!is.na(date_of_publication)) %>%
  mutate(
    "date_of_publication" = as.Date(date_of_publication),
    "month" = round_date(date_of_publication, "month"),
    "criticality_fac" = factor(criticality, 
                                 levels = c("severely critical",
                                            "strongly critical",
                                            "moderately critical",
                                            "mildly critical",
                                            "minimally critical",
                                            "not critical")))
  return(opinions)
}

###############################################################################
plot_criticality <- function(df, subtitle) {
  
  # Plots a stacked bar chart of opinions by month and criticality. See README 
  # for an example.
  # 
  # Args:
  #   df: A dataframe of data produced by read_opinions()
  #   subtitle: The subtitle for the plot
  # 
  # Returns:
  #   A plot object visualising opinions by month submitted and criticality.  
  
  criticality_colour <- c("severely critical" = "#a50f15",
                        "strongly critical" = "#de2d26",
                        "moderately critical" = "#fb6a4a",
                        "mildly critical" = "#fcae91",
                        "minimally critical" = "#fee5d9",
                        "not critical" = "#bdd7e7")
  
  ggplot(df, aes(month, fill = criticality_fac)) +
    geom_bar(width=25) +
    scale_fill_manual("", values = criticality_colour) +
    scale_x_date(limits = as.Date(c('2008-08-01',NA)),
                 date_breaks = "1 year",
                 date_labels = "%Y") +
    scale_y_continuous(position = "right") +
    theme_minimal() +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          axis.title.x = element_blank(),
          axis.title.y = element_blank(),
          legend.position = c(.15, .7)) +
     labs(title = "Number of Care Opinion stories per month",
         subtitle = subtitle,
         caption = "Source: ISD Scotland")
}
