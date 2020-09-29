#' Create a Matrix containing Weights for each Combination of Hexagons
#'
#' @param template A \code{\link{HexTemplate}}
#' @param method "exp" for exponential, "disc" or anything else for discrete approach
#' @param gamma Integer controlling the speed of the decrease. Only applies when method = "exp".
#' @param val A vector containing weights for each ranked distance between hexagons. Only applies when method = "disc".
#'
#' @return A matrix containing weights for each combination of hexagons. To be used in \code{\link{weightedBray}}.
#' @export
#' @importFrom sp coordinates
#' @importFrom dplyr dense_rank
#' @examples
weightMatrix <- function(template, method = "exp", gamma = 8, val = c(.5,.25,.25)) {

  centroids <- as.data.frame(coordinates(template@hexagonSP))
  euclDist <- as.matrix(dist(centroids, method = "euclidean"))

  if(method == "exp") {

    w = exp(-1*gamma*euclDist)

  } else {

    w <- euclDist %>%
      round(3) %>%
      as.vector() %>%
      dplyr::dense_rank() %>%
      matrix(ncol = template@nHex, nrow = template@nHex)

    w2 <- w
    w[w2 > length(val)] <- 0
    for (i in 1:length(val)) {
      w[w2 == i] <- val[i]
    }

  }

  w

}
