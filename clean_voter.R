# clean up the voter responses to 27 positions
# remove duplicate responses for each voter id
# remove sequenctial identical responses
# remove responses which had only answered a few questions as these are probably just checking the site and giving random answers  

source('setup_data.R', echo = TRUE);
source('read_data.R', echo = TRUE);

# sum the question ids for responses for each voter_id
# by is a wrapper for tapply
sumcheck <- by(vpositions[,2], vpositions$voter_id, sum)

# sum should be <= sum(1:27) if one set of responses present for each voter
incorrectsum <- sumcheck[sumcheck > sum(1:27)]
correctsum <- sumcheck[sumcheck <= sum(1:27)]

str(correctsum)
str(incorrectsum)
str(sumcheck)

# each voter has only one set of responses as incorrectsum  is 0

# next check for scores less than 20 as these are likely to be people entering random responses 
# just to check out the site

scorecheck <- by(vpositions[,5], vpositions$voter_id, sum)

qplot(as.numeric(scorecheck), main="Histogram of voter total scores over 27 questions", xlab="score")

qplot(as.numeric(scorecheck[!(scorecheck %in% c(0:20, 81))]), binwidth = 81/30, main="Histogram of voter total scores over 27 questions - removed lower scores", xlab="score")

voter_ids_out_of_range <- as.numeric(names(scorecheck[(scorecheck %in% c(0:20, 81))]))

vpositions_clean1 <- vpositions[!(vpositions$voter_id %in%  voter_ids_out_of_range ),]

# check for adjacent responses with same score. Most of these will be repeat responses by the same voter.

myfunction_idx <- function(idx, x) {
  score <- x[[idx]]
  if(idx < length(x)) {
    next_score <- x[[idx + 1]]
  
    #message(sprintf("Adding values %s:", idx))
    if (score == next_score){
      sum(0)
    } else{
      sum(score)
    }
  }
  else{
    sum(score)
  }  
}

scores_without_ajacent_duplicates <- unlist(lapply(seq_along(scorecheck), myfunction_idx, x = scorecheck))

voter_id_vector <- as.numeric(names(scorecheck))

voter_id_df <- data.frame(voter_id = voter_id_vector, score = scores_without_ajacent_duplicates )

voter_id_df_clean <- voter_id_df[voter_id_df$score != 0,]

vpositions_clean2 <- vpositions_clean1[(vpositions_clean1$voter_id %in%  voter_id_df_clean$voter_id ),]

scorecheck2 <- by(vpositions_clean2[,5], vpositions_clean2$voter_id, sum)

qplot(as.numeric(scorecheck2), binwidth = 81/30)

vpositions_cast <- dcast(vpositions_clean2, voter_id ~ question_id, value.var = "voterposition_score")

#rename cols
vposition_names <- names(vpositions_cast)
vpositions_colnames <- unlist(lapply(vposition_names, function(x) paste ("vp", x, sep = "_")))

colnames(vpositions_cast) <- vpositions_colnames