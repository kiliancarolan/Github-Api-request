library(jsonlite)
library(httpuv)
library(httr)
oauth_endpoints("github")
myapp <- oauth_app(appname = "Software_Engineering_Kilian_Carolan",
                   key = "237cd284e97e7cb3d561",
                   secret = "a00444a548f2cf7d81d040c90cb389c0be3bf814")
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)
gtoken <- config(token = github_token)
usersTest<-("https://api.github.com/users")
pages<-list()
for(i in 1:2)
{
  mydataPaste<-paste0(usersTest, "?per_page=75&page=",i)
  mydata<-GET(mydataPaste,gtoken)
  json1 = content(mydata)
  mydataFrame = jsonlite::fromJSON(jsonlite::toJSON(json1))
  message("Retrieving page ", i)
  pages[[i+1]] <- mydataFrame
  logins <- rbind_pages(pages)
}
loginsName<-logins$login
loginsName
loginsName[3]
##Test Code to get number of followers from sample of users
testPaste<-paste0(usersTest,"/",loginsName[3])
testData=GET(testPaste,gtoken)
jsonTest=content(testData)
testDF=jsonlite::fromJSON(jsonlite::toJSON(jsonTest))
testDF
testDF$followers
#logins <- rbind_pages(pages)
logins$avatar_url<- NULL
logins$gravatar_id<-NULL
 
#check
nrow(logins)
length(logins)
#final_data<-do.call(rbind,logins)
#write.csv(final_data,"final_data.csv")
#head(final_data)
