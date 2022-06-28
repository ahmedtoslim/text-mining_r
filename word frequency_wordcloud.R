
#load packages
library("pdftools")
library(stringr)
library(tm)
library(SnowballC)
library(writexl)
library(tmap)
library(RColorBrewer)
library(wordcloud)
library(officer)


#set working directory
setwd("C:/Users/")

# read the pdf files only from the folders
pdffiles <- list.files(pattern = "pdf$")
pdffiles

#extract the texts
textcontent <- lapply(pdffiles, pdf_text)
length(textcontent)
lapply(textcontent, length)

# define stopwords, create Term-Doc Matrix
mystop_a<- stopwords("en")
mystop <- c(stopwords("en"), "will")

tcorp <- Corpus(URISource(pdffiles), readerControl = list(reader = readPDF))

#Term-Doc 

tdm <- TermDocumentMatrix(tcorp, control = list(removePunctuation = TRUE, stemming = FALSE,
                                                removeNumbers = TRUE, removeWords = mystop,
                                                stopwords = TRUE, tolower = TRUE,
                                                bounds = list(global = c(1, Inf)))) 
inspect(tdm[1:100,])                                                         


#get term freq

ft <- findFreqTerms(tdm, lowfreq = 5, highfreq = Inf)
as.matrix(tdm[ft,]) 

# sort freq terms; optional
tfreq <- sort(rowSums(as.matrix(tdm)), decreasing=TRUE)   
head(tfreq, 15)  


#doc-term

dtm <- DocumentTermMatrix(tcorp, control = list(removePunctuation = TRUE, stemming = FALSE,
                                                removeNumbers = TRUE, removeWords = mystop,
                                                stopwords = TRUE, tolower = TRUE, 
                                                bounds = list(global = c(1, Inf)))) 
dtm                                          
                                          
## further clean up and inspect##
freq <- colSums(as.matrix(dtm))   
length(freq) 
ord <- order(freq) 

m <- as.matrix(dtm)   
dim(m)  
freq <- colSums(as.matrix(dtm))

#matrix that is maximum 20% empty space. 
dtms <- removeSparseTerms(dtm, 0.2)
dtms

freq <- colSums(as.matrix(dtms))   
freq   

# get word frequency in descending order. 
freq <- sort(colSums(as.matrix(dtm)), decreasing=TRUE)   
head(freq, 15)  

wf <- data.frame(word=names(freq), freq=freq)   
wf
qq <- as.matrix(wf)

#save as csv file
#write.csv(qq, file="File Name.csv")

#generate wordcloud 

#set seed 
set.seed(10)   
wordcloud(names(freq), freq, max.words=100)    








