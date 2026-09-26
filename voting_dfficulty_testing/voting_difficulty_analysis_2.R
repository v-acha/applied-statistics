# ============================================================
# Voting Difficulty Across Party Groups
# ANES 2022 Pilot Study
# ============================================================

library(readr)
library(effsize)


# ------------------------------------------------------------
# 1. LOAD DATA
# ------------------------------------------------------------

data <- read_csv("DS_203/Lab1/anes_pilot_2022_csv_20221214.csv")

# Inspect variables and data types
str(data)


# ------------------------------------------------------------
# 2. DEFINE PARTY AFFILIATION
# ------------------------------------------------------------

# Create an empty party affiliation variable.
#
# Respondents are classified sequentially using:
#   1. Initial party identification
#   2. Party leaning
#   3. 2020 presidential vote
#   4. 2022 governor vote
#   5. 2022 House vote
#   6. 2022 Senate vote
#
# Each later variable is used ONLY when party affiliation has
# not already been assigned.

data$party_affiliation <- NA_character_


# Initial party identification
data$party_affiliation[
  data$pid1r == 1 & is.na(data$party_affiliation)
] <- "Democrat"

data$party_affiliation[
  data$pid1r == 2 & is.na(data$party_affiliation)
] <- "Republican"


# Party leaning
data$party_affiliation[
  data$pidlean == 2 & is.na(data$party_affiliation)
] <- "Democrat"

data$party_affiliation[
  data$pidlean == 1 & is.na(data$party_affiliation)
] <- "Republican"


# 2020 presidential vote
data$party_affiliation[
  data$vote20 == 1 & is.na(data$party_affiliation)
] <- "Democrat"

data$party_affiliation[
  data$vote20 == 2 & is.na(data$party_affiliation)
] <- "Republican"


# 2022 governor vote
data$party_affiliation[
  data$gov22p == 1 & is.na(data$party_affiliation)
] <- "Democrat"

data$party_affiliation[
  data$gov22p == 2 & is.na(data$party_affiliation)
] <- "Republican"


# 2022 House vote
# Important: is.na() prevents this variable from overwriting
# classifications made using earlier variables.
data$party_affiliation[
  data$house22p == 1 & is.na(data$party_affiliation)
] <- "Democrat"

data$party_affiliation[
  data$house22p == 2 & is.na(data$party_affiliation)
] <- "Republican"


# 2022 Senate vote
data$party_affiliation[
  data$senate22p == 1 & is.na(data$party_affiliation)
] <- "Democrat"

data$party_affiliation[
  data$senate22p == 2 & is.na(data$party_affiliation)
] <- "Republican"


# Convert to factor so group ordering is explicit
data$party_affiliation <- factor(
  data$party_affiliation,
  levels = c("Democrat", "Republican")
)

# Check resulting distribution
table(data$party_affiliation, useNA = "ifany")


# ------------------------------------------------------------
# 3. ORIGINAL VOTING DIFFICULTY ANALYSIS
# ------------------------------------------------------------

# Compare the original votehard measure between party groups.
#
# Remove observations missing either votehard or party affiliation.

votehard_data <- data[
  !is.na(data$votehard) &
  !is.na(data$party_affiliation),
]


# Group summaries
aggregate(
  votehard ~ party_affiliation,
  data = votehard_data,
  FUN = mean
)


# Wilcoxon rank-sum test
wilcox_result <- wilcox.test(
  votehard ~ party_affiliation,
  data = votehard_data,
  exact = FALSE
)

wilcox_result


# ------------------------------------------------------------
# 4. CONSTRUCT COMPOSITE VOTING DIFFICULTY SCORE
# ------------------------------------------------------------

# The following variables are combined to create a broader
# measure of voting difficulty.
#
# NOTE:
# These are COMPONENT weights used to construct the score.
# They are NOT ANES survey/sample weights.


# Original / transformed measures
data$regdiff_norm  <- data$regdiff
data$votehard_norm <- data$votehard

