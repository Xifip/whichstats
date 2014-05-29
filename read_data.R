vpositions <- read.csv("data/voter_positions.csv")
cpositions <- read.csv("data/candidate_positions.csv")
questions <- read.csv("data/questions.csv")
responses <- read.csv("data/surveyresponses.csv")

colnames(responses)[1] <- "response_id"
colnames(responses)[9] <- "response_score"
colnames(responses)[10] <- "response_comment"
colnames(responses)[11] <- "response_created"
colnames(responses)[12] <- "response_updated"

colnames(questions)[1] <- "question_id"
colnames(questions)[2] <- "question_text"
colnames(questions)[3] <- "question_created"
colnames(questions)[4] <- "question_updated"

colnames(vpositions)[1] <- "voterposition_id"
colnames(vpositions)[5] <- "voterposition_score"
colnames(vpositions)[6] <- "voterposition_created"
colnames(vpositions)[7] <- "voterposition_updated"

merge01 <- merge(responses, questions, by.x = "surveyquestion_id", by.y = "question_id")
merge02 <- merge(merge01, vpositions, by = "voter_id")