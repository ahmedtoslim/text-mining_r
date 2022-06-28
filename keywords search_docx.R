library("pdftools")
library(stringr)
library(tm)
library(SnowballC)
library(writexl)
library(tmap)
library(RColorBrewer)
library(wordcloud)
library(officer)

# set working directory
setwd("C:/Users/")
# read the text files only from the folders
tex <- list.files(pattern = "docx$")
tex 

#extract the texts
docx <- lapply(tex, function(x) officer::docx_summary(officer::read_docx(x)) )
# length(docx)
# lapply(docx, length) 
# tdm <- TermDocumentMatrix(Corpus(VectorSource(docx)))

tcorp <- Corpus(VectorSource(docx))

tdm <- TermDocumentMatrix(tcorp, control = list(removePunctuation = FALSE, stopwords = TRUE, 
                                                stemming = FALSE, removeNumbers = TRUE,
                                                tolower = FALSE, bounds = list(global = c(1, Inf))))
inspect(tdm[1:100,])

t <- findFreqTerms(tdm, lowfreq =0, highfreq = Inf)
j <- as.matrix(tdm[t,])
dim(j)
head(j)
View(j)

#'"word1', 'word2"'

words <- c('word1')
words

k <- findFreqTerms(tdm[words,], lowfreq =0, highfreq = Inf)
kn <- t(as.matrix(tdm[k,]))
kn

write.table(tex, "tex.csv", sep = ",", row.names = TRUE)
write.table(kn, "kn.csv", sep = ",", row.names = TRUE)