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
phadejRaw<-("https://api.github.com/users/phadej/followers")
pages<-list()
mydata1<-fromJSON(paste0(phadejRaw, "?page=1"),flatten=TRUE)
mydata2<-fromJSON(paste0(phadejRaw, "?page=2"),flatten=TRUE)
mydata3<-fromJSON(paste0(phadejRaw, "?page=3"),flatten=TRUE)
mydata4<-fromJSON(paste0(phadejRaw, "?page=4"),flatten=TRUE)
mydata5<-fromJSON(paste0(phadejRaw, "?page=5"),flatten=TRUE)
mydata6<-fromJSON(paste0(phadejRaw, "?page=6"),flatten=TRUE)

nrow(mydata1)
finalDataTest<-rbind_pages(list(mydata1,mydata2,mydata3,mydata4,mydata5,mydata6))
finalDataTest
for(i in 1:6)
{
  mydata<-fromJSON(paste0(phadejRaw, "?page=",i))
  message("Retrieving page ", i)
  pages[[i+1]] <- mydata
}
logins <- rbind_pages(pages)
#check
nrow(logins)

#data<-fromJSON(phadejRaw)
#length(data)
#final_data<-do.call(rbind,data)
#write.csv(final_data,"final_data.csv")
#head(final_data)

