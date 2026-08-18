# Visualizing Police Violence in Louisiana 
![](https://github.com/aclu-national/JL_dashboard/blob/750f780d571485c2c932d4ffbceaf4d256ebe400/image/image.png)

## Mission
We built this dashboard as an interactive tool to empower interested people, nonprofit organizations, journalists, attorneys, academics, and even law enforcement agencies to explore and compare statewide policing statistics, uncover crucial insights, and identify areas needing greater transparency.

## Goals
### 1. Enhancing Data Accessibility and Stewardship 
Our mission is to offer seamless access to crucial policing statistics in Louisiana. Beyond presenting these statistics, we hope to empower users by providing access to the raw data, transforming them into custodians of this valuable information.

### 2. Amplifying Voices: 
This initiative serves as a powerful tool to magnify the experiences of individuals who have faced police violence and their families. Through a combination of data and narratives, we hope to bring attention to and amplify the stories of those affected by violence.

### 3. Ensuring Accountability: 
We are committed to holding the police accountable for their actions. This involves representing instances of violence against the community and ensuring that individuals have transparent access to information about violent departments and officers.

## Git Structure

```
├── README.md
├── VPVL.Rproj                                               
├── data
│   ├── intake_data                                                     
│   │   └── 2026-08-17
│   │       └── louisiana_police_misconduct_data_collection.csv         # Not included in GitHub due to privacy
│   ├── misconduct_data                                                 # This has not been updated for several years
│   │   └── 2024-02-27
│   │       ├── data_agency-reference-list.csv
│   │       ├── data_allegation.csv
│   │       ├── data_event.csv
│   │       ├── data_personnel.csv
│   │       └── data_post-officer-history.csv
│   └── overview_data                                                    # Newer data not included due to size
│       ├── 2024-02-27
│       │   └── pe_1960_2022.csv
│       ├── 2025-01-27
│       └── └── lee_1960_2023.csv
├── reference_data
│   ├── data_years.csv
│   ├── key_words.csv
│   ├── misconduct_agency_representation.csv
│   └── represented.csv
└── scripts
    ├── intake_scripts
    │   └── intake_data_cleaning.R
    ├── killing_scripts
    │   └── killing_data_cleaning.R
    ├── misconduct_scripts
    │   ├── allegation_classification
    │   │   ├── GSDMM.py
    │   │   ├── classification_methodology.pdf
    │   │   ├── data_and_predictions
    │   │   │   ├── labelled_data.csv
    │   │   │   ├── rf_predictions.csv
    │   │   │   ├── svm_predictions.csv
    │   │   │   └── test_for_predictions.csv
    │   │   ├── fitting_allegation_models.R
    │   │   └── multilabel.py
    │   └── misconduct_data_cleaning.R
    └── overview_scripts
        └── overview_data_cleaning.R
```

## Sources
Data on known killings by police were obtained by [Mapping Police Violence](http://mappingpoliceviolence.org/) and include crowd-sourced data on killings by police officers that have been reported by the media beginning in 2013. The Mapping Police Violence data are [sourced](https://mappingpoliceviolence.org/methodology) from the Google News and validated using [Fatal Encounters](https://fatalencounters.org/), [Fatal Force](https://www.washingtonpost.com/graphics/investigations/police-shootings-database/), and governmental data sources. More information on these data can be found at [mappingpoliceviolence.org](http://mappingpoliceviolence.org). Data used for this report was downloaded from Mapping Police Violence on January 27th, 2025.

Demographic information was obtained from the [2020 U.S. Census](https://data.census.gov/table?g=040XX00US22,22$0500000&amp;y=2020&amp;d=DEC+Redistricting+Data+(PL+94-171)&amp;tid=DECENNIALPL2020.P1). In the analyses presented here, the Black population includes individuals who identified their race as Black or African American alone or in combination with another race. The white population includes individuals who identified their race as white and their ethnicity as not “Hispanic or Latino”.

Data on police officers were obtained from the [FBI Crime Data Explorer](https://cde.ucr.cjis.gov/LATEST/webapp/#/pages/downloads). [The Law Enforcement Employees](https://cde.ucr.cjis.gov/LATEST/webapp/#) dataset comprises annual data concerning personnel employed by law enforcement agencies, encompassing both officers and civilians. This data was accessed on January 27th, 2025. The Law Enforcement Agency names were cleaned using the [Law Enforcement Agency Identifiers Crosswalk, United States, 2012](https://www.icpsr.umich.edu/web/ICPSR/studies/35158/datadocumentation#) accessed through the University of Michigan on January 11th, 2024.

Data on known misconduct by police officers were obtained by the [Louisiana Law Enforcement and Accountability Database](https://llead.co/) (LLEAD) through public records requests and include public data collected from law enforcement agencies including police departments, sheriff’s offices, and civil service commissions. Note that as the data is a result of law enforcement reporting, we cannot guarantee the accuracy or depth of the reporting. To learn more about how the data is collected, visit [llead.co](http://llead.co) or their [GitHub page](https://github.com/ipno-llead/processing). Data used for this report was downloaded from LLEAD on February 27th, 2024.

Please note that the categorization of misconduct allegations, dispositions, and repercussions was carried out by analyzing key word stems, with the aim of standardizing categories across various police department reports. It is important to acknowledge that in certain instances, these classifications may not fully reflect the actual allegations, dispositions, and repercussions due to inconsistent reporting. For a detailed breakdown of our classification methodology, you can refer to this [PDF document](https://github.com/aclu-national/JL_dashboard/blob/main/scripts/misconduct_scripts/allegation_classification/classification_methodology.pdf).

Internal data on misconduct by police officers were obtained by Justice Lab's [Louisiana Police Misconduct Data Collection](https://action.aclu.org/la-misconduct-data-collection) form. This form serves as a data collection tool aimed at enhancing police accountability and monitoring and reporting incidents of police misconduct specifically within Louisiana. This comprehensive approach helps identify patterns, trends, and potential areas of concern, ultimately contributing to a more informed and data-driven effort toward promoting transparency and accountability in law enforcement activities in the state. Data used for this report was downloaded on January 27th, 2025.
