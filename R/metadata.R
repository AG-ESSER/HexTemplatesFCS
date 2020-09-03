#' Getter-Function for a HexTemplate's Metadata
#'
#' @param hexTemplate A \code{\link{HexTemplate}}
#'
#' @return a \code{data.frame} (The HexTemplate's metadata slot)
#' @export
#'
#' @examples hexT <- data(Testplate)
#' head(meta.data(hexT))
meta.data <- function(hexTemplate) {
  hexTemplate@metadata
}
