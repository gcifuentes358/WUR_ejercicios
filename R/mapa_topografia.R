####################################################
###Código análisis de cuencas#######################
####################################################

########## Cargar paquetes requeridos ##############
library("tidyverse")
library("raster")
library("spatstat")
library("rgeos")



########### Cargar el proyecto #####################
setwd("C:/Users/GONZALO/Dropbox/00_Veolia_Santa_Marta/06_R")

col_code <- 53
col_code_s <- "COL"

# Crear una nueva carpeta para almacenar nueva información
datadir <- "data"
dir.create(datadir)

# La información viene en formato RDS - propia de R
col_adm <- raster::getData("GADM", country = "COL", level =2, path = datadir)
col_DEM <- raster::getData("alt", country = "COL", mask = TRUE)
coord <- "Proyección Geográfica\n 
Sistema de Coordenadas: WGS84\n
Fuente: GADM.org"

# Creacion de n puntos distribuidos de forma uniforme
dran <- runifpoint(500, win = as.vector(extent(col_adm)))
s <- SpatialPoints(data.frame(x= dran$x, y= dran$y), 
                   proj4string = CRS(proj4string(col_adm)) )
s_col <- gIntersection(s, col_adm)

# Extracción de las alturas a partir de los puntos
# ESte método puede ser útil para hacer un muestreo espacial de alguna variable
# más interesante (NDVI o veolocidad del viento, por ejemplo)
puntos_alt <- extract(col_DEM, s_col, df= TRUE)
colnames(puntos_alt) <- c("id", "altura")

#####################################################################
########### Elaborar un mapa básico de ubicación#####################
#####################################################################

# Seleccionar olo el departamnto de magdalena
magdalena <- col_adm[col_adm$NAME_1 == "Magdalena", ]

# Dibujar varias capas (adicionarlas entre ellas con add = TRUE)
plot(magdalena, bg = "dodgerblue", axes = TRUE)
plot(magdalena, lwd = 10, border = "skyblue", add = TRUE)
plot(magdalena, col= "green4", add =TRUE)
plot(adm, add = TRUE)
grid()
box()

# Obtener una copia temporal invisible de un objeto
  # Pilas, text es una herramienta del paquete RASTER que sirve para plotear texto
  # sobre un mapa existente, puede determinar la ubicación de los labels con
  # getSpPPolygonsLabptSlots, pero está obsoleta (deprecated)
invisible(text((magdalena),
          labels = as.character(magdalena$NAME_2), 
                                cex = 0.5, col = "white", font = 1))

# Colocar gráficos en los márgenes con mtext
mtext(side =3, "Departamento de Magdalena", line = 2.5 , cex = 1.1)
mtext(side =2, "Latitud", line = 2.5 , cex = 1.1)
mtext(side =1, "longitud", line = 2.5 , cex = 1.1)
mtext(side =1, coord, adj = 1, cex =0.5, col = "grey", line = -2)

#####################################################################
########### Elaborar un mapa con alturas y puntos #####################
#####################################################################

  # Grafico de los puntos y las alturas
plot(col_DEM )
plot(col_adm, add = TRUE)
plot(s_col, add = TRUE, col = "red", pch = 19, cex = 0.2)

