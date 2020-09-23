#' Get t-scores for a HexTemplate and a Metadata Group
#'
#' @param template A HexTemplate Object
#' @param group A metadata group
#'
#' @return A DataFrame of t-scores
#' @export

#' @examples
tscores <- function(template, group = 1) {

  relative <- t(frequencies(template))
  treatment <- as.factor(template@metadata[,group])

  gr <- expand.grid(unique(treatment), unique(treatment))
  gr <- gr[!duplicated(t(apply(gr, 1, sort))), ]
  gr <- gr[gr[,1] != gr[,2],]

  tscores <- apply(gr, 1, function(x) {
    smean <- apply(relative[,which(treatment == x[2])],1,mean)
    pmean <- apply(relative[,which(treatment == x[1]| treatment == x[2])],1,mean)

    ssd <- apply(relative[,which(treatment == x[2])],1,sd)
    n <- ncol(relative[,which(treatment == x[2])])

    (smean - pmean)/(ssd/sqrt(n))

  })

  colnames(tscores) <- paste(gr[,2],gr[,1], sep = "-")
  tscores

}
