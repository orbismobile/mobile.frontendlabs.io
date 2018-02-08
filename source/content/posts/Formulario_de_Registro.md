---
title: "Formulario de Registro"
date: 2018-01-30T16:31:49Z
draft: false
---

# ¿Cómo crear un formulario de registro utilizando Scroll View?
<p align="justify">
Por lo general cuando generamos un formulario de registro son varios los campos necesarios (entre campos obligatorios y requeridos) y el tamaño de algunos iPhones (SE, 5, entre otros) no es lo suficientemente alto como para poder mostrar todos los campos y su(s) respectivo(s) botón(es), en consecuencia algunos campos no se podrán ver o se verán superpuestos.</p>
<p align="justify">
Una de las soluciones, tal vez la más rápida, podría ser implementar el formulario mediante el uso de un UITableView ya que te permite el manejo de su propio ScrollView y no tendrías problemas con el tamaño del iPhone sea cual sea. Pero nos encontramos con un problema ya que en un TableView al realizar scroll el dequee de las celdas se recargan y perderás los datos ingresados en las primeras celdas, ello podrías solucionarlo guardando tus datos en un arreglo pero si el usuario modifica los datos de algunos campos tendrías que realizar demasiadas validaciones y tú código se volvería demasiado pesado con líneas innecesarias.</p>
<p align="justify">
Otra de las soluciones, y es con la que vamos a trabajar nuestro ejemplo, es implementar el formulario utilizando un Scroll View como contenedor de todos los campos (pueden ser UIVIews, TextFields, o lo que prefieras), adicional a ello te sugiero que los campos, botones, imagenes u otros componentes que pueda presentar tu formulario los manejes mediante el uso de Stack Views (créeme te facilitará la vida).</p>

Expuesto lo anterior comencemos a desarrollar nuestro ejemplo, en este punto ya hemos creado nuestro proyecto, en mi caso se llama: RegisterForm 

### Empecemos a diseñar nuestro storyboard

**Nota:** Asignaremos un color al background de  nuestro storyboard para que se puedan distinguir los elementos

#### Paso 1. Arrastremos 6 UIViews hacia nuestro View Controller:

![Default Image](../RegisterForm/UIViewController.png)

#### Paso 2. Colocamos los 6 UIViews dentro de un StackView y le asignamos los constraints:

![Default Image](../RegisterForm/StackView.gif)

#### Paso 3. Ahora agregamos 2 botones a nuestro View Controller, los colocaremos dentro de un StackView y se asignaremos constraints:

![Default Image](../RegisterForm/Buttons.gif)
<p align="justify">
* Ahora asignaremos a nuestros botones un color de Background y notaremos que se superponen con el último UIView de nuestro 1er stackView, pero lo solucionaremos con el Scroll View.</p>

![Default Image](../RegisterForm/Storyboard.png)

#### Paso 4. Agregaremos el Scroll View
<p align="justify">
Para agregar el Scroll View no lo realizaremos arrastrando desde storyBoard, en su lugar haremos uso de la ayuda que nos proporciona el xCode. Para ello seleccionamos los elementos que deseamos que se encuentren dentro del Scroll View y nos dirigimos a la siguiente ruta:</p>

![Default Image](../RegisterForm/addScrollView.png)
<p align="justify">
Luego de ello ya tendremos nuestro Scroll View con todos los elementos adentro del mismo, pero el Xcode nos notificará que tenemos problemas con los constraints ello lo solucionaremos seleccionando nuestro Scroll View y aceptando las recomendaciones de constraints que nos indica el Xcode:</p>

![Default Image](../RegisterForm/ConstraintsScrollView.gif)
<p align="justify">
**Nota:**Si cuando agregaste el Scroll View, alguno de los Stacks Views pierde algún constraint simplemente vuelvelos a agregar. En mi caso el Stack View de los botones perdió el constraint **Trailing** pero lo volví a agregar y se solucionó el problema.</p>

![Default Image](../RegisterForm/ScrollViewFinish.png)
<p align="justify">
Aún vemos que el botón "Registrarme" se superpone con el último campo , ello lo solucionamos a continuación modificando uno de los constraints que se generaron cuando aceptamos los constraints sugeridos por xCode.</p>

