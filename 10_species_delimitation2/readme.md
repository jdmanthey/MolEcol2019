## Species Delimitation - 1 November 2019

Today we will be loading the workspace from Wednesday to load our phylogenies and pruned phylogenies, and then performing 
species delimitation with the program bGMYC (http://nreid.github.io/software/). Here is a copy of the sampling localities
map again for reference:

![map](https://github.com/jdmanthey/MolEcol2019/blob/master/09_species_delimitation1/map.png)


#### Load the image that you saved

Double click on the "trees.RData" object to open up the object and load R or RStudio in that directory. Alternatively, in 
RStudio, set the correct working directory, and then use:

    load("trees.RData")

If you want to make sure all the objects are there and remember their names, type ls():

    ls()
    
#### Load packages

    library(ape)
    source("bgmyc.r")
    
#### Set base plotting scheme

Some of the plotting functions in the bGMYC scripts will change the base plotting settings. Here, we will save the original 
settings:

    old_par <- par(no.readonly = TRUE)
    
If you need to reset the plotting functions later, use:

    par(old_par)

#### Plot the full and pruned trees to refresh your memory:

    plot(trees[[1]], cex=0.5)
    plot(pruned_trees[[1]], cex=0.5)

#### Species delimitation (full tree)

This first step will run the MCMC for the full tree. It is a short run for time purposes. If you wanted to do a real analysis
for publication, you'd likely run this much longer (1-2 orders of magnitude longer).

    result_multi <- bgmyc.multiphylo(trees, mcmc=5000, burnin=4000, thinning=100, t1=2, t2=46, start=c(1,1,45))

Now we will look at the MCMC mixing plot. What we want to see here is that the points are moving around to many different
values for each estimated parameter (each of the four plots). If you are interested in learning more, you can search for
information about MCMC convergence or MCMC mixing.

    plot(result_multi)
    
Now, whether or not it mixed well (we are on a time budget here), we will check out the results of delimiting the tips of
the phylogeny into different assigned groups:

    result_probmat <- spec.probmat(result_multi)
    
And plot:

    plot(result_probmat, trees[[1]])

#### Species delimitation (pruned tree)

Now we will repeat the above steps for the pruned tree of just the subclade that you chose last class.

    result_multi2 <- bgmyc.multiphylo(pruned_trees, mcmc=5000, burnin=4000, thinning=100, t1=2, t2=length(pruned_trees[[1]]$tip.label), start=c(1,1,3))

Check out the MCMC mixing:
    
    plot(result_multi2)

Make the probability matrix:

    result_probmat2 <- spec.probmat(result_multi2)
    
Plot:

    plot(result_probmat2, pruned_trees[[1]])

#### If you want, save the image of the work today like you did on Wednesday.


