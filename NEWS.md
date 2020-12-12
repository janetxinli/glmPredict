## glmPredict v0.2.0
In this minor release, `glmPredict` was refactored to simplify and specify functionalities. The `glm_predict` function was altered to take different positive/negative class labels, and now returns only the `augment` object with corresponding predictions. Evaluating predictions is now addressed by specific functions -- `accuracy_score`, `precision_score` and `recall_score`.

## glmPredict v0.1.1
No code changes here. A more detailed description of the development of `glmPredict` was added to the main `README`.

## glmPredict v0.1.0
This is the first version of glmPredict! It contains a single function, `glm_predict`, that can make predictions given a `glm` object. It also comes packaged with a toy dataset, `cancer_clean`, which can be used to test and play with. 
