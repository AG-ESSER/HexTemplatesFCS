#' Get table of Frequencies of every Hexagon's Event for Every Sample
#'
#' @param template A \code{\link{HexTemplate}}
#'
#' @return a data.frame
#' @export
#'
#' @examples
frequencies <- function(template) {

  relValues <- function(vVec) {
    #returns vector of frequencies/hexagon
    vVec/sum(vVec)*100
  }

  t(sapply(template@counts, relValues))
}
