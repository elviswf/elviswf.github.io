+++
title = 'Safe, responsible and effective use of LLMs'
date = 2024-10-11T22:35:19+08:00
draft = true

tags = ["llm", "agent"]
categories = ["tech"]
+++

This article elaborates on the strengths and limitations of large language models (LLMs) based on publicly available research and our own experiences from working with language models in an industrial context. We consider a diversity of concerns, including unreliable and untrustworthy output, harmful content, cyber security vulnerabilities, intellectual property challenges, environmental and social impacts, and business implications of rapid technology advancements. We discuss how, and to what extent, these risks may be avoided, reduced or controlled, and how to harness language models effectively and responsibly in light of the risks.

## 1. What are (large) language models?

A language model is a probabilistic model for predicting the next word (or token, an even smaller language unit than a word) to appear in a sentence, given a particular context. Such models are trained on a set of example sentences known as a corpus, and are iteratively refined to improve prediction capabilities over time.

Following the success of the transformer architecture \[[\[1\]](#_edn1)\] proposed by Google in 2017 for machine translation, two kinds of transformer sub-architectures were adopted by Google and OpenAI respectively in 2018 to build their own language models. These two language model types are now known as BERT \[[\[2\]](#_edn2)\] (bidirectional encoder representations from transformers) and GPT \[[\[3\]](#_edn3)\]  (generative pre-trained transformer) (see [Figure 1](#figure-p1_ch1_1)).

{{< figure src="/imgs/p1_ch1_1.png" caption="Figure 1: BERT versus GPT models." id="p1_ch1_1">}}

BERT is trained by the task of filling the randomly masked parts in a sentence. Contexts before and after the masked parts are used to recover the missing information. This mimics the human behavior in doing cloze test \[[\[4\]](#_edn4)\]. On the other hand, GPT is trained to autoregressively predict next word/token (see [Figure 2](#figure-p1_ch1_2)). Only the preceding context, which is called the “prompt”, is used to generate the word/token right after, and the generated word/token is then appended to the context for further generation until an end token is received or maximal generation length is reached. The maximal amount of text that the model can handle in a prompt is called the “context window”. This generation paradigm models the human behavior in essay writing.

{{< figure src="/imgs/p1_ch1_2.gif" caption="Figure 2: Illustration of how an autoregressive model, such as a GPT, generates the next word/token." id="p1_ch1_2">}}

Initially, BERT outperformed GPT in various downstream language tasks. However, as models and training data scaled up, GPT’s capabilities excelled while BERT’s performance plateaued. Consequently, today’s dominant language models are based on the GPT architecture, characterized by their unprecedented size. This trend has led to the widespread use of the term “large language model” (LLM). While the initial LLM could only handle text, we now see more multimodal models that can handle images, text and speech as input and/or output.

## 2 How are LLMs used?

Custom training of LLMs is impractical for most companies due to resource costs, expertise demands, and data privacy issues. Instead, leveraging existing models or APIs is a more pragmatic choice. Even companies that have the resources to train their own LLMs will typically use pretrained commercial or open-source models as a basis for their own LLM. LLMs are usually accessed via (public or private) APIs, but smaller models can also be run locally on laptop computers or even mobile devices.

There are two main types of models or APIs:

- Base model/API: This is used to complete text based on a single prompt.
- Chat model/API: Essentially, it performs dialog completion and creates an illusion of interacting with a human through chat. The chat model is fine-tuned from the base model using human-verified high-quality dialogs. This fine-tuning process aligns the model with common human values and preferencesmitigates ethical risks[\[HA6\]](#_msocom_6) . In most cases, the name of the chat model includes terms like “instruct” or “chat” appended to the base model’s name.

While technical details about base APIs and chat APIs are less disclosed by providers, their relationship is believed to mirror that of base models and chat models. Overall, the chat model/API provides a better experience when interacting with actual humans.

![](Safe,%20responsible%20and%20effective%20use%20of%20LLMs_revision1.2_files/image011.png)[\[HA7\]](#_msocom_7) [\[HA8\]](#_msocom_8) 

While LLMs inherently only generate text, they can be set up to interact and make use of other technologies and tools. For example, a language model may be given permissions to trigger certain actions such as executing web searches, querying databases, calling APIs or running code.  The output of such actions can then be fed back into the prompt so that the language model can process it before providing its final response.  The workflow may be predefined and fixed, or the language model may act as an “agent” that decides for itself how and when to make use of tools. One can even have systems of interacting agents that collaborate or compete to achieve some goal. With multimodal models, different capabilities are more directly integrated through common embeddings for different modalities, and such models can make use of different modes of information as needed (e.g., text, images, sound).

Only creativity limits how LLMs may be used, but here are some typical use cases (note that all of these have limitations and associated risks, as discussed further below):

- **Content generation:** LLMs can be used to generate any kind of text, for example stories, poetry, articles and social media content. They may also generate other types of content, like synthetic datasets or code. Multimodal models may even generate images, speech or video.

- **Coding and debugging:** LLMs can help with code suggestions, error detection, generating boilerplate code, as well as automatic generation of documentation and comments for codebases.

- **Content summarization and analysis:** LLMs are able to quickly process large amounts of text and provide summaries. This can for example be used for extracting relevant information from reports, interview or meeting transcripts, medical records or legal documents. LLMs can also be used to detect the sentiments and opinions from texts such as user reviews and social media posts.

- **Translation and adaptation:** LLMs can be used to translate content between languages and styles, and to adapt content to particular settings or contexts. This includes translation of code between programming languages.

- **Information retrieval:**  LLMs can respond to specific queries by leveraging the knowledge contained in its training data and processing information provided in the prompt. Specifically, the LLM may be used to process results obtained from search engines, databases or API calls to enhance information retrieval from external sources.

- **Content checking, moderation and filtering:** LLMs can be used for correcting spelling and grammar, detecting and flagging inappropriate, offensive, or harmful content, for identifying and filtering out spam messages, detecting fraud attempts and so on. They can also be used to check that documents adhere to a set of standards or requirements or fit a prescribed format.

- **Chatbots:** Chatbots are basic conversational interfaces to LLMs that can understand and respond to user inputs in natural language. This is common in customer support to answering common queries about products, services and procedures. Chatbots may also be used to provide counselling or to act as tutors on various subjects, offering explanations, giving hints, pointing out mistakes and making corrections.

- **Copilots:** Copilots are assistants that provides suggestions, complete tasks, or aids users in real-time within a specific application or context. Examples include writing or coding assistants. The LLM used in a copilot may be finetuned and prompted to act in a certain way in a desired role. Copilots often have access to (with certain risks) user’s documents and files in order to provide assistance beyond the LLM’s own ‘knowledge’.

- **Agents:** LLM agents are (more or less) autonomous systems that can perform complex (scheduled) tasks, involving multiple systems and/or datasets. Example use cases can be virtual customer service agents that can (with access to command or APIs) handle complex multi-step transactions, such as booking travel arrangements. Agents go beyond chatbots and copilots in the sense that they also can execute actions based on their own generated content. Agent LLMs are empowered with given access or management privileges to certain system features/functions, such that they can perform automated operations within the system. Depending on the context, the latter introduces risk of harm from the actions the LLM executes.

- **Collaborative AI agents:** Multiple LLM-powered agents can work together to achieve a common goal. An example is a pipelined workflow automation in business environments where different agents perform specific tasks in the process/chain.

The strength of collaborative AI components/agents of LLM comes out of specifically trained (more often fine-tuned) LLMs with each good at one task.

- **Semantic user interfaces:** LLMs can serve as natural language user interfaces to control any kind of software (which in turn may control any kind of hardware). For example, a virtual assistant based on an LLM may be used to perform tasks like setting reminders, providing weather updates, and managing schedules or controlling the lights and other appliances in a home. In industrial settings, LLMs could provide interfaces to control systems, simulators or other software. LLMs can be used as interfaces to other generative AI systems, such as image or video generators.  Multimodal models may serve as combined voice, text and image user interfaces, enabling the user to interact with the AI model in the same way they interact with other humans.

## 3 What are the strengths and limitations of LLMs?

Already in 2016, the first report came of a machine passing the Turing test, which tests whether a human can tell apart a machine from a human when interacting with both via a text-based interface \[[\[5\]](#_edn5)\]. When ChatGPT was released in 2022 \[[\[6\]](#_edn6)\], it astonished the world with its remarkably human-like interactions. Since then, AI generated content has become increasingly hard to recognize. LLMs are performing task today that would have been hard to believe for most people only a few years ago. Amidst the enthusiasm about LLMs and generative AI in the media and in marketing, it is crucial to be critical about the AI capabilities and limitations. The examples being promoted are often cherry-picked, and in reality the LLMs can be inconsistent and unpredictable. This poses challenges for applications in real-world business- and production settings.

This section attempts to explain the inherent limitations and capabilities of current LLMs. Section 4 discusses the risks that emerge from these strengths and weaknesses.

### 3.1 Fluency, grammar and style

LLMs are good at writing text that is fluent and grammatically correct.  They also have a remarkable ability to produce content according to different styles that we ask for. This can be both useful and amusing, but it should not come as a surprise if we consider how language models are trained on large corpuses of data to predict the next token: It is likely that most of the sentences in the training data are grammatically correct, and that most of the words in the training data are spelt correctly. Thus, grammar and spelling are attributes of text that manifest as strong correlations in the training data.  Similarly, style is about the patterns of expression used in different contexts (for example the style is different in complaint letters, birthday speeches, news reports or Shakespeare plays). Programming languages, even more than natural human languages, conform to syntax rules and style conventions, which also manifest as correlations in the training data. LLMs are good at learning such patterns and can therefore be good at suggesting “boilerplate code” for common applications.

The flip side of being good at learning style is that LLMs may acquire a innate tendency  towards styles that are dominant in the training corpus and perpetuate biases that are present in the data it has seen. For example, an LLM trained on a mainly English corpus tend to anglicise text in other languages, and may not work well for contexts or languages that are poorly represented in the training data \[[\[7\]](#_edn7)\]. LLMs may also reinforce gender stereotypes by the examples and words they choose \[[\[8\]](#_edn8)\]. In other words, not all “style” patterns learnt from the training data are desirable.

### 3.2 Knowledge and understanding

LLMs are good at answering questions about “common” factual knowledge. Again, this is maybe not surprising, considering that claims repeated many times in different sources would be picked up as strong correlations by a LLM. LLMs have the advantage of being trained on “the entire internet”, where even topics that are obscure to most individual humans may be common to humanity as a whole.

To the extent that LLMs can “know” anything, the knowledge originates from one of two places:

- **Parametric memory:** When a LLM is trained, its parameters are tuned to take on specific values. During training, the LLM is essentially compressing the training data (including any human feedback). Conversely, generation of responses from prompts is a form of decompression.

- **Context memory:** Prompts provide contextual information that guides the response of the LLM. In addition to queries from humans, prompts can include information received or requested by the LLM from other sources or tools. The input prompt is translated into an embedding vector space and propagated through the layers of the language model which in a way that is determined by the model parameters. This is how the LLM fuses the context memory and parametric memory to produce and output.

There are several issues with both the parametric and context memory of LLMs (and these can only partially be mitigated by coupling to other tools):

- **“Garbage in, garbage out” (GIGO):** Information in the training data or provided in prompts is not necessarily correct, which can cause the LLM to reproduce errors.

- **Hallucination.** This is in part because the compression of the training data by the model is not perfect, but could also be a sign of overfitting to the training data and poor generalization and extrapolation. Ambiguity and lack of context in the prompt may cause the LLM to “misunderstand” or make wrong associations. On top of this, since the LLM generates output token-by-token probabilistically, there is some randomness in the responses, and the model may tend to “prioritize” style and fluency over factual correctness.  The effect of hallucinations is made worse by the LLMs’ tendency to write convincingly, their limited “awareness” of what they don’t “know”, and their limited ability to be self-critical and express uncertainties. It is common for LLMs to be “confidently wrong”. Ways of combating hallucinations are discussed further below.

- **Distractions.** LLMs tend to be distracted by irrelevant information provided in the prompt. LLMs use an attention mechanism to weigh the importance of different parts of the input text and take context into account when generating responses, which can sometimes lead to suboptimal handling of irrelevant details. Distractions in prompts can lead LLMs to generate responses that are inaccurate or irrelevant.

- **Limited context memory.** As one exceeds the context window during a sequence of interactions with a LLM, it will eventually drop and “forget” the earlier parts of the exchange. LLMs typically struggling to effectively account for text located in the middle of the context as opposed to the beginning or the end \[[\[9\]](#_edn9)\]. This limitation can severely influence the model's comprehension and the coherence of the generated content.

- **Lack of domain and cultural knowledge:** LLMs often struggle with domain-specific knowledge deficits, particularly in emerging fields, due to limited training data coverage and insufficiently diverse pre-training datasets. Similarly, they also lack knowledge of languages and cultures that are poorly represented in the training data.

- **Outdated knowledge:** An LLM only knows what was in the training data at the time it was trained, and any more recent information need to be provided through the prompt (for example by calling APIs).

- **Unstructured knowledge:** It is a topic of debate whether LLMs effectively learn a “world model”. What is clear is that their knowledge is implicitly encoded in the neural net weights, as opposed to being structured in the form of a database, ontology or knowledge graph. In some sense, the knowledge of a LLM is tacit rather than explicit, and therefore not transparent. (Despite this, LLMs can interface with structured knowledge representations to help retrieval of information.)

- **Lack of quality data:** Today’s leading LLMs are trained on “the entire internet” and other large corpuses of data. They rely on the data containing meaningful correlations. However, given that LLMs have accelerated the speed of content production, there is a fear that the internet may be swamped with AI generated data, which may contain errors and biases. New models may then be trained on such “polluted data. There is evidence that this can lead to “model collapse”, where the performance of a model declines at it is trained on its own output \[[\[10\]](#_edn10)\].

- **Tokenization:** The way text is divided into tokens influences the internal representation of knowledge in the LLM. This can influence performance on downstream tasks, and the tokenization optimal for one language may not work well for another \[[\[11\]](#_edn11)\].


### 3.3 Guessing versus reasoning
---------------------------------

There are many benchmarks measuring the performance of LLMs on standardised test or puzzles reporting human like performance (e.g., \[[\[12\]](#_edn12)\]). The OpenAi CTO, Mira Murati, even stated in June 2024 that “GPT-3 was toddler-level, GPT-4 was a smart high schooler and the next gen, to be released in a year and a half, will be PhD-level” \[[\[13\]](#_edn13)\]. However, such benchmarks and claims are questionable. One reason for the apparent high achievement of some LLMs on problem solving benchmarks is that they are actually just retrieving information. There is a lot of information on the internet, including pages containing answers to standardised test and puzzles. On top of that, because they have seen many examples and patterns of reasoning, they are good at “guessing” the answer.  The challenge is that we do not know when the LLM is using patterns in style or patterns in meaning. For example, when presenting an LLM with a common puzzle with a slight twist, the LLM may answer based on the pattern of answers it has seen rather than picking up the crucial detail that changes the solution  \[[\[14\]](#_edn14)\]. (We experienced this when asking GPT-4 about variations of the Monty Hall problem.)

The psychology professor Daniel Khaneman introduced the concept that human brains have a “System 1” and a “System 2” mode \[[\[15\]](#_edn15)\]. System 1 is fast and automatic/ unconscious, but also emotional and stereotypical. On the contrary, system 2 is slow and requires conscious effort and logical reasoning. Professor Subbarao Kambhampati advocates that LLMs are akin to an external System 1, and that we should be content with that and not expect them to have System 2 capabilities \[14\].  In another paper, Kambhampati and coauthors conclude that the claimed improvement in reasoning achieved by LLMs with Chain of Thoughts (CoT) prompting “…do not stem from the model learning general algorithmic procedures via demonstrations but depend on carefully engineering highly problem specific prompts” \[[\[16\]](#_edn16)\]. As a consequence, the improvements co me at the cost of human labour. They have also devised a benchmark where leading LLMs still perform very low (0-36%) on planning tasks even when using CoT. Similar conclusions were reached in a study that included over 1,000 experiments, which according to the authors provided compelling evidence that emergent abilities of LLMs can primarily be ascribed to in-context learning (i.e. that it was related to clever rompting) \[[\[17\]](#_edn17)\]. 

Symbolic reasoning and computations are areas where computers outperformed humans decades ago, yet today’s state-of-the-art LLMs struggle with simple problems. This is not strange, give that today’s LLMs are feed-forward neural nets without the ability of recursion or adaptation, and they use the same computational resources for problems irrespective of their computational complexity. Hybrid systems that exploit capabilities of symbolic manipulation and computation may have the ability to bridge the step to “system 2” level intelligence. For example, DeepMind announced in January 2024 that Alpha Geometry achieved mathematics Olympiad performance on geometry problems \[[\[18\]](#_edn18)\] but note that it in reality only using a language model to interface with a symbolic engine and not doing the heavy symbolic reasoning itself (as pointed out by Hector Zenil \[[\[19\]](#_edn19)\]).  

It has been found that when LLMs are asked to criticize themselves, they may actually perform worse \[[\[20\]](#_edn20)\]. A possible explanation for this is that LLMs tend to wrongly identify correct claims as errors while overlooking real errors, such that errors accumulate with iterations .

In the end, does it matter whether LLMs are really reasoning, or simply very good at retrieving information and guessing? That depends on the use case, and on how easy it is to check the LLM answers and detect its errors. In many cases guessing and checking (trial and error) is an efficient strategy to search for solutions, but it seems that language models should onlyy be relied on for the guessing part. For the checking part, one should not rely on LLMs. Adding humans in the loop or coupling LLMs to external tools such as reasoning engines can help to some extent.  

## 4 What are the risks associated with language models?

Like any technology, LLMs can have both wanted and unwanted consequences. Some consequences are predictable and well understood, while others are unpredictable and poorly understood. This space of consequences and associated uncertainty constitute the risks related to the technology (including opportunities, i.e. "positive risk"). Risk management is the effort to reduce uncertainty and control consequences to maximise benefits and minimise harms.

To be able to manage LLM risks, we need to understand the LLMs’ capabilities and limitations. However, we also need to examine how they are developed, used and managed. We must be able to trust that the interests of various stakeholders are safeguarded by the LLMs and those who develop, manage and provide services based on them.

The consequences of an LLM’s capabilities and limitations depends on how it is used. There range of concerns and possible impacts are very different if, for example, journalists use the LLM to suggest news headlines, if a company employs an LLM chatbot to talk to their customers, if an employer uses LLMs to screen job applications, if a doctor use LLMs to summarize health records, or if the police uses an LLM to summarize interrogation and match information to other sources. For some applications the main concern may be to avoid misinformation, while other applications bring concerns about privacy, concerns about harmful content, and so on. Therefore, the risk related to LLMs must always be evaluated in context.

Beyond the possible failures and unanticipated side effects of using LLMs for benign and legitimate purposes, there are also the possibilities of misuse, for example to cheat on exams, commit fraud, produce fake news, and so on. These risks of adversarial uses grow as the capabilities of the models improve.

The subsections below discuss some selected risk categories relevant to language model use and development, specifically in the context of industry and business.

### 4.1 Unreliable, untrustworthy or harmful output

Maybe the most obvious risk related to language models relate to their output. The consequences depend on what the output is used for, including an LLM agent’s level of autonomy, system privileges and access to tools.

The risks from use of language model output stem from their strengths as much as their weaknesses and may from both good and bad intentions.  On the one hand, a well-articulated but hallucinating LLM may lead us to make suboptimal or bad choices based on wrong or inaccurate information. On the other hand, adversaries may use LLMs to intentionally fool and manipulate us. On top of that, even if the content generated by an LLM is correct, it may be harmful. For example, an LLM may provide information about making bombs, performing crimes, committing suicide and so on. Furthermore, biases that are perpetuated and reinforced by the LLM could also lead to societal or individual harm, for example by contributing to discrimination and unfair treatment.Large Language Models (LLMs) like GPT-4 are powerful tools capable of generating human-like text based on the input they receive. However, a notable risk associated with their use is the phenomenon of hallucination. In this context, hallucination refers to instances where an LLM generates content that is factually incorrect, misleading, or entirely fabricated. These inaccuracies can be subtle or blatantly incorrect, and when such erroneous outputs are used as the basis for subsequent decisions, actions, or processes, they can lead to significant errors or even pose high risks.

Methods exist to control the behaviour of LLMs to improve the trustworthiness of responses and reduce harm, as discussed in the subsections below[\[HA9\]](#_msocom_9) . However, even using these approaches to control LLM output, the probabilistic nature of LLMs can make them behave in unpredictable ways. In an industrial setting, it may not be tolerable if a task is performed correctly/adequately only 80% of the time, and LLM based applications may be too unreliable for production settings.

#### 4.1.1 Nature of Hallucinations

Hallucinations in LLMs occur because these models are trained on vast amounts of data from the internet, books, and other sources, encompassing both factual and non-factual information. They generate responses based on patterns and probabilities rather than understanding or verifying the truth. As a result, LLMs can confidently produce information that appears credible but is inaccurate or false. For instance, an LLM might:

- Fabricate statistics or data points.
- Misrepresent facts, events, or figures.
- Generate plausible-sounding but entirely made-up information.

These hallucinations are often delivered with high fluency and coherence, which can make it challenging for users to discern fact from fiction.

#### 4.1.2 Consequences of Hallucinations

Maybe the most obvious risk related to language models relate to their output. The consequences depend on what the output is used for, including an LLM agent’s level of autonomy, system privileges and access to tools.

The risks from use of language model output stem from their strengths as much as their weaknesses and may from both good and bad intentions.  On the one hand, a well-articulated but hallucinating LLM may lead us to make suboptimal or bad choices based on wrong or inaccurate information. On the other hand, adversaries may use LLMs to intentionally fool and manipulate us. On top of that, even if the content generated by an LLM is correct, it may be harmful. For example, an LLM may provide information about making bombs, performing crimes, committing suicide and so on. Furthermore, biases that are perpetuated and reinforced by the LLM could also lead to societal or individual harm, for example by contributing to discrimination and unfair treatment.

#### 4.1.3 Amplification of LLM output errors

_These hallucinations (Maynez et al., 2020) are particularly problematic in domains that require multi-step reasoning, since a single logical error is enough to derail a much larger solution._

The risk is further amplified when LLMs are integrated into processes where their output is used as input for other automated systems. In such cases, a hallucination at one step can propagate through the system, causing compounding errors. For example, if an LLM is used to generate a report that feeds into an automated decision-making system, an error in the report could lead to incorrect decisions being made without human oversight.

When LLMs are used in workflows that rely on their outputs for decision-making, planning, or execution, hallucinations can have a cascading effect, leading to errors in downstream processes.

#### 4.1.4 The Challenge of hallucination detection

Detecting hallucinations can be particularly challenging because LLMs can generate responses that are highly plausible. Users may not have the expertise or resources to verify every piece of information provided by the model, especially in real-time applications. This increases the risk that hallucinated content will go unnoticed until it has already influenced critical processes.


### 4.2 Cyber security risks

LLMs can be targets of cyber attacks, but also provide a powerful tool attackers and defenders. All these three perspectives are discussed below, and have implications for how we think about cybersecurity in the age of LLMs.

#### 4.2.1 LLMs as targets[\[AB23\]](#_msocom_23) 

As the adoption of Large Language Models (LLMs) continues to rise in various applications, the spectrum of associated cybersecurity risks is also expanding. To mitigate these risks effectively, a systematic approach for identifying and addressing potential vulnerabilities is crucial. Each vulnerability presents unique challenges that require targeted mitigation strategies to ensure the secure deployment and operation of LLMs across different applications. The following list outlines some potential vulnerabilities, although it is not exhaustive \[[\[42\]](#_edn42)\]:

- **Prompt Injection**: Malicious inputs can manipulate LLMs to perform unintended actions or expose sensitive information, including jailbreaking prompts to circumvent moderation and alignment of LLMs.. The issue is essentially that LLMs do not separate the code (i.e., the system prompts) from the data (i.e., user prompts), which means that any instructions can in principle be overridden by a clever user. There exist both white-box and black-box methods that can be used to automatically find prompts that can jailbreak an LLM and make it do essentially anything you want \[[\[43\]](#_edn43),[\[44\]](#_edn44),[\[45\]](#_edn45)\]. This include making it always respond with the termination token (i.e. block any response) or generate very long/infinite responses (i.e., potentially spending excessive computational resources).

- **Insecure Output Handling**: Inadequate validation and sanitization of LLM outputs can lead to security vulnerabilities like remote code execution.

- **Training Data Poisoning**: Malicious alteration of training data can introduce biases, backdoors, or compromise the integrity and functionality of LLMs.

- **Model Denial of Service**: Exploiting the resource-intensive nature of LLMs by overwhelming the system with resource-heavy tasks can cause service degradation.

- **Supply Chain Vulnerabilities**: Dependencies on third-party data, models, and infrastructure can introduce vulnerabilities if these components are compromised.

- **Sensitive Information Disclosure**: LLMs may inadvertently leak confidential information embedded in their training data or through their interactions. It is also possible to tease out information from system prompts that the model provider did not intend the user to see, which in turn may be used to design new attack strategies. In some cases only an embedding vector is exchanged with the model, but this does not ensure privacy,  as there exists methods for reproducing prompts by embedding inversion \[[\[46\]](#_edn46)\].

- **Insecure Plugin Design**: Security flaws in plugin designs can lead to unauthorized actions or data exposure.

- **Excessive Agency**: Granting excessive permissions or functionality to LLMs can result in unintended or unauthorized actions.

- **Overreliance**: Overreliance on LLMs without adequate oversight can lead to misinformation and misjudgments based on incorrect outputs.

- **Model Theft**: Unauthorized access and theft of proprietary LLM models can result in economic losses and competitive disadvantages.

To address these risks effectively, organizations must implement robust security measures, including secure development practices, access controls, input validation, output sanitization, and continuous monitoring and auditing of LLM systems.

#### 4.2.2 LLMs as attackers[\[AB24\]](#_msocom_24) 

LLMs possess the capability to automate sophisticated "hands-on-keyboard" cyber-attacks, transforming the dynamics of cyber warfare \[[\[47\]](#_edn47)\]. By leveraging the high-level natural language understanding and processing abilities of models like GPT-4, attackers can automate the complete cycle of a cyber attack, including post-breach activities traditionally requiring human intervention. This includes running shell commands, controlling network operations, or manipulating system processes across diverse operating systems like Windows and Linux. LLM-based systems can utilize a modular agent architecture that integrates summarizing, planning, navigating, and retrieving past attack experiences to optimize attack strategies. This not only increases the speed and scale of attacks but also allows attackers to execute complex, contingent attack sequences with minimal human input. The automation of such tasks can significantly reduce the cost and increase the frequency of cyber-attacks, posing serious challenges to current cybersecurity defenses which are mostly designed to counter human-led operations. This evolution marks a pivotal shift in security dynamics, emphasizing an urgent need for developing more advanced, AI-integrated defense mechanisms that can anticipate and counteract these automated threats.

#### 4.2.3 LLMs as defenders[\[AB25\]](#_msocom_25) 

The rapid proliferation of cyber threats in the digital age demands innovative solutions, and Large Language Models (LLMs) are at the forefront of this technological evolution, offering a new paradigm in cybersecurity.While LLMs introduce new vulnerabilities and can be used for cyber attacks, they may also be used to defend against cyber attacks \[[\[48\]](#_edn48),[\[49\]](#_edn49)\]. These modelLLMs can significantly enhance threat detection and response capabilities by automating the analysis of vast amounts of data in real time. For instance, LLMs can identify subtle patterns and anomalies indicative of cyber attacks, such as malware distribution, phishing attempts, and unauthorized intrusions, enabling faster and more accurate threat identification. Furthermore, these models support the automation of routine cybersecurity tasks such as patch management, vulnerability assessments, and compliance checks, which alleviates the burden on cybersecurity teams and allows them to focus on more complex challenges. Additionally, LLMs can improve incident response by providing rapid analysis and suggesting appropriate mitigation strategies, thus shortening the time to respond to threats and potentially reducing the impact of breaches. The versatility of LLMs extends to enhancing the capabilities of cybersecurity chatbots, which can offer real-time assistance, incident reporting, and user interaction, further integrating AI into the daily operations of cybersecurity frameworks.

### 4.3 Intellectual property and data privacy challenges

There are several intellectual property (IP) and data privacy challenges related to LLMs. Firstly, LLMs are typically trained on vast amounts of data sourced from various providers. Ensuring that data is used legally and ethically involves:

- **Licensing Agreements**: Formal agreements with data providers specifying the scope and terms of data usage.

- **Compliance:** Adhering to legal requirements and ensuring that the data usage aligns with the terms set by the providers.

- **Transparency**: Maintaining transparency in how data is sourced and used to build trust and avoid legal disputes.

- **Authorship**: Determining whether the outputs of LLMs can be considered original works and who holds the rights to these creations. This involves proper citation of sources to avoid plagiarism.

Companies need to carefully evaluate commercial use of LLM-generated content, especially when it is derived from data with specific licensing agreements. The evolving legal landscape around AI-generated content, which may vary across jurisdictions, needs to be closely monitored.

Another issue is the protection of data privacy, during both the training and use of LLMs. Federated learning (FL) is a technique that enables training models across decentralized devices or servers holding local data samples without exchanging them. FL allows different actors to collaboratively train models without sharing proprietary data, thereby preserving IP rights. This has also been applied to training LLMs, however researchers have shown that FL on text is vulnerable to attacks \[[\[50\]](#_edn50)\]. Data can also leak during use of LLMs. One thing is the leak of sensitive information from the training data. Another is the leak of sensitive information from system prompts that are supposed to be secret, for example though jailbreaks. Even if only the embedding vectors of user prompts are sent to a model, there exist the possibility that the prompt may be reconstructed using embedding inversion techniques \[ref46\]. Differential privacy is a way to add noise to training data or embedding vectors to protect privacy and give probabilistic guarantees on data leaks \[[\[51\]](#_edn51)ref\].

The IP challenges related to LLMs are multifaceted and require careful consideration of legal, ethical, and technical aspects. Collaboration among stakeholders, including data providers, AI developers, and legal experts, is crucial to navigate these challenges effectively and ensure the responsible development and deployment of LLMs.

### 4.4 Environmental and social impacts

Specifically, the training and running of language models consumes resources, including data, labour, land, energy and water:

- **Data**: Of course, the performance of language models depend on the quality of the data it was trained on, including any biases, knowledge gaps or erroneous information it contains. On top of that, there are concerns about copyright infringement and respect of data owners' interests. Data sources may also contain sensitive information that could potentially leak out of models trained on it. 

- **Labour**: Humans are needed for the curation of data, data labelling, and evaluation of model output to fine-tune model behaviour and moderate unwanted responses. This has raised concerns about working conditions for people involved, including the workload, pay, and possible exposure to traumatic material. In addition, as language models automate certain tasks that previously depended on more human effort, there may also be consequences for the workforce in other industries, including journalism. With voice enabled models, there is also the possibility of generating or even cloning voices, with implications for voice actors.

- **Land**: The increasing computational demands for training and running large language models requires more data centers that consume space. The construction of data centers may impact local biodiversity and have other environmental impacts.

- **Energy**: The running of data centers used for training and hosting language models consumes large amounts of energy. Energy from fossil fuels may have an impact on the climate. More generally, energy production consumes land areas, and the increased energy demands from data centers can put pressure on the electricity markets and increase prices for consumers and other industries.

- **Water**: The cooling of data centers is typically done with water, which is already a scarce resource in many locations.

Viewed in isolation, these mentioned aspects of resource use may appear negative for society. However, the net impact depends on what the language models are used for and how they replace other technologies and activities that also have an environmental and social footprint. Moreover, the impacts are expected to change over time as technologies develops and technology adoption evolves.

## 5 Mitigating risks associated with language models

As these powerful tools become embedded in various sectors, from healthcare to finance, understanding and mitigating the associated risks becomes not just a technical necessity but an ethical imperative. This discourse will delve into the foundational aspects of managing these risks, starting with the operations specific to LLM management and evolving through the various intricacies that come with their advanced use.

### 5.1 Preference optimization and fine tuning to tune model behaviour

Many approaches are used to modify LLM behaviour, such as reducing harmful output, teaching the model to produce output in a certain format or style.

- **Reinforcement Learning with Human Feedback (RLHF)**: RLHF is a method where human feedback is used to train large language models (LLMs). By incorporating human judgments about the quality of the model's outputs, RLHF aims to fine-tune the model to align better with user preferences. This technique leverages reinforcement learning algorithms to optimize the model's performance based on the provided feedback.

- **Proximal Policy Optimization (PPO)**: PPO is a reinforcement learning algorithm that is commonly used in the context of RLHF. PPO strikes a balance between exploration and exploitation by using a clipped objective function to ensure that updates to the policy do not deviate excessively from the current policy. This helps in maintaining stable training and improving the performance of LLMs when fine-tuning them based on human feedback.

- **Direct Preference Optimization (DPO)**: DPO is another technique for optimizing LLMs directly based on user preferences. Unlike RLHF, which may involve indirect measures of performance, DPO focuses on directly optimizing the model to produce outputs that align with explicit user preferences. This method can be particularly effective when precise preference data is available, allowing for more targeted fine-tuning of the model.

- **Supervised Fine-Tuning (SFT)**: SFT involves training LLMs on labeled datasets where the desired outputs are known. This method uses supervised learning techniques to adjust the model's parameters to improve its performance on specific tasks or domains. SFT is often used as an initial step before applying more advanced techniques like RLHF, providing a solid foundation for further optimization.

In a comprehensive study, PPO surpassed other alignment methods in all cases and achieve state-of-the-art results in challenging code competitions \[[\[53\]](#_edn53)\], while others claim that there exist more efficient methods \[[\[54\]](#_edn54)\]. However, other research has shown that incorporating safety mechanisms through preference optimization and fine-tuning of LLMs can impact their general performance \[[\[55\]](#_edn55)\].

Unfortunately, preference optimization and fine tuning are not bullet-proof techniques for avoiding harmful output, as there are jailbreaks to make override how the model has been trained to behave (see section 4.2.1). One simple attack method that often works is to give unsafe prompts in a language that is different from the main language the model has been trained on \[[\[56\]](#_edn56)\]. Multilingual LLM safety is therefore an ongoing challenge that is drawing researchers’ attention (see e.g. \[[\[57\]](#_edn57)\]).

### 5.2 Giving the LLM new knowledge and capabilities

Recent advances in hardware and algorithms have expanded the context lengths that models can handle, leading to questions about the need for retrieval systems. For example, recent advancements allow LLMs to process extensive inputs, as seen in models like Gemini 1.5, capable of handling up to 2 million tokens, and Claude 3, with a capacity of 200,000 tokens. However, LLMs tend to underutilize long-range context and see declining performance as context length increases, especially when relevant information is embedded within a lengthy context. Moreover, practically, the use of long contexts is expensive and slow. This suggests that selecting the most relevant information for knowledge-intensive tasks is crucial. There are many ways an LLM can augment its knowledge and enhance efficiency in handling knowledge-intensive tasks. Here are some examples:

- **Parameter-Efficient Fine-tuning** optimizes large language models by updating only a small subset of parameters, reducing computational costs while preserving model performance. For example, in traditional fine-tuning, the entire model is retrained, which is resource-intensive, especially for large models with billions of parameters. LoRA (Low-Rank Adaptation) addresses this issue by freezing the pre-trained model weights and introducing low-rank matrices that adapt only certain parts of the model during training. This method is particularly useful for applications where multiple tasks require fine-tuning, as it enables fine-tuning large models on specific tasks without needing to retrain or store the entire model for each task, offering both scalability and flexibility.

- **In-context learning:** This involves providing examples of the desired task directly in the prompt, allowing the model to infer how to perform the task based on these examples. For example, if you provide an LLM with several examples of question-answer pairs, it will use those examples as "context" to generate answers for new questions.

- **Knowledge editing:** This involves making targeted adjustments to a model's stored information or parameters to correct errors or update its knowledge base without retraining the entire model \[[\[58\]](#_edn58)\]. This process is crucial for maintaining the accuracy and relevance of LLMs as new information becomes available or inaccuracies in their outputs are identified. Techniques for knowledge editing include directly modifying specific model parameters (i.e., ROME and T-Patcher), using crafted prompts to influence outputs (i.e., MemPrompt, MeLLo, and IKE), conducting limited fine-tuning with new data, or integrating external modules that can override the model's responses (i.e., GRACE). This capability allows LLMs to be adapted swiftly to new data or corrections, ensuring they remain useful and reliable in various applications.

- **Knowledge localization**: This refers to the process of identifying specific components within a model that are responsible for storing and processing particular pieces of information or knowledge. This task is crucial for targeted knowledge editing, as it allows researchers and engineers to pinpoint where certain facts or data are encoded within the model's complex network of parameters. By effectively localizing knowledge, modifications can be made precisely and efficiently, without necessitating a complete retraining of the model. Techniques used in knowledge localization often involve analysis methods such as probing tasks, where auxiliary models are trained to predict properties based on model representations, or feature attribution methods, which help trace the model's decision-making pathways back to specific neurons or layers. This enables a deeper understanding of how information is structured within the model and facilitates targeted interventions to update or correct the model's knowledge base.

- **Tool use:** This approach involves giving LLMs access to external tools such as calculators, symbolic engines, web search, simulators, etc. By integrating these tools, LLMs can handle a broader range of tasks more accurately and efficiently. The tools may be verified by humans, and it is also possible to trace how the LLM uses the tools (i.e., the input and output to the tool) so that results may be verified and validated.

- **Structured output:** OpenAI has introduced the option of structured output in their API, allowing one to specify a desired JSON schemas for the output that the model reliably adheres to. This capability is very useful for integrating LLMs with tools and as part of automated workflows where different components and systems need to exchange information reliably.

- **Retrieval Augmented Generation (RAG)** presents an alternative method to fine tuning that retrieves relevant information from external knowledge sources. It then uses the retrieved information to augment the input prompts to give the LLM context/reference that it can use to generate its answer.

#### 5.2.1 RAG with Vector

Most RAG tools rely on data stored in a vector database (i.e. databases that store embedding vectors for chunks of text) and relevant information is retrieved based on vector similarity. This capability to add knowledge sources without retraining the LLM significantly lowers data requirements and enhances flexibility. A limitation is that RAG bases retrieval on vector similarity between sequential chunks of text, but the answers to a query may not lie within a single chunk but require an overview of the totality of a document. Research in these areas suggests that RAG is useful for integrating new knowledge while fine-tuning can be used to improve model performance and efficiency through improving internal knowledge, output format, and teaching complex instruction following \[59\] (but keep in mind the limitations of finetuning discussed in section 5.1.1). Exploring the combination of the above-mentioned approaches is a promising path to maximizing the advantages of each approach.

Figure 3 presents a typical RAG application workflow: 

- **Input**: The question to which the LLM system responds is referred to as the input. If no RAG is used, the LLM is directly used to respond to the question.

- **Indexing**: If RAG is used, then a series of related documents are indexed by chunking them first, generating embeddings of the chunks, and indexing them into a vector database. Most RAG approaches use vector similarity as the search technique, while RAG with Graph uses knowledge graphs to provide substantial improvements in question-and-answer performance when reasoning about complex information. A knowledge graph is an advanced data structure that represents information in a network of interlinked entities.

- **Retrieval**: The relevant documents are obtained by comparing the query against the indexed vectors, also denoted as "Relevant Documents".

- **Generation**: The relevant documents are combined with the original prompt as additional context. The combined text and prompt are then passed to the model for response generation which is then prepared as the final output of the system to the user.

{{< figure src="/imgs/p1_ch5_2_1.png" caption="Figure 3: Retrieval augmented generation using vector database and knowledge graph." id="p1_ch5_2_1">}}

#### 5.2.2 RAG with Graph

As illustrated in Figure 3, the RAG with a Graph pattern is similar to the RAG with a Vector Database but incorporates a knowledge graph during the indexing phase. For example, GraphRAG \[[\[59\]](#_edn59)\], a library developed by Microsoft Research, employs a retrieval path that includes a knowledge graph. This method extends RAG by incorporating structured knowledge from knowledge graphs. By leveraging graph-based data structures, Graph RAG can provide more precise and contextually relevant information, improving the model's ability to generate accurate and coherent responses. Traditional RAG techniques often struggle to maintain and comprehend the entities and relationships among documents. They perform poorly when tasked with holistically understanding summarized semantic concepts over a large data collection. GraphRAG addresses this gap by integrating a knowledge graph to enhance the understanding of semantic relationships.[\[LE28\]](#_msocom_28) [\[HA29\]](#_msocom_29)  GraphRAG can overcome the above-mentioned limitation of RAG by making a knowledge graph out of a document or database to capture relevant relationships that can help it answer questions that cannot be answered based on a single vector similarity search against separate chunks of data.

However, GraphRAG also has its limitations. First, the cost of implementation in real production environments is extremely high. Second, updating or deleting nodes within the knowledge graph can be challenging. In addition, \[[\[60\]](#_edn60)\] [\[LZ30\]](#_msocom_30) compared the RAG with the GraphRAG in four different metrics: Comprehensiveness, Diversity, Empowerment, Directness. In short, by introducing more information through graph connection, the comprehensiveness and diversity of the data are improved, but the absence of a filtering mechanism for this additional information leads to a decrease in empowerment and directness.

#### 5.2.3 Hybrid RAG

Recently, Researchers from BlackRock, Inc., and NVIDIA introduced a novel approach known as HybridRAG \[61\]. This method integrates the strengths of both RAG with Vector and RAG with Knowledge Graph to create a more robust system for extracting information from financial documents. HybridRAG operates through a sophisticated two-tiered approach. Initially, RAG with Vector retrieves context based on textual similarity, which involves dividing documents into smaller chunks and converting them into vector embeddings stored in a vector database. The system then performs a similarity search within this database to identify and rank the most relevant chunks. Simultaneously, RAG with Knowledge Graph is to extract structured information, representing entities and their relationships within the financial documents. By merging these two contexts, HybridRAG ensures that the language model generates contextually accurate responses and rich in detail.

> Potential Disadvantages of GraphRAG
> - Knowledge Graph Construction Complexity: Building a comprehensive and accurate knowledge graph can be a complex and time-consuming process, requiring sophisticated entity extraction and relationship modeling techniques.
> - Dependency on Underlying Data: The quality and coverage of the knowledge graph are heavily dependent on the input data sources. If the underlying data is incomplete or biased, it can limit the effectiveness of GraphRAG.
> - Scalability Challenges: As the knowledge graph grows in size and complexity, the computational resources required for efficient retrieval and reasoning may become a challenge, especially for real-time applications.


{{< figure src="/imgs/p1_ch5_2_3.png" caption="Figure 5 Hybrid RAG: integrating Knowledge Graphs and Vector library" id="p1_ch5_2_3">}}

### 5.3 Guardrails

LLM guardrails are mechanisms designed to ensure that the outputs of LLMs align with desired safety, ethical, and accuracy standards \[[\[61\]](#_edn61),[\[62\]](#_edn62)\]. They can be implemented at different stages of the model's lifecycle, including during training, inference, and post-processing.

Guardrails can be implemented in multiple ways:

- **Preambles to Prompts**: One method to guide LLM behavior is by adding preambles or specific instructions to prompts. These preambles can set the context, specify rules, or outline ethical considerations that the LLM should follow when generating responses. For example, a preamble might instruct the LLM to avoid generating content that could be harmful, offensive, or misleading.

- **Workflow with Multiple LLMs**: Another approach involves using several LLMs in a workflow. Different models can be specialized for various tasks, such as content generation, ethical review, and factual verification. By combining these models, organizations can create a robust system where one model generates content, another checks for adherence to ethical guidelines, and a third verifies the accuracy of the information.

- **Rule-based Systems**: In addition to prompt engineering, rule-based systems can be used to filter and modify outputs. These systems can flag or alter responses that do not comply with predefined rules. This method ensures that any potentially harmful or inappropriate content is caught and corrected before reaching the end user.

- **Human-in-the-Loop**: Incorporating human oversight is another critical guardrail. Human reviewers can monitor and evaluate the outputs of LLMs, providing an additional layer of scrutiny. This hybrid approach leverages the efficiency of LLMs with the nuanced judgment of human reviewers to ensure high-quality and safe outputs.

- **Monitoring and Feedback Loops**: Continuous monitoring and feedback loops are essential to keep LLMs aligned with desired behaviors. By analyzing the performance and outputs of LLMs over time, developers can identify areas for improvement and adjust the guardrails accordingly. This ongoing process helps maintain the effectiveness of the guardrails in dynamic environments. By incorporating these guardrails, developers can enhance the reliability, safety, and fairness of LLMs, making them more suitable for real-world applications.

While no individual guardrail is perfect, adding several layers of guardrails can significantly reduce the probability of unwanted LLM output. This is because an attack that successfully bypasses one guardrail would also need to bypass the other guardrails (which may require an entirely different approach). 

### 5.4 Uncertainty quantification

There are several reasons why one would like LLMs to know what they don’t know and express how confident they are. Information about uncertainty can help users judge how much they should trust the LLM. Statements about uncertainty can add transparency to decision processes, sometimes demanded by regulations. Furthermore, understanding uncertainty is crucial for addressing issues such as hallucinations, where LLMs generate plausible sounding but factually incorrect outputs. Expression of uncertainty may also be used to filter LLM answers and only return responses scoring above some confidence threshold.

Uncertainty quantification in neural networks has always been a challenging task, particularly in the context of natural language processing, where it has traditionally been applied to classification tasks. However, with the advent of LLMs, there is an increased focus on uncertainty quantification in generation tasks, where the model must generate coherent and contextually relevant text rather than simply classify an input into some predefined categories.

Uncertainty can be elicited from an LLM in different ways. One approach is to let the LLM explicitly verbalise its judgement of uncertainty. This requires prompt engineering to teach the LLM how to express uncertainty. A problem with this approach is that the LLM may hallucinate in its responses about uncertainty, and one may ask how uncertain it is about its uncertainty, and so on. A second approach is to use the log-likelihood from the LLM output layer to judge confidence in answers. However, this can be unreliable simply because there are many different ways to answer a question correctly. A third approach is to send the same prompt several times to the LLM and to classify the responses and quantify uncertainty based on the frequency of answer categories. A concern with this approach is whether the obtained uncertainty quantification is calibrated to the underlying data. An important challenge here is differentiating between token-level uncertainty, which considers the model’s confidence in predicting each word, and sequence-level uncertainty, which assesses the confidence in the entire generated text. While most UQ studies focus on the former, the latter remains more complex due to the vast output space and potential for diverse and valid responses.

There is a difference between closed questions that have a truth value, versus open-ended questions that have complex or ambiguous truth values. Closed questions lend themselves more easily to uncertainty quantification because the model can be trained to recognize correct and incorrect answers explicitly. For open-ended questions, uncertainty quantification becomes more challenging due to the subjective nature of the responses.

Recent research work on uncertainty quantification for LLMs tries to distinguish between uncertainty and confidence \[[\[63\]](#_edn63)\]. Uncertainty relates to the model’s ambiguity or the spread of potential predictions, while confidence pertains to the model’s belief in a specific prediction. These concepts are further nuanced by distinguishing between epistemic and aleatoric uncertainty. Epistemic uncertainty arises from the model’s lack of knowledge and can often be reduced with more data and better training, whereas aleatoric uncertainty is due to the inherent variability or noise in the task and cannot be reduced by improving the model \[[\[64\]](#_edn64), [\[65\]](#_edn65)\].

Irrespective of the approach used, an expression of uncertainty is not helpful unless it is rooted in reality, which requires some effort for ensuring calibration. Some methods for uncertainty quantification and calibration for LLMs include:

- **Introspection**: This involves the LLM assessing its own confidence in the generated responses, often requiring specialized training or fine-tuning to improve self-assessment capabilities. For example a model may be fine-tuned on a dataset that includes information about uncertainty, such as labels indicating the confidence level of each answer \[[\[66\]](#_edn66)\]. However, this may be difficult for open-ended questions. This technique may be less effective for open-ended questions or tasks without clear ground truth, requiring careful calibration to avoid overconfidence.

- **Model-based oversight:** This technique uses a secondary model to oversee the primary model's outputs and provide a confidence score. The oversight model can be trained on labeled data to recognize patterns associated with high or low confidence. This approach aligns with the supervised methods, such as white-box, grey-box, and black-box supervised uncertainty estimation, where different levels of access to the model’s internal states are used to construct features for the oversight model.

- **Mechanistic interpretability:** This approach aims to understand the internal workings of the LLMs \[[\[67\]](#_edn67)\].. By interpreting the mechanisms of how the model generates answers, one can infer the confidence level of specific responses. Some have hypothesized that LLMs contain special entropy neurons that can be probed for uncertainty \[[\[68\]](#_edn68)\]. However, not all uncertainty quantification methods rely on access to the LLM’s internals, some operate purely on the generated text, making them more applicable in settings where the model’s architecture or parameters are inaccessible.

- **Cheat correction:** This approach teaches models to cheat by training it on pairs of independent responses from different experts. It is then allowed to cheat by observing one of the responses to predict the second response, and the idea is that the model only need to cheat when there is something I doesn’t know \[[\[69\]](#_edn69)\].

- **Calibration techniques and Conformal Prediction**: Methods like temperature scaling adjust the predicted probabilities to better match actual likelihoods, improving model reliability. Conformal prediction provides a robust framework to ensure that the true output falls within a predicted set at a specified confidence level \[[\[70\]](#_edn70)\].

- **Unsupervised approaches**: They involve analysing the distribution of the LLM’s output probabilities (entropy) or the semantic similarity between multiple generated reponses. High entropy or low semantic similarity across outputs indicates high uncertainty. This is particularly useful in black-box settings, where access to the model’s internals is limited, and only generated text can be analyzed.

Despite much research into LLM uncertainty quantification and calibration, researchers have shown that LLM uncertainty is fragile, and that it is possible to embed a backdoor in LLMs that manipulates its uncertainty without affecting its answers \[[\[71\]](#_edn71)\]. This fragility highlights the need for robust uncertainty quantification techniques that can differentiate between genuine uncertainty and manipulation, further complicating the task of developing trustworthy LLMs.

### 5.5 Best Practices for Responsible LLM Use

In addition to advanced techniques, best practices play a crucial role in mitigating risks when deploying LLMs.

#### 5.5.1 Transparency and Explainability
Providing transparency about how LLMs work and the data they are trained on can help users understand the limitations and potential biases of the models. Explainability techniques can also aid in interpreting model decisions, making it easier to identify and correct errors.
#### 5.5.2 Ethical Guidelines and Governance
Developing and adhering to ethical guidelines and governance frameworks is essential for ensuring responsible LLM use. This includes defining acceptable use cases, monitoring for misuse, and implementing mechanisms for accountability and redress.

#### 5.5.3 Continuous Monitoring and Evaluation
Regularly monitoring LLM outputs and evaluating their performance against benchmarks for accuracy, fairness, and bias is vital. This process allows for the identification and rectification of issues, ensuring the model remains aligned with ethical standards.

#### 5.5.4 User Education and Awareness
Educating users about the capabilities and limitations of LLMs is crucial. Users should be aware of potential risks, such as misinformation or biases, and be equipped with strategies for critically evaluating model outputs.


## 6 The trends and future impacts of LLMs

The latest iteration of LLMs, exemplified by LLama3 in the Groq cloud\[[\[72\]](#_edn72)\], has achieved remarkable throughput speeds, now capable of processing 870 tokens per second. This pace far surpasses human cognitive speed, marking a critical milestone in the journey toward an intelligence revolution. The increased speed and efficiency of LLMs will fundamentally alter how we approach problem-solving in science and business. Below we discuss some LLM technology and market trends.

### 6.1 Enhanced Efficiency through AI Agents

AI agents are expected to significantly boost digital work efficiency, establishing human-AI collaboration as a standard working mode. Many tasks will evolve into a framework where AI drafts content, humans verify its accuracy and make the decision, creating a seamless synergy that enhances productivity and quality of output.

### 6.2 Emergence of the LLMOps Service Market

The operational demands of AI agents will necessitate a robust support infrastructure, leading to a booming market for LLMOps services. This sector will focus on the maintenance, optimization, and governance of AI systems, emphasizing the importance of ensuring reliability and performance in increasingly automated workflows.

As LLMs become integral to various industries, the assurance of reliable and trustworthy LLMOps providers becomes paramount. These providers must offer consistent performance, adhere to stringent security standards, and ensure transparency in their operations to build trust with their clients.

### 6.3 Shifting Employment Landscape and New Market Opportunities

While the demand for traditional job roles may decline as AI agents take on more responsibilities, individuals' capabilities and efficiencies will be significantly enhanced. This shift will foster increased productivity, creating new market demands that require innovative solutions. Strategic fields such as biomedicine, aerospace, and nuclear energy are likely to see accelerated growth, positioning them as focal points for research and investment as humanity seeks to harness these vast, untapped opportunities.

## 7 Conclusion

There is no doubt that LLMs can have impact on business and industries. Among the key advantages they bring are the ability to function as a natural language interface between humans and computers, their versatility to be applied across a wide range of tasks, and their ability to process large amounts of text quickly.

Despite some hyped claims about LLMs’emergent properties, it is seems clear that LLMs responding based patterns in the training data, and does not actually understand the prompts or its own answers. Therefore, while LLMs are good at making guesses and suggestions, they should not be relied upon for tasks that require reasoning and computation. However, LLMs can be coupled to other tools such as symbolic reasoning engines and specialized software. To avoid hallucination and improve the reliability of information retrieval, LLMs can be connected to other trusted information sources. LLMs can significantly improve workflows by providing a simple interfaces to other software systems and databases, but they should not be used as the main computational engine or source of knowledge.

The greatest harm from LLMs may not be from their limitations and weaknesses, but from their strengths. LLMs can be used by adversaries to perform cybercrime and other malicious activities. Even when used with good intention, LLMs do not come out of the box with the ability to criticize themselves and express uncertainty. Therefore, they can sometimes be “confidently wrong” which could lead to unwanted consequences.

LLM providers, deployers and users should be aware of risks related to data leaks and violations of intellectual property and take measures to protect sensitive data. Use third-party LLM platforms for API services and web application deployment, could inadvertently expose sensitive internal knowledge, information, and data to these external entities. Generated output may also infringe on copyrights, so one should consider citing sources of information and obtain consent from data providers.

Individuals and companies should be careful in applying LLMs to critical tasks. Different guardrails can be applied to reduce the probability of unwanted output, such as barriers that can detect off-topic questions and confirm user queries before providing answers. However, no guardrail is perfect, and one should be aware of the possibility of jailbreaks that can bypass them.

Companies wishing to use LLM should also consider alternatives to LLMs that may be more efficient, reliable and sustainable for their use cases. If deciding to use LLMs, it also important to not be over-reliant on models that may be outdated or have new licensing terms tomorrow, and to build the ‘scaffolding’ around the models in such a way that the system can be easily maintained in the future.   The trends and future impacts of LLMs underscore a transformative era in technology and society. As we harness the power of these advanced models, it is imperative to navigate the associated challenges and opportunities with foresight and responsibility. By fostering a supportive ecosystem and addressing ethical concerns, we can unlock the full potential of LLMs to drive progress and innovation across all sectors.[\[HA31\]](#_msocom_31) 

## 8 References

[](#_ednref1)[1] Vaswani, Ashish, et al. "Attention is all you need." _Advances in neural information processing systems_ 30 (2017).

[](#_ednref2)[2] Devlin, Jacob, et al. "Bert: Pre-training of deep bidirectional transformers for language understanding." _arXiv preprint arXiv:1810.04805_ (2018).

[](#_ednref3)[3] Radford, Alec, et al. "Improving language understanding by generative pre-training." (2018).

[](#_ednref4)[4] Taylor, Wilson L. "“Cloze procedure”: A new tool for measuring readability." _Journalism quarterly_ 30.4 (1953): 415-433.

[](#_ednref5)[5] Warwick, Kevin, and Huma Shah. "Can machines think? A report on Turing test experiments at the Royal Society." _Journal of experimental & Theoretical artificial Intelligence_ 28.6 (2016): 989-1007.

[](#_ednref6)[6] OpenAI. “Introducing ChatGPT”. Published November 30, 2022. [https://openai.com/index/chatgpt/](https://openai.com/index/chatgpt/)

[](#_ednref7)[7] Kutuzov, Andrey, et al. "Large-scale contextualised language modelling for Norwegian." _arXiv preprint arXiv:2104.06546_ (2021).

[](#_ednref8)[8] Zhao, Jinman, et al. "Gender Bias in Large Language Models across Multiple Languages." _arXiv preprint arXiv:2403.00277_ (2024).

[](#_ednref9)[9] Liu, Nelson F., et al. "Lost in the middle: How language models use long contexts." _Transactions of the Association for Computational Linguistics_ 12 (2024): 157-173.

[](#_ednref10)[10] Shumailov, Ilia, et al. "AI models collapse when trained on recursively generated data." _Nature_ 631.8022 (2024): 755-759.

[](#_ednref11)[11]  Ali, Mehdi, et al. "Tokenizer Choice For LLM Training: Negligible or Crucial?." _arXiv preprint arXiv:2310.08754_ (2023).

[](#_ednref12)[12]  Stribling, Daniel, et al. "The model student: GPT-4 performance on graduate biomedical science exams." _Scientific Reports_ 14.1 (2024): 5670.

[](#_ednref13)[13] [https://x.com/tsarnick/status/1803901130130497952](https://x.com/tsarnick/status/1803901130130497952)

[](#_ednref14)[14\] \] Kambhampati, Subbarao. "Can large language models reason and plan?." _Annals of the New York Academy of Sciences_ 1534.1 (2024): 15-18.

[](#_ednref15)[15]  Kahneman, Daniel_._ _“Thinking, Fast and Slow”._ New York : Farrar, Straus and Giroux, 2011.

[](#_ednref16)[16] Valmeekam, Karthik, et al. "On the planning abilities of large language models-a critical investigation." Advances in Neural Information Processing Systems 36 (2023): 75993-76005.

[](#_ednref17)[17] Lu, Sheng, et al. "Are Emergent Abilities in Large Language Models just In-Context Learning?." arXiv preprint arXiv:2309.01809 (2023).

[](#_ednref18)[18]  Trinh, Trieu H., et al. "Solving olympiad geometry without human demonstrations." _Nature_ 625.7995 (2024): 476-482.

[](#_ednref19)[19] [https://www.linkedin.com/feed/update/urn:li:activity:7154157779136446464/](https://www.linkedin.com/feed/update/urn:li:activity:7154157779136446464/)

[](#_ednref20)[20] Huang, Jie, et al. "Large language models cannot self-correct reasoning yet." arXiv preprint arXiv:2310.01798 (2023).

[](#_ednref21)[21] Tekgul, Hakan. “Guardrails: What Are They and How Can You Use NeMo and Guardrails AI To Safeguard LLMs?”. [https://arize.com/blog-course/guardrails-what-are-they-and-how-can-you-use-nemo-and-guardrails-ai-to-safeguard-llms/](https://arize.com/blog-course/guardrails-what-are-they-and-how-can-you-use-nemo-and-guardrails-ai-to-safeguard-llms/)

[](#_ednref22)[22]  “A Comprehensive Guide: Everything You Need to Know About LLMs Guardrails”. https://attri.ai/blog/a-comprehensive-guide-everything-you-need-to-know-about-llms-guardrails

[](#_ednref23)[23] Xu, Shusheng, et al. "Is dpo superior to ppo for llm alignment? a comprehensive study." arXiv preprint arXiv:2404.10719 (2024).

[](#_ednref24)[24] Ahmadian, Arash, et al. "Back to basics: Revisiting reinforce style optimization for learning from human feedback in llms." arXiv preprint arXiv:2402.14740 (2024).

[](#_ednref25)[25] Deng, Yue, et al. "Multilingual jailbreak challenges in large language models." arXiv preprint arXiv:2310.06474 (2023).

[](#_ednref26)[26] Yong, Zheng-Xin, Cristina Menghini, and Stephen H. Bach. "Low-resource languages jailbreak GPT-4." _arXiv preprint arXiv:2310.02446_ (2023).

[](#_ednref27)[27] Üstün, Ahmet, et al. "Aya model: An instruction finetuned open-access multilingual language model." arXiv preprint arXiv:2402.07827 (2024).

[](#_ednref28)[28] Vinod Kumar, G R. “End-to-End Implementation of GraphRAG(Knowledge Graphs + Retrieval Augmented Generation): Unlocking LLM Discovery on Narrative Private Data”, Medium blog 14th July 2024. https://medium.com/@vinodkumargr/graphrag-graphs-retreival-augmented-generation-unlocking-llm-discovery-on-narrative-private-1bf977dadcdd

[](#_ednref29)[29] Zhang, Ningyu, et al. "A comprehensive study of knowledge editing for large language models." arXiv preprint arXiv:2401.01286 (2024).

[](#_ednref30)[30] https://www.promptingguide.ai/

[](#_ednref31)[31] https://github.com/microsoft/graphrag

[](#_ednref32)[32] Edge, Darren, et al. "From local to global: A graph rag approach to query-focused summarization." arXiv preprint arXiv:2404.16130 (2024).

[](#_ednref33)[33] Lin, Zhen, Shubhendu Trivedi, and Jimeng Sun. "Generating with confidence: Uncertainty quantification for black-box large language models." arXiv preprint arXiv:2305.19187 (2023).

[](#_ednref34)[34] Yadkori, Yasin Abbasi, et al. "To Believe or Not to Believe Your LLM." arXiv preprint arXiv:2406.02543 (2024).

[](#_ednref35)[35] Ahdritz, Gustaf, et al. "Distinguishing the knowable from the unknowable with language models." arXiv preprint arXiv:2402.03563 (2024).

[](#_ednref36)[36] Liu, Linyu, et al. "Uncertainty Estimation and Quantification for LLMs: A Simple Supervised Approach." arXiv preprint arXiv:2404.15993 (2024).

[](#_ednref37)[37] Ferrando, Javier, et al. "A primer on the inner workings of transformer-based language models." arXiv preprint arXiv:2405.00208 (2024).

[](#_ednref38)[38] Gurnee, Wes, et al. "Universal neurons in gpt2 language models." arXiv preprint arXiv:2401.12181 (2024).

[](#_ednref39)[39] Johnson, Daniel D., et al. "Experts Don't Cheat: Learning What You Don't Know By Predicting Pairs." _arXiv preprint arXiv:2402.08733_ (2024).

[](#_ednref40)[40] Su, Jiayuan, et al. "Api is enough: Conformal prediction for large language models without logit-access." arXiv preprint arXiv:2403.01216 (2024).

[](#_ednref41)[41] Zeng, Qingcheng, et al. "Uncertainty is Fragile: Manipulating Uncertainty in Large Language Models." _arXiv preprint arXiv:2407.11282_ (2024).

[](#_ednref42)[42] https://owasp.org/www-project-top-10-for-large-language-model-applications/

[](#_ednref43)[43] Zou, Andy, et al. "Universal and transferable adversarial attacks on aligned language models." _arXiv preprint arXiv:2307.15043_ (2023).

[](#_ednref44)[44] Chao, Patrick, et al. "Jailbreaking black box large language models in twenty queries." _arXiv preprint arXiv:2310.08419_ (2023).

[](#_ednref45)[45] Mehrotra, Anay, et al. "Tree of attacks: Jailbreaking black-box llms automatically." arXiv preprint arXiv:2312.02119 (2023).

[](#_ednref46)[46] Morris, John X., et al. "Text embeddings reveal (almost) as much as text." arXiv preprint arXiv:2310.06816 (2023).

[](#_ednref47)[47] Xu, Jiacen, et al. "Autoattacker: A large language model guided system to implement automatic cyber-attacks." arXiv preprint arXiv:2403.01038 (2024).

[](#_ednref48)[48] Hassanin, Mohammed, and Nour Moustafa. "A Comprehensive Overview of Large Language Models (LLMs) for Cyber Defences: Opportunities and Directions." arXiv preprint arXiv:2405.14487 (2024).

[](#_ednref49)[49] Xu, HanXiang, et al. "Large language models for cyber security: A systematic literature review." arXiv preprint arXiv:2405.04760 (2024).

[](#_ednref50)[50] Fowl, Liam, et al. "Decepticons: Corrupted transformers breach privacy in federated learning for language models." _arXiv preprint arXiv:2201.12675_ (2022).

[](#_ednref51)[51] Singh, Tanmay, et al. "Whispered tuning: Data privacy preservation in fine-tuning llms through differential privacy." Journal of Software Engineering and Applications 17.1 (2024): 1-22.

[](#_ednref52)[52] [https://github.com/stanfordnlp/dspy](https://github.com/stanfordnlp/dspy)

[](#_ednref53)[53] Xu, Shusheng, et al. "Is dpo superior to ppo for llm alignment? a comprehensive study." arXiv preprint arXiv:2404.10719 (2024).

[](#_ednref54)[54] Ahmadian, Arash, et al. "Back to basics: Revisiting reinforce style optimization for learning from human feedback in llms." arXiv preprint arXiv:2402.14740 (2024).

[](#_ednref55)[55] Deng, Yue, et al. "Multilingual jailbreak challenges in large language models." arXiv preprint arXiv:2310.06474 (2023).

[](#_ednref56)[56] Yong, Zheng-Xin, Cristina Menghini, and Stephen H. Bach. "Low-resource languages jailbreak GPT-4." _arXiv preprint arXiv:2310.02446_ (2023).

[](#_ednref57)[57] Üstün, Ahmet, et al. "Aya model: An instruction finetuned open-access multilingual language model." arXiv preprint arXiv:2402.07827 (2024).

[](#_ednref58)[58] Zhang, Ningyu, et al. "A comprehensive study of knowledge editing for large language models." arXiv preprint arXiv:2401.01286 (2024).

[](#_ednref59)[59] https://github.com/microsoft/graphrag

[](#_ednref60)[60] Edge, Darren, et al. "From local to global: A graph rag approach to query-focused summarization." arXiv preprint arXiv:2404.16130 (2024).

\[61\] Sarmah, Bhaskarjit, et al. "HybridRAG: Integrating Knowledge Graphs and Vector Retrieval Augmented Generation for Efficient Information Extraction." arXiv preprint arXiv:2408.04948 (2024).

[](#_ednref61)[61] Tekgul, Hakan. “Guardrails: What Are They and How Can You Use NeMo and Guardrails AI To Safeguard LLMs?”. [https://arize.com/blog-course/guardrails-what-are-they-and-how-can-you-use-nemo-and-guardrails-ai-to-safeguard-llms/](https://arize.com/blog-course/guardrails-what-are-they-and-how-can-you-use-nemo-and-guardrails-ai-to-safeguard-llms/)

[](#_ednref62)[62]  “A Comprehensive Guide: Everything You Need to Know About LLMs Guardrails”. https://attri.ai/blog/a-comprehensive-guide-everything-you-need-to-know-about-llms-guardrails

[](#_ednref63)[63] Lin, Zhen, Shubhendu Trivedi, and Jimeng Sun. "Generating with confidence: Uncertainty quantification for black-box large language models." arXiv preprint arXiv:2305.19187 (2023).

[](#_ednref64)[64] Yadkori, Yasin Abbasi, et al. "To Believe or Not to Believe Your LLM." arXiv preprint arXiv:2406.02543 (2024).

[](#_ednref65)[65] Ahdritz, Gustaf, et al. "Distinguishing the knowable from the unknowable with language models." arXiv preprint arXiv:2402.03563 (2024).

[](#_ednref66)[66] Liu, Linyu, et al. "Uncertainty Estimation and Quantification for LLMs: A Simple Supervised Approach." arXiv preprint arXiv:2404.15993 (2024).

[](#_ednref67)[67] Ferrando, Javier, et al. "A primer on the inner workings of transformer-based language models." arXiv preprint arXiv:2405.00208 (2024).

[](#_ednref68)[68] Gurnee, Wes, et al. "Universal neurons in gpt2 language models." arXiv preprint arXiv:2401.12181 (2024).

[](#_ednref69)[69] Johnson, Daniel D., et al. "Experts Don't Cheat: Learning What You Don't Know By Predicting Pairs." _arXiv preprint arXiv:2402.08733_ (2024).

[](#_ednref70)[70] Su, Jiayuan, et al. "Api is enough: Conformal prediction for large language models without logit-access." arXiv preprint arXiv:2403.01216 (2024).

[](#_ednref71)[71] Zeng, Qingcheng, et al. "Uncertainty is Fragile: Manipulating Uncertainty in Large Language Models." _arXiv preprint arXiv:2407.11282_ (2024).

[](#_ednref72)[72] Groq official website: [https://groq.com/](https://groq.com/)


