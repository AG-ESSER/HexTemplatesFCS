#' S4 Class HexTemplate
#'
#' @slot hexagonSP SpatialPolygons that contain information about the hexagons.
#' @slot counts list of events per hexagon per sample.
#' @slot metadata data.frame.
#' @slot xChannel character.
#' @slot yChannel character.
#' @slot nHex numeric.
#' @slot nSamples numeric.
#'
#' @return
#'
#'
#' @examples
setClass("HexTemplate",
         representation(hexagonSP = "SpatialPolygons",
                        counts = "list",
                        metadata = "data.frame",
                        xChannel = "character",
                        yChannel = "character",
                        nHex = "numeric",
                        nSamples = "numeric"))
