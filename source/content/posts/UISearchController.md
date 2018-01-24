---
title: "¿Cómo usar un UISearchController con su ResultViewController?"
date: 2018-01-16T17:03:57Z
draft: true
---

# ¿Qué es un UISearchController?

Es un componente que nos ayuda a mostrar de una manera adecuada los resultados de busqueda de un usuario.

![](https://github.com/erikfloresq/UISearchControllerDemo/blob/master/UISearchView.gif)

# Implementando un UISearchController

Primero vamos a declarar un ViewController donde mostraremos los resultados de busqueda al cual llamaremos ResultViewController, para mi ejemplo cree un ViewController en el storyboard y le agrege un indetificador para poder utilizarlo

```swift
    // Usamos lazy para cargarlo en memoria cuando lo necesitemos
    lazy var resultViewController: UIViewController = {

        // Llamamos al Storyboard donde esta mi ViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        // Instancio al ViewController usando el identificador que le asigne
        let resultView = storyboard.instantiateViewController(withIdentifier: "ResultsViewController")

        // Valido si la instancia es de la clase ResultsViewController la cual usaré para mostrar los resultados
        guard let resultViewController = resultView as? ResultsViewController else {
            fatalError("Problems with viewController")
        }
        return resultViewController
    }()
```

Luego voy a crear una instancia del UISearchController y realizar la personalizacion que deseamos

```swift
    lazy var searchController: UISearchController = {

        // Creamos la instancia y le asignamos el ViewController donde vamos a mostrar los resultados (el ResultViewController lo creamos anteriormente)
        let searchController = UISearchController(searchResultsController: resultViewController)

        // Vamos a mostra una vista oscura con alpha al momento de usar el buscador
        searchController.dimsBackgroundDuringPresentation = true

        // Ocultamos el NavigationBar cuando se muestra el buscador
        searchController.hidesNavigationBarDuringPresentation = true

        // Vamos a aplicar el delegado de la vista que usaremos resultados
        searchController.searchResultsUpdater = self
        return searchController
    }()
```

Como ya tenemos nuestro SearchViewController lo asignamos a la vista donde lo queremos mostrar, recordemos que desde iOS 11, nos dan la facilidad de colocarlo en el NavigationBar

```swift
    override func viewDidLoad() {
        super.viewDidLoad()

        // Asignamos el SearchController al ViewController que ya debe de tener un NavigationBar implementando
        self.navigationItem.searchController = searchController

        // Con esta linea decimos que no queremos ocultar el SearchBar cuando se realize scroll
        self.navigationItem.hidesSearchBarWhenScrolling = false

        // Definimos que el ResultViewController se muestre debajo de nuestro NavigationBar,
        // si colocamos el definesPresentationContext en false el ResultViewController se
        // mostrara en toda la pantalla. 
        self.definesPresentationContext = true
    }
```

# Mostrando los resultados de busqueda

Para mostrar lo resultados de busqueda del SearchController debemos implementar el delegado que previamente habiamos implementado

```swift
    searchController.searchResultsUpdater = self
```

```swift
    extension MainViewController: UISearchResultsUpdating {
    
    // Este es el metodo delegado para poder obtener cada letra que se ingrese en el SearchBar
    func updateSearchResults(for searchController: UISearchController) {

        // Obtenemos el texto del SearchBar
        guard let searchText = searchController.searchBar.text else {
            return
        }

        // Pasamos el texto a nuestro metodo *getResults y obtenemos los datos filtrados
        let filteredResults = getResults(searchText)

        // usamos el searchController que nos da el metodo delegado del cual obtenemos
        // la vista donde mostramos los resultados mediente el uso de searchResultsController,
        // al cual le hacemos la validacion que sea del tipo de ViewController
        // que usaremos para mostrar los resultados.
        if let resultView = searchController.searchResultsController as? ResultsViewController {

            // el resultView.results es por donde le vamos a pasar a nuestra vista de resultado lo resultados que filtramos previamente
            resultView.results = filteredResults
        }
    }
}
```

*El metodo getResults que usamos para obtener los datos filtrados, deberia ser tu metodo para que hage la comparación entre el texto que se ingresa en el searchBar y tu fuente de datos


# Conclusión

Debemos aprovechar el ResultViewController ya que es una de las formas convenientes de mostrar los resultados de busqueda.
He visto en otras ocaciones en donde se suele usar el SearchController asignandole al ResultViewController como nil y terminando usando los protocolos del SearchBar para obtener los datos ingresado por el textField del SearchBar, cosa que seria inecesaria si se saber usar el ResultViewController .

* El demo final se encuentra en [Github](https://github.com/erikfloresq/UISearchControllerDemo)

