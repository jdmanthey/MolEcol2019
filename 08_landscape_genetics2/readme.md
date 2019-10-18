## Landscape Genetics 2 - 18 October 2019

Today we will be using the conductance maps we made on Wednesday to estimate least cost path (LCP) distances between 
populations, and see which model best fits the data.

### 1. Answer question #3 on your worksheet.

### 2. Change the directory to the one you used on Wednesday. Install and load packages.

We need one more package to be installed:

    install.packages("ecodist")

Load the packages we need for today:

    library(raster)
    library(rgdal)
    library(gdistance)
    library(ecodist)

### 3. Estimate distances between populations for your conductance layer.

1. Read your conductance raster. If you named it something different, you will need to change the code.

        x <- raster("test.grd")

2. Load the political boundaries and make the Arizona shapefile again:

        usa <- readOGR("gadm36_USA_shp", "gadm36_USA_1")
        arizona <- subset(usa, usa@data$NAME_1 %in% c("Arizona"))

3. Read in sampling points and modify as on Wednesday:

        # read in sampling points and re-structure format
        sampling_points <- read.csv("sitta_sampling.csv", header=T, stringsAsFactors=F)
        sampling_points2 <- as.matrix(sampling_points[,3:2])

4. Make sure they loaded properly by plotting. 

        plot(x)
        plot(arizona, add=T)
        points(sampling_points2)
    
5. Create a cost distance object (functions are part of the gdistance package).

        # first step is to make all NA values in the raster to 0 conductance
        x[is.na(x)] <- 0
        
        # next we create a transition layer that includes costs of moving between cells in all directions (not plottable)
        transition_layer <- transition(x, mean, directions=8)
        
        # corrects the transition layer with information based on how close cells are to one another and the coordinate system
        transition_layer2 <- geoCorrection(transition_layer, "c", scl=T)
        
        # create the cost-distance object, calculating LCP for each pairwise comparison of sampling locations
        cost_distance <- costDistance(transition_layer2, sampling_points2)
        
        # look at the object that was created and pairwise LCP distances
        cost_distance
        
### 4. Statistics of the result using multiple regression of distance matrices (MRM).

    # read in genetic differentiation data
    fst <- read.table("distance_all.csv", header=T, sep=",", stringsAsFactors=F)
        
    # convert the cost distance matrix to a vector
    lcp <- as.vector(cost_distance)
        
    # combine your cost_distance object with the fst object
    fst <- cbind(fst, lcp)
        
    # do the stats!
    mrm_results <- MRM(fst$fst ~ fst$lcp, nperm=100)
        
    # look at the results:
    mrm_results$r.squared
        
### 5. Write your results on the white-board for comparison with everyone else.

### 6. Make a plot of LCP between populations

If we want to visualize the LCP between two populations, we can do so as follows:

    # see what numbers each of the populations are:
    sampling_points
    
    # get the LCP between population 2 and population 5
    plot(x)
    plot(arizona, add=T)
    lines(shortestPath(transition_layer2, sampling_points2[2, ], sampling_points2[5, ], output="SpatialLines"))
   
If you want to plot all the LCP between population 1 and another population, run the following. If you want to change which
population you are starting with, choose a different number assigned to the variable "population_to_use"

    plot(x)
    plot(arizona, add=T)
    population_to_use <- 1
    for(a in 1:9) {
	    lines(shortestPath(transition_layer2, sampling_points2[population_to_use,], sampling_points2[a,], output="SpatialLines"), lwd=2)
    }
    points(sampling_points[,3], sampling_points[,2], cex=1.5, lwd=2)
    points(sampling_points[population_to_use,3], sampling_points[population_to_use,2], pch=19, cex=2)


