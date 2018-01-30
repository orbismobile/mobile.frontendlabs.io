---
title: "DesignOfApplicationsForTablets"
date: 2018-01-29T16:52:05Z
draft: false
---
![image](../designOfApplicationsForTablets/header.png)

En este articulo trataremos el diseño y la adaptación de aplicativos móviles en tablets, ya que toda aplicación android se ejecuta en
distintos dispositivos que ofrecen diferentes tamaños  y densidades por lo que contemplar un  solo diseño para nuestra aplicación y dejar que éste se adapte
a todos los dispositivos donde se instale resulta muy complicado y podría provocar una mala experiencia de usuario al interactuar 
con la aplicación.

> Además, ten en cuenta que este articulo de diseño es soportada desde Android 3.2 en adelante, ya que se presentaron API nuevas que te permiten controlar de un modo más preciso los recursos de diseño empleados por tu aplicación para diferentes tamaños de pantallas. Estas funciones nuevas son especialmente importantes si desarrollas una aplicación optimizada para tablets.

# Términos y Conceptos
Con la finalidad de poder comprender algunos términos y conceptos que son usados 
en este articulo y la API que nos proporcional Google, nombrare algunos que debes de conocer antes de comenzar.

* ***Tamaño de pantalla:*** Tamaño físico real para cuya medición se considera la diagonal de la pantalla.
* ***Densidad de pantalla:*** Cantidad de píxeles dentro de un área física de la pantalla.
* ***Orientación:*** Orientación de la pantalla desde el punto de vista del usuario. Es horizontal(Landscase) o vertical (Portrait).
* ***Pixeles independientes de densidad(dp)***:  Unidad de pixeles virtuales al definir el tamaños de diseño de la UI (para definir tamaño de texto usar sp).

# Cómo admitir pantallas múltiples
Como desarrolladores tenemos que tener en cuenta los siguientes puntos, al momento de poder incorporar múltiples pantallas a nuestra aplicación

## 1. Declara en el manifest de forma explicita los tamaños de pantalla que admite tu aplicación
    
[El modo de compatibilidad de pantalla](https://developer.android.com/guide/practices/screen-compat-mode.html) presenta 2 versiones, la **Versión 1** esta obsoleta (Android 1.6 - 3.1) y la **Versión 2** se aplica cuando no se ha implementado las técnicas de pantallas múltiples para diferentes tamaños de pantalla. En otras palabras al trabajar con el modo de compatibilidad de pantalla, se redimensionara el único **layout** disponible para las diferentes pantallas, actualmente no es recomendable trabajar bajo este modo  ya que visualmente no es tan atractivo para el usuario.
    
## 2. Proporciona diseños diferentes para diferentes tamaños de pantalla:

En esta sección ya no haremos uso de los tradicionales calificadores de tamaño(small, normal,large, xlarge) ya que a partir de android 3.2 la documentación oficial recomienda utilizar los calificadores de tamaño `sw<N>dp`, para definir el ancho mínimo disponible que tus recursos de diseño requieran.
    
**Ejemplos de configuración:**

Con el propósito de ayudarte a alcanzar algunos de tus diseños para diferentes tipos de dispositivos, a continuación se ofrecen algunos números para los anchos típicos de la pantalla:

    - 320 dp: una pantalla típica de teléfono (240 x 320 ldpi, 320 x 480 mdpi, 480 x 800 hdpi,etc).
    - 480 dp: una tablet tweener como Streak (480 x 800 mdpi).
    - 600 dp: una tablet de 7” (600 x 1024 mdpi).
    - 720 dp: una tablet de 10” (720 x 1280 mdpi, 800 x 1280 mdpi, etc).

Una vez que llegaste a este punto, pasaremos a la práctica para realizarlo de la manera correcta en el *IDE Android Studio* , manos a la obra :muscle: :muscle: !! 

## 2.1 Técnica de pantallas múltiples

**a) Crear el archivo XML para el Layout especifico:**
Nos situaremos en la carpeta *Layout* especifico para poder generar el XML adaptable

![image](../designOfApplicationsForTablets/img1.png)

**b) Aplicaremos algún calificador de tamaño**
 Se podría elegir cualquier de los 3 calificadores de tamaño: `sw<600>dp`, `w<600>dp`, `h<600>dp`, eso dependerá según el criterio que se le quiera establecer por ejemplo: `layout-sw600dp`, donde le decimos a android que este layout será para una pantalla cuyo ancho y alto sea mayor o igual a 600 dp (Tablet 7''). 

 ![image](../designOfApplicationsForTablets/img2.png)

**c) Aplicaremos otra característica**
 Se puede incluir el **Screen Orientation**, el cual puede ser portrait o landscase, todo dependerá de las características que busque el desarrollador para el layout.

 ![image](../designOfApplicationsForTablets/img3.png)


**Resultado:**
![image](../designOfApplicationsForTablets/img4.png)

 El `layout-sw600dp-land` representa para android un layout para una pantalla cuyo ancho y alto sea mayor o igual a 600 dp (Tablet 7'') y en orientación landscase (horizontal).
 
 >**Nota**:Usted puede personalizar a gusto los layout para smartphone y tablet, pero tener en consideración que si esta vinculando algún componente a travéz de `findViewById(R.id.component)` no lo puede eliminar en ninguno de los layout creados, de lo contrario lanzará una exception de tipo RosourceNotFountException.

## 3. Proporcionar diferentes elementos de diseño del mapa de bits para diferentes densidades:
Con respecto a los tipos de densidades , android admite las siguientes tipos.
    
    - ldpi (baja) ~120 dpi
    - mdpi (media) ~160 dpi
    - hdpi (alta) ~240 dpi
    - xhdpi (extraalta) ~320 dpi (Se agregó a partir de API 8) 
    - xxhdpi (extra extraalta) ~480 dpi (Se agrego a partir de API 16)
    - xxxhdpi (extra extra extraalta) ~640 dpi
Según las estadísticas, si creamos una aplicación cuyo **API Level mínimo** sea el 16, abarcara el 99.2% de dispositivos
donde poseen una densidad mayor o igual a mdpi en su mayoria(90% hdpi - 10% mdpi)por lo que incorporar una imagen cuya densidad sea ldpi-120 dpi no tendría ningún sentido.

![image](../designOfApplicationsForTablets/img6.png)


# Bibliografía:

- https://developer.android.com/guide/practices/screen-compat-mode.html 

- https://developer.android.com/guide/practices/screens_support.html#support

- https://material.io/guidelines/layout/responsive-ui.html#responsive-ui-patterns

- https://developer.android.com/guide/topics/resources/providing-resources.html#AlternativeResources