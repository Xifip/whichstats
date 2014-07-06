#source('read_data.R', echo = TRUE);
#source('clean_voter.R', echo = TRUE);

# sum the question ids for responses for each voter_id
# by is a wrapper for tapply
sumcheck <- by(responses[,6], responses$voter_id, sum)

# sum should be <= 45 if one set of responses present for each voter
incorrectsum <- sumcheck[sumcheck > 45]
correctsum <- sumcheck[sumcheck <= 45]

str(correctsum)
str(incorrectsum)
str(sumcheck)

# get voter_ids for voters with multiple responses
vid_dup_reponses <- as.numeric(names(incorrectsum))

discard_ids <- vector()
  
remove_duplicate_responses <- function(id, reponses){
  # get the rows with multiple responses 
  multi_responses <- responses[responses$voter_id == id,]
  
  # and the number of the response_id we want to keep
  keep_response <- max(multi_responses$response_id)
  
  # all response_ids 
  response_ids <- as.numeric(levels(as.factor(multi_responses$response_id)))
  # and response_ids we want to discard
  discard_response_ids <- response_ids[response_ids != keep_response]
  
  discard_ids <- c(discard_ids, discard_response_ids)

  #str(clean_res)
  
  return(discard_ids)
}

#discard_ids <- remove_duplicate_responses(793, responses)
discard_response_ids <- unlist(lapply(vid_dup_reponses, function(x) remove_duplicate_responses(x, responses)))

# remove unwanted responses
clean_responses <- responses[!(responses$response_id %in% discard_response_ids), ]

sumcheck_after <- by(clean_responses[,6], clean_responses$voter_id, sum)

# sum should be <= 45 if one set of responses present for each voter
incorrectsum_after <- sumcheck_after[sumcheck_after > 45]
correctsum_after <- sumcheck_after[sumcheck_after <= 45]

str(correctsum_after)
str(incorrectsum_after)
str(sumcheck_after)

# remove responses without a matching voter_id in the cleaned voter_positions dataframe

responses_clean <- clean_responses[(clean_responses$voter_id %in%  vpositions_clean2$voter_id ),]

# number of responses to the survey (1188)

length(levels(as.factor(responses_clean$response_id)))

responses_cast <- dcast(responses_clean, response_id + voter_id ~ surveyquestion_id, value.var = "response_score")

#rename cols
responses_names <- names(responses_cast)
responses_colnames <- unlist(lapply(responses_names, function(x) paste ("res", x, sep = "_")))

colnames(responses_cast) <- responses_colnames