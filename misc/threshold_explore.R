d_acc_ms <- d_acc |>
  group_by(dataset_id, administration_id, age) |>
  summarise(thresholded_accuracy = mean(accuracy > .50),
         accuracy = mean(accuracy))
    
ggplot(d_acc_ms, 
       aes(x = age, y = accuracy)) +
  geom_point() + 
  geom_smooth(method = "lm")

ggplot(d_acc_ms, 
       aes(x = age, y = thresholded_accuracy)) +
  geom_point() + 
  geom_smooth(method = "lm")

cor.test(d_acc_ms$age ,d_acc_ms$thresholded_accuracy)
cor.test(d_acc_ms$age ,d_acc_ms$accuracy)
