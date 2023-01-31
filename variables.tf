variable "dataset_id" {
  description = "Unique ID for the dataset being provisioned."
  type        = string
}

variable "dataset_name" {
  description = "Friendly name for the dataset being provisioned."
  type        = string
  default     = null
}

variable "description" {
  description = "Dataset description."
  type        = string
  default     = null
}

variable "location" {
  description = "The regional location for the dataset only US and EU are allowed in module"
  type        = string
  default     = "US"
}

variable "delete_contents_on_destroy" {
  description = "(Optional) If set to true, delete all the tables in the dataset when destroying the resource; otherwise, destroying the resource will fail if tables are present."
  type        = bool
  default     = null
}

variable "deletion_protection" {
  description = "Whether or not to allow Terraform to destroy the instance. Unless this field is set to false in Terraform state, a terraform destroy or terraform apply that would delete the instance will fail"
  type        = bool
  default     = false
}

variable "default_table_expiration_ms" {
  description = "TTL of tables using the dataset in MS"
  type        = number
  default     = null
}

variable "project_id" {
  description = "Project where the dataset and table are created"
  type        = string
}


variable "tables" {
  description = "A list of objects which include table_id, schema, time_partitioning."
  type = list(object({
    table_id  = string,
    schema = optional(string),
    time_partitioning = object({
      field                    = string,
      type                     = string,
    }),
  }))
}

variable "external_tables" {
    description = "A list of objects which include table_id and external_data_configuration."
    type = list(object({
        table_id = string,
        source_format = string,
        autodetect = string,
        ignore_unknown_values = optional(bool),
        max_bad_records = optional(number),
        source_uris = list(string),
        schema = optional(string),
        source_format = string,
        csv_options = object({
            quote = string,
            allow_jagged_rows = optional(bool),
            allow_quoted_newlines = optional(bool),
            encoding =string,
            field_delimiter  = string,
            skip_leading_rows = number,
        }),
        google_sheets_options = object({
            skip_leading_rows = number,
            range = optional(string),
        }),
    }))
}
