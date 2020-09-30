#' Get a Matrix with no Gaps from one Sample of a HexTemplate
#'
#' @param template A \code{\link{HexTemplate}}
#' @param sample An integer representing a sample
#'
#' @return A matrix
#' @export
#'
#' @examples
getMatrix <- function(template, sample = 1) {

  matr <- rep(0,template@dimen[1]*template@dimen[2])
  matr[template@gapID] <- template@counts[[sample]]
  matr <- matrix(matr, nrow = template@dimen[1],ncol = template@dimen[2], byrow = T)

}
