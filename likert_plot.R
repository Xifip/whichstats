#source('read_data.R', echo = TRUE);
#source('clean_voter.R', echo = TRUE);
#source('check_duplicate_responses.R', echo = TRUE);
#source('merge_data.R', echo = TRUE);

vp_likert <- vpositions_cast

# remove voter_id col
vp_likert <- vp_likert[,!(names(vp_likert) %in% "vp_voter_id")]

# convert to matrix (for speed) and replace 0 <- 2.
# This is to combine "no opinion" and "neither agree or disagree"
# Change back to dataframe
df <- vp_likert
m <- as.matrix(df)
m[m==0] <- 2
df <- as.data.frame(m)

# change colnames to question text 
colnames(df) <- issues$issue_question_text
plot(likert(df))
plot(likert(df), type="heat")
