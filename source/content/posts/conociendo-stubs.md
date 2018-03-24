---
title: "Conociendo Stubs y Mocks"
date: 2018-01-15T21:00:44Z
draft: false
---

Cuando desarrollamos con APIs web o servicios de terceros en nuestra aplicación,
tenemos la limitante de programar o probar dependiendo de la disponibilidad del servicio,
nace la interrogante ¿Podría desarrollar y probar mi aplicación sin depender todo el tiempo de un servicio?, la respuesta es un contundente **Sí se puede**,
 para lograr ello necesitamos acudir al uso de **stubs** y **mocks**.

# Conceptos básicos

Normalmente los términos **stubs** y **mocks** se manejan bajo una suite de pruebas unitarias, en este caso se replantea la idea de estos términos en un escenario sin una suite en especial.

## Stubs

Son aquellas funciones de relleno que tienen como finalidad sustituir funcionalidades del cual depende nuestro código,
Una funcionalidad viene a ser una orden o un conjunto de órdenes que tienen uno o muchos propósitos, ya sea calcular la suma de un número, o retornar el total a pagar de un carrito de compras.

Por ejemplo, tenemos la siguiente función llamada **randomNumber**:

{{< gist andru255 b75444f1f41391921d2b2ec2fd75ba1b "randomNumber.swift">}}

Realizamos un **stub** de la función **randomNumber**:

{{< gist andru255 b75444f1f41391921d2b2ec2fd75ba1b "randomNumberStub.swift">}}

Como se visualiza, un **stub** no tiene una operación compleja, simplemente cumple con lo que necesitamos,
una función con el mismo nombre pero con una salida puntal o fija :)

Ahora tenemos el siguiente ejemplo:

{{< gist andru255 b75444f1f41391921d2b2ec2fd75ba1b "getRemoteInfo.swift">}}

Como en el ejemplo anterior tenemos 2 parámetros de tipo función, **success** y **fail**, en este caso,
 necesitamos crear 2 **stubs** para cubrir el escenario en donde se ejecutará el parámetro **success**,
 y otra dónde el parámetro **fail** es ejecutado:

{{< gist andru255 b75444f1f41391921d2b2ec2fd75ba1b "getRemoteInfoStub.swift">}}

## Mocks

Es muy similar a un **stub**, pero la diferencia es que un **mock** es la copia de un objeto o clase, eso quiere decir
de que aprovechamos el uso de un protocolo para poder definir los métodos que una clase debe tener:

{{< gist andru255 b75444f1f41391921d2b2ec2fd75ba1b "UserActionsProtocol.swift">}}

Y normalmente lo usamos para crear una clase original que implementará el protocolo,
nuestra clase se llamará **UserActions**

{{< gist andru255 b75444f1f41391921d2b2ec2fd75ba1b "UserActions.swift">}}

Ahora, implementamos nuestro protocolo a nuestra clase llamada **MockUserActions**:

{{< gist andru255 b75444f1f41391921d2b2ec2fd75ba1b "MockUserActions.swift">}}

# Caso de uso

Deseo hacer una aplicación que me facilite la búsqueda de libros por autor bajo el servicio de [openlibrary](http://openlibrary.org/) y a la vez poder guardar/listar los libros que deseo leer mas tarde

Para ello realizé un paquete en swift bajo docker, el code completo lo pueden ver [aquí](https://github.com/andru255/swift-stubs-mocks)

Este es el diagrama de clases:

![MyLittlePocket](../conociendo-stubs/my_little_pocket_diagram.png)

# Aplicando lo aprendido en pruebas unitarias

Bajo una suite de pruebas, los **stubs** y **mocks** extienden su uso manteniendo su escencia,
según el genial post [Mocks aren't stubs](http://martinfowler.com/articles/mocksArentStubs.html) de [Martin Fowler](http://www.martinfowler.com/), nos explica no solamente de la confusión que suele pasar en usar **stubs** y **mocks**, sino también acerca de **fakes** y **dummies**.

En este caso nos centramos en lo que define **stubs** y **mocks** considerándolos **dobles** así como en las películas, donde en las escenas de alto riesgo se juegan la vida, por otro lado, en el desarrollo de pruebas unitarias los **dobles** toman el lugar de nuestras funciones y clases originales.

Con conceptos y ejemplos aplicaré en un paquete swift que crearé bajo linux/ubuntu, usando swift 4.0 + docker, a la vez la suite de testing [Quick](https://github.com/Quick/Quick) y [nimble](https://github.com/Quick/Nimble) para las pruebas unitarias 

## Stubs

Nos ayuda a resolver las siguientes preguntas cuando desarrollamos:

- ¿Mis pruebas unitarias funcionarían bien si reemplazo mi función original con un stub?

- ¿Están preparados todos los escenarios sean satisfactorios y fallidos cambiando mis funciones originales por stubs?

Como vemos, el uso de **stubs** bajo pruebas unitarias nos ayuda a verificar el **estado** de una función en nuestra aplicación, eso quiere decir, validar y probar la responsabilidad de nuestra función original.

{{< gist andru255 b75444f1f41391921d2b2ec2fd75ba1b "NetworkAdapter-stubs.swift">}}

Como se vé, definimos unos stubs para simular los escenarios que puede darnos el método **request**

## Mocks

Nos facilita resolver estas preguntas:

- ¿Se definió mi función?

- ¿Se ejecutó mi función?

- ¿Cuántas veces se ejecutó mi función?

Estas preguntas hacen que un **mock** bajo pruebas unitarias se oriente a verificar el comportamiento de nuestra función, y para ello lo aprovechamos mediante clases y protocolos.

{{< gist andru255 b75444f1f41391921d2b2ec2fd75ba1b "MockBookFinder.swift">}}

Como se vé, definimos una clase mock que nos ayudará a simular la clase **BookFinder**

## Usando nuestros stubs y mocks

Como ya tenemos nuestras definiciones, como resultado tenemos las siguientes pruebas unitarias:


{{< gist andru255 b75444f1f41391921d2b2ec2fd75ba1b "BookTests.swift">}}

## Mocks parciales y completos

Los mocks se dividen en 2 tipos, que son los **parciales** y **completos**, estos son fáciles de detectar
ya que un **mock parcial** simula una parte de una clase, mientras los **completos** vienen a ser los que cubren todas las funcionalidades de una clase en base al protocolo del cual son definidos.

## Fuentes

- [Mocking in Swift by Jhon Sundell](https://www.swiftbysundell.com/posts/mocking-in-swift)
- [Desmitificando los dobles de test: Mocks, stubs and friends](https://www.genbetadev.com/javascript/desmitificando-los-dobles-de-test-mocks-stubs-and-friends)
- [Lightweight Object Mocking in Swift by @lvsti](https://lvsti.github.io/cocoagrinder/2017/01/06/lightweight-object-mocking-in-swift.html)
- [How to Mock and Stub a System Class in Swift](https://cocoacasts.com/how-to-mock-and-stub-a-system-class-in-swift-part-1)
- [Real World Mocking in Swift](https://academy.realm.io/posts/tryswift-veronica-ray-real-world-mocking-swift/)
- [How to Design Swift Mock Objects - Quality Coding](https://qualitycoding.org/swift-mock-objects/)
- [Test Doubles: Mocks, Stubs, and More - objc.io](https://www.objc.io/issues/15-testing/mocking-stubbing/)
- [Unit Testing Tutorial: Mocking Objects](https://www.raywenderlich.com/101306/unit-testing-tutorial-mocking-objects)
