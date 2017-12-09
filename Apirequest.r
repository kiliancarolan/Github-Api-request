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
  mydataPaste<-paste0(usersUrl, "?per_page=50&page=",i)
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

while(i<101)
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
  print(paste0("getting user and details ", i))
  
  i=i+1
}
followervsfollowing<-data.frame(namelist,followinglist,followerlist)
followervsfollowing
qplot(followinglist,followerlist,followervsfollowing,xlab="Number Following", 
      ylab="Number of Folllowers", main="graph of followers vs following")

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
###Get user name
getUser<-function()
{
  user <- readline(prompt="Enter user name ")
  return(user)
}
###Get repository Name
getRepo<-function()
{
  repo<-readline(prompt="Enter repository name")
  return(repo)
}

###Getting Commit stats for a repository
repositoryParticipation<-function(desiredUser,desiredRepo,weekVector)
{
  contributeurl<-paste0(githubURL,"/repos/",desiredUser,"/",desiredRepo,"/stats/participation")
  participationData=GET(contributeurl,gtoken)
  jsonParticipation=content(participationData)
  participationDF=jsonlite::fromJSON(jsonlite::toJSON(jsonParticipation))
  participationDF
  ownerCommits=participationDF$owner
  outsiderCommits=(participationDF$all)-(participationDF$owner)
  ownerCommits
  outsiderCommits
  j=0
  for(j in 1:length(ownerCommits))
  {
    weekVector<-c(weekVector,j)
    print(j)
  }
  ownervsoutsider<-data.frame(weekVector,ownerCommits,outsiderCommits)
  return(ownervsoutsider)
}
### Try typing tensorflow for user name and tensorflow for repository name as example
userName<-getUser()
repoName<-getRepo()
weekVector<-c()
ownervsoutsiderDF=repositoryParticipation(userName,repoName,weekVector)
ownerweekNum<-(ownervsoutsiderDF$weekVector)
outsiderweekNum<-(ownervsoutsiderDF$weekVector)
ownerCommitNum<-(ownervsoutsiderDF$ownerCommits)
outsiderCommitNum<-(ownervsoutsiderDF$outsiderCommits)
ownerDF<-data.frame(x=ownerweekNum,y=ownerCommitNum)
outsiderDF<-data.frame(x=outsiderweekNum,y=outsiderCommitNum)
ownervsoutsiderDF
ggplot(ownerDF,aes(x,y))+geom_point(aes(color="owners commits"))+
  geom_point(data=outsiderDF,aes(color="Non owner commits"))+
  labs(x="Week",y="Number of Commits",color="Legend",title="Commits made by Owner vs Contributer")