data$waittime_norm <- data$waittime
data$triptime_norm <- data$triptime


# Specific voting difficulties
specific_difficulties <- c(
  "vharder_0",
  "vharder_1",
  "vharder_2",
  "vharder_3",
  "vharder_4",
  "vharder_5",
  "vharder_6",
  "vharder_7",
  "vharder_8",
  "vharder_9",
  "vharder_10",
  "vharder_11"
)


# Sum reported specific difficulties
data$specific_difficulties_sum <- rowSums(
  data[specific_difficulties],
  na.rm = TRUE
)


# Turnout-related measures
data$turnout22_norm <- ifelse(
  data$turnout22 == 1, 1,
  ifelse(
    data$turnout22 == 2, 2,
    ifelse(
      data$turnout22 == 3, 3,
      ifelse(
        data$turnout22 == 4, 4, 5
      )
    )
  )
)

data$turnout22w_norm <- data$turnout22w


# ------------------------------------------------------------
# 5. UNWEIGHTED COMPOSITE SCORE
# ------------------------------------------------------------

composite_variables <- c(
  "regdiff_norm",
  "votehard_norm",
  "waittime_norm",
  "triptime_norm",
  "specific_difficulties_sum",
  "turnout22_norm",
  "turnout22w_norm"
)


data$difficulty_score <- rowSums(
  data[composite_variables],
  na.rm = TRUE
)


# ------------------------------------------------------------
# 6. COMPONENT-WEIGHTED COMPOSITE SCORE
# ------------------------------------------------------------

# These values control how strongly each component contributes
# to the constructed difficulty score.

weight_regdiff <- 1
weight_votehard <- 1
weight_waittime <- 0.5
weight_triptime <- 0.5
weight_specific_difficulties <- 1
weight_turnout22 <- 1
weight_turnout22w <- 0.5


data$difficulty_score_weighted <-
  (data$regdiff_norm *
   weight_regdiff) +
  (data$votehard_norm *
   weight_votehard) +
  (data$waittime_norm *
   weight_waittime) +
  (data$triptime_norm *
   weight_triptime) +
  (data$specific_difficulties_sum *
   weight_specific_difficulties) +
  (data$turnout22_norm *
   weight_turnout22) +
  (data$turnout22w_norm *
   weight_turnout22w)


# ------------------------------------------------------------
# 7. OPTIONAL DIFFICULTY CATEGORIES
# ------------------------------------------------------------

threshold_low <- quantile(
  data$difficulty_score_weighted,
  probs = 0.33,
  na.rm = TRUE
)

threshold_medium <- quantile(
  data$difficulty_score_weighted,
  probs = 0.66,
  na.rm = TRUE
)


data$difficulty_category <- cut(
  data$difficulty_score_weighted,
  breaks = c(
    -Inf,
    threshold_low,
    threshold_medium,
    Inf
  ),
  labels = c(
    "Low",
    "Medium",
    "High"
  )
)


# Check category distribution
table(
  data$difficulty_category,
  useNA = "ifany"
)


# ------------------------------------------------------------
# 8. COMPOSITE SCORE ANALYSIS
# ------------------------------------------------------------

# Keep only observations with both a composite score
# and a party affiliation.

composite_data <- data[
    !is.na(data$difficulty_score_weighted) &
    !is.na(data$party_affiliation),
]


# Group summaries
aggregate(
  difficulty_score_weighted ~ party_affiliation,
  data = composite_data,
  FUN = mean
)


# Welch two-sample t-test
t_test_composite <- t.test(
  difficulty_score_weighted ~ party_affiliation,
  data = composite_data
)

t_test_composite


# ------------------------------------------------------------
# 9. EFFECT SIZE
# ------------------------------------------------------------

cohen_d_composite <- cohen.d(
  difficulty_score_weighted ~ party_affiliation,
  data = composite_data
)

cohen_d_composite