---
title: "AnimationTableView"
date: 2018-02-21T15:38:07Z
draft: false
---
# Cómo presentar los elementos de tu tableView como cards?
<p align="justify">
Con la llega del iPhone X y con el reciente comunicado de apple en el que informa que a partir de abril no se aceptarán aplicaciones que no se encuentren optimizadas para la pantalla del iphone X, nos podemos dar cuenta de que la tendencia de apple es de priorizar y dar mayor soporte a los dispositivos con pantalla más amplia. Ahora nosotros como desarrolladores qué podemos hacer con una pantalla más amplia?, seguiremos utilizando imágenes, fuentes, íconos del mismo tamaño y desaprovechar el nuevo tamaño de las pantallas? o podemos aprovechar ese "espacio extra" para mejorar la interface de nuestras aplicaciones, mejorar la experiencia del usuario y desarrollar aplicaciones no tan "planas". Algunas aplicaciones están aprovechando este espacio extra para presentar la información de una manera no tan "plana" utilizando el estilo de cards, una de estas aplicaciones es Lineo que ha rehecho toda su interface y lo ha adaptado pensando en el nuevo tamaño de las pantallas, otro claro ejemplo es la presentación de las aplicaciones en el Appstore.
</p>

![Default Image](../AnimationTableView/AppStore.png)

Crear aplicaciones con este estilo no es nada complicado, todo se maneja a través del Nib de un TableViewCell en el que se configura toda la presentación de la celda.

## Comenzemos a constuir nuestro Card
<p align="justify">
Crearemos un nuevo proyecto en xCode, eliminamos el View Controller que se genera por defecto en el Main.storyboard y en su lugar colocaremos un Table View Controller. Luego de ello crearemos nuestro xib que es donde configuraremos nuestra celda, para crear nuestro xib debes de hacer click derecho en el Bundle de tu proyecto y seleccionar la opción New File -> Cocoa Touch Class -> Next , luego deberás asignarle un nombre  a tu clase y en la opción Subclass deberás seleccionar que la clase sea de tipo: UITableViewCell y marcar la opción : Also create XIB FIle para que se genere la interface.</p>

![Default Image](../AnimationTableView/XibCell.png)
<p align="justify">
Podemos en nuestro bundle del proyecto, que se han generado 2 archivos uno de ellos es el controlados (.swift) y el otro es nuestra interface (.xib), ahora trabajaremos en la interface.</p>

### Contruyendo nuestra interface (.xib)

Para nuestro ejemplo trabajaremos con una imágen y el título de la imagen.

* Para nuestra imágen colocaremos los siguientes constraints con respecto al contenedor:

![Default Image](../AnimationTableView/ConstraintsImage.png)

* Para nuestro título (Label) colocaremos los siguientes constraints respecto al contenedor:

![Default Image](../AnimationTableView/BottomLabel.png)

![Default Image](../AnimationTableView/HorizontallyConstraintLabel.png)
<p align="justify">
* Ahora necesitamos un UIView para lograr el efecto del card, pero este UIView no debe de contener la imagen ni el label y le asignamos los mismos constraints que a la imagen. De esta manera tenemos nuestra vista organizada de la siguiente manera:</p>

![Default Image](../AnimationTableView/CardView.png)

**Nota:** Ahora ya tenemos nuestra interface lista y podemos configurar los elementos para otorgarle el aspecto de card.

### Configurando nuestros elementos para dar el efecto de Card.
<p align="justify">
Nos ubicamos en el controlador de nuestro xib, en mi proyecto se llama CardsCell.swift. Realizamos las conexiones de los elementos gráficos de nuestra interface y en la funcion awakeFromNib(), procedemos a configurarlos de la siguiente manera:</p>

```
override func awakeFromNib() {
    super.awakeFromNib()
    imageCard.layer.masksToBounds = true
    viewCard.layer.masksToBounds = false
    viewCard.layer.cornerRadius = 8.0
    imageCard.layer.cornerRadius = 8.0
    viewCard.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
    viewCard.layer.shadowOffset = CGSize(width: 0, height: 0)
    viewCard.layer.shadowOpacity = 0.8
}
```
<p align="justify">
Ya tenemos configurado nuestra celdas con el aspecto de card, ahora realizamos una configuración básica del controlador del Table View Cell con las siguientes líneas:</p>

```
class CardTableViewController: UITableViewController {

    let nameImages = ["elefante", "oso", "panda", "perro", "tigre"]
    let titlesCards = ["Elefante", "Oso", "Panda", "Perro", "Tigre"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CardsCell",bundle: nil), forCellReuseIdentifier: "CardsCell")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = Bundle.main.loadNibNamed("CardsCell", owner: self, options: nil)?.first as? CardsCell else {
            fatalError("No se pudo cargar el nib")
        }
        cell.imageCard.image = UIImage(named: nameImages[indexPath.row])
        cell.labelCard.text = titlesCards[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }

}

```

Ejecutamos nuestro proyecto y listo!!!, lo logramos ya tenemos nuestra interface con el aspecto de cards:

![Default Image](../AnimationTableView/CardFinal.png)

Hasta ahora hemos logrado nuestro cometido, pero que tal si implementamos una animación al momento de presentar los cards?, las siguientes líneas de código otorgarán el efecto de que los cards se cargan de abaja hacia arriba logrando una presentación no tan "plana".

```
func animateTable() {
    tableView.reloadData()
    let cells = tableView.visibleCells
    let tableHeight: CGFloat = tableView.bounds.size.height
    for i in cells {
        let cell: UITableViewCell = i as UITableViewCell
        cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
    }
    var index = 0
    for a in cells {
        let cell: UITableViewCell = a as UITableViewCell
        UIView.animate(withDuration: 3.0, delay: 0.50 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .transitionFlipFromBottom, animations: {
             cell.transform = CGAffineTransform(translationX: 0, y: 0);
        }, completion: nil)
            
        index += 1
     }
}
```

La función declarada líneas arriba debemos de ejecutarla en la función viewWillAppear():

```
override func viewWillAppear(_ animated: Bool) {
     animateTable()
}
```

Listo, ya conseguimos nuestro nuevo efecto y con ello damos por concluído este artículo.

![Default Image](../AnimationTableView/AnimationTable.gif)

El proyecto completo puedes encontrarlo en : [TableViewCell like Cards](https://github.com/Gerrard12/AnimationCardsTableView)

