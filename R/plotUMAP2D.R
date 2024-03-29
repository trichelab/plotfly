#' toss a 2D UMAP plot up on the interwebs with plotly 
#'
#' @param x         an object (a data.frame, matrix, SCE, or Seurat) 
#' @param use       name of dimred to use, if x is not a df or matrix ("UMAP")
#' @param color_by  column name of metadata (or x itself) to color by ("group")
#' @param static    use cached palette(s) of the appropriate size? (TRUE)
#' @param shuffle   shuffle the colors of the cached palette(s)? (FALSE) 
#' @param ...       other stuff passed to plotly
#' 
#' @return          nothing much; a static webpage is created as a side effect.
#' 
#' @import plotly
#'
#' @export
plotUMAP2D <- function(x, 
                       use="UMAP", 
                       color_by="group", 
                       static=TRUE, 
                       shuffle=FALSE, 
                       ...) { 

  n <- nrow(x)  
  m <- length(dims)
  g <- length(color_by)
  rd <- grabData(x, use=use, color_by=color_by, dims=1:2)
  if (!"group" %in% names(rd)) { 
    names(rd) <- sub(paste0("^", color_by, "$"), "group", names(rd))
  }
  rd[, "group"] <- factor(rd[, "group"])
  if (is.null(rd$label)) rd$label <- paste0(rownames(x), " (", rd$group, ")")
  pal <- choosePalette(rd$group, static=static, shuffle=shuffle)
  names(pal) <- levels(rd$group)

  # render
  config(layout(add_markers(plot_ly(rd, 
                                    text = ~ label, 
                                    hoverinfo = "text", 
                                    type = "scatter",
                                    color = ~ group, 
                                    colors = pal), 
                            x = ~X, 
                            y = ~Y, 
                            ...),

                yaxis = list(title = "UMAP1", 
                             zeroline = FALSE,
                             showgrid = FALSE,
                             showticklabels = FALSE),

                xaxis = list(title = "UMAP2", 
                             zeroline = FALSE,
                             showgrid = FALSE,
                             showticklabels = FALSE)), 
         
         displayModeBar = FALSE)

}
