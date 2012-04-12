# Outline

1.	 Chimpanzee and Elephant Save Christmas
  - stream of disordered records
  - group/sort records by their label
  - process each group of records
2.	 Heraclitus and the Stream
  - Simple disordered stream (map-only) in Wukong
  - Simple ordered-group transform (map+reduce) in Wukong
3.	 Why Hadoop Works
  - the locality problem
  - the Hadoop haiku
  - robots are inexpensive, programmers are not
4.	 How to Scale Dirty and its Influence on People
  - How to think at scale
  -	Pedantic Points of Style 
  - Best Practices
3. 	Herding `cat`s: the mechanics of 
  - getting data within Hadoop's reach
  - launching jobs
  - seeing the data
  - seeing the logs
  - simple debugging
6.	 Statistics
  - sum, average, standard deviation, etc
  - medians and percentiles
  - construct a histogram
  - normalize data by mapping to percentile
  - normalize data by mapping to Z-score
8.	 Advanced Pig
  - map-side join
  - merge join
  - skew joins
  - Performance and efficiency
11.	 Processing Text
  - grep'ing for simple matches
  - tokenize text
  - simple document analysis
  - minhash clustering
12.	 Geo Data
  - quadkeys and grid coordinate system
  - k-means clustering to produce readable summaries
  - partial quad keys for "area" data
  - voronoi cells to do "nearby"-ness
  - Using polymaps to see results
14.	 Processing Graphs
  - subuniverse extraction
  - Pagerank
  - identify strong links
  - clustering coefficient
15.	 Black-Box Machine Learning
  - Simple Naive Bayes classification
  - Document clustering
26.	 Flume and Stream Processing
  - sources, sinks and decorators
  - deploying a wukong script as a decorator
  - parse the twitter stream API feed
17.	 Time Series
  - windowing
  - simple anomaly detection
  - rolling statistics
19.	 Pig UDFs
  - Basic UDF
  - why algebraic is awesome and how to be algebraic
  - Wonderdog: a LoadFunc / StoreFunc for elasticsearch 
16.	 Installing and Operating a Cluster
17.	 Tuning
18.	 HBase and Databases

99.   Appendix A: Tao Te Chimp