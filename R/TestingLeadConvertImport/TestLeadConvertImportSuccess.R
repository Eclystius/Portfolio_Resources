



# Load Libraries
library(shiny)
library(miniUI)
library(salesforcer)
library(dbplyr)
library(ggplot2)
library(dplyr)
library(readr)
library(tibble)
library(tidyr)
library(purrr)
library(stringr)
library(forcats)

# For debugging
# print(getwd())
# 
# Setting working directory to location of 3rd party export
# setwd("E:/Projects/TestingLeadConvertImport")
# 
# For debugging
# print(getwd())


# Create Data Frame from csv
baseData <- read.csv(dir(pattern='')[1])

# # Add Id column for temporary key when debugging
# orderedData <- tibble::rowid_to_column(baseData, "ID")


separatedData <- separate(orderedData, name, into = c("FirstName", "LastName"))

# # For debugging
# separatedData %>% 
#   group_by(email) %>% 
#   filter(n()>1)

# Check for duplicates in email, since it is the primary key
dedupedData <- distinct(separatedData,email, .keep_all = TRUE)

# Fix formatting issues with zip codes
dedupedData$zip <- stringr::str_pad(dedupedData$zip, width=5, pad = "0")

# Add two boolean columns for SF Automation Logic
dedupedData$sfpremium <- c(FALSE)
dedupedData$sfbasic <- c(FALSE)

# Manipulating boolean fields for SF Automation Logic for Products
premData <- within(dedupedData, {
  f <- product == 'SFPremium'
  sfpremium[f] <- 'TRUE'
  sfbasic[f] <- 'TRUE'
})

# premData <- within(premData, {
#   f <- product == 'SFPremium'
#   sfpremium[f] <- 'TRUE'
#   sfbasic[f] <- 'TRUE'
# })

prodprepData <- within(premData, {
  f <- product == 'SFBasic'
  sfbasic[f] <- 'TRUE'
})

colnames(prodprepData) <- c("ID", "Email", "FirstName", "LastName", "Age", 
                            "Street", "City", "State", "PostalCode", "Revenue", 
                            "Product", "Company", "Date", "SFPremium__c", 
                            "SFBasic__c", "Remove")

prodprepData$Remove <- NULL
prodprepData$ID <- NULL
prodprepData$Date <- NULL
prodprepData$Age <- NULL
prodprepData$Revenue <- NULL
prodprepData$Product <- NULL
head(prodprepData)
# n <- nrow(prodprepData)

# Authenticate connection with Salesforce Org
sf_auth()


new_leads1 <- sf_create(prodprepData, object_name = "Lead", api_type = "Bulk 1.0")
new_leads1
