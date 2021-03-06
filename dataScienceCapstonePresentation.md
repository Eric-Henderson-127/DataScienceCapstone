Data Science Capstone App Presentation
========================================================
author: Eric Henderson
date: August 31st, 2017
autosize: true
transition: rotate
css: dataScienceCapstonePresentation.css
type: title

Project Summary
========================================================
transition: rotate
type: content

The goal of this project was to suggest the next word for a user supplied phrase.

A prediction model was created from a large body of text, sourced from blogs, news, and twitter.

The prediction model was then integrated into a Shiny app and deployed to the web.

Prediction Model - Construction
========================================================
transition: rotate
type: content

N-grams are word sequences of set length that appear in a body of text, along with the frequency of each sequence occuring.

N-grams of various lengths were created from samples of the source text.

The longer the n-gram the larger the sample from the source, as unique phrases occur less frequently with increases in length.

Prediction tables were made using those n-grams, which contain the phrase, frequency, next word, and phrase length.

Prediction Model - Making suggestions
========================================================
transition: rotate
type: content

A response table is made by matching user phrases against the stored phrases in the prediction tables.

The response table is then ordered first by phrase length, then by frequency, and then suggestions are made from the "end word" in the top rows of the response table.


```
[1] "An example for this is a"
```

```
[1] "great" "good"  "big"   "very"  "new"  
```

```
    Phrase Frequency  ends length
 this is a       155 great      3
 this is a       130  good      3
 this is a        58   big      3
 this is a        52  very      3
 this is a        33   new      3
```

Application Use
========================================================
transition: rotate
type: content

The app can be accessed at: https://eric-henderson-127.shinyapps.io/CapstoneWordPredict/

To intereact with the app, type a phrase into the text field below "Input Sentence".

You can increase the amount of elements in the Detail View by marking the "increase detail view" check box.
***
![App Image](appImage.png)
