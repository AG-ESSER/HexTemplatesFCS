#' Create a Data.Frame of mean Bray Distances per Resolution
#'
#' @param fcs A flowCore flowSet
#' @param xChannel name of the x-channel
#' @param yChannel name of the y-channel
#' @param seqq a vector of resolutions (xbins) to check
#'
#' @return A data.frame of mean Bray distances
#' @export
#' @importFrom vegan vegdist
#'
#' @examples
determineNHex <- function(fcs, xChannel, yChannel, seqq = seq(5,50,5)) {
  listHexT <- lapply(seqq, function(x) {
    print(x)
    HexTemplate(flowset = fcs,
                xChannel = xChannel,
                yChannel = yChannel,
                xbins = x,
                metadata = data.frame(dummy = 1:length(fcs)))
  })

  listFrequencies <- lapply(listHexT, frequencies)

  listDist <- lapply(listFrequencies, vegdist)

  meanDist <- sapply(listDist, mean)
  dF <- data.frame("meanDist" = meanDist, "resolution" = seqq)
}








