#' Plot an empty or filled HexTemplate
#'
#' @param hexTemplate A \code{\link{HexTemplate}} Object
#' @param sample A positive number corresponding to the sample with which the template should be filled. Leave NA to plot empty template.
#'
#' @return A ggplot2 plot
#' @export
#' @importFrom ggplot2 ggplot scale_fill_gradientn labs
#' @import sf
#' @examples
plot.HexTemplate <- function(hexTemplate, sample = NA) {
  #sanity checks
  #add optional "add text" argument c("hexnr", "rel", "abs")

  sf_poly <- as(hexTemplate@hexagonSP, "sf")

  if (is.na(sample)) {

    ggplot(sf_poly)+
      geom_sf(color = "black", fill = "white")

  } else {

    colours <- c("blue4", "cyan3", "darkgreen", "mediumseagreen",  "chartreuse1", "goldenrod" , "gold", "darkorange", "firebrick1", "firebrick4")

    ggplot(sf_poly,aes(fill = log10(hexTemplate@counts[[sample]])))+
      geom_sf(color = NA) +
      scale_fill_gradientn(colours = colours) +
      labs(fill = "log10(Events)", title = names(hexTemplate@counts[sample]), x = hexTemplate@xChannel, y = hexTemplate@yChannel)

  }
}
