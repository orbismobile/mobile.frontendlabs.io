---
title: "Conociendo Stubs y Mocks"
date: 2018-01-15T21:00:44Z
draft: false
---

Cuando desarrollamos con APIs en nuestra aplicación,
 tenemos la limitante de programar o testear dependiendo la disponibilidad de este,
 la necesidad viene en ¿Podría testear mi aplicación sin depender todo el tiempo del servicio?, la respuesta es un contundente **Sí**,
 para lograr ello necesitamos acudir al uso de **stubs** y **mocks**.

# Stubs

Son aquellas implementaciones que normalmente retornar un valor fijo
 y toman el lugar de las funciones originales,
 como por ejemplo:

```swift
   // Función original
   func randomNumber(min: Int, max: Int) -> Int {
       // implementación original
       return min + Int(arc4random_uniform(UInt32(max - min + 1)))
   }
   let myNumber = randomNumber(min: 5, max: 31) //retorna un número aleatorio
```

Realizamos un stub de la función **randomNumber**:

```swift
   // Implementación que retorna un valor fijo a diferencia de la Función original
   func randomNumber(min: Int, max: Int) -> Int {
       return 10
   }
   let myNumber = randomNumber(min: 5, max: 31) //retornará siempre 10
```

# Mocks

Tiene el mismo propósito de un stub,
 pero es orientado en tomar el lugar de la información original de retorno,
 como por ejemplo:

```swift
   // Función original
   func getRemoteInfo(success: @escaping([String: Any]) -> Void, fail: @escaping(Error) -> Void ) {
       let url = URL(string: "http://swapi.co/api/people/1/")!
       var request = URLRequest(url: url)
       request.httpMethod = "GET"
       let sessionConf = URLSessionConfiguration.default
       let urlSession = URLSession(
           configuration: sessionConf,
           delegate: nil,
           delegateQueue: nil
       )
       let dataTask = urlSession.dataTask(
           with: request as URLRequest,
           completionHandler: {(data: Data?, response: URLResponse?, error) in
               guard let data = data, error == nil else {
                   print("Error: \(error!.localizedDescription)")
                   fail(error!.localizedDescription as! Error)
                   return
               }
               if let httpStatus = response as? HTTPURLResponse {
                   if httpStatus.statusCode == 200 {
                       guard let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: Any] else {
                       print("Not containing JSON")
                           return
                       }
                       success(json)
                   }
               }
       })
       dataTask.resume()
   }
   getRemoteInfo(success: { data in
       print("name: ", data["name"]!) // Retornará el valor de la llave "name" que es "Luke Skywalker"
   }, fail: {
       print("fail: ", error) // Retornará un error del servicio
   })
```

Como en el ejemplo anterior tenemos 2 parámetros de tipo función, **success** y **fail**, en este caso,
 necesitamos crear 2 stubs para cubrir el escenario en donde se ejecutará el parámetro **success**,
 y otra dónde el parámetro **fail** es ejecutado

```swift
   // Implementación que retorna un contenido fijo a diferencia de la Función original
   // Cobertura para el escenario satisfactorio o success
   func getRemoteInfoSuccess(success: @escaping([String: Any]) -> Void, fail: @escaping(Error) -> Void ) {
       // Definimos una variable como mock
       let json: [String: Any] = {
           "name": "Luke SkyWalker of Mocker"
       }
       success(json)
   }

   // Implementación que ejecuta el error directamente a diferencia de la Función original
   // Cobertura para el escenario fallido o fail
   func getRemoteInfoFail(success: @escaping([String: Any]) -> Void, fail: @escaping(Error) -> Void ) {
       let error = NSError(domain:"MyDomain", code:-1, userInfo:nil)
       fail(error)
   }

   // Invocando al stub con el escenario satisfactorio
   getRemoteInfoSuccess(from: { data in
       // Retornará el mock con la llave "name" que tiene el valor de "Luke Skywalker of Mocker"
       print("name: ", data["name"]!)
   }, fail: { error in
       // No se ejecutará nada aqui por definicion del stub
   })

   // Invocando al stub con el escenario fallido
   getRemoteInfoFail(from: { data in
       // No se ejecutará nada aqui por definicion del stub
   }, fail { error in
       // Se podrá mostrar el error definido en el stub
       print("error founded", error)
   })
```

# Usando OHTTPStubs

Teniendo estos ejemplos, en el siguiente capítulo usamos el poderío de la librería [OHTTPStubs](https://github.com/AliSoftware/OHHTTPStubs) que nos facilita implementar stubs y mocks a medida en nuestras pruebas unitarias.