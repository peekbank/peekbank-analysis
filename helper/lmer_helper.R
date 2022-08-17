fit_trial_model <- function(predicted, fixed_effects, random_effects, data,
                            optimizer = lmerControl()$optimizer) {
  fixefs <- paste(fixed_effects, collapse = ' + ')
  ranefs <- paste(random_effects, names(random_effects), sep = " | ")
  ranefs <- glue("({ranefs})") |> paste(collapse = " + ")
  frml <- as.formula(glue("{predicted} ~ {fixefs} + {ranefs}"))
  lmer(frml, data = data, control = lmerControl(optimizer = optimizer))
}

predict_trial_model <- function(trial_model, target_labels = hf_words$target_label) {
  model_frame <- stats::model.frame(trial_model) |> as_tibble()
  model_terms <- trial_model@call$formula |> terms() |> attr("factors") |>
    attr("dimnames") |> pluck(1)
  y_term <- model_terms[1]
  x_terms <- model_terms[2:length(model_terms)]
  
  fixed_terms <- x_terms[!str_detect(x_terms, "\\|")]
  age_term <- fixed_terms[str_detect(fixed_terms, "age")]
  non_age_terms <- fixed_terms[!str_detect(fixed_terms, "age")]
  
  random_terms <- x_terms[str_detect(x_terms, "\\|")]
  target_label_term <- random_terms[str_detect(random_terms, "target_label")]
  
  step <- if (age_term == "age") 1 else 0.1 # might need adjusting for other age terms
  ages <- seq(min(model_frame[[age_term]]), max(model_frame[[age_term]]), step)
  
  if (!length(target_label_term)) {
    model_frame <- model_frame |> expand_grid(target_label = target_labels)
    re_form <- ~ 0
  } else {
    re_form = as.formula(paste("~", target_label_term))
  }
  
  pred_data <- model_frame |>
    select({{ non_age_terms }}, target_label) |>
    distinct() |>
    filter(target_label %in% target_labels) |>
    expand_grid({{ age_term }} := ages)
  
  pred_data |>
    mutate(.pred = predict(trial_model,
                           re.form = re_form,
                           newdata = pred_data))
}