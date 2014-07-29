source('setup_data.R', echo = TRUE);
source('read_data.R', echo = TRUE);
source('clean_voter.R', echo = TRUE);
source('check_duplicate_responses.R', echo = TRUE);
source('likert_plot.R', echo = TRUE);


# split data into test, training and validation sets

## to do, this is a rough cut to get SOM working..

# scale data

train_train_ds <- scale(merge_pos_survey)
train_train_dfs <- data.frame(train_train_ds)

# Colour palette definition
pretty_palette <- c("#1f77b4", '#ff7f0e', '#2ca02c', '#d62728', '#9467bd', '#8c564b', '#e377c2')

## custom palette 
source('coolBlueHotRed.R')

# rename the columns

survey_short_questions <- c("Gender", "Age", "Education", "Party affinity", "Party voting intention", "Voting reason", "Left-right")
issuesQuestions <- issues$issue_question_text
issuesQuestions <- c("Prioritise building of social housing in Limerick",
                      "Favor rent suppliment over social housing",
                      "One-off rural housing is damaging to the countryside",
                      "Ghost estates should be demolished",
                      "Water rates should not be introduced",
                      "Reduce Property Tax, even if it means cutting services",
                      "Ring-fenced property tax for local spending",
                      "Increase business ratese in line with other cities",
                      "Allocate more money for Traveller accommodation",
                      "More schools should be removed from Church patronage",
                      "Council should impound unlicenced horses",
                      "Council should continue support for Gay Pride",
                      "work for unemployment benefits",
                      "Asylum seekers should be allowed to work",
                      "evict anti-social local authority tenants",
                      "prioritise bypasses for congested towns",
                      "The Council should oppose wind farms",
                      "welcome water metering for water conservation",
                      "prioritise bus and cycle lanes",
                      "prioritise revitalising Limerick city centre",
                      "rename Shannon Bridge",
                      "more free car parking in the city",
                      "more pedestrianisation",
                      "directly elected Mayor for Limerick",
                      "local referendums", 
                      "Community groups role in Council decision-making", 
                      "balance of male and female candidates")
descriptive_colnames <- c("res_voter_id", "res_response_id", survey_short_questions, issuesQuestions)

colnames(train_train_dfs) <- descriptive_colnames

## select factors
#sp_4 <- sp_3#[,!(names(sp_3) %in% c("Total.Z", "Time.in.REM", "Time.in.Wake", "Time.in.Light", "Time.in.Deep", "Times.Woken"))]

# remove NA's and select factors
selectedFactors <- c(3:5, 9:16)
d <- train_train_dfs[selectedFactors]
dm.sc <- as.matrix(d)
dm.nona <- na.omit(dm.sc)


# call som function
set.seed(50000)
dm.som <- som(data = dm.nona,
              keep.data = TRUE,
              n.hood = "circular",
              alpha=c(0.05,0.01),
              rlen=100,
              grid = somgrid(12, 12, "hexagonal"))

# plot the process plots

png('plots/som/process/changes.png')
plot(dm.som, type="changes")
dev.off()

png('plots/som/process/count.png')
plot(dm.som, type="count")
dev.off()

png('plots/som/process/dist_neighbours.png')
plot(dm.som, type="dist.neighbours")
dev.off()

png('plots/som/process/codes.png')
plot(dm.som, type="codes")
dev.off()

# plot the results
n <- dim(d)[2]
#print(n)

for(i in 1:n){
  sel <- i
  png(paste('plots/som/results/', tolower(gsub("\\.", "",colnames(dm.som$data)[sel])),'.png', sep = ''))
  plot(dm.som, type = "property", property = dm.som$codes[,sel], main=colnames(dm.som$data)[sel], palette.name=coolBlueHotRed)
  dev.off()
}

mydata <- dm.som$codes 
wss <- (nrow(mydata)-1)*sum(apply(mydata,2,var)) 
for (i in 2:15) {
  wss[i] <- sum(kmeans(mydata, centers=i)$withinss)
}
png('plots/som/process/wss.png')
plot(wss)
dev.off()

## use hierarchical clustering
som_cluster <- cutree(hclust(dist(dm.som$codes)),6)
png('plots/som/results/clusters.png')
plot(dm.som, type="mapping",  bgcol = pretty_palette[som_cluster], main = "Clusters") 
add.cluster.boundaries(dm.som, som_cluster)
dev.off()














