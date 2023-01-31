locals {
  tables = { for table in var.tables : table["table_id"] => table }
  external_tables = {for ext_table in var.external_tables : ext_table["table_id"] => ext_table}
}

resource "google_bigquery_dataset" "main" {
  dataset_id                  = var.dataset_id
  friendly_name               = var.dataset_name
  description                 = var.description
  location                    = var.location
  delete_contents_on_destroy  = var.delete_contents_on_destroy
  default_table_expiration_ms = var.default_table_expiration_ms
  project                     = var.project_id

}


resource "google_bigquery_table" "main" {
  for_each            = local.tables
  dataset_id          = google_bigquery_dataset.main.dataset_id
  table_id            = each.key
  schema              = file("schema.json")
  project             = var.project_id
  deletion_protection = var.deletion_protection

    dynamic "time_partitioning" {
    for_each = each.value["time_partitioning"] != null ? [each.value["time_partitioning"]] : []
    content {
      type                     = time_partitioning.value["type"]
      field                    = time_partitioning.value["field"]
    }
  }
}


resource "google_bigquery_table" "ext_table"{
    for_each = local.external_tables
    dataset_id  = google_bigquery_dataset.main.dataset_id
    table_id = each.key
    project = var.project_id
    deletion_protection = var.deletion_protection

    external_data_configuration{
        source_format = each.value.source_format
        autodetect = each.value.autodetect
        schema = file("schema.json")
        source_uris = each.value["source_uris"]
        ignore_unknown_values = each.value.ignore_unknown_values
        max_bad_records = each.value.max_bad_records
        
        dynamic "csv_options" {
            for_each = each.value["csv_options"] != null ? [each.value["csv_options"]] : []
            content{
                allow_quoted_newlines= csv_options.value.allow_quoted_newlines
                encoding = csv_options.value.encoding
                field_delimiter =  csv_options.value.field_delimiter
                skip_leading_rows = csv_options.value.skip_leading_rows
                quote = csv_options.value.quote    
                allow_jagged_rows     = csv_options.value["allow_jagged_rows"]    
            }
        }

        dynamic "google_sheets_options" {
            for_each = each.value["google_sheets_options"] != null ? [each.value["google_sheets_options"]] : []
            content {
                skip_leading_rows = google_sheets_options.value["skip_leading_rows"]
      }
    }
    }
}
