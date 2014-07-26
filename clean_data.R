source('read_data.R', echo = TRUE);
library("ggplot2")

responses_voter_ids <- unique(responses$voter_id)
positions_voter_ids <- unique(positions$voter_id)

position_with_responses <- positions[positions$voter_id %in% responses_voter_ids, ]

position_with_responses_ids <- unique(position_with_responses$voter_id)

#remove invalid responses here

positions_q1 <- position_with_responses[position_with_responses$question_id == 1, ]

ggplot(positions_q1, aes(x = score)) + 
  geom_histogram() +
  ggtitle("Priority should be given to building more social housing in Limerick")

positions_q1_0 <- positions_q1[positions_q1$score == 0, ]
positions_q1_1 <- positions_q1[positions_q1$score == 1, ]
positions_q1_2 <- positions_q1[positions_q1$score == 2, ]
positions_q1_3 <- positions_q1[positions_q1$score == 3, ]

voter_is_q1_p0 <- unique(positions_q1_0$voter_id)
voter_is_q1_p1 <- unique(positions_q1_1$voter_id)
voter_is_q1_p2 <- unique(positions_q1_2$voter_id)
voter_is_q1_p3 <- unique(positions_q1_3$voter_id)