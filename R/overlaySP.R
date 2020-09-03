#' Bins a Data.Frame of Coordinates into a SpatialPolygons Object
#'
#' @param hexagonSP A \code{\link{SpatialPolygons}} objects
#' @param data A \code{data.frame} of coordinates
#'
#' @return A list of binned events per polygon
#'
#' @importFrom sp SpatialPoints over
#' @import magrittr
#'
#' @examples
overlaySP <- function (hexagonSP , data ) {

  lapply(data, SpatialPoints) %>%
    lapply(function(x){
      sp::over(hexagonSP,x, returnList = T)
    }) %>%
    lapply(function(x){
      as.vector(sapply(x, length))
    })

}
