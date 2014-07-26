# Read in the data from csv files exported from the whichcandidate.ie application

# Description of the data frames

  # vpostisons: voter positions on 27 statements
  # cpositions: candidate positions on 27 statements
  # questions: 9 optional profile questions presented to the voters
  # responses: voter responses to the optional profile questions
  # voters: constituency for the voter
  # candidates: profile information for the candidates

source('setup_data.R', echo = TRUE);

vpositions <- read.csv("data/voter_positions.csv")
cpositions <- read.csv("data/candidate_positions.csv")
questions <- read.csv("data/questions.csv")
responses <- read.csv("data/surveyresponses.csv")
issues <- read.csv("data/issues.csv")
voters <- read.csv("data/voters.csv")
candidates <- read.csv("data/candidates.csv")

cpositions <- cpositions[cpositions$positionable_type == "Candidate",]

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

colnames(cpositions)[1] <- "candidateposition_id"
colnames(cpositions)[3] <- "candidate_id"
colnames(cpositions)[5] <- "candidateposition_score"
colnames(cpositions)[7] <- "candidateposition_created"
colnames(cpositions)[8] <- "candidateposition_updated"

colnames(candidates)[1] <- "candidate_id"
colnames(voters)[1] <- "voter_id"

colnames(issues)[1] <- "issue_id"
colnames(issues)[2] <- "issue_text"
colnames(issues)[3] <- "issue_question_text"

#merge01 <- merge(responses, questions, by.x = "surveyquestion_id", by.y = "question_id")
#merge02 <- merge(merge01, vpositions, by = "voter_id")