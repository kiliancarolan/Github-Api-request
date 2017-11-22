library(jsonlite)
library(httpuv)
library(httr)
oauth_endpoints("github")
myapp <- oauth_app(appname = "Software_Engineering_Kilian_Carolan",
                   key = "237cd284e97e7cb3d561",
                   secret = "a00444a548f2cf7d81d040c90cb389c0be3bf814")
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)
gtoken <- config(token = github_token)
phadejReq <- GET("https://api.github.com/users/phadej/followers?per_page=100;", gtoken)

# Take action on http error
stop_for_status(phadejReq)

# Extract content from a request
json1 = content(phadejReq)

# Convert to a data.frame
gitDF = jsonlite::fromJSON(jsonlite::toJSON(json1))

# Subset data.frame
gitDF[gitDF$full_name == "phadej", "created_at"] 
gitDF
gg_commits<-fromJSON("https://api.github.com/repos/hadley/ggplot2/commits")
phadejRaw<-("https://api.github.com/users/phadej/followers?per_page=100;")
data<-fromJSON(phadejRaw)
length(data)
final_data<-do.call(rbind,data)
write.csv(final_data,"final_data.csv")
head(final_data)
