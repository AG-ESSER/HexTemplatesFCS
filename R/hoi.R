#' Plot a Grid of t statistics
#'
#' @param template A HexTemplate
#' @param group A metadata group
#'
#' @return A list of ggplots
#' @export
#'
#' @examples
hoi <- function(template, group = 1) {
  #variances, normality

  #hexagons of interest in given group
  #highlights change in median frequency/hexagons between levels of the given group, if hexagon was determined
  #to be significant (p <= 0.05) by aov+Tukey
  #Only for exploration and not for statistical testing! p-Values are not adjusted!
  relative <- t(frequencies(template))
  treatment <- as.factor(template@metadata[,group])

  #ANOVA on hexagons
  ano <- lapply(as.data.frame(t(relative)), function(i) aov(i ~ treatment))
  glhtSum <- lapply(ano, function(x) summary(glht(x, linfct = mcp(treatment = "Tukey"))))
  tstat <- as.data.frame(lapply(glhtSum, function(i) i[["test"]][["tstat"]]))
  #p-Values in a data.frame
  pvals <- as.data.frame(lapply(glhtSum, function(i) i[["test"]][["pvalues"]]))
  rownames(pvals) <- rownames(tstat)
  pvals <- tstat
  nPlots <- dim(pvals)[[1]]

  diffGroups <- function(matr, treatment, group) {
    group1 <- vector()
    for (i in 1:dim(matr)[1]) {
      group1[i] <- median(matr[i, c(which(treatment == group[[1]][1]))])
    }
    group2 <- vector()
    for (i in 1:dim(matr)[1]) {
      group2[i] <- median(matr[i, c(which(treatment == group[[1]][2]))])
    }

    (group1/group2)*100
  }

  centroids <- as.data.frame(coordinates(template@hexagonSP))
  bn <- template@nHex
  colours <- c("blue4", "cyan3", "darkgreen", "mediumseagreen",  "chartreuse1", "goldenrod" , "gold", "darkorange", "firebrick1", "firebrick4")



  plotList <- lapply(1:nPlots, function(my_i){
    colV <- diffGroups(matr = relative, treatment = treatment, group = strsplit(rownames(pvals[my_i,]), " - "))
    #colV[colV > 200] <- 200
    #colV[pvals[my_i,] > 0.05] <- NA
    ids <- 1:template@nHex

    ggplot(centroids, aes(x = V1, y = V2, fill = as.numeric(pvals[my_i,])) ) +
      geom_point(size = 10, shape = 22) +
      #geom_tile(aes(fill = as.numeric(pvals[my_i,])), width = 1, height = 1)+
      scale_fill_gradientn(colours = colours) +
      labs(title  = rownames(pvals[my_i,]), x = template@xChannel, y = template@yChannel)


    # plot_ly(data = centroids, x = ~V1, y = ~V2, color = colV, text = ids, type = "scatter", mode = "markers",
    #         hoverinfo = 'x+y+text', colors = 'YlOrRd',
    #         marker = list(symbol = "hexagon-dot",
    #                       size = 1000/bn*5)) %>%
    #   layout(title = rownames(pvals[my_i,]),
    #          xaxis = list(title = template@xChannel),
    #          yaxis = list(title = template@yChannel))

  })

  names(plotList) <- rownames(pvals)
  plotList
}
