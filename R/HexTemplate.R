#' Title
#'
#' @param flowset A flowCore \code{flowSet}
#' @param xChannel A string representing the x-axis channel
#' @param yChannel A string representing the y-axis channel
#' @param xbins Number of hexagons on the x-axis - 1
#' @param metadata A data.frame containing metadata. Column names should be the group names.
#' @param trans_fun A function to transform the data. Standard is \code{log10}. \code{return} if data should not be transformed.
#' @return A HexTemplate
#' @export
#'
#' @importFrom hexbin hexbin
#'
#' @examples #get example fcs
#' #get example metadata
#' #show available channels
#' colnames(fcs)
#' hexT <- HexTemplate(flowset = fcs, xChannel = "SSC-H", yChannel = "DAPI-H", metadata)
HexTemplate <- function(flowset, xChannel, yChannel, xbins = 20, metadata = data.frame(), trans_fun = log10) {
  #create HexTemplate object

  #turn flowset environment into list and reorder alphabetically
  fl <- as.list(flowset@frames)
  fl <- fl[order(names(fl))]

  #log10-transform x- and yChannel data
  logD <- lapply(fl, function(x) as.data.frame(trans_fun(x@exprs[, c(xChannel , yChannel)])))

  #set -Inf entries to 0
  logD <- lapply(logD, function(x) {
    x[x < 0] <- 0
    x
  })

  xChannelAll <- vector()
  yChannelAll <- vector()
  for(i in 1:length(logD)) {
    xChannelAll <- c(xChannelAll, logD[[i]][,1])
    yChannelAll <- c(yChannelAll, logD[[i]][,2])
  }

  hexb <- hexbin(xChannelAll, yChannelAll, xbins = xbins)
  hsp <- hex2Spatial(hexb)
  df <- overlaySP(hsp, logD)

  nHex <- hexb@ncells
  nSamples <- length(df)
  rownames(metadata) <- names(fl)

  new("HexTemplate", hexagonSP = hsp, counts = df, metadata = metadata,
      xChannel = xChannel, yChannel = yChannel, nHex = nHex, nSamples = nSamples)
}
