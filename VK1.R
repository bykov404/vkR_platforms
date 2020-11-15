# Bykov's R - Getting data from Vkontakte with R

# Lab goals
# Install, load & set package 'vkR'
# Analyze community activiy
# Extract posts

# Check your working directory
getwd()
# If necessary, set your working directory
# setwd("/home/R/VK1")

# If necessary, install packages
install.packages("vkR") 

# Load package packages in operating memory
library("vkR")

# Check if the package has been loaded
search()

# Set Up VK oauth
vkOAuth(client_id = 6258451, scope = "friends,groups,messages")

# Set Up VK access token (get it from URL)
setAccessToken("a969074651a049f8a8e864d84267e668666c5b18e8572d1ba1698a671bf5db9e4a3ac5ceb1c528aeb35ac")

# Analyzing community activity
domain <- 'citizenmoscow'
wall <- getWallExecute(domain = domain, count = 0, progress_bar = TRUE)
metrics <- jsonlite::flatten(wall$posts[c("date", "likes", "comments", "reposts")])
metrics$date <- as.POSIXct(metrics$date, origin="1970-01-01", tz='Europe/Moscow')

library(dplyr)
df <- metrics %>% 
  mutate(period = as.Date(cut(date, breaks='month'))) %>% 
  group_by(period) %>%
  summarise(likes = sum(likes.count), comments = sum(comments.count), reposts = sum(reposts.count), n = n())

library(ggplot2)
library(tidyr)
ggplot(data=gather(df, 'type', 'count', 2:5), aes(period, count)) + geom_line(aes(colour=type)) +
  labs(x='Date', y='Count')

# Extracting 100 posts from community citizenmoscow
wall <- getWallExecute(domain="citizenmoscow", count=100, progress_bar=TRUE)
View(wall)
df <- as.data.frame(wall[2])
write.csv(df$items.text, "wall.csv")

# Extracting 100 posts from community portalnashspb
wall <- getWallExecute(domain="portalnashspb", count=100, progress_bar=TRUE)
View(wall)
df <- as.data.frame(wall[1])
write.csv(df$posts.text, "wall.csv")