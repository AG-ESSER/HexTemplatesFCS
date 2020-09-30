#' Automatically detect Gates based on the t-scores
#'
#' @param template A HexTemplate Object
#' @param ts A vector of t-scores
#' @param thresh A threshold that indicates neighboring hexagons might belong to the same region of interest (gate)
#' @param minT A minimum t-score so that a hexagon with this score is regarded as a valid entry point
#' @param tryO An integer that determines how many times should be looked for the best configuration
#' @param nM An integer specifying what is considered a neighbor
#'
#' @return A list of coordinates
#' @export
#' @import dplyr
#' @import sf
#' @import concaveman
#' @examples
detectGates <- function(template, ts, thresh = 5, minT = 1, tryO = 10, nM = 2, conc = 3.5, tSeed = NA) {

  floodFill <- function(hexNr, org, rn) {
    for(i in 1:template@nHex) {
      if(w[i,hexNr] == 1 & i != hexNr & roi.env$roi[i] == 0 & !is.nan(ts[i])) {
        if((abs(ts[i]) >= minT) & (abs(ts[i] - org) <= thresh)) {
          roi.env$roi[hexNr] <- rn
          floodFill(i, org, rn)
        }
      }
    }
  }

  entryPoint <- function() {
    for(i in sample(template@nHex)) {
      if((ts[i] < q[2] | ts[i] > q[4]) & (!is.infinite(ts[i]) & !is.na(ts[i]) & !is.nan(ts[i]))) {
        if(roi.env$roi[i] == 0) {
          floodFill(i, ts[i], count)
          count <- count + 1
        }
      }
    }
  }


  #neighboring matrix w
  centroids <- as.data.frame(coordinates(template@hexagonSP))
  euclDist <- as.matrix(dist(centroids, method = "euclidean"))
  w <- euclDist %>%
    round(1) %>%
    as.vector() %>%
    dplyr::dense_rank() %>%
    matrix(ncol = template@nHex, nrow = template@nHex)

  w[w <= nM] <- 1
  w[w > nM] <- 0

  q <- quantile(ts, na.rm = T)

  #creating environment for modifying by reference
  roi.env <- new.env()
  roi.env$roi <- rep(0, template@nHex)

  if (is.na(tSeed)) {
    mx <- 0
    bestSeed <- 0
    #find best configuration
    for(seed in sample(1000,tryO)) {
      roi.env$roi <- rep(0, template@nHex)
      count <- 1
      set.seed(seed)
      entryPoint()

      hist <- table(roi.env$roi)
      #find optimal (most hexagons covered with minimal number of gates)
      m <- sum(hist[-1])/nlevels(as.factor(roi.env$roi))
      if(m > mx) {
        mx <- m
        bestSeed <- seed
      }
    }
  } else {
    bestSeed <- tSeed
  }
  print(paste0("Seed for this configuration: ",bestSeed))

  roi.env$roi <- rep(0, template@nHex)
  count <- 1
  #recreate with best configuration
  set.seed(bestSeed)
  entryPoint()

  hist <- table(roi.env$roi)

  roi.env$roi[which(roi.env$roi %in% as.numeric(names(which(hist <= 2))))] <- 0
  roi.env$roi <- dplyr::dense_rank(roi.env$roi)

  #create concave gates
  p <- lapply(2:max(roi.env$roi), function(x){
    cr <- centroids[which(roi.env$roi == x),]
    cr <- concaveman(as.matrix(cr), concavity = conc, length_threshold = .1)#cr[chull(cr),]
  })
}
