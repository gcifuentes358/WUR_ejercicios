#################################################################
############ Manteniendo control de versiones--- ################
#################################################################

# Seleccionar el ddirectorio para el WS
setwd("~/GitHub/WUR_ejercicios")

# Recordar que las funciones se pueden traer a partir source(CCC)
# la idea es que el archivo MAIN llame a los demás dentro de la carpeta
# R

# Cargar paquetes para generar un ejemplo reproducible referente a 
# análisis espacial
library(raster)

# Crear una instancia de raster
r <- s <- raster(ncol=50, nrow=50)

r[] <- 1:ncell(r)

s[] <- 2 * (1:ncell(s))

s[200:400] <- 150

s[50:150] <- 151

# Realizar un reemplazo

r[s %in% c(150, 151)] <- NA

plot(r)

# En ocasiones en lugar de generar pequeños datasets, es útil usar
# conjuntos de "data" (R Built in DS)

# Importar datos de la variable "cars"
# Datos de 1920 relacionando velocidad de carros y a distancia que
# les tomó detenerse.
data(cars)

# Importar datos del dataset "meuse"
# Este dataset tiene localizaciones y concentración de metales pesados en 
# la superfiie, con algunas variables de tipo de suelo, recopiladas en la
# llanura de inundación del river Meuse en Stein (Holanda)
# Para usar meuse es necesario tener en el WS el paquete "sp"

data("meuse")

# la herramienta coordinates sirve para definir coordenadas espaciales de un 
# objeto espacial, si el objeto era un data frame se convierte en un DF espacial

coordinates(meuse) <- c("x","y")

# La función Bubble esta definida dentro del paquete "sp" crea burbujas de datos espaciales
# key.entries sirve para definir los valores que van a ser colocados en los labels

bubble(meuse, "zinc", maxsize = 2.5,
       main = "zinc concentrations (ppm)", key.entries = 2^(-1:4))


######################################################################
############ Crear un segundo set de datos espaciales ################
######################################################################

# cargarla matriz
# La información es un perímetro del río alrededor del dataset
data(meuse.riv)

# Crear un polígono espacial a partir de la matriz (son 176 parejas ordenadas)

  # Primerro se crea un polígono desde el paquete sp - usa los puntos en orden.
  # Luego saco el objeto usando la herrmaienta list del paquete "base"
  # El objeto listado se define coordenadas espaciales usando polygons, queda como un 
  # polígono dentro de otro -- a priori_
  # Spatial polygons crea los polígonos espaciales
meuse.sr <- SpatialPolygons(list(Polygons(list(Polygon(meuse.riv)),"meuse.riv")))


# Crgar datos adicionales
# tiene 3103 filas y 7 columnas que cubren el área de estudio con una red de 40 x 40 m
data(meuse.grid)

# definir las coordenadas (volver el dataframe un objeto espacial)
coordinates(meuse.grid) = c("x", "y")
# definir que el objeto es un grid regular
gridded(meuse.grid) = TRUE

#  Graficvar todas las variables - spplot grafica datos espaciales con atributos
  # El objeto a graficar es el GRID creasso con la parte
  # el archivo grid contiene los datos de tipo de suelo, frecuencia d inundación
  # separación en dos partes y distancia al río
spplot(meuse.grid, col.regions=bpy.colors(), main = "meuse.grid",
       sp.layout=list(
         list("sp.polygons", meuse.sr),
         list("sp.points", meuse, pch="+", col="black")
       )
)

######################################################################
######################## Recomendaciónes básicas #####################
######################################################################


# Hay varios tipos de ráster (Ver ?`RasterStack-class`)
  # RasterLayer -> Un ráster, apuntar a un archivo en disco o colocarlo en memoria
  # RasterStack -> Colección de ráster layers con misma resolución y extensión
  # RasterBrick -> Junta los Stacks en un único layer, es menor flexible y más rápido

# Al escribir funciones es útil colocar Warnings de clase de ingreso, evitando un crash
# e informando al usuario del error 

# warning("pilas wn!!!)

# Try() evita errores y de existir devuelve "try-error"
  # a <- try(1-"f", silent = TRUE)
  # class(a)  ---> "try-error"

# Para debuggear
  # traceback()
  # debugonce(funcion)



