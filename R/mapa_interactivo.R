##################################################################
########### Visualización de perfil temporal de un pixel##########
##################################################################

########## Cargar paquetes requeridos ##############
library("tidyverse")
library("raster")
library("spatstat")
library("rgeos")
library("zoo")
library("maptools")


# Definir el directorio de trabajo
setwd("C:/Users/GONZALO/Dropbox/00_Veolia_Santa_Marta/06_R")

# descargar un archivo preparado para el ejemplo
# El formato es RDA (RData) asignaar la información directamente
# es más facil con RDS
download.file(url = 'https://raw.githubusercontent.com/loicdtx/bfastSpatial/master/data/tura.rda', destfile = 'tura.rda', method = 'auto')
load('tura.rda')

# USa la función click que pertenece al paquete Raster y se usa para obtener los valores de 
# un ráster o un objeto espacial (Adicionalmente puede entregar coordenadas y número de celda)
# para SpatialLines y SpatialPoints se requieren dos clicks (pintar un recuadro)
click2ts <- function(x) {
    # con click estraigo e valor de NDVI y con getZ extraigo los tiempos 
    # al momento no se como dejar el NDVI con varianza temporal
  val <- click(x, n = 1)
  z <- getZ(x)
    #Plor de paquete base
  plot(zoo(t(val), z), type = 'h', pch = 20, xlab = 'Time', ylab = 'NDVI (-)')
}

# pintar el ráster y activar la función
plot(tura,1)
click2ts(tura)

#################################################################################
########### Segundo Ejercicio - Evolucipon temporal de var. Geográfica ##########
########### Segundo Ejercicio - Error con los datos de origen ######## ##########
########### Segundo Ejercicio - GENERAR NUEVOS DATOS PARA COLOMBIA ##################
################################################################################

# Descargar la inormación de a URL del curso WUR Geoscripting
# los datos son una serie de datos de MODIS VCF con el porcentaje
# de cobertura de arboles en Holanda

download.file(url = 'https://raw.githubusercontent.com/GeoScripting-WUR/Scripting4Geo/gh-pages/data/MODIS_VCF_2000-2010_NL.rds', 
              destfile = "MODIS_VCF_2000-2010_NL.rds", method = 'auto')

# Leer la informaci´pn
modis <- readRDS("MODIS_VCF_2000-2010_NL.rds")

# En los datos si el valor es superior a 100 corresponde a cuerpos de agua
# se eleminan estos datos con una selección similar a un DF
modis[modis > 100] <- NA

# el ,1 es para indicidar que solo se grafica el último periodo, no olvidar
# que es una información temporal.
plot(modis,1)

# Seleccionar una zona para el estudio usando la herramienta EXTENT
# del paquete raster, pilas primero x1 y x2, luego y1 y y2

e <- extent(340101, 370323, 5756221, 5787772)
plot(e, add = TRUE)

# LA herramienta crop retorna un subconjunto geográfico de un objeto dentro
# de un bjeto de la clase Extent
modis_sub <- crop(modis, e)
plot(modis_sub, 1)

# definir una función para calcular las tendencias temporales
  # se ingresa un valor después se usa calc para aplicarla sobre un raster
  # completo
temp_tend <- function(x) {
   # Definir las series temporales del objeto RDS
    # aparenta tener un objeto con una fila de fecha y otra de cobertura
    # VCF es Vegetation Continuous fields
  ts <- zoo(x, time)
    # definir como data frame la fecha
      # decimal_date convierte la fecha en un decimal del año
      # index devuelve la fecha del PPP "ts"
      # el campo VCF es una serie concatenada de los VCF históricos
  df <- data.frame(t = decimal_date(index(ts)), vcf = c(ts))
  
    # hacer una regresión lineal entre VCF y el tiempo y devolver la pendiente
  out <- try(lm(vcf ~ t, data = df)$coefficients[2], silent = T)
    # Si devuve un error, utilizar NA en lugar de generar error
  if(class(out) == 'try-error')
    out <- NA
  return(out)
}

# Correr la función

resultado <- calc(x = modis_sub, fun = temp_tend)

# Ver el output

plot(resultado)
hist(resultado, 
     main = 'Cambio de cobertur 250 m resolution (2000-2010)', 
     xlab = 'Cambio Porcentual')

