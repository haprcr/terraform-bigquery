# terraform-bigquery

This module allows you to create Google Cloud Platform BigQuery datasets and tables. This will allow the user to programmatically create an empty table, external bigquery tables. 

## Usage

```HCL
resource "google_bigquery_dataset" "main" {
  dataset_id                  = "bigquery_dataset_id"
  location                    = "us"
  delete_contents_on_destroy  = false
  project                     = "<PROJECT_ID>"

}


resource "google_bigquery_table" "main" {
  dataset_id          = google_bigquery_dataset.main.dataset_id
  table_id            = "bigquery_table_id"
  schema              = file("<PATH_TO_SCHEMA_JSON_DATA")
  deletion_protection = false

  "time_partitioning" {
      type                     = "YEAR"
      field                    = null
  }
}


resource "google_bigquery_table" "ext_table"{
    dataset_id  = google_bigquery_dataset.main.dataset_id
    table_id = "bigquery_external_table_id"
    deletion_protection = false

    external_data_configuration{
        source_format = "CSV"
        autodetect = true
        schema = file("<PATH_TO_SCHEMA_JSON_DATA")
        source_uris = ["<LINK_TO_THE_URI>"]
        
        "csv_options" {
                encoding = "UTF-8"
                field_delimiter =  ","
                skip_leading_rows = 1
                quote = ""    
        }
    }
}

```
Functional Examples are included in examples directory


## Inputs

Name | Description | Type | Default | Required
--- | ----- | ------- | -------- | ---
dataset_id | Unique ID for the dataset being provisioned |
