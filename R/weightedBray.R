#' Compute Weighted Bray Distance between Samples of a HexTemplate
#'
#' @param hexTemplate A \code{\link{HexTemplate}} Object
#' @param gamma A positive number specifying the drop off of the weight matrix when w = NA
#' @param w Optionally you may provide your own weight matrix created with \code{\link{weightMatrix}}
#'
#' @return A distance matrix
#' @import sp
#' @export
#'
#' @examples
weightedBray <- function(hexTemplate, gamma = 8, w = NA) {
  #computes weighted bray distance between samples
  #if w is undefined then w = exp(-1*gamma*euclDist)

  h <- t(frequencies(hexTemplate))

  if(is.na(w)) {
    centroids <- as.data.frame(coordinates(hexTemplate@hexagonSP))
    euclDist <- as.matrix(dist(centroids, method = "euclidean"))
    w = exp(-1*gamma*euclDist)
  }

  len <- hexTemplate@nSamples
  d <- matrix(nrow = len, ncol = len)

  for(i in 1:len) {
    for(j in 1:len) {

      d[i,j] <- sum(w*abs(outer(h[,i], h[,j], FUN = "-"))) / sum(w*outer(h[,i], h[,j], FUN = "+"))

    }
  }

  as.dist(d)

}
