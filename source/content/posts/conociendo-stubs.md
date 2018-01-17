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

{{< gist andru255 b75444f1f41391921d2b2ec2fd75ba1b "randomNumber.swift">}}

Realizamos un stub de la función **randomNumber**:

{{< gist andru255 b75444f1f41391921d2b2ec2fd75ba1b "randomNumberStub.swift">}}


# Mocks

Tiene el mismo propósito de un stub,
 pero es orientado en tomar el lugar de la información original de retorno,
 como por ejemplo:

{{< gist andru255 b75444f1f41391921d2b2ec2fd75ba1b "getRemoteInfo.swift">}}

Como en el ejemplo anterior tenemos 2 parámetros de tipo función, **success** y **fail**, en este caso,
 necesitamos crear 2 stubs para cubrir el escenario en donde se ejecutará el parámetro **success**,
 y otra dónde el parámetro **fail** es ejecutado

{{< gist andru255 b75444f1f41391921d2b2ec2fd75ba1b "getRemoteInfoStub.swift">}}

# Usando OHTTPStubs

Teniendo estos ejemplos, en el siguiente capítulo usamos el poderío de la librería [OHTTPStubs](https://github.com/AliSoftware/OHHTTPStubs) que nos facilita implementar stubs y mocks a medida en nuestras pruebas unitarias.