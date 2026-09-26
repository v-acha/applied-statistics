# 2016 House Campaign Spending and Vote Analysis
# Estimate the association between campaign disbursements, party, and votes.

# 1. Load packages and source data --------------------------------------------
library(fec16)
library(ggplot2)
library(dplyr)
library(lmtest)
library(stargazer)

#The fec16 package supplies candidate, campaign-finance, and House-results data.
data("candidates")
data("results_house")
data("campaigns")

# Inspect the source tables before joining them.
head(candidates)
head(results_house)
head(campaigns)

# 2. Join results to campaign spending ----------------------------------------
house_analysis <- inner_join(results_house, campaigns, by = "cand_id") %>%
  mutate(candidate_party = case_when(
    party == "DEM" ~ "Democrat",
    party == "REP" ~ "Republican",
    TRUE ~ "Other Party"
  )) %>%
  mutate(candidate_party = factor(
    candidate_party,
    levels = c("Democrat", "Other Party", "Republican")
  ))

# Confirm the join size and available fields.
dim(house_analysis)
names(house_analysis)

# 3. Explore vote and spending distributions ----------------------------------
ggplot(results_house, aes(x = general_percent)) +
  geom_histogram(binwidth = 1, fill = "blue", color = "black") +
  labs(
    title = "Distribution of General-Election Vote Share",
    x = "General-election vote share (%)",
    y = "Candidate count"
  )

ggplot(campaigns, aes(x = ttl_disb)) +
  geom_histogram(binwidth = 1000, fill = "green", color = "black") +
  labs(
    title = "Distribution of Campaign Disbursements",
    x = "Total disbursements ($)",
    y = "Campaign count"
  )

# Compare spending and votes across party groups. These are descriptive views.
ggplot(house_analysis, aes(x = ttl_disb, y = general_votes, color = candidate_party)) +
  geom_point(alpha = 0.6) +
  scale_x_continuous(labels = scales::dollar) +
  scale_y_continuous(labels = scales::comma) +
  labs(
    title = "Campaign Disbursements and General-Election Votes",
    x = "Total disbursements ($)",
    y = "General-election votes",
    color = "Party"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))

# Compare the distribution of campaign spending by party.
ggplot(house_analysis, aes(x = candidate_party, y = ttl_disb, fill = candidate_party)) +
  geom_boxplot() +
  scale_y_continuous(labels = scales::dollar) +
  labs(
    title = "Campaign Disbursements by Party",
    x = "Party",
    y = "Total disbursements ($)",
    fill = "Party"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))

# Compare mean vote totals; group means do not adjust for other variables.
average_votes <- house_analysis %>%
  group_by(candidate_party) %>%
  summarise(avg_votes = mean(general_votes, na.rm = TRUE))

ggplot(average_votes, aes(x = candidate_party, y = avg_votes, fill = candidate_party)) +
  geom_col() +
  labs(
    title = "Average General-Election Votes by Party",
    x = "Party",
    y = "Average votes",
    fill = "Party"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))

# 4. Estimate the spending and party association -------------------------------
# Democrat is the reference group for the party coefficients.
spending_party_model <- lm(
  general_votes ~ ttl_disb + candidate_party,
  data = house_analysis
)

# Review model estimates and coefficient-level tests.
summary(spending_party_model)
coeftest(spending_party_model)

# Test whether party improves fit beyond a spending-only model.
spending_only_model <- lm(general_votes ~ ttl_disb, data = house_analysis)
anova(spending_only_model, spending_party_model)

# 5. Export the model table -----------------------------------------------------
stargazer(
  spending_party_model,
  type = "latex",
  title = "General-Election Votes, Campaign Spending, and Party",
  covariate.labels = c("Total Disbursements", "Other Party", "Republican"),
  dep.var.labels = "General-Election Votes",
  no.space = TRUE,
  style = "default",
  notes = "Standard errors are in parentheses.",
  single.row = TRUE,
  out = "regression_results.tex"
)

