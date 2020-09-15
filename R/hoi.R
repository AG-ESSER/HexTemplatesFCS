#' Plot a Grid of t-scores
#'
#' @param template A HexTemplate
#' @param group The column name or index of a metadata group
#'
#' @return A list of ggplots
#' @export
#' @import ggplot2
#' @import sf
#' @examples
hoi <- function(template, group = 1) {

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

  colnames(tscores) <- paste(gr[,1],gr[,2], sep = "-")

  ht <- as(template@hexagonSP, "sf")

  plotList <- lapply(1:ncol(tscores), function(i){

    ggplot(ht, aes(fill = tscores[,i]) ) +
      geom_sf()+
      scale_fill_gradient2(low = "blue", high = "red") +
      labs(title  = colnames(tscores)[i], x = template@xChannel, y = template@yChannel)

  })

  names(plotList) <- colnames(tscores)
  plotList

}
