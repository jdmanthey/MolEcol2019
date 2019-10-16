
standardize <- function(xxxx) {
	values(xxxx) <- values(xxxx) + 1
	min_x <- min(na.omit(values(xxxx)))
	
	if(min_x < 0) {
		values(xxxx) <- values(xxxx) - min_x
	}
	max_x <- max(na.omit(values(xxxx)))
	values(xxxx) <- values(xxxx) / max_x
	
	return(xxxx)
}