#### Paso 5. Modificamos los constraints generados por el Scroll View
<p align="justify">
5.1 En nuestro ejemplo se generó un constraint entre el Stack View de los botones y el Scroll View, es por ello que los botones se siguen superponiendo al último campo. Eliminemos ese constraint y en su lugar generemos un nuevo constraint entre ambos Stack Views (vertical spacing)y le asignaremos una distancia de 50.</p>

![Default Image](../RegisterForm/UpdateConstraint.gif)
<p align="justify">
Ya tenemos nuestro formulario terminado, pero son solo UIViews y nosotros necesitamos TextFields para que el usuario pueda ingresar sus datos. Adicional a ello y para no tener problemas con el teclado (en ocultar los campos o los botones) utilizaremos el siguiente pod: [IQKeyboardManager](https://github.com/hackiftekhar/IQKeyboardManager) que en conjunto con nuestro ScrollView manejarán de la mejor forma los constraints cuando el teclado este visible.</p>
<p align="justify">
5.2 A nuestro ejemplo le agregaremos Texfields, cornerRadius a los UIViews(5 ptos) y finalmente ejecutamos nuestra aplicación y tendremos como resultado nuestro formulario terminado:</p>

![Default Image](../RegisterForm/RegisterForm.png)

#### ¿Cómo podemos mejorar nuestro formulario?
<p align="justify">
Como podemos ver en esta última imagen, nuestros botones siempre estarán a una distancia fija(50 ptos) de nuestros campos, pero cómo podríamos lograr que los botones se encuentren siempre en la parte baja de nuestra pantalla sin importar el tamaño de nuestro dispositivo?, pues bastaría con asignar una distancia variable entre los botones y para calcular dicha distancia nos bastaría con el siguiente cálculo matemático :</p>

```
X: Distancia a calcular entre Stack View de campos y Stack View de botones.
a: Alto de Scroll View.
b: Alto de Stack View de campos.
c: Alto de Stack View de botones.
d: Distancia entre Stack View de campos y el top del Scroll View.
e: Distancia entre Stack View de botones y el bottom del Scroll View.
X = a - (b+c+d+e)
```
<p align="justify">
Aplicado a nuestro ejemplo nos resultaría la siguiente operación, teniendo en cuenta que el valor que varía es el alto del Scroll View ya que depende del tamaño de cada pantalla.</p>

```
X: Distancia a calcular entre Stack View de campos y Stack View de botones.
a: Alto de Scroll View.
b: 410
c: 110
d: 20
e: 20
X = a - 560
```

Este cálculo lo realizaremos en la funcion viewWillAppear(_ animated: Bool) de nuestro controlador para que pueda realizar el cálculo de la distancia antes de mostrar en pantalla nuestros elementos:

```Swift
override func viewWillAppear(_ animated: Bool) {
  // mainScrollView.frame.size.height: Alto de Scroll View
  // distanceStackViews.constant: Distancia a calcular entre Stack View de campos y Stack View de botones
  distanceStackViews.constant = mainScrollView.frame.size.height - 560
    }
```
<p align="justify">
Con el cálculo de la distancia entre los Stack Views, nuestros botones siempre se encontrarán a una distancia fija de 20 puntos de la base de la pantalla sea cual sea el tamaño de la misma. Nuestro formulario quedará de la siguiente manera:</p>

![Default Image](../RegisterForm/FinalRegisterForm.png)
<p align="justify">
Y con esto hemos llegado al final de nuesro ejemplo de cómo crear un formulario de registro con Scroll View, no es nada complicado y el 90% lo puedes realizar mediante storyboard sin necesidad de escribir nada de código, y si quieres personalizarlo un poco te bastará con unas líneas de código y listo!! tendrás tu formulario a la medida de todos los tamaños de los iPhones.</p>

Pueden encontrar el ejemplo completo en el siguiente enlace [Formulario de registro](https://github.com/Gerrard12/Registre-Form) 
