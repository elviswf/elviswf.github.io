+++
title = 'Llm_graphrag'
date = 2024-10-16T16:23:19+08:00
draft = true

author = ["Elvis Wu"]
tags = ["LLM", "RAG"]
categories = ["tech"]
+++

RAG(Retrieval-Augmented Generation) is widely used in LLM applications nowadays. (There is an experimental comparison shows RAG> RAG+FT >FT. Not general conclusion but worth to notice. https://arxiv.org/pdf/2312.05934)

 

Howerver, even with the agent mechanism, RAG solutions also have very realistic challenges: 1. It is hard to decide suitable top-k retrievals for simple and professional queries at the same time. 2. It is hard to improve the solutions according to the users' feedbacks.

 

To solve the 2 challenges above, we are exploring the GraphRAG solution, which utilizes knowledge graphs(KG) as a middleware to organize the knowledge from the documents.  The middleware KGs can also be improved continously in the operation stage and make themselves valuable DNV digital assests.


In real applications like ChatDNV, you would expect traditional VectorRAG to answer the general questions and more GraphRAG to answer professional questions for trustworthness and completeness. (Pic 1)

 

We are still exploring on KG generation driven by LLMs. (Pic 2) But domain materials (like textbooks, rules) and industry ontologies can be very useful in the KG refinement. 



## Solving the out-of-context chunk problem for RAG
A large percentage of the problems developers face with RAG comes down to this: 
- Individual chunks oftentimes do not contain sufficient context to be properly used by the retrieval system or the LLM. This leads to the inability to answer questions and, more worryingly, hallucinations.

Examples of this problem
- Chunks oftentimes refer to their subject via implicit references and pronouns. This causes them to not be retrieved when they should be, or to not be properly understood by the LLM.
- Individual chunks oftentimes don’t contain the complete answer to a question. The answer may be scattered across a few adjacent chunks.
- Adjacent chunks presented to the LLM out of order cause confusion and can lead to hallucinations.
- Naive chunking can lead to text being split “mid-thought” leaving neither chunk with useful context.
- Individual chunks oftentimes only make sense in the context of the entire section or document, and can be misleading when read on their own.

## What would a solution look like?
There are two solutions that, when used together, solve the bulk of these problems.

### Contextual chunk headers
The idea here is to add in higher-level context to the chunk by prepending a chunk header. This chunk header could be as simple as just the document title, or it could use a combination of document title, a concise document summary, and the full hierarchy of section and sub-section titles.

### Chunks -> segments
Large chunks provide better context to the LLM than small chunks, but they also make it harder to precisely retrieve specific pieces of information. Some queries (like simple factoid questions) are best handled by small chunks, while other queries (like higher-level questions) require very large chunks. What we really need is a more dynamic system that can retrieve short chunks when that's all that's needed, but can also retrieve very large chunks when required. How do we do that?

Given that relevant chunks tend to be clustered within their original documents, what if we could identify those clusters and concatenate all of the chunks back into their original form? This would provide much more complete and understandable context to the LLM than just providing the individual (and out-of-order) chunks.


## Propositions Chunking
### Overview
This code implements the proposition chunking method. The system break downs the input text into propositions that are atomic, factual, self-contained, and concise in nature, encodes the propositions into a vectorstore, which can be later used for retrieval

### Key Components
1. **Document Chunking**: Splitting a document into manageable pieces for analysis.
1. **Proposition Generation**: Using LLMs to break down document chunks into factual, self-contained propositions.
1. **Proposition Quality Check**: Evaluating generated propositions based on accuracy, clarity, completeness, and conciseness.
1. **Embedding and Vector Store**: Embedding both propositions and larger chunks of the document into a vector store for efficient retrieval.
1. **Retrieval and Comparison**: Testing the retrieval system with different query sizes and comparing results from the proposition-based model with the larger chunk-based model.


### Motivation
The motivation behind the propositions chunking method is to build a system that breaks down a text document into concise, factual propositions for more granular and precise information retrieval. Using propositions allows for finer control and better handling of specific queries, particularly for extracting knowledge from detailed or complex texts. The comparison between using smaller proposition chunks and larger document chunks aims to evaluate the effectiveness of granular information retrieval.

Method Details
Loading Environment Variables: The code begins by loading environment variables (e.g., API keys for the LLM service) to ensure that the system can access the necessary resources.

Document Chunking:

The input document is split into smaller pieces (chunks) using RecursiveCharacterTextSplitter. This ensures that each chunk is of manageable size for the LLM to process.
Proposition Generation:

Propositions are generated from each chunk using an LLM (in this case, "llama-3.1-70b-versatile"). The output is structured as a list of factual, self-contained statements that can be understood without additional context.
Quality Check:

A second LLM evaluates the quality of the propositions by scoring them on accuracy, clarity, completeness, and conciseness. Propositions that meet the required thresholds in all categories are retained.
Embedding Propositions:

Propositions that pass the quality check are embedded into a vector store using the OllamaEmbeddings model. This allows for similarity-based retrieval of propositions when queries are made.
Retrieval and Comparison:

Two retrieval systems are built: one using the proposition-based chunks and another using larger document chunks. Both are tested with several queries to compare their performance and the precision of the returned results.
Benefits
Granularity: By breaking the document into small factual propositions, the system allows for highly specific retrieval, making it easier to extract precise answers from large or complex documents.
Quality Assurance: The use of a quality-checking LLM ensures that the generated propositions meet specific standards, improving the reliability of the retrieved information.
Flexibility in Retrieval: The comparison between proposition-based and larger chunk-based retrieval allows for evaluating the trade-offs between granularity and broader context in search results.
Implementation
Proposition Generation: The LLM is used in conjunction with a custom prompt to generate factual statements from the document chunks.
Quality Checking: The generated propositions are passed through a grading system that evaluates accuracy, clarity, completeness, and conciseness.
Vector Store Integration: Propositions are stored in a FAISS vector store after being embedded using a pre-trained embedding model, allowing for efficient similarity-based search and retrieval.
Query Testing: Multiple test queries are made to the vector stores (proposition-based and larger chunks) to compare the retrieval performance.
Summary
This code presents a robust method for breaking down a document into self-contained propositions using LLMs. The system performs a quality check on each proposition, embeds them in a vector store, and retrieves the most relevant information based on user queries. The ability to compare granular propositions against larger document chunks provides insight into which method yields more accurate or useful results for different types of queries. The approach emphasizes the importance of high-quality proposition generation and retrieval for precise information extraction from complex documents.
