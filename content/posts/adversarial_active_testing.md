+++
title = 'Analysis on Adversarial active testing'
date = 2024-10-12T15:28:04+08:00
draft = true

author = ["Elvis Wu"]
tags = ["Adversarial", "DoE"]
categories = ["tech"]

math = true
+++

This blogs aims at analyzing the Adversarial active testing in the ESREL 2022 paper: https://www.rpsonline.com.sg/proceedings/esrel2022/html/S05-03-290.xml.

Although we found this phenomenon independently, 2 papers pave the way for the paper writing:

1. adversarial active learning: [1802.09841v1](https://arxiv.org/abs/1802.09841v1)
2. active testing: [2103.05331v2](https://arxiv.org/abs/2103.05331)

First, we will introduce the basic formulation of adversarial attacks, and then focus on 3 related attack methods:

1. DeepFool: https://arxiv.org/abs/1511.04599
2. CW attack: https://arxiv.org/abs/1608.04644
3. MI-FGSM: https://arxiv.org/abs/1710.06081

## Adversarial attacks 

This concept is first introduced in https://arxiv.org/abs/1312.6199. 

First, let us follow the guide of https://adversarial-ml-tutorial.org/ to analyze the adversarial attack in the basic formats.

If you are familiar with this, just [skip to the next session](#attack-distance-as-an-uncertainty-metric).
### Formulation
Let us define the model, or hypothesis function, $f_\theta : \mathcal{X} \rightarrow \mathbb{R}^k$, where $k$ is the number of classes being predicted.  The $\theta$ vector represents all the parameters which we typically optimize over when we train the neural network.

{{< rawhtml >}}
For $x \in \mathcal{X}$ the input and $y \in \mathbb{Z}$ the true class, we consider the cross entropy loss:
$$
\begin{equation}
\ell(f_\theta(x), y) = \log \left( \sum_{j=1}^k \exp(f_\theta(x)_j) \right) - f_\theta(x)_y
\end{equation}
$$
where $f_\theta(x)_j$ denotes the $j$th elements of the vector $f_\theta(x)$.

{{< /rawhtml >}}

<!-- **Aside:** For those who are unfamiliar with the convention above, note that the form of this loss function comes from the typical softmax activation.  

Defining the softmax operator $\sigma : \mathbb{R}^k \rightarrow \mathbb{R}^k$ applied to a vector

$$
\begin{equation}
\sigma(z)_i = \frac{exp(z_i)}{\sum_{j=1}^{k}\exp(z_{j})}
\end{equation}
$$

to be a mapping from the class logits returned by $f_\theta$ to a probability distribution.  Then the typical goal of training a network is to maximize the probability of the true class label.  Since probabilities themselves get vanishingly small, it is more common to maximize the _log_ of the probability of the true class label, which is given by

$$
\begin{equation}
\log \sigma(f_\theta(x))_y = \log \left(\frac{exp(f_\theta(x)_y)}{\sum_{j=1}^{k}\exp(f_\theta(x)_{j})} \right) = f_\theta(x)_y - \log \left (\sum_{j=1}^{k}\exp(f_\theta(x)_{j}) \right ).
\end{equation}
$$
Since the convention is that we want to _minimize_ loss (rather than maximizing probability), we use the negation of this quantity as our loss function.  We can evaluate this loss in PyTorch using the following command. -->


Consider a target label $y_{adv} \neq y$, the attack process can be viewed from the following two perspectives: 

1. A process of moving away from the true label $y$: 
$$
\begin{equation}
\max_{\delta \in \Delta} \ell(f_\theta(x +\delta), y)
\end{equation}
$$
2. A process of approaching the target label $y_{adv}$:
$$
\begin{equation}
\min_{\delta \in \Delta} \ell(f_\theta(x +\delta), y_{adv})
\end{equation}
$$
where $\Delta$ represents an allowable set of perturbations
$$
\begin{equation}
\Delta = \{\delta : \|\delta\|_p \leq \epsilon\}
\end{equation}
$$

### DeepFool

In the DeepFool paper [(Seyed-Mohsen et al. 2015)](https://arxiv.org/abs/1511.04599), they give a **closed form** of the attack for a binary classifier. 

{{< figure src="/imgs/p3_ch1_deepfool.png" caption="DeepFool for a binary classifier." id="p3_ch1_deepfool">}}

In the case where the classifier $f$ is affine, it can easily be seen that the robustness of $f$ at point $x_0$, $\Delta(x_0; f)$, is equal to the distance from $x_0$ to the separating affine hyperplane $\mathscr{F} = \lbrace x: w^Tx+b= 0 \rbrace $. The minimal perturbation to change the classifier's decision corresponds to the orthogonal projection of $x_0$ onto $\mathscr{F}$. It is given by the closed-form formula:

{{< rawhtml >}}
$$
\begin{aligned}
r_*(x_0) & := \argmin \| r \|_2 \\
         & \text{ s.t. } \text{ sign } (f(x_0+r)) \neq \text{ sign} (f(x_0)) \\ 
		 & = -\frac{f(x_0)}{\|w\|_2^2}w.		  			
\end{aligned}
$$

Assuming now that $f$ is a general binary differentiable classifier, we adopt an iterative procedure to estimate the robustness $\Delta(x_0; f)$. Specifically, at each iteration, $f$ is linearized around the current point $x_i$ and the minimal perturbation of the linearized classifier is computed as
$$
\begin{align}
\argmin_{r_i} \| r_i \|_2, \text{ s.t. } f(x_i) + \nabla f(x_i)^T r_i = 0.
\end{align}
$$

The perturbation $r_i$ at iteration $i$ of the algorithm is computed using the closed form solution in Eq. , and the next iterate $x_{i+1}$ is updated. The algorithm stops when $x_{i+1}$ changes sign of the classifier. 

{{< /rawhtml >}}

### CW Attack
The Carlini and Wagner (CW) attack is a powerful adversarial attack that leverages optimization techniques to generate adversarial examples.
CW attack uses two key optimization strategies:
1. **Lagrange Penalty Function**: In the naive adversarial attack formulation, we want to find a small perturbation $\delta$ such that the model misclassifies the adversarial example $x + \delta$, while keeping the perturbation small. A typical formulation might look like:
   {{< rawhtml >}}
   $$
   \text{minimize} \|\delta\|_p \quad \text{subject to} \quad f(x + \delta) \neq f(x)
   $$
   {{< /rawhtml >}}
   where $f(x)$ is the model's output (e.g., class label or logits). The CW attack transforms this into an unconstrained optimization problem using a **Lagrange multiplier** technique. The idea is to convert the constraint into a penalty term in the objective function, so the formulation becomes:
   {{< rawhtml >}}
   $$
   \min_{\delta} \|\delta\|_p + c \cdot \mathcal{L}(f(x + \delta), y_{adv})
   $$
   {{< /rawhtml >}}
   where $c$ is a constant that controls the balance between the perturbation size and the adversarial loss. This penalty-based formulation allows the optimization to be handled in a continuous way.
   

2. **Tanh-Space Transformation**: 
   To avoid the issue of clipping the perturbation $\delta$ to ensure that the adversarial example $x + \delta$ lies within a valid pixel range (e.g., $[0, 1]$ for image data), the CW attack uses a **tanh transformation**. Instead of directly optimizing $\delta$, it optimizes in a different space, where the values are unconstrained. Specifically, the perturbation is parameterized as:
   {{< rawhtml >}}
   $$
   \delta = \frac{1}{2} \left( \tanh(w) + 1 \right) - x
   $$
   {{< /rawhtml >}}
   where $w$ is the variable being optimized. The $\tanh$ function maps $w$ from $(- \infty, \infty)$ to $(0, 1)$, which corresponds to the valid range for pixel values (or whatever range the input data has). This transformation extends the optimization space and allows for more flexibility without requiring hard clipping after each optimization step.

These two strategies allow the CW attack to find adversarial examples efficiently and with minimal distortion, making it highly effective against many models.


### MI-FGSM 

The **Momentum Iterative Fast Gradient Sign Method (MI-FGSM)** is an enhancement of the basic FGSM attack that incorporates momentum to improve the adversarial example generation process. 

The standard **Fast Gradient Sign Method (FGSM)** computes a perturbation by taking the sign of the gradient of the loss function with respect to the input, i.e.:
$$
\delta = \epsilon \cdot \text{sign}(\nabla_x \mathcal{L}(f(x), y))
$$
However, FGSM can be unstable, especially in iterative versions like I-FGSM, where multiple steps can lead to a zigzagging behavior. 

MI-FGSM addresses this by incorporating **momentum**, which accumulates gradients from previous iterations to stabilize and smooth the optimization. Instead of using just the current gradient, MI-FGSM modifies the iterative update rule by maintaining an exponential moving average of the gradients, leading to more stable perturbation directions. This helps the attack avoid local minima and escape from flat regions of the loss surface.

{{< figure src="/imgs/p3_ch2_mi_fgsm.png" caption="MI-FGSM algorithm." id="p3_ch2_mi_fgsm" width="70%">}}

The gradient at each step $t$ is updated as:
{{< rawhtml >}}
$$
g_{t+1} = \mu \cdot g_t + \frac{\nabla_x \mathcal{L}(f(x_t), y)}{\|\nabla_x \mathcal{L}(f(x_t), y)\|_1}
$$
where $g_t$ is the accumulated gradient, $\mu$ is the decay factor for momentum, and $\|\cdot\|_1$ normalizes the current gradient. The adversarial example is then updated by taking a step in the direction of the accumulated gradient:
$$
x_{t+1} = x_t + \epsilon \cdot \text{sign}(g_{t+1})
$$
{{< /rawhtml >}}
This momentum term enables MI-FGSM to generate more effective adversarial examples that generalize better across different models, making it more potent in transfer-based attacks.

MI-FGSM creates adversarial examples that are more likely to "transfer" between different models, making it highly effective in black-box scenarios where the attacker only has access to a substitute model, not the actual model being attacked.


## Sensitivity to adversarial attacks as the sample hardness metric

### From model robustness evaluation to sample hardness evaluation

Here we brief the key idea of adversarial active testing (AAT). 

In the DeepFool paper, they propose that the adversarial attack effects can be used to compare the robustness of different models.

Here we fix the model, and use the difficulty of the adversarial attack as a metric to evaluate the **Sample Hardness**. 

> **Sample Hardness Evaluation** is a method used to quantify how difficult a given sample is for a machine learning model to correctly classify or predict. The concept revolves around identifying which data points are inherently more challenging for the model, providing insights into model performance and dataset quality. Understanding and measuring sample hardness helps in identifying difficult cases, improving model robustness, and guiding training strategies.

### Key aspects and approaches for sample hardness evaluation

1. **Prediction Confidence**:
   One simple way to evaluate sample hardness is by using the **confidence score** of the model's predictions. Samples that receive low confidence scores (close to 50% in binary classification or spread across multiple classes in multi-class tasks) are considered harder, while high-confidence predictions are seen as easier.

   - **Entropy of Predictions**: Higher entropy (uncertainty) in the model's output distribution can indicate harder samples, while low entropy (clear predictions) points to easier examples.
   $$
   H(x) = - \sum_{i=1}^{n} p_i \log(p_i)
   $$
   Here, $ p_i $ represents the predicted probability for class $i$.

2. **Margin of Classification**:
   In many models, especially in **support vector machines (SVMs)** and **neural networks**, the distance of a sample from the decision boundary can be used as a measure of hardness. Samples closer to the boundary are typically harder to classify, while those far from the boundary are easier.

   - **SVM Margin**: In an SVM, the sample hardness can be related to the margin, where samples on or near the margin are considered harder.

3. **Loss Value**:
   The **loss function** (such as cross-entropy for classification tasks) directly measures how well a model fits a sample. A higher loss indicates that the sample is harder for the model to learn, while a low loss means the model can easily fit the sample.
   
   - **Hardness based on loss**: By monitoring the loss value for individual samples during training, one can evaluate their relative hardness. Difficult samples tend to persist with higher loss values over time.

4. **Ensemble Disagreement**:
   When using ensemble methods like **bagging** or **boosting**, evaluating how often different models in the ensemble disagree on a particular sample can indicate hardness. Higher disagreement among models suggests that the sample is difficult.

   - **Disagreement Score**: By measuring the variance or inconsistency in predictions across multiple models in the ensemble, we can estimate sample hardness. Higher disagreement implies greater hardness.

5. **Data Characteristics (Intrinsic Features)**:
   Some samples might be inherently harder due to properties such as:
   - **Class overlap**: Samples that reside in regions where multiple classes overlap tend to be harder for the model to distinguish.
   - **Outliers**: Samples that lie far from the main data distribution (outliers) are typically harder to classify accurately.
   - **Noise or Ambiguity**: Noisy data (e.g., mislabeled or low-quality samples) or ambiguous samples (e.g., belonging to multiple plausible classes) tend to increase hardness.

6. **Latent Space Distance**:
   In deep learning models, particularly those using embeddings (e.g., transformers or autoencoders), the distance between a sample's representation in the latent space and the class centroid can be used as a hardness measure. Samples far from their class representation are considered harder to classify.

### Experiments on corrosion segmentation dataset
Here we give a visual intuition for this method.

{{< figure src="/imgs/p3_ch2_seg_aat.png" caption="MI-FGSM attack demo on the corrosion segmentation task." id="p3_ch2_seg_aat" width="90%">}}

For DeepFool on binary classification, they use the accumulated perturbation as the distance metric for the sample to the decision boundary.

Here, in our paper [AAT](https://www.rpsonline.com.sg/proceedings/esrel2022/html/S05-03-290.xml), we mainly adapt the idea in 3 points:

1. **Pseudo label**: Usually an adversarial attack is to drag the sampple across the decison boundary and detach from the ground truth label. For any sample in real scenarios which is unlabled, we just use the original prediction $f_\theta(x)$ as the pseudo label.
2. **Attack effect measure**: We use an effective attack method, like MI-FGSM, as well as the fixed hyperparameters $\phi_{att}$ which inlcude the attack iteration, perturbation size and decay factor. Therefore the distance metric of $d(f_\theta(x), f_\theta(x + \delta))$ can be a measurement on the prediction deviation under the same attack. (The perturbation $\delta$ is the output of the attack.)
3. **Distance metric**: The distance metric $d(f_\theta(x), f_\theta(x + \delta))$ can be chosen according to the business target of the ML application. For example, the accurate corrosion ratio and position in the corrosion segementation case are the business targets. Then we use mIoU as the metric $d$.

> For the ML applications with labels in high dimension, like segmentation mask, the active testing and learning method is more useful since the labeling budget is high. For simple label task, like binary classification, I would suggest label or pseudo-label the real samples directly. 

> However, if the computation is affordable, this method can be still useful in the continous monitor, to detect OOD or hard samples.

### Formulation for the attack-based sample hardness evaluation

This metric can be viewed as a scalar function $h_\theta(x): \mathcal{X} \rightarrow \mathbb{R}$.
The attack robustness for a certain sample is calculated in this process:
$$
   \delta(\theta, x) = \text{attack}(f_\theta, x) 
$$
$$
   h_\theta(x) = d(f_\theta(x), f_\theta(x + \delta(\theta, x)))
$$

Thus $h_\theta(x)$ is the attack-based sample hardness metric.

Let us consider the same binary classification case in DeepFool.
To get the simplified intuition, we consider one iteration attack
{{< rawhtml >}}
$$
   \delta(x_i) = -\frac{f(x_i)}{\|\nabla f(x_i)\|_2^2}\nabla f(x_i)
$$
{{< /rawhtml >}}

For this case, just set the distance metric be:
$$
\begin{aligned}
h_\theta(x) & := \|f_\theta(x + \delta) - f_\theta(x)\| \\
\end{aligned}
$$

#### Linear approximation of $f(x)$ 

First consider $f(x)$ can approximate to a linear function. 
Higher order gradients are aproximately zero. 

The Taylor expansion of $f(x + \delta)$ up to the first order is given by:
$$
f(x + \delta) \approx f(x) + \nabla f(x) \cdot \delta 
$$

Now, we can substitute this approximation into the expression for $ h_\theta(x) $:
{{< rawhtml >}}
$$
\begin{aligned}
h_\theta(x) & = \|f_\theta(x + \delta) - f_\theta(x)\| \\
& \approx \| \nabla f_\theta(x) \cdot \delta \| \\
& = \| \nabla f_\theta(x) \cdot -\frac{f_\theta(x)}{\|\nabla f_\theta(x)\|_2^2}\nabla f_\theta(x) \| \\
& = \| f_\theta(x)\| \\
\end{aligned}
$$


In the linear situation, the margin (distance to the decision boundary) can be easily calculated:
$$
\begin{aligned}
r(x) & = \| -\frac{f_\theta(x)}{\|\nabla f_\theta(x)\|_2^2}\nabla f_\theta(x) \| \\
& = \frac{\| f_\theta(x)\|}{\|\nabla f_\theta(x)\|_2} \\
\end{aligned}
$$
{{< /rawhtml >}}
For the fixed model $\theta$, ${\|\nabla f_\theta(x)\|_2}$ is also a constant.

This simplification shows, in the linear approximation, **the metric $h_\theta(x)$ reflects the margin $r(x)$.**
{{< rawhtml >}}
$$
h_\theta(x) \approx \|\nabla f_\theta(x)\|_2 \cdot r(x) \propto r(x)
$$

{{< /rawhtml >}}

{{< figure src="/imgs/p3_ch1_deepfool.png" caption="DeepFool for a binary classifier." id="p3_ch1_deepfool">}}


#### NonLinear situation  

In the context of adversarial attacks on samples $x$ when $f$ is a neural network, the attack process can be conceptualized as a multi-step traversal across the decision boundary. Here, the margin isn't a simple one-step linear margin; rather, it embodies a measure of the difficulty associated with the attack.

To link $h_\theta(x)$ with the margin, consider the following points:

1. **Understanding Margins in Decision Boundaries**: In machine learning, the margin typically measures the distance between a data point and the decision boundary. A larger margin implies that a sample is farther from the boundary, making it more robust against adversarial perturbations.

2. **Gradient Influence**: The metric $h_\theta(x)$ reflects changes in the function $f_\theta$ as a result of perturbations. If $h_\theta(x)$ encompasses the response of $f_\theta$ to small variations in $x$, then it inherently captures how sensitive the network is to changes in input, which is correlated with the margin. 

3. **Multi-step Attacks and Margin**: In multi-step adversarial attacks, the process effectively considers how far an adversarial sample can be perturbed before crossing the decision boundary. Thus, $h_\theta(x)$, as a measure of the difference between $f_\theta(x)$ and its perturbed version, can be interpreted as a proxy for the margin by revealing how many perturbations can be applied before a misclassification occurs.

In conclusion, $h_\theta(x)$ can be connected to the margin $r(x)$ as it reflects sensitivity to perturbations and indicates the robustness of the decision boundary, thereby serving as an empirical measure of the margin in high-dimension non-linear situations.


### QA

1. How is the MAT results different from sensitivity that would be measured with IPT and OOD measurements using DRT?

- IPT: Image perturbations of certain types, such as blur, rain, 
- MAT: Calculate the sensititvity under the most effective perturbations generated by advanced attacks.  Not limited to images. 

2. I cannot see the relation to the decision boundary in the approach. The ADS is a smart perturbation technique looking for a direction to model changes, but it is not set up to determine the decision boundary as I understand it.

- Answered in [linear-approximation session](#linear-approximation-of-fx)

3. The labelling referred to in Fig 2 on the scored pool is not explained in the paper, so I do not understand what you do when you have used ADS to prioritize the unlabeled pool.

- Since we the score metric (ADS in the paper) $h_\theta(x)\propto r(x)$ margin, we can use calibrated $h_\theta^*(x)$ as the sampling probability. 
{{< rawhtml >}}
$$
\begin{equation}
h_\theta^*(x_i) = \frac{h_\theta(x_i) }{\sum_{j\in pool}h_\theta(x_j))} 
\end{equation}
$$
{{< /rawhtml >}}
- Sampling and statisitcal details can be found in [2103.05331v2](https://arxiv.org/abs/2103.05331)

