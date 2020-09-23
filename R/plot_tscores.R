#' Convenience Function for plotting t-scores
#'
#' @param template A HexTemplate Object
#' @param ts A vector of t-scores
#' @param ... Additional arguments passed to \code{geom_sf}
#'
#' @return A ggplot Object
#' @export
#' @import ggplot2
#' @examples
plot_tscores <- function(template, ts,...) {
  plot(template, mapping = aes(fill = ts),...) +
    scale_fill_gradient2(low = "blue", high = "red") +
    labs(title = colnames(ts))
}
