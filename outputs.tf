output "tables"{
    value = google_bigquery_table.main
    description = "Map of bigquery table resources being provisioned."
}

output "external_tables"{
    value = google_bigquery_table.ext_table
    description = "Map of bigquery external table resources being provisioned."
}