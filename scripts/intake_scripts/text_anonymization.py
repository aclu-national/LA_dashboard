# Importing packages
from presidio_analyzer import AnalyzerEngine
from presidio_anonymizer import AnonymizerEngine
from presidio_anonymizer.entities import OperatorConfig
from presidio_analyzer.nlp_engine import SpacyNlpEngine, NerModelConfiguration
import pandas as pd

# Defining entities
entity_mapping = {
    "PER": "PERSON", 
    "PERSON": "PERSON",
    "LOC": "LOCATION", 
    "GPE": "LOCATION", 
    "FAC": "LOCATION",
    "ORG": "ORGANIZATION",
    "NORP": "NRP",
    "EVENT": "EVENT", 
    "LAW": "LAW",
    "DATE": "DATE_TIME", 
    "TIME": "DATE_TIME"
}

# Defining our NLP Engine as the large Spacy
nlp_engine = SpacyNlpEngine(
    models=[{"lang_code": "en", "model_name": "en_core_web_lg"}],
    ner_model_configuration=NerModelConfiguration(
        model_to_presidio_entity_mapping=entity_mapping,
        
        # Setting default score LOW (percision)
        default_score=0.05,
    )
)

# Defining analyzer and anonymizer
analyzer  = AnalyzerEngine(nlp_engine=nlp_engine, supported_languages=["en"])
anonymizer = AnonymizerEngine()

# Defining our entities
ENTITIES = [
    "PERSON", 
    "LOCATION", 
    "ORGANIZATION", 
    "NRP",
    "EVENT", 
    "LAW", 
    "DATE_TIME",
    "EMAIL_ADDRESS", 
    "PHONE_NUMBER", 
    "URL",
    "IP_ADDRESS",
    "US_SSN",
    "US_ITIN",
    "US_DRIVER_LICENSE",
    "US_PASSPORT",
    "AGE"
]

REDACTED = OperatorConfig("replace", {"new_value": "[REDACTED]"})

# Defining anonymize text maker
def anonymize_text(text):
    if not isinstance(text, str) or not text.strip():
        return text

    # Getting the analyzed results
    results = analyzer.analyze(text=text, language="en", score_threshold=0.05, entities=ENTITIES)
                               
    # Returning anonymized text with REDACTED rather than the entity type
    return anonymizer.anonymize(text=text, analyzer_results=results, 
 # operators={e: REDACTED for e in ENTITIES} | {"DEFAULT": REDACTED}
  ).text

# Running the anonymizer
print(anonymize_text("Elijah Appelson was walking down the street in front of Walmart on May 7th at 10:30 pm, when he saw John Smith from Somewhereville PD call his sister at 555-555-5555."))

# Fitting on dataframe
df = pd.read_csv("misconduct.csv")
df["narrative_anonymized"] = df["narrative"].apply(anonymize_text)
df[["narrative_anonymized"]].to_csv("misconduct_anonymized.csv", index=False)
