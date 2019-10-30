## Playing with phylogenies 30 October 2019

Today we will be loading phylogenies, plotting them in different ways, and getting everything set up for doing some
species delimitation analyses on Friday. We will be working with some phylogenetic data from Ethiopian birds, with sampling
localities indicated in the below figure. In the figure, darker shades indicate higher elevation, and the dotted lines show
putative biogeographic barriers.

![map](https://github.com/jdmanthey/MolEcol2019/blob/master/09_species_delimitation1/map.png)

#### Download the data and set up the working directory.

Download the trees.zip file to your computer, unzip the file, and set that as your working directory for these exercises. 
Inside will be a file with phylogenetic trees (n = 101) estimated in the program BEAST, and a spreadsheet that indicates
the sample names and sampling locations. The trees were estimated from complete mitochondrial genomes for each individual.

#### Install packages

    install.packages("ape")
    install.packages("phangorn")
    install.packages("phytools")
    
#### Load packages

    library(ape)
    library(phangorn)
    library(phytools)

#### Read in the trees file and plot

    # read in file
    trees <- read.nexus("eth_mtDNA.trees")

This file contains 101 samples of phylogenetic tree estimation from the same dataset. It contains all the individuals
found in the spreadsheet you downloaded. We can plot one of the trees like so:

    plot(trees[[1]], cex=0.5)

There are other ways to visualize trees as well. We can plot an unrooted tree:

    plot(unroot(trees[[1]]),type="unrooted",cex=0.6, use.edge.length=FALSE,lab4ut="axial", no.margin=TRUE)

Or we can plot a circular style tree:

    plotTree(trees[[1]],type="fan",fsize=0.7,lwd=1, ftype="i", cex=0.5)

Since there are 101 trees, we can also plot all the trees at once. Here, each tree will be partially translucent so
that we can see all the trees simultaneously:

    densiTree(trees, cex=0.5)

#### Prune the trees to only one species

Randomly choose a species:

    sample(c("Cossypha", "Melaenornis", "Parophasma", "Serinus", "Turdus", "Zosterops"), 1)

Set this genus in the following command, replacing the word "genus" with the genus the sampler gave you:

    genus_to_keep <- "genus"
    
Prune the trees:

    tips_to_keep <- trees[[1]]$tip.label[grepl(paste(genus_to_keep, "*", sep=""), trees[[1]]$tip.label)]
    pruned_trees<-lapply(trees, keep.tip, tips_to_keep)
    class(pruned_trees)<-"multiPhylo"

Plot one of the pruned trees:

    plot(pruned_trees[[1]]
    
Plot all of the pruned trees:

    densiTree(pruned_trees, cex=0.5)

#### Save the work

Save the image of the work you did today for next class:

    save.image("trees.RData")
    
