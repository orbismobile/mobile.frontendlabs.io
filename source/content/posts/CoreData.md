---
title: "CoreData"
date: 2018-01-10T15:06:30Z
draft: false
---

# Usando CoreData por primera vez

Hasta hace algunos días no había tenido la necesidad de utilizar un manejador de base de datos en las aplicaciones que he desarrollado, para manejar la persistencia de datos utilizaba los [UserDefaults](https://developer.apple.com/documentation/foundation/userdefaults).
<p align="justify">
Pero me ví con la necesidad de almacener una cantidad de datos mucho mayor, podría utilizar los **UserDefaults** pero no es óptimo, los mismos desarrolladores de **Apple** recomiendan implementar los UserDefaults para almacenar información puntual acerca del usuario y sus preferencias, por lo que necesitaba utilizar un manejador de base de datos y esto era algo nuevo para mí, tenía que decidir entre las diferentes bases de datos compatibles con dispositivos iOS y una entre ellas se encontraba **CoreData** que es un framework desarrollada y recomendada por **Apple**.</p>
<p align="justify">
Dicho lo anterior, vamos a comenzar a crear nuestro modelo de datos con sus respectivas entidades, almacenaremos datos en ellos y recuperaremos esos datos para mostrarlos al usuario haciendo uso de **CoreData**</p>


### Creando nuestro modelo de datos

Crear el modelo para nuestra base de datos es tan sencillo como hacer un **click** en la opción "Use Core Data" al momento de crear tu proyecto.

![Default Image](../CoreData/CrearModeloCoreData.png)
<p align="justify">
 Puedes ubicar el modelo de tu base de datos en bundle de tu proyecto , el nombre al modelo asigna automáticamente como **"Nombre_Proyecto.xcdatamodeld"** pero si gustas puedes cambiarle el nombre.</p>

![Default Image](../CoreData/ModeloBaseDatos.png)

* si olvidaste agregar la base de datos al crear tu proyecto , no te preocupes a continuación te mostraré cómo agregarlo de manera manual.

![Default Image](../CoreData/CrearModeloManual.gif)


### ¿Cómo crear las entidades en mi base de datos?
<p align="justify">
Las entidades son tratados como objetos , en nuestro ejemplo definiremos la entidad **Persona**. Para agregar una entidad basta con hacer click en el botón **Add Entity** que se encuentra en la parte baja del archivo de tu modelo y luego hacer doble click para cambiar el nombre.</p>

![Default Image](../CoreData/CrearEntidad.gif)
<p align="justify">
* Ahora crearemos las propiedades o atributos de nuestra entidad "Persona", para nuestro ejemplo solamente definiremos un atributo "nombre" y será del tipo String. 
</p>
![Default Image](../CoreData/CrearAtributo.gif)


### Ya hemos definido nuestra entidad y su atributo, pero ¿Cómo puedo grabar acceder a mi entidad y guardas datos?
<p align="justify">
Para nuestro ejemplo haremos uso de un TableViewController y simularemos una lista de personas la cuál inicialmente se encontrará vacía y mediante el uso de un botón agregaremos personas a la lista.</p>
<p align="justify">
* Para poder hacer uso de los métodos y poder acceder a nuestra base de datos , necesitamos importar el framework CoreData en nuestro controllador de la vista, bastará con declarar la siguiente línea en la cabecera del controlador:</p>

```Swift
import CoreData
```
<p align="justify">
* Necesitamos declarar una variable del tipo *NSManagedObject* que en nuestro caso nos servirá tanto para almacenar los registros ingresados y para recuperar los registros desde nuestra base de datos.</p>

```Swift
var managedObjects:[NSManagedObject] = []
```
<p align="justify">
* A continuación se muestra el código necesario para poder guadar información en nuestra base de datos:</p>

```Swift
func registrarNombre(nombre: String) { // en esta funcion pasamos por parámetro el nombre del alumno
    // 1. Para guardar o recuperar objetos necesitamos un objeto del tipo managedObjectContext.
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    let managedcontext = appDelegate!.persistentContainer.viewContext
        
    // 2. creamos un objeto de tipo "NSManagedObject" usando la clase de entity.
    let entity = NSEntityDescription.entity(forEntityName: "Lista", in: managedcontext) // debes de colocar el nombre de tu base de datos
    let managedObject = NSManagedObject(entity: entity!, insertInto: managedcontext)
    // 3. Registramos nuestro valor en  el managedObject
    managedObject.setValue(nombre, forKeyPath: "palabra")// forKeyPath: el nombre del atributo
    // 4. utilizando nuestro managedcontext guardaremos los cambios.
    do {
          try managedcontext.save()
        } catch let error as NSError {
            print("No se pudo guardar, error: \(error), \(error.userInfo)")
        }
    }
```

### Y cómo accedo a mi base de datos para extraer los nombres registrados?
<p align="justify">
Para poder recuperar los registros desde nuestra base de datos debemos de ejecutar el siguiente código:</p>

```Swift
func recuperarDatosCoreDate() {
    // 1. Para guardar o recuperar objetos necesitamos un objeto del tipo managedObjectContext.
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    let managedcontext = appDelegate!.persistentContainer.viewContext
    // 2. Usaremos fetch para buscar, traer y extraer.
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Lista")
    // 3. do y catch
    do {
    	  //Guardamos nuestro valor recuperado en  el managedObject
          managedObjects = try managedcontext.fetch(fetchRequest)
        } catch let error as NSError {
            print("No se pudo guardar, error: \(error), \(error.userInfo)")
        }
    }
```

### Pero si me equivoqué en ingresar un nombre, ¿Cómo elimino el registro?

Pues eliminar un registro es la parte más fácil del manejo de datos con Core Data:

```Swift
func eliminar (palabra:String) {
    // 1. Para guardar o recuperar objetos necesitamos un objeto del tipo managedObjectContext.
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    let managedcontext = appDelegate!.persistentContainer.viewContext
    // 2. Usaremos fetch para buscar, traer y extraer el registro a eliminar.
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Lista")
    // 3. Dentro de todos nuestros registros ubicamos el que queremos eliminar
    fetchRequest.predicate = NSPredicate(format: "palabra == %@", palabra)
    let object = try! managedcontext.fetch(fetchRequest)
    do {
        // 4. Eliminamos el registro
           managedcontext.delete(object.first!)
           try managedcontext.save()
        } catch let error as NSError {
            print("Error al eliminar: \(error)")
        }
    }
```
El desarrollo completo del ejemplo lo puedes encontrar en el siguiente [repositorio](https://github.com/Gerrard12/ExampleCoreData).

<p align="justify">
Como podrás ver el ingresar, recuperar y eliminar registros desde una base de datos es sumamente sencillo con CoreData, pero puede ser más sencillo inclusive ya que como mencione líneas arriba las entidades son tratadas como objetos sin necesidad de utilizar la referencia de llave-valor.</p>
<p align="justify">
Para poder tratar las entidades como objetos solamente necesitas un poco de ayuda del Xcode, a continuación dejaré un gif de cómo generar las clases que nos ayudarán a tratar las entidades como objetos, tener en cuenta que en este punto ya deberíamos de tener nuestro modelo con sus entidades y atributos creados. </p>

![Default Image](../CoreData/CoreDataObject.gif)

<p align="justify">
Xcode nos genera 2 clases, una de ellas nos permite administrar las funciones (Persona+CoreDataClass) y en la otra podemos ver todos los atributos que fueron declarados en nuestra entidad (Persona+CodeDataProperties). Ahora veremos cómo cambiaría nuestro código al tratar las entidades como objetos</p>

```Swift
func registrarNombre(nombre: String) {
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    let managedcontext = appDelegate!.persistentContainer.viewContext
    // 1. creamos una variable objeto del tipo de nuestra entidad (en este caso Persona).
    let entity = NSEntityDescription.entity(forEntityName: "Persona", in: managedcontext) // debes de colocar el nombre de tu base de datos
    let persona = Persona(entity: entity!, insertInto: managedcontext)
    // 2. Registramos nuestro valor en  el managedObject
    persona.nombre = nombre// forKeyPath: el nombre del atributo
    // 3. utilizando nuestro managedcontext guardaremos los cambios.
    do {
          try managedcontext.save()
          managedObjects.append(persona)// Ahora el arreglo para almacenar nuestros datos debe de ser el tipo del objeto(Persona).
        } catch let error as NSError{
            print("No se pudo guardar, error: \(error), \(error.userInfo)")
        }
    }
```

Puedes encontrar el proyecto completo, tratando las entidades como objetos en el siguiente [repositorio](https://github.com/Gerrard12/ExampleCoreDataObject).

<p align="justify">
Hemos llegado al final de este artículo, espero que les sirva de ayuda y sobre para  quitarse un poco el miedo de utilizar CoreData en sus aplicaciones, ya que utilizar un framework nativo y desarrollado por Apple es mejor que utilizar un framework externo.
</p>




