#source('read_data.R', echo = TRUE);
#source('clean_voter.R', echo = TRUE);
#source('check_duplicate_responses.R', echo = TRUE);
#source('merge_data.R', echo = TRUE);

# this option is required for this example. It is also in the demo. Using the likert function with the
# default for digits returns an error for this example.
options(digits=2)

require(likert)
require(reshape)
require(plyr)

vp_likert <- vpositions_cast

# remove voter_id col
#vp_likert <- vp_likert[,!(names(vp_likert) %in% "vp_voter_id")]

# convert to matrix (for speed) and replace 0 <- 2.
# This is to combine "no opinion" and "neither agree or disagree"
# Change back to dataframe
#df <- vp_likert
#m <- as.matrix(df)
#m[m==0] <- 2
#df <- as.data.frame(m)

#plot(likert(df))
#plot(likert(df), type="heat")

# merge in the voter constituency data
voters_1 <- voters[,names(voters) %in% c("voter_id", "constituency_id")]

merge_df_constit <- merge(vpositions_cast, voters_1, by.x = "vp_voter_id", by.y = "voter_id")
vp_likert <- merge_df_constit

# remove cols not representing response scores
likert.df <- merge_df_constit[,!(names(merge_df_constit) %in% c("vp_voter_id", "constituency_id"))]

# change no opinions to NA
df <- likert.df
m <- as.matrix(df)
m[m==0] <- NA
likert.df <- as.data.frame(m)

# give the colnames the question test
colnames(likert.df) <- issues$issue_question_text

# convert the data to fators

for (i in 1:27){
  #likert[,i] <- factor(likert[,i], labels=c("no opinion", "disagree", "neither agree or disagree", "agree"))
  likert.df[,i] <- factor(likert.df[,i], labels=c("disagree", "neither agree or disagree", "agree"))
}

# need for the grouping variable to be a factor
constit_factor <- factor(vp_likert$constituency_id, labels = c("All Local Electoral Areas","Adare-Rathkeale","Cappamore-Kilmallock","Newcastle West","Limerick City East","Limerick City North","Limerick City West"))

# a large number of questions and factor levels results in an unreadable plot
l<- likert(likert.df)
plot(l, wrap=40)

# split the dataset to get something more useful
l1<- likert(likert.df[,1:5], grouping = constit_factor)
plot(l1, wrap=40)
l2<- likert(likert.df[,6:10], grouping = constit_factor)
plot(l2, wrap=40)
l3<- likert(likert.df[,11:15], grouping = constit_factor)
plot(l3, wrap=40)
l4<- likert(likert.df[,16:20], grouping = constit_factor)
plot(l4, wrap=40)
l5<- likert(likert.df[,21:25], grouping = constit_factor)
plot(l5, wrap=40)
l6<- likert(likert.df[,26:27], grouping = constit_factor)
plot(l6, wrap=40)

# try other variable, such as city v country (2 levels) instead of constituencies (7 levels)


# merge in the response data

# merge in the survey response data
# careful when merging as you are potentially reducing the number of observations
# in this case 2020 voters paricipated and 1188 completed a survey.
# Two analysis done seperatly to avoid conflict. 

merge_pos_survey <- merge(responses_cast, vpositions_cast, by.x = "res_voter_id", by.y = "vp_voter_id")

## look at data split by gender

# merge_df_constit <- merge(merge_pos_survey, voters_1, by.x = "res_voter_id", by.y = "voter_id")


# need for the grouping variable to be a factor
# doesn't work guess is that grouping can't be NA
# probably want to remove rows with NA from merge_pos_survey before creating likert.df.resp

completeFun <- function(data, desiredCols) {
  completeVec <- complete.cases(data[, desiredCols])
  return(data[completeVec, ])
}

likert_plot_by_factor <- function(data, factor, factor_labels){
  data <- completeFun(data, factor)
  
  data_vector <- data[,factor]
  data_factor <- factor(data_vector, labels= factor_labels)
  
  # remove cols not representing response scores
  likert.df.resp <- data[,!(names(data) %in% c("res_voter_id","res_response_id","res_1","res_2","res_3","res_4","res_5","res_6","res_7","res_8","res_9", "constituency_id"))]
  
  # give the colnames the question test
  colnames(likert.df.resp) <- issues$issue_question_text
  
  # change no opinions to NA
  df <- likert.df.resp
  m <- as.matrix(df)
  m[m==0] <- NA
  likert.df.resp <- as.data.frame(m)
  
  # convert the data to fators
  
  for (i in 1:27){
    #likert[,i] <- factor(likert[,i], labels=c("no opinion", "disagree", "neither agree or disagree", "agree"))
    likert.df.resp[,i] <- factor(likert.df.resp[,i], labels=c("disagree", "neither agree or disagree", "agree"))
  }
  
  
  
  #gender_vector[is.na(gender_vector)] <- 3
  #gender_factor <- factor(gender_vector, labels=c("Female", "Male", "Not given"))
  
  l1<- likert(likert.df.resp[,1:5], grouping = data_factor)
  l2<- likert(likert.df.resp[,6:10], grouping = data_factor)
  #l1<- likert(likert.df[,1:5], grouping = data_factor)

  #l2<- likert(likert.df[,6:10], grouping = data_factor)

  #l3<- likert(likert.df[,11:15], grouping = data_factor)

  #l4<- likert(likert.df[,16:20], grouping = data_factor)

  #l5<- likert(likert.df[,21:25], grouping = data_factor)

  #l6<- likert(likert.df[,26:27], grouping = data_factor)
  lg <- list(l1, l2)
  
  return(lg)
}

responses_by_gender <- likert_plot_by_factor(merge_pos_survey,"res_1", c("Female", "Male"))
responses_by_age <- likert_plot_by_factor(merge_pos_survey,"res_2", c("Under 18", "18-25", "25-34", "35-44", "45-54", "55-64", "Over 65"))
responses_by_location <- likert_plot_by_factor(merge_pos_survey,"res_3", c("Limerick city", "Limerick county", "Other"))
responses_by_education <- likert_plot_by_factor(merge_pos_survey,"res_4", c("None", "Completed Primary", "Junior/Inter Cert. or equivalent", "Leaving Cert. or equivalent", "Diploma or Certificate", "University degree"))
responses_by_party_affinity <- likert_plot_by_factor(merge_pos_survey,"res_5", c("Fine Gael", "Labour Party", "Fianna Fáil", "Sinn Féin", "United Left Alliance", "People Before Profit", "Socialist Party", "Green Party", "Anti-Austerity Alliance", "Other", "None"))
responses_by_voting_intention <- likert_plot_by_factor(merge_pos_survey,"res_6", c("I do not intend to vote","Fine Gael","Labour Party","Fianna Fáil","Sinn Féin","Anti-Austerity Alliance","Independent","Undecided"))
responses_by_reason <- likert_plot_by_factor(merge_pos_survey,"res_7", c("I like the candidate(s)","The party is more competent","The ideas of the party are closest to my own","The party helps people like me","My friends and family support the party","I like the party leader","Other"))
responses_by_gen_elec_2011 <- likert_plot_by_factor(merge_pos_survey,"res_8", c("I did not vote","I was not eligible to vote","I do not remember","Fine Gael","Labour Party","Fianna Fáil","Sinn Féin","United Left Alliance","People Before Profit","Socialist Party","Green Party","Independent","Other"))
responses_by_left_right <- likert_plot_by_factor(merge_pos_survey,"res_9", c(c("Left 5","Left 4","Left 3","Left 2","Left 1","Neither left or right","Right 1","Right 2","Right 3","Right 4","Right 5")))


