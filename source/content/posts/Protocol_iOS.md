---
title: "Uso básico de protocolos para comunicar 2 vistas en iOS"
date: 2018-03-14T15:53:12Z
draft: false
---
<p align="justify">
En muchas ocasiones nos vemos en la necesidad de establecer una comunicación entre 2 controladores, podemos utilizar los segues para compartir información entre controladores o vistas, pero esta comunicación es solo en un sentido( 1er controlador hacía el 2do controlador) qué pasaría si necesitamos compartir información desde el 2do controlador hacía el  1er controlador?? tendríamos que establecer otro segue en sentido contrario y si queremos comunicarnos con otros controladores tendrías que establecer más segues y de esa forma nuestro StoryBoard se llenaría de segues. Este problema podemos solucionarlo con el uso de los Protocolos. </p>

### Comencemos a construir nuestro ejemplo.
<p align="justify">
Crearemos un nuevo proyecto en xCode, en mi caso lo llamaré ProtocolDemo y en nuestro StoryBoard a parte del VIewController que se genera por default al crear el proyecto, debemos de arrastrar un TableViewController(para mostrar la lista de nuestros colores) y entre ellos estableceremos un segue desde el VIewcontroller hacia el TableViewController para establecer la navegabilidad. Por último a nuestro UIViewController le asignamos un UINavigationController y al nuestro segue le asignamos un identificador de tal forma que nuestro StoryBoard quedará de la siguiente forma: </p>

![Default Image](../Protocols/initialStoryBoard.png)

**Nota:** No olvidar de generar un UITableViewCOntroller para nuestra tabla.
<p align="justify">
Hasta este punto ya tenemos nuestros 2 controladores conectados, pero necesitamos un botón para poder pasar de la primera vista hacía la segunda y así terminar de establecer la navegabilidad para ello haremos uso de un Bar Button Item y lo colocaremos en el lado derecho del Navigation Item de nuestro ViewController y se asignará como Right Bar Button, por último debemos de asignarle una acción a nuestro Bar Button e indicarle que haga uso del segue para la navegación hacia nuestra tabla, es algo tan simple como el siguiente código: </p>

```
@IBAction func goColorsTable(_ sender: Any) {
     // withIdentifier = identifer que se le colocó al segue.
     performSegue(withIdentifier: "goSelectColor", sender: self)
}
```
<p align="justify">
listo, ya hemos establecido totalmente la navegavibilidad entre nuestras 2 vistas ahora necesitamos configurar nuestra tabla para que muestre nuestra lista de colores, es una configuración básica: </p>

```
class ColorsTableViewController: UITableViewController {

    let colorsList = ["Rojo", "Amarillo", "Azul", "Verde"]
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colorsList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = colorsList[indexPath.row]

        return cell
    }
}
```
<p align="justify">
Si ejecutas la aplicación podrás notar que la navegabilidad funciona muy bien y que en la tabla se muestra nuestra lista de colores, pero aún no hemos asignado ninguna acción cuando seleccionamos algún elemento de la lista. No es posible modificar directamente el color del background de nuestra primera vista, necesitamos de un enlace que nos permita ejecutar funciones o modificar elementos de nuestra primera vista desde la segunda vista y es en donde haremos uso de protocolos.</p>

### Generamos nuestro protocolo.
<p align="justify">
Es una buena práctica declarar el protocolo en el controlador en el que se realizará la acción, en nuestro caso será en el ViewController ya que es en esta vista en donde se modificará el color del background. Dentro de nuestro protocolo declararemos la función que modificará el background de la vista, pero solo lo declararemos mas no lo desarrollaremos.</p>

Definir un protocolo es tan sencillo como: 
```
protocol FirstControllerDelegate: class {
    func changeBackgraound(indexColor: Int)
}
```
**Nota:** Tener en cuenta que la declaración se realiza fuera de la clase del controlador.

### Ahora desarrollaremos nuestro protocolo.
<p align="justify">
Un protocolo puede ser visto como un contrato que se establece entre el protocolo y la clase que adopta este protocolo y en el cual la clase se ve obligada a implementar todas las funciones declaradas dentro del protocolo, aunque existen funciones opcionales pero ese ya es un tema avanzado de protocolos que lo tocaremos en otro momento. Para nuestro ejemplo realizaremos una extensión de nuestro ViewController en la cual adoptaremos el protocolo que hemos creado y en ella desarrollaremos la función del protocolo.</p>

