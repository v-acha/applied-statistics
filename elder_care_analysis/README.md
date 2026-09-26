# Eldercare Time, Earnings, and Household Factors

## Overview

This analysis examines the relationship between weekly earnings and time spent providing eldercare using data from the 2023 American Time Use Survey (ATUS).

Four regression specifications progressively incorporate employment and household characteristics, including full-time or part-time status, the presence of children, partner presence, and total weekly hours worked.

Across the fitted models, weekly earnings do not show a statistically significant relationship with eldercare time. In the fuller models, household composition appears more informative, with the presence of children showing the clearest statistical association with eldercare time.

Because the analysis is observational, these relationships should be interpreted as associations rather than causal effects.

## Research Question

How is time spent providing eldercare associated with weekly earnings, employment characteristics, and household composition?

## Data

The analysis uses the 2023 American Time Use Survey, sponsored by the U.S. Bureau of Labor Statistics and conducted by the U.S. Census Bureau.

ATUS respondents report their activities during a single 24-hour diary period and provide additional demographic, employment, and household information.

The primary variables used in this analysis are:

| Variable | Description |
|---|---|
| `TRTEC` | Minutes spent providing eldercare during the diary day |
| `TRERNWA` | Weekly earnings from the respondent's main job |
| `TRDPFTPT` | Full-time or part-time employment status |
| `TRHHCHILD` | Presence of children in the household |
| `TRSPPRES` | Presence of a spouse or partner |
| `TEHRUSLT` | Total usual weekly hours worked |

After filtering invalid observations and retaining records with the variables required for the analysis, the working dataset contains 163 observations.

## Data Preparation

Weekly earnings were converted to dollar values, and earnings and eldercare time were log-transformed for the adjusted regression models to reduce skewness.

Employment status, child presence, and partner presence were recoded as categorical variables. Invalid negative codes were excluded from the analysis.

## Modeling Approach

Four linear regression models were estimated to examine how the relationship changes as additional characteristics are introduced.

### Model 1

The baseline model evaluates the relationship between weekly earnings and eldercare time using the original scales.

`Eldercare Time ~ Weekly Earnings`

### Model 2

The second model uses log-transformed earnings and eldercare time and adds employment status.

`Log Eldercare Time ~ Log Weekly Earnings + Employment Status`

### Model 3

The third model introduces household composition.

`Log Eldercare Time ~ Log Weekly Earnings + Children + Partner Presence`

### Model 4

The final model incorporates earnings, employment status, household composition, and weekly hours worked.

`Log Eldercare Time ~ Log Weekly Earnings + Employment Status + Children + Partner Presence + Weekly Hours Worked`

## Results

Weekly earnings do not show a statistically significant relationship with eldercare time across the fitted specifications.

Adding employment status does not substantially change this result. In the fuller models, household composition becomes more informative, with the presence of children showing the strongest statistical association with eldercare time.

The final model therefore suggests that differences in eldercare time within this sample are more closely associated with household characteristics than with weekly earnings alone.

## Interpretation

The results do not provide evidence that higher or lower weekly earnings independently explain differences in eldercare time after the modeled employment and household characteristics are considered.

The relationship involving children is particularly notable, but it should not be interpreted as evidence that having children causes individuals to provide more eldercare. The association may reflect broader household structure, caregiving responsibilities, age, family composition, or other characteristics that are not represented in the models.

More broadly, the analysis illustrates how an initially simple relationship between income and caregiving can change when household context is incorporated into the model.

## Limitations

Several limitations affect how these results should be interpreted.

The final analytic sample contains 163 observations, which limits statistical precision and the number of relationships that can be estimated reliably.

The analysis uses observational survey data, so the regression coefficients describe associations rather than causal effects.

ATUS records activities for a single diary day. Eldercare time therefore reflects the respondent's reported activity during that particular day and may not represent their typical caregiving responsibilities over longer periods.

The regression models do not incorporate ATUS survey weights. Results should therefore be interpreted as relationships within the analyzed sample rather than estimates for the broader U.S. population.

The models also omit potentially relevant characteristics such as caregiver age, health, relationship to the care recipient, intensity of care needs, access to paid caregiving services, and broader household income.

Finally, the log transformations reduce skewness but do not by themselves guarantee that all linear-model assumptions are satisfied.

## Conclusion

Weekly earnings do not show a statistically significant relationship with eldercare time in the models estimated here. Household composition, particularly the presence of children, appears more strongly associated with differences in eldercare time within the analyzed sample.

The findings suggest that household context provides useful information beyond earnings alone, while the limited sample, observational design, and absence of survey weighting constrain broader conclusions.