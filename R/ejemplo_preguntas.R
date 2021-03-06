#################################################################
############ Manteniendo control de versiones--- ################
#################################################################

# Seleccionar el ddirectorio para el WS
setwd("~/GitHub/WUR_ejercicios")

# Recordar que las funciones se pueden traer a partir source(CCC)
# la idea es que el archivo MAIN llame a los dem�s dentro de la carpeta
# R

# Cargar paquetes para generar un ejemplo reproducible referente a 
# an�lisis espacial
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

# En ocasiones en lugar de generar peque�os datasets, es �til usar
# conjuntos de "data" (R Built in DS)

# Importar datos de la variable "cars"
# Datos de 1920 relacionando velocidad de carros y a distancia que
# les tom� detenerse.
data(cars)

# Importar datos del dataset "meuse"
# Este dataset tiene localizaciones y concentraci�n de metales pesados en 
# la superfiie, con algunas variables de tipo de suelo, recopiladas en la
# llanura de inundaci�n del river Meuse en Stein (Holanda)
# Para usar meuse es necesario tener en el WS el paquete "sp"

data("meuse")

# la herramienta coordinates sirve para definir coordenadas espaciales de un 
# objeto espacial, si el objeto era un data frame se convierte en un DF espacial

coordinates(meuse) <- c("x","y")

# La funci�n Bubble esta definida dentro del paquete "sp" crea burbujas de datos espaciales
# key.entries sirve para definir los valores que van a ser colocados en los labels

bubble(meuse, "zinc", maxsize = 2.5,
       main = "zinc concentrations (ppm)", key.entries = 2^(-1:4))


######################################################################
############ Crear un segundo set de datos espaciales ################
######################################################################

# cargarla matriz
# La informaci�n es un per�metro del r�o alrededor del dataset
data(meuse.riv)

# Crear un pol�gono espacial a partir de la matriz (son 176 parejas ordenadas)

  # Primerro se crea un pol�gono desde el paquete sp - usa los puntos en orden.
  # Luego saco el objeto usando la herrmaienta list del paquete "base"
  # El objeto listado se define coordenadas espaciales usando polygons, queda como un 
  # pol�gono dentro de otro -- a priori_
  # Spatial polygons crea los pol�gonos espaciales
meuse.sr <- SpatialPolygons(list(Polygons(list(Polygon(meuse.riv)),"meuse.riv")))


# Crgar datos adicionales
# tiene 3103 filas y 7 columnas que cubren el �rea de estudio con una red de 40 x 40 m
data(meuse.grid)

# definir las coordenadas (volver el dataframe un objeto espacial)
coordinates(meuse.grid) = c("x", "y")
# definir que el objeto es un grid regular
gridded(meuse.grid) = TRUE

#  Graficvar todas las variables - spplot grafica datos espaciales con atributos
  # El objeto a graficar es el GRID creasso con la parte
  # el archivo grid contiene los datos de tipo de suelo, frecuencia d inundaci�n
  # separaci�n en dos partes y distancia al r�o
spplot(meuse.grid, col.regions=bpy.colors(), main = "meuse.grid",
       sp.layout=list(
         list("sp.polygons", meuse.sr),
         list("sp.points", meuse, pch="+", col="black")
       )
)

######################################################################
######################## Recomendaci�nes b�sicas #####################
######################################################################


# Hay varios tipos de r�ster (Ver ?`RasterStack-class`)
  # RasterLayer -> Un r�ster, apuntar a un archivo en disco o colocarlo en memoria
  # RasterStack -> Colecci�n de r�ster layers con misma resoluci�n y extensi�n
  # RasterBrick -> Junta los Stacks en un �nico layer, es menor flexible y m�s r�pido

# Al escribir funciones es �til colocar Warnings de clase de ingreso, evitando un crash
# e informando al usuario del error 

# warning("pilas wn!!!)

# Try() evita errores y de existir devuelve "try-error"
  # a <- try(1-"f", silent = TRUE)
  # class(a)  ---> "try-error"

# Para debuggear
  # traceback()
  # debugonce(funcion)



