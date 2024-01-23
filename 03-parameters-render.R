library(readr)
library(dplyr)
library(quarto)

polling_places <-
  readr::read_csv(here::here("data", "geocoded_polling_places.csv"))

polling_places_reports <-
  polling_places %>%
  dplyr::distinct(state) %>%
  dplyr::slice_head(n = 5) %>%
  dplyr::mutate(
    output_format = "html",
    output_file = paste0(tolower(state),
                         "-polling-places.html"),
    execute_params = purrr::map(state,
                                \(state) list(state = state))
  ) %>%
  dplyr::select(output_file, execute_params)

purrr::pwalk(
  .l = polling_places_reports,
  .f = quarto::quarto_render,
  input = here::here("02-iterate-report-parameters.qmd"),
  .progress = TRUE
)
