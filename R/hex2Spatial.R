#' Convert a Hexbin Object to a SpatialPolygons Object
#'
#' @param hex A Hexbin Object
#'
#' @return A SpatialPolygons Object
#' @export
#' @importFrom hexbin hcell2xy hexcoords
#' @importFrom sp Polygon Polygons SpatialPolygons
#'
#' @examples
hex2Spatial <- function(hex){
  #convert hexbin-Object to SpatialPolygons
  center <- hcell2xy(hex)
  xwidth <- diff(hex@xbnds) / hex@xbins
  uniy <- sort(unique(center$y))
  ywidth <- uniy[2] - uniy[1]
  hexagon <- hexcoords(xwidth / 2, ywidth / 3)
  coordx <- sapply(1:6, function(i) center$x + hexagon$x[i])
  coordy <- sapply(1:6, function(i) center$y + hexagon$y[i])

  coordinates <- list(coordx,coordy)
  p1p <- list()
  for (n in 1:nrow(coordinates[[1]])) {
    p1 <- Polygon(coords = cbind(coordinates[[1]][n,], coordinates[[2]][n,]))
    p1p <- c(p1p, Polygons(list(p1), as.character(n)))
  }
  spp <- SpatialPolygons(p1p)
}
