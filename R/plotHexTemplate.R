#' Plot an empty or filled HexTemplate
#'
#' @param hexTemplate A \code{\link{HexTemplate}} Object
#' @param sample A positive number corresponding to the sample with which the template should be filled. Leave NA to plot empty template.
#' @param ... Additional arguments passed to \code{geom_sf}
#'
#' @return A ggplot2 plot
#' @export
#' @import ggplot2
#' @import sf
#' @examples
plot.HexTemplate <- function(hexTemplate, sample = NA,...) {
  #sanity checks
  #add optional "add text" argument c("hexnr", "rel", "abs")

  sf_poly <- as(hexTemplate@hexagonSP, "sf")
  freq <- frequencies(hexTemplate)[sample,]
  if (is.na(sample)) {

    ggplot(sf_poly)+
      geom_sf(...)

  } else {

    colours <- c("blue4", "cyan3", "darkgreen", "mediumseagreen",  "chartreuse1", "goldenrod" , "gold", "darkorange", "firebrick1", "firebrick4")

    ggplot(sf_poly,aes(fill = log10(freq)))+
      geom_sf(...) +
      scale_fill_gradientn(colours = colours) +
      labs(fill = "log10(Events)", title = names(hexTemplate@counts[sample]), x = hexTemplate@xChannel, y = hexTemplate@yChannel)

  }
}
