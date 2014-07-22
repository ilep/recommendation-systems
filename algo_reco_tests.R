# Load required library
library(recommenderlab) # package being evaluated
library(ggplot2) # For plots

# Load the data we are going to work with
data(MovieLense)
MovieLense
# 943 x 1664 rating matrix of class ‘realRatingMatrix’ with 99392 ratings.

# Visualizing a sample of this
image(sample(MovieLense, 940), main = "Raw ratings")


image(table_Rating, main = "Raw ratings")


## create a 0-1 matrix
m <- matrix(sample(c(0,1), 50, replace=TRUE), nrow=5, ncol=10,
            dimnames=list(users=paste("u", 1:5, sep=''), 
                          items=paste("i", 1:10, sep='')))
m

## coerce it into a binaryRatingMatrix
b <- as(m, "binaryRatingMatrix")
b
dim(b)
dimnames(b)

image(table_Rating2[1:1000,])
image(b)
## counts
rowCounts(b)
colCounts(b)


hist(rowCounts(b))

hist(colCounts(b))
## plot
image(b)

############### Reco : differents model

recommenderRegistry$get_entries(dataType = "binaryRatingMatrix")
# We have a few options

rowCounts(table_Rating)
colCounts(table_Rating)
hist(rowCounts(table_Rating))
summary(rowCounts(table_Rating))

hist(colCounts(table_Rating))


#### Table_ratings2 : table ratings sans les doublons
table_Rating2
rowCounts(table_Rating2)
colCounts(table_Rating2)
hist(rowCounts(table_Rating2))
summary(rowCounts(table_Rating2))

hist(colCounts(table_Rating2))
## plot
image(table_Rating2)

# Let's check some algorithms against each other
scheme <- evaluationScheme(table_Rating, method = "cross",
                           k = 5,given=1)

# Let's check some algorithms against each other
scheme2 <- evaluationScheme(table_Rating2, method = "cross",
                           k = 5 ,given=1)
scheme
nn<-11
k<-seq(1,100,2)


data<-matrix(NA,length(k)+1,5)
i<-0
for(valeur in k)
{
  i<-i+1
algorithms <- list(
 # "Association Rules" = list(name="AR"),
  #"Random" = list(name="RANDOM", param=NULL),
 # "Popular" = list(name="POPULAR", param=NULL),
 # "user-based CF jaccard" = list(name="UBCF", param=list(method="jaccard", nn=nn) ),
  "item-based CF jaccard" = list(name="IBCF", param=list(method="jaccard",k=valeur))
 #"user-based CF cosine " = list(name="UBCF", param=list(method="cosine",nn=nn)),
  #"item-based CF cosine " = list(name="IBCF", param=list(method="cosine",k=k)),

#  "user-based CF dice " = list(name="UBCF", param=list(method="dice",
#                                                 nn=nn)),
#  "item-based CF dice" = list(name="IBCF", param=list(method="dice",
#                                                 k=k)),
#  "user-based CF matching" = list(name="UBCF", param=list(method="matching",
#                                                 nn=nn)),
#  "item-based CF matching" = list(name="IBCF", param=list(method="matching",
#                                                 k=k))
)

# run algorithms, predict next n movies
results <- evaluate(scheme, algorithms, n=c(10))
results2 <- evaluate(scheme2, algorithms, n=c(10))

############

res2<-avg(results2)[[1]][8:9]
res2

res1<-avg(results)[[1]][8:9]
res1

data[i,]<-cbind(valeur,res1[1],res1[2],res2[1],res2[2])
}

colnames(data)<-c("k","FPR","TPR","FPR_D","TPR_D")
head(data)  

plot(data[20:49,"FPR"],data[20:49,"TPR"],col='blue')
text(data[20:49,"FPR"],data[20:49,"TPR"], data[20:49,'k'],adj=0)

plot(data[1:50,"FPR_D"],data[1:50,"TPR_D"],col='blue')
text(data[20:50,"FPR_D"],data[20:50,"TPR_D"], data[20:50,'k'],adj=0)
  
# Draw ROC curve
plot(results, annotate = 1:4, legend="topleft")
plot(results2, annotate = 1:4, legend="topleft")
# See precision / recall
plot(results2, "prec/rec", annotate=1:4)


###################


data("MSWeb")

MSWeb10 <- sample(MSWeb[rowCounts(MSWeb) <5,], 50)
MSWeb10 
image(MSWeb10)

esSplit <- evaluationScheme(MSWeb10, method="split",
                            train = 0.9, k=1, given=1)
esSplit

esCross <- evaluationScheme(MSWeb10, method="cross-validation",
                            k=4, given=3)
esCross




######### creations da matrice R : user*item de l'article lié au package recommenderlab

d<-c(0,1,0,0,1,0,1,0,0,0,1,1,1,0,0,0,0,0,1,0,1,1,0,0,1,1,0,1,0,1,0,1,1,1,0,1,0,0,0,0,0,0,0,0,1,1,1,1)
m<-matrix(d,6,8)
row.names(m)<-c("u1","u2","u3","u4","u5","u6")
colnames(m)<-c("i1","i2","i3","i4","i5","i6","i7","i8")
m

m4<-as(m2,"binaryRatingMatrix")
r<-Recommender(m4[1:6], method="IBCF", parameter = list(method="jaccard",k=1))

r@model$sim
recom <- predict(r,m4[7], n = 5)
recom@items
recom@itemLabels
+str(recom)
bestN(recom,n=3)




####################
m2<-rbind(m,c(0,0,1,1,0,1,0,1))

m2<-as(m,"binaryRatingMatrix")
m2
row.names(m2)<-c("u1","u2","u3","u4","u5","u6","ua")

m3<-m/rowSums(m)
colSums(m)



mat2<-matrix(c(0,1,1,0,1,1,1,1,1,0,1,0),4,3)
row.names(mat2)<-c("u1","u2","u3","u4")
colnames(mat2)<-c("i1","i2","i3")
mat22<-as(mat2,"binaryRatingMatrix")
mat22


sim_krypasis<-function(x,alpha=1)
  {
 
  mat<-matrix(0,ncol(x),ncol(x))
  y<-x/rowSums(x)
  for(j in 1:ncol(y)){
   for(i in 1:ncol(y)){
     z<-0
     for(k in 1:nrow(y)){
       
    if(y[k,i]>0){
      z<-z+y[k,j]
    }
     }
      
    mat[i,j]<-z/(sum(x[,i])*(sum(x[,j])^alpha))
    }
  }
  return(mat)
}

test<-sim(mat2)
test

rowCounts(m2)
colCounts(m2)
hist(rowCounts(m2))
summary(rowCounts(m2))

hist(colCounts(m2))
## plot
image(m2)

1-dissimilarity(m2, method='jaccard')


