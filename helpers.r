#setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
#dat_loaded = read_delim("./data/dat_sub.csv", delim = ",")


properties_map <- function(ranges){
  p = ggplot()+
    geom_point(data = dat_loaded,
               aes(x = long,
                   y = lat,
                   color = `Slope Percent Difference`))+
    scale_color_gradientn(trans = "log", colors = rev(rainbow(9)))+
    coord_map(xlim = ranges$x, ylim = ranges$y)
  return(p)
}