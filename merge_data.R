#source('read_data.R', echo = TRUE);
#source('clean_voter.R', echo = TRUE);
#source('check_duplicate_responses.R', echo = TRUE);

merge_pos_survey <- merge(responses_cast, vpositions_cast, by.x = "res_voter_id", by.y = "vp_voter_id")