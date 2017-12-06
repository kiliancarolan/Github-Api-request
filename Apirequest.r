###Package Instalation, some will not be necessary but allow for future adaption
library(jsonlite)
library(httpuv)
library(httr)
library(ggplot2)
library(d3r)

### getting oauth to allow for more api requests within given time period
oauth_endpoints("github")
myapp <- oauth_app(appname = "Software_Engineering_Kilian_Carolan",
                   key = "237cd284e97e7cb3d561",
                   secret = "a00444a548f2cf7d81d040c90cb389c0be3bf814")
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)
gtoken <- config(token = github_token)

###BaseUrl
usersUrl<-("https://api.github.com/users")

###Allow for pagnation
pages<-list()
for(i in 1:2)
{
  mydataPaste<-paste0(usersUrl, "?per_page=75&page=",i)
  mydata<-GET(mydataPaste,gtoken)
  json1 = content(mydata)
  mydataFrame = jsonlite::fromJSON(jsonlite::toJSON(json1))
  message("Retrieving page ", i)
  pages[[i+1]] <- mydataFrame
  logins <- rbind_pages(pages)
}
### Following code will produce a graph of users Followers Vs Following Numbers 
### given sample size of 70
followinglist<-c()
followerlist<-c()
i=1

while(i<70)
{
  testLoopPaste<-paste0(usersUrl,"/",loginsName[i])
  testLoopData=GET(testLoopPaste,gtoken)
  jsonLoopTest=content(testLoopData)
  testLoopDF=jsonlite::fromJSON(jsonlite::toJSON(jsonLoopTest))
  testFollower<-testLoopDF$followers
  testFollowing<-testLoopDF$following
  print(paste("name of user is ",loginsName[i]," number of followers ", testLoopDF$followers,
              " They follow ",testLoopDF$following, "people"))
  followinglist=c(followinglist,testFollowing)
  followerlist<-c(followerlist,testFollower)
  
  i=i+1
}
plot(followinglist,followerlist)

###Show users followers details

i=1
while(i<3)
{
  followerPaste<-paste0(usersUrl,"/",loginsName[i],"/followers")
  followerData=GET(followerPaste,gtoken)
  jsonfollower=content(followerData)
  followerDF=jsonlite::fromJSON(jsonlite::toJSON(jsonfollower))
  followerDF
  followerNames<-followerDF$login
  print(followerNames)
  i=i+1
}

