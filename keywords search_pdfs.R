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

# set working directory
setwd("C:/Users/")
# read the pdf files only from the folders
pdffiles <- list.files(pattern = "pdf$")
pdffiles

#extract the texts
textcontent <- lapply(pdffiles, pdf_text)
length(textcontent)
lapply(textcontent, length)

tcorp <- Corpus(URISource(pdffiles), readerControl = list(reader = readPDF))
tcorp2 <- tm_map(tcorp, removePunctuation, ucp = TRUE)
tdm <- TermDocumentMatrix(tcorp2, control = list(stopwords = TRUE, tolower = TRUE, removeNumbers = TRUE,
                                               stemming = FALSE, bounds = list(global = c(1, Inf))))

inspect(tdm[1:10,])

#searck keywords

my.filter.words <- c('word1')
search<- inspect(tdm[my.filter.words,])
View(search)

ftk <- findFreqTerms(tdm[my.filter.words,], lowfreq =0, highfreq = Inf)
hk <- t(as.matrix(tdm[ftk,]))

write_xlsx(ev17, "2017.xlsx")
write.table(hk, "test.csv", sep = ",", row.names = TRUE)