## Estimating Genetic Structure from SNPs 4 October 2019

Today we will be working with a subset of genomic SNPs (n = 5000) from the Brown Creeper populations. Here is a map of the
subspecies again as well as a sampling map of all the populations used for the SNP dataset we are using today. In Panel B, 
green areas indicate places with dense vegetation, likely different types of forest.

![distribution](https://github.com/jdmanthey/MolEcol2019/blob/master/06_genetic_structure/sampling.png)

Open RStudio and set the working directory to the same one we have been using and download the .stru file from this 
directory on GitHub. 

We'll need to install a couple packages for the exercises today, do that here (you can copy all 4 lines at once). This will
install these two packages and a bunch of dependencies.

    if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
    BiocManager::install("LEA")
    install.packages("adegenet")
    
Load the libraries:
    
    require("LEA")
    require("adegenet")
    
### Using PCA

First, we will use a method called discriminant analysis of principal components (DAPC). This is an extension of the principle
components analysis (PCA) that we discussed in class. If you want more info about this method, a link to the paper is here:
https://bmcgenet.biomedcentral.com/articles/10.1186/1471-2156-11-94

To get started we load a structure-formatted file into R. If you are interested in what that looks like, you can open the 
file in a text editor and check it out.

    x <- read.structure("certhia_contact.stru",onerowperind=F,n.ind=24,n.loc=5000,ask=F,sep="\t")

Next, we'll use the DAPC program to identify the number of potential clusters in the genetic data. Here, we are setting the
maximum number of clusters to 6 (number of populations) and running for 1e5 iterations. Here, when the program asks you how 
many PCs to retain, choose 20. This is an amount that maintains most of the variation in the data and is less than the 
number of individuals we have sampled. Then, the program will show you a Bayesian Information Criterion (BIC) plot. The BIC
value will be _lowest_ where the number of genetic clusters is most supported. Choose that number of K (hopefully = 2). 

    grp <- find.clusters(x,max.n.clust=6,n.iter=1e5)
    
Next, we will choose the number of PCs again (choose 20 again) as well as the number of discriminant factors to include, which
has to be less than K. Choose the highest number you can based on the value of K you chose.
    
    dapc1 <- dapc(x,grp$grp)

Now, we'll plot the DAPC results in two ways. The first will be the principal components themselves, colored to the group that
each individual (here each point) belongs to:
    
    plot(dapc1$tab[grp$grp==1,1:2], xlim=c(min(dapc1$tab[,1]), max(dapc1$tab[,1])), ylim=c(min(dapc1$tab[,2]), max(dapc1$tab[,2])), col="blue", pch=19)
    points(dapc1$tab[grp$grp==2,1:2], col="red", pch=19)

We can also look at a STRUCTURE-like type of plot showing the assignment of each individual to the two genetic clusters:
    
    compoplot(dapc1, col=c("blue", "red"))

If you already looked at the text input file, you know we have three individuals per population from 8 localities:
    1. Utah (individuals 1-3)
    2. Pinal Mountains (4-6)
    3. Pinaleno Mountains (7-9)
    4. Santa Catalina Mountains (10-12)
    5. Chiricahua Mountains (13-15)
    6. Santa Rita Mountains (16-18)
    7. Huachuca Mountains (19-21)
    8. Central Mexico (22-24)



### Using STRUCTURE-like analyses

We are not going to run STRUCTURE here because it takes too much time. Rather we are going to use a similar type of method
that runs quickly and is appropriate for the time we have. The R function we will use and associated references can be found
here is you are interested: https://www.rdocumentation.org/packages/LEA/versions/1.4.0/topics/snmf

First, we have to convert our input file to an appropriate format for this program. This will create new files in your working
directory.
    
    struct2geno("certhia_contact.stru", ploidy=2, FORMAT = 2, extra.row = 0, extra.col = 1)

Next, we will run the snmf algorithm and obtain the Q coefficients for our samples for a K = 2:
    
    x_structure_k2 <- snmf("certhia_contact.stru.geno", K = 2, alpha=100, project="new")
    k2_q <- Q(x_structure_k2, K = 2)

Plot this in a barplot:
    
    plot_colors <- c("red", "blue", "white", "orange", "purple", "black")
    barplot(t(k2_q), col=plot_colors)

Now we will run the same program for multiple values of K: 

    x_structure_k3 <- snmf("certhia_contact.stru.geno", K = 3, alpha=100, project="continue")
    x_structure_k4 <- snmf("certhia_contact.stru.geno", K = 4, alpha=100, project="continue")
    x_structure_k5 <- snmf("certhia_contact.stru.geno", K = 5, alpha=100, project="continue")
    x_structure_k6 <- snmf("certhia_contact.stru.geno", K = 6, alpha=100, project="continue")

Get the Q coefficients for each run:

    k3_q <- Q(x_structure_k3, K = 3)
    k4_q <- Q(x_structure_k4, K = 4)
    k5_q <- Q(x_structure_k5, K = 5)
    k6_q <- Q(x_structure_k6, K = 6)

Plot them all together. The two 'par' commands sets up the plotting and dimensions. The first one sets the number of plots
equal to 5 rows and 1 column of figures. The second command sets up the margins for each plot.

    par(mfrow=c(5,1))
    par(mar=c(1,4,0,1))
    barplot(t(k2_q), col=plot_colors)
    barplot(t(k3_q), col=plot_colors)
    barplot(t(k4_q), col=plot_colors)
    barplot(t(k5_q), col=plot_colors)
    barplot(t(k6_q), col=plot_colors)
    
    
    

    