```
extension ViewController: FirstControllerDelegate {
    func changeBackgraound(indexColor: Int) {
        switch indexColor {
        case 0:
            self.view.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        case 1:
            self.view.backgroundColor = #colorLiteral(red: 0.9368221164, green: 0.9953032136, blue: 0, alpha: 1)
        case 2:
            self.view.backgroundColor = #colorLiteral(red: 0.05784124881, green: 0.03156668693, blue: 0.9577758908, alpha: 1)
        case 3:
            self.view.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        default:
            self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
}
```
<p align="justify">
ya hemos desarrollado la función de nuestro protocolo, como podemos ver nuestra función cambiará el color de nuestro background dependiendo del valor del parámetro que le enviemos, pero ahora cómo podemos ejecutar esa función desde el controlador de nuestra tabla?. En realidad esa función se puede ejecutar desde cualquier controlador, lo único que necesitamos es declarar una variable (del tipo de nuestro delegado) en el controlador que disparará la acción a ser realizada por la función del protocolo, en nuestro caso declararemos una variable, pero tiene que ser weak var y optional, en nuestro ColorsTableViewController de la siguiente manera:
</p>

```
weak var firstViewDelegate: FirstControllerDelegate?
``` 
<p align="justify">
Pero ¿Cómo ejecuto la función desarrollada en el controlador de la primera vista?, pues es muy fácil. Lo que nosotros queremos es que el background de la primera vista cambie según la opción que selecciones en nuestra tabla, en ese caso ejecutaremos la función de nuestro protocolo en la función  "tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)" de nuestra tabla ya que esa función responde cuando hacemos touch en alguna de las celdas de nuestra tabla y nos notifica el índice de la celda que está interactuando con el usuario y ese índice es el que vamos a enviar por el parámetro del delegado.</p>

```
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        firstViewDelegate?.changeBackgraound(indexColor: indexPath.row)
        navigationController?.popViewController(animated: true) // para que vuelva a la vista anterior después de seleccionar alguna opción de nuestra lista
    }
```
<p align="justify">
De esta manera le estamos diciendo a nuestra tabla, que modifique el background de nuestra primera vista a través del protocolo "FirstControllerDelegate". Pero si ejecutamos nuestra aplicación e intentamos modificar el background de nuestra primera vista a través de nuestra tabla, nos daremos cuenta que aún no se modifica a pesar de que estamos "ejecutando la función de nuestro delegado" porqué sucede ello??, acaso el delegado no funciona?. Tranquilos todo el desarrollo de nuestro ejemplo es correcto pero para que nuestro variable (de tipo de nuestro delegado) declarado en el controlador de nuestra tabla pueda ser atendido por el controlador de nuestra primera vista, necesita los permisos necesarios y para ello nos apoyaremos en el segue y de de la función "prepare(for segue: UIStoryboardSegue, sender: Any?)" </p>

```
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "goSelectColor" {
        guard let controller = segue.destination as? ColorsTableViewController else {
                return
         }
         //Establecemos "los permisos mediante el self"
         controller.firstViewDelegate = self
    }
 }
```
<p align="justify">
Con la función anterior nuestro ejemplo se encuentra completo, hemos logrado actualizar/ejecutar funciones que se encuentran desarrolladas en un controladores desde otro controlador. En proyectos reales vas a necesitar mucho de los protocolos, nosotros solo hemos tocado una pequeña parte de su potencial para que se entienda cómo es que funcionan pero en realidad con los protocolos se pueden realizar cosas más avanzadas, pueden ahondar en el tema de los protocolos investigando sobre la programación orientada a protocolos, Apple ha utilizado bastante los protocolos en el desarrollo de Swift lo puedes notar en los delegados de los TableViewContoller, UITextField, UIScrollView, entre otros.</p>

Con ello hemos llegado al final del artículo, espero que haber podido ayudarlos a entender la base de cómo funciona un protocolo y en qué situaciones podemos utilizarlos para que nos faciliten la vida, el ejemplo completo pueden revisarlo en el siguiente enlace [Protocolos en iOS](https://github.com/Gerrard12/Protocols-iOS) 