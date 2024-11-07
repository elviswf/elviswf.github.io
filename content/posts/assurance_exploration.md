+++
title = 'Assurance_exploration'
date = 2024-10-29T10:27:30+08:00
draft = true

author = ["Elvis Wu"]
tags = ["Assurance", "DoE", "Game Theory"]
categories = ["theory"]
+++

In this blog, I would like to explore the theory of Assurance.
Let us start from 2 papers shared by Andreas and Borre:

1. [Assurance 2.0: A Manifesto](https://arxiv.org/abs/2004.10474)
2. [Confidence in Assurance 2.0 Cases](https://arxiv.org/abs/2409.10665)


### Assurance 2.0: A Manifesto

The paper titled "Assurance 2.0: A Manifesto" discusses the challenges faced by system assurance in the context of rapid technological advancements, particularly with the rise of autonomous systems driven by machine learning and AI. It argues that traditional assurance methods are often seen as barriers to innovation, being costly and time-consuming. In response, the authors propose a modernized framework called "Assurance 2.0," which aims to support innovation and continuous incremental assurance by making the assurance process more rigorous.

Key points from the paper include:

1. **Assurance as an Enabler**: The paper repositions assurance not as a hindrance but as an enabler of innovation, suggesting that assurance should be integrated into the design process from the earliest stages.

2. **Assurance 2.0 Framework**: This framework builds on the concept of an "Assurance Case," where system claims are supported by evidence-based arguments. It emphasizes a structured approach with a focus on evidence, reasoning (both logical and probabilistic), and the exploration and assessment of doubts and potential counterevidence.

3. **Deductive Reasoning**: Assurance 2.0 advocates for deductive reasoning in assurance arguments, which requires each step to be supported by evidence, making the process more rigorous and identifying weak spots in the argument.

4. **Evidence Weight and Confirmation Theory**: The paper suggests using confirmation theory to assess the weight of evidence, requiring evidence not only to support a claim but also to discriminate between a claim and its negation or counterclaim.

5. **Indefeasibility Criterion**: Assurance 2.0 uses the indefeasibility criterion for justified belief, which means that all identified doubts and objections must be addressed, and no credible doubts should remain that could change the conclusion.

6. **Search for Defeaters**: The framework requires a comprehensive search for potential defeaters (evidence or arguments that could undermine the assurance case) and their defeat, either by showing they are not valid or by adjusting the system and/or its assurance case to negate them.

7. **Mitigation of Confirmation Bias**: Assurance 2.0 includes innovations to systematically mitigate confirmation bias, which is the tendency to interpret information in a way that confirms prior beliefs.

8. **Structured Argumentation**: The paper discusses the structure of an assurance case argument, including elementary evidential and reasoning steps, and how confidence in the case can be assessed and propagated through the case structure.

9. **Application and Future Work**: The authors have applied the principles of Assurance 2.0 in training and research projects and plan to prototype and evaluate the approach in industrial applications and research projects, including the DARPA ARCOS program.

In conclusion, Assurance 2.0 is presented as a response to the challenges of modern system assurance, offering a more dynamic, rigorous, and innovative approach that aligns with contemporary developments in epistemology and aims to enhance the interaction with tools for logical and probabilistic reasoning.


### Confidence in Assurance 2.0 Cases

The paper "Confidence in Assurance 2.0 Cases", is an in-depth exploration of the Assurance 2.0 framework, which aims to provide a rigorous and structured approach to assessing the confidence in the safety or security of computer-based systems. Here's a summary of the key points:

1. **Assurance Case Objective**: An assurance case should provide justifiable confidence in the truth of claims about critical properties of a system, such as safety or security.

2. **Indefeasible Confidence**: The goal is to achieve indefeasible confidence, meaning that all credible doubts and objections have been addressed to the extent that none remain that could change the decision.

3. **Four Perspectives**: Confidence is approached from four perspectives:
   - Logical soundness: Assessing the argument's validity and soundness.
   - Probabilistic assessment: Quantifying confidence through subjective probabilities.
   - Dialectical examination: Systematically exploring and addressing potential defeaters (doubts or objections).
   - Residual risks: Evaluating the impact of any remaining doubts after addressing defeaters.

4. **Assurance 2.0 Framework**: This framework builds on the concept of assurance cases, emphasizing rigor in evidence assessment, reasoning, and active exploration of potential defeaters to combat confirmation bias.

5. **Natural Language Deductivism (NLD)**: Assurance 2.0 arguments are interpreted as NLD, an informal counterpart to deductive proof, where the premises are "reasonable or plausible" rather than certain.

6. **Evidence and Reasoning**: The paper discusses the structure of an assurance case, composed of claims, argument, and evidence. It emphasizes the importance of distinguishing between evidence that measures something directly and evidence that is useful for drawing conclusions.

7. **Confirmation Measures**: These measures are used to assess the strength of evidence and how it discriminates between a claim and its negation or counterclaim.

8. **Probabilistic Assessment**: A method for calculating probabilistic confidence in assurance cases is introduced, which can be used to compare different arguments or parts of the same argument.

9. **Defeaters**: Doubts about an assurance case are recorded as defeaters, which challenge other nodes in the argument. Defeaters can be sustained, refuted, or addressed, and their management is crucial for establishing the indefeasibility of an assurance case.

10. **Residual Doubts**: These are explicitly marked defeaters that have not been eliminated or fully mitigated. Their potential impact must be assessed, and only those deemed negligible or manageable can remain as residual risks.

11. **Conclusion**: Assurance 2.0 provides a comprehensive approach to assessing confidence in assurance cases by considering both positive and negative perspectives. It emphasizes the synthesis of assurance cases from instantiations of generic subcases, or assurance theories, and advocates for community-driven development of these theories.

The paper concludes by emphasizing the importance of a systematic and rigorous approach to assurance cases, which can be supported by tools like Clarissa/asce, and the need for continued development and refinement of Assurance 2.0 theories and practices.


### Why third-pary assurance?

In this chapter, I would like to discuss the fundamental question, "Why we need assurance?", which is the natural question from the First Principle Thinking.
However, if you list all the reasons, which seems a lot, most of them may fall into quality assurance region, which can be well handled by the first party itself, not necessarily to position third-party companies like DNV.

Therefore, I would like categorize the assurance requirements into 3 types:

1. **First-party assurance**
- examples: Internal audit; Quality assurance team
- Characteristics: Aligned interest; Information fully shared
2. **Second-party assurance**
- examples: Audit on supplier
- Characteristics: Information not fully shared; Interest conflicted
3. **Third-party assurance**
- examples: Ship/Offshore classification; ISO certification
- Characteristics:   Information not fully shared; Interest non-conflicted; Third-party interest

{{< figure src="/imgs/assurance_type.png" caption="Assurance types based on roles." id="assurance_type">}}

So now we can focus on the key question, why we need third-pary assurance?

Third-party assurance refers to the process where an independent organization, not involved in the development or provision of a product or service, evaluates and verifies the safety, reliability, performance, or other critical attributes of a product, system, or process. Here are several key reasons why third-party assurance is necessary:

#### 1. Enhancing Objectivity and Impartiality
- **Objective Assessment**: Third-party organizations are not involved in the development or sales of the product or service, thus they can provide a more objective and unbiased assessment.
- **Reducing Conflicts of Interest**: Since third parties have no direct commercial interest in the product or service, potential conflicts of interest are minimized, enhancing the credibility of the assessment results.

#### 2. Building Trust and Confidence
- **Public Trust**: Third-party assurance can enhance consumer and user trust in a product or service by providing an independent verification of its performance and safety.
- **Market Confidence**: For investors and partners, third-party assurance can serve as a sign of the company's transparency and responsibility, boosting market confidence in the company and its products.

#### 3. Compliance and Regulatory Adherence
- **Legal Requirements**: In certain industries, such as aviation, healthcare, and nuclear energy, laws and regulations may require independent safety and compliance assessments by third-party organizations.
- **International Standards**: Third-party assurance helps demonstrate that a product or service complies with international standards and best practices, which is crucial for international trade and cooperation.

#### 4. Risk Management and Mitigation
- **Identifying and Mitigating Risks**: Third-party organizations can identify potential risks and vulnerabilities and provide professional advice on how to mitigate these issues.
- **Reducing Liability**: For providers of products or services, third-party assurance can help reduce legal liability in case of product failure or safety issues.

#### 5. Enhancing Brand Image and Market Competitiveness
- **Brand Reputation**: Through third-party assurance, companies can showcase their commitment to quality and safety, enhancing their brand image.
- **Competitive Advantage**: In a highly competitive market, third-party assurance can be a key differentiator for a company's products or services.

#### 6. Continuous Improvement and Learning
- **Feedback and Improvement**: Third-party assessments provide feedback that helps organizations identify areas for improvement, driving continuous improvement.
- **Industry Best Practices**: Third-party organizations typically have a grasp of industry best practices, and their assessments can help organizations learn and adopt these practices.

#### 7. Globalization and Standardization
- **Global Recognition**: Third-party assurance helps ensure that a product or service is recognized and accepted globally.
- **Standardized Processes**: Third-party organizations usually follow standardized assessment processes, which helps achieve consistency and comparability of assessment results worldwide.

In summary, third-party assurance provides an independent and objective verification mechanism that helps build trust, ensure compliance, manage risks, and enhance a company's market competitiveness. It is an indispensable part of the modern business environment, especially in industries where safety, quality, and reliability are of utmost importance.


### The Rationale for Third-Party Assurance in Game Theoretic Terms

In the context of technology and business transactions, assurance mechanisms play a pivotal role in establishing trust and reliability. This chapter delves into the necessity of third-party assurance from the perspectives offered by game theory, examining why such assurance is indispensable even when first-party and second-party assurances are present.

#### 1. Information Asymmetry

**Core Issue**: The fundamental issue in many transactions is information asymmetry, where the first party (the producer or service provider) possesses more information about the product or service than the second party (the consumer or client). This disparity can lead to market failures as the second party may not fully trust the claims made by the first party.

**Role of Third Parties**: Third-party assurance mitigates information asymmetry by providing an independent evaluation. Acting as an intermediary, third parties help validate the first party's claims, thereby reducing transaction risks and fostering a more level playing field.

#### 2. Reputation and Signaling

**Reputation Building**: In repeated interactions within game theory, individuals establish reputations to facilitate cooperation. While first-party assurance is a means of building reputation, it may be compromised by vested interests.

**Signaling**: Third-party assurance serves as a credible signal to the market that the first party's product or service meets the claimed standards, enhancing the reliability of the quality assurance signal.

#### 3. Commitment and Bonding

**Commitment Mechanisms**: Assurances between the first and second parties can be seen as commitment mechanisms to ensure adherence to agreements. However, these commitments can be fragile and rely on self-policing.

**Third-Party Constraints**: Third-party assurance introduces external constraints, increasing the costs of breaking commitments. This external oversight encourages compliance and maintains market trust.

#### 4. Avoiding Prisoner's Dilemma

**Cooperation vs. Betrayal**: The prisoner's dilemma in game theory illustrates the choice between cooperation and betrayal. Without third-party assurance, the first and second parties might default to a non-cooperative stance, leading to suboptimal outcomes for both.

**Third-Party Mediation**: Third-party assurance acts as a neutral mediator, facilitating trust and cooperation, thus preventing the pitfalls of the prisoner's dilemma.

#### 5. Repeated Games and Long-Term Relationships

**Long-Term Cooperation**: In the framework of repeated games, the formation of long-term relationships is crucial for sustained cooperation. Third-party assurance supports this by providing a continuous and reliable evaluation mechanism.

**Alignment of Incentives**: Third-party assurance ensures that the interests of the first and second parties are aligned, incentivizing the first party to maintain high standards to retain third-party certification.

In summary, third-party assurance, when viewed through the lens of game theory, serves to reduce information asymmetry, establish credibility, provide external constraints, prevent non-cooperative scenarios, and foster long-term cooperative relationships. These factors collectively underscore the necessity for third-party assurance, supplementing first-party and second-party assurances and offering an additional layer of trust and reliability in the complex landscape of technology and business transactions.
