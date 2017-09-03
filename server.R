library(shiny)
library(ggplot2)

sortedSixgram <- NA
sortedPentagram <- NA
sortedQuadgram <- NA
sortedTrigram <- NA
sortedBigram <- NA
results <- NA
suggested <- NA
defaultSuggests <- c("is", "a", "to", "the", "and", "for", "with", "from", "by", "or")
grams <- c("6-gram", "5-gram", "4-gram", "3-gram", "2-gram")
occurs <- c(0, 0, 0, 0, 0)
occurances <- data.frame(grams, occurs)
p <- ggplot()
cutoff <- 10
tablemax <- 5
rm(grams)
rm(occurs)
data_loaded <- FALSE

load_data <- function() {
progress <- shiny::Progress$new()
progress$set(message = "Loading Data", value = 0)
progress$inc(0.0, detail = "Loading 6-gram data")
sortedSixgram <<- read.csv(file = "data/prediction_table_sixgram.csv")
progress$inc(0.2, detail = "Loading 5-gram data")
sortedPentagram <<- read.csv(file = "data/prediction_table_pentagram.csv")
progress$inc(0.4, detail = "Loading 4-gram data")
sortedQuadgram <<- read.csv(file = "data/prediction_table_quadgram.csv")
progress$inc(0.6, detail = "Loading 3-gram data")
sortedTrigram <<- read.csv(file = "data/prediction_table_trigram.csv")
progress$inc(0.9, detail = "Loading 2-gram data")
sortedBigram <<- read.csv(file = "data/prediction_table_bigram.csv")
progress$inc(0.98, detail = "Initializing data")
progress$close()
}

shinyServer(function(input, output) {
  if(data_loaded == FALSE)
  {
    load_data()
  }
  
  output$suggested <- renderText({
    sentence <- input$sentence
    
    withProgress(message = "Calculating suggestion", value = 0, {
      incProgress(0.1, detail = "Filtering phrase")
      sentence <- unlist(strsplit(sentence, split=" "))
      sentence <- sapply(sentence, tolower)
      sentence <- gsub("[^'[:lower:]]", "", sentence)
      sentence <- gsub("^'*$", "", sentence)
      sentence <- gsub("^'s$", "", sentence)
      numsAndEmpty <- grep("^[[:digit:]]*$", sentence)
      cutoff <<- 10
      if(input$details == TRUE)
      {
        cutoff <<- 100
      }
      if(length(numsAndEmpty) > 0)
      {
        sentence <- sentence[-numsAndEmpty]
      }
      incProgress(0.15, detail = "Checking 6-grams")
      if(length(sentence) > 5)
      {
        trim <- (length(sentence) - 5) + 1
        sentence <- sentence[trim:length(sentence)]
      }
      result <- data.frame(Phrase=character(),
                            Frequency=integer(),
                            ends=character(),
                            length=integer())
      results <<- result
      if(length(sentence) == 5 && NROW(results) < cutoff)
      {
        tempSentence <- paste(sentence, collapse = " ")
        tempSentence <- paste("^", tempSentence, "$")
        tempSentence <- sub("\\^ ", "^", tempSentence)
        tempSentence <- sub(" \\$", "$", tempSentence)
        temp <- grep(tempSentence, sortedSixgram$Phrase)
        occurances$occurs[1] <- length(temp)
        results <<- rbind(results, sortedSixgram[temp,])
        sentence <- sentence[2:length(sentence)]
      }
      incProgress(0.3, detail = "Checking 5-grams")
      if(length(sentence) == 4 && NROW(results) < cutoff)
      {
        tempSentence <- paste(sentence, collapse = " ")
        tempSentence <- paste("^", tempSentence, "$")
        tempSentence <- sub("\\^ ", "^", tempSentence)
        tempSentence <- sub(" \\$", "$", tempSentence)
        temp <- grep(paste(tempSentence, collapse = " "), sortedPentagram$Phrase)
        occurances$occurs[2] <- length(temp)
        results <<- rbind(results, sortedPentagram[temp,])
        sentence <- sentence[2:length(sentence)]
      }
      incProgress(0.5, detail = "Checking 4-grams")
      if(length(sentence) == 3 && NROW(results) < cutoff)
      {
        tempSentence <- paste(sentence, collapse = " ")
        tempSentence <- paste("^", tempSentence, "$")
        tempSentence <- sub("\\^ ", "^", tempSentence)
        tempSentence <- sub(" \\$", "$", tempSentence)
        temp <- grep(paste(tempSentence, collapse = " "), sortedQuadgram$Phrase)
        occurances$occurs[3] <- length(temp)
        results <<- rbind(results, sortedQuadgram[temp,])
        sentence <- sentence[2:length(sentence)]
      }
      incProgress(0.7, detail = "Checking 3-grams")
      if(length(sentence) == 2 && NROW(results) < cutoff)
      {
        tempSentence <- paste(sentence, collapse = " ")
        tempSentence <- paste("^", tempSentence, "$")
        tempSentence <- sub("\\^ ", "^", tempSentence)
        tempSentence <- sub(" \\$", "$", tempSentence)
        temp <- grep(paste(tempSentence, collapse = " "), sortedTrigram$Phrase)
        occurances$occurs[4] <- length(temp)
        results <<- rbind(results, sortedTrigram[temp,])
        sentence <- sentence[2:length(sentence)]
      }
      incProgress(0.9, detail = "Checking 2-grams")
      if(length(sentence) == 1 && NROW(results) < cutoff)
      {
        tempSentence <- paste(sentence, collapse = " ")
        tempSentence <- paste("^", tempSentence, "$")
        tempSentence <- sub("\\^ ", "^", tempSentence)
        tempSentence <- sub(" \\$", "$", tempSentence)
        temp <- grep(paste(tempSentence, collapse = " "), sortedBigram$Phrase)
        occurances$occurs[5] <- length(temp)
        results <<- rbind(results, sortedBigram[temp,])
      }
      incProgress(0.95, detail = "Building output")
      if(NROW(results) >= 10)
      {
        theSubset <- results[1:10,]
      }
      if(NROW(results) < 10)
      {
        theSubset <- results[1:NROW(results),]
      }
      if(is.na(theSubset$ends[1]))
      {
        theSubset <- theSubset[-1,]
      }
      suggested <- as.character(theSubset$ends)
      suggested <- c(suggested, defaultSuggests)
      suggested <- unique(suggested)
      if(length(suggested) >= 5)
      {
        suggested <<- suggested[1:5]
      }
      if(length(suggested) < 5)
      {
        suggested <<- suggested[1:length(suggested)]
      }
    })
    p <<- ggplot(occurances, aes(x=grams, y=occurs)) + geom_bar(stat = "identity", fill="steelblue")
    suggested[1]
  })
  
  output$suggested2 <- renderText({
    sentence <- input$sentence
    paste(suggested, collapse = ", ")
  })

  
  output$plot <- renderPlot({
    sentence <- input$sentence
    input$details
    p <- p + ggtitle(paste("Number of Matching N-grams ( up to",cutoff,") for Phrase:\n",sentence))
    p
  })
  
  output$table <- renderTable({
    input$sentence
    if(input$details == TRUE)
    {
      tablemax <- 10
    }
    results[1:tablemax,]
  })
})
