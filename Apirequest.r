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
githubURL<-("https://api.github.com")
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
logins
loginsName<-logins$login
### Following code will produce a graph of users Followers Vs Following Numbers 
### given sample size of 70
followinglist<-c()
followerlist<-c()
namelist<-c()
i=1

while(i<70)
{
  loopPaste<-paste0(usersUrl,"/",loginsName[i])
  loopData=GET(loopPaste,gtoken)
  jsonLoop=content(loopData)
  loopDF=jsonlite::fromJSON(jsonlite::toJSON(jsonLoop))
  numFollower<-loopDF$followers
  numFollowing<-loopDF$following
  name<-loopDF$login
  followinglist=c(followinglist,numFollowing)
  followerlist<-c(followerlist,numFollower)
  namelist<-c(namelist,name)
  print(".")
  
  i=i+1
}
followervsfollowing<-data.frame(namelist,followinglist,followersist)
followervsfollowing
qplot(followinglist,followerlist,followervsfollowing,xlab="Number Following", 
      ylab="Number of Folllowers", main="graph of followers vs following")



##Graph user event activity vs num of followers
eventlist<-c()
followerlist2<-c()
i=1
eventPaste<-paste0(usersUrl,"/","octocat","/events/public")
eventData=GET(eventPaste,gtoken)
eventJson=content(eventData)
eventDF=jsonlite::fromJSON(jsonlite::toJSON(eventJson))
eventDF
eventJson

while(i<70)
{
  ###get number of followers
  loopPaste2<-paste0(usersUrl,"/",loginsName[i])
  loopData2=GET(loopPaste2,gtoken)
  jsonLoop2=content(loopData2)
  loopDF2=jsonlite::fromJSON(jsonlite::toJSON(jsonLoop2))
  numFollower<-loopD2F$followers
  ###get number of events
  eventPaste<-paste0(usersUrl,"/",loginsName[i],"/events/public")
  eventData=GET(eventPaste,gtoken)
  eventJson=content(eventDara)
  eventDF=jsonlite::fromJSON(jsonlite::toJSON(eventJson))
  
  eventlist=c(eventlist,numEvents)
  followerlist2<-c(followerlist2,numFollower)
  
  i=i+1
}

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

contributeurl<-paste0(githubURL,"/repos/norvig/pytudes/stats/participation")
participationData=GET(contributeurl,gtoken)
jsonParticipation=content(participationData)
participationDF=jsonlite::fromJSON(jsonlite::toJSON(jsonParticipation))
participationDF
ownerCommits=participationDF$owner
outsiderCommits=(participationDF$all)-(participationDF$owner)
ownerCommits
outsiderCommits
ownervsoutsider<-data.frame(ownerCommits,outsiderCommits)
ownervsoutsider
