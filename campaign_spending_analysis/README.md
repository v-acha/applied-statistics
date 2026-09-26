# Campaign Spending and Votes in 2016 House Elections

This project examines how reported campaign disbursements and candidate party are associated with vote totals in the 2016 U.S. House general elections. In the fitted model, higher disbursements are associated with more votes after accounting for the three party categories. The analysis describes an association; it does not show that spending caused a candidate to gain votes.


## Question and data

How do campaign disbursements and party affiliation relate to the number of general-election votes a House candidate receives?

The analysis combines the `results_house` and `campaigns` datasets from the [`fec16` R package](https://search.r-project.org/CRAN/refmans/fec16/html/00Index.html). `results_house` contains 2016 House election results; `campaigns` contains campaign finance information. The modeled variables are:

| Variable | Role |
|:---|:---|
| `general_votes` | Candidate's general-election vote total, the outcome |
| `ttl_disb` | Campaign's total reported disbursements, in dollars |
| `candidate_party` | Party grouping used in this analysis: Democrat, Republican, or Other Party |

The party grouping is derived from the election-result party field. Campaign disbursements are strongly right-skewed: a small number of campaigns report much larger amounts than most others.

## Approach

The main analysis fits a linear regression:

```r
lm(general_votes ~ ttl_disb + candidate_party, data = new_df)
```

Democrats are the reference party category. Each party coefficient compares that category with Democrats at the same modeled spending level. A nested-model F-test compares this model with a spending-only model to assess whether the party terms add explanatory information *jointly*. The coefficient p-values come from the regression's t statistics; they are not separate two-sample t-tests.

## Findings

| Term | Estimate | p-value | Reading of the estimate |
|:---|---:|---:|:---|
| Total disbursements | 0.01326 votes per dollar | 6.9 × 10⁻¹⁴ | About 13,260 more votes per additional $1 million in reported disbursements, at the same modeled party category |
| Other Party vs. Democrat | −113,100 votes | < 2 × 10⁻¹⁶ | A lower modeled vote total than the Democratic reference group, holding disbursements fixed |
| Republican vs. Democrat | +6,534 votes | 0.177 | No clear evidence of a difference from the Democratic reference group in this model |

The positive spending coefficient is statistically detectable, but it should be read as a **conditional association**. The $1 million comparison scales the fitted coefficient; it does not predict what would happen if a campaign actually increased its spending by that amount.

Adding the two party terms improves fit over the spending-only model in the reported nested-model F-test (`p < 2.2 × 10⁻¹⁶`). This is a joint result: it does not imply that both individual party contrasts are significant. In particular, the Republican–Democrat contrast has `p = 0.177`.

## Limitations

- Candidates may spend more because they are competitive, raise more money, or face stronger opponents. This regression cannot separate those explanations from any effect of spending on votes.
- Incumbency, district size and turnout, race competitiveness, and other campaign characteristics are not controlled for here. Candidates in the same district also compete for votes, so treating their records as independent may understate uncertainty.
- Spending is highly skewed, and a few large campaigns could have substantial influence on an untransformed linear fit. The model should be checked with residual and influence diagnostics before relying on its predictions.
- The outcome is **vote total**, not vote share or the probability of winning. It reflects differences between districts as well as differences between candidates.

## Takeaway

Within the analyzed 2016 House candidates, reported disbursements are positively associated with general-election vote totals, and party grouping adds information to the spending-only model. These results are useful as a descriptive starting point, while the observational design and omitted race characteristics limit causal or predictive conclusions.
