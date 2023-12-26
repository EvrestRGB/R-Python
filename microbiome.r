#Required packages
install.packages("devtools")
install.packages("BiocManager")

# Install NetCoMi
devtools::install_github("stefpesche/NetCoMi",
                         dependencies = c("Depends", "Imports", "LinkingTo"),
                         repos = c("https://cloud.r-project.org/",
                                   BiocManager::repositories()))


library(NetCoMi)

#Phyloseq object
biom_18s_2020

#Select for a genus level
ps.genus.phy <- phyloseq::tax_glom(biom_18s_2020, taxrank = "Genus")
genus.renamed <- renameTaxa(ps.genus.phy, pat = "<name>",
                            substPat = "<name>_<subst_name>(<subst_R>)",
                            numDupli = "Genus")
#Construct Network
net_construct <- netConstruct(genus.renamed,
                              measure = "pearson",
                              filtTax = 'totalReads',
                              filtTaxPar = list(totalReads = 500),
                              filtSamp = "totalReads",
                              filtSampPar = list(totalReads = 1000),
                              sparsMethod = "threshold",
                              normMethod = "clr",
                              seed = 123456)

#Analyze Network
net_analyze <- netAnalyze(net_construct,
                          clustMethod = "cluster_fast_greedy")

#Plot Method
plot(net_analyze, shortenLabels = "none", lebelScale = FALSE,
     cexLabels = 0.8, nodeSize = "degree", mar = c(1,1,3,1)
     repulsion =0.9)
