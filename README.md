# Rappeliculas
Prueba Técnica Rappi 2018

Capas de la aplicación:
1) Modelo

  1.1) Servicios Core data: servicios
  
  1.2) Servicios de red: servicio
  
  1.3) Entidades: peliculaCD, pelicula
  
2) Controladores: DetallePeliculaVC, PopularVC, TabBarController
3) Vista


Responsabilidades de cada clase:

-servicios: esta clase contiene 2 responsabilidades (esto se debió separar). La primera es encargarse de todas las peticiones de red y la segunda es manejar coredata

-peliculaCD: esta clase sirve como modelo de datos de un tipo de pelicula y está vinculada directamente con core data

-pelicula: esta es una clase auxiliar, la cual tiene una extensión que implemente el protocolo codable y facilita el parseo de respuestas desde el servicio web

-DetallePeliculaVC: esta es el controlador encargado de manejar la vista detalle de pelicula

-PopularVC: este es el controlador encargado de manejar la vista de peliculas populares

-TabBarController: este es el controlador encargado de manejar la tab bar

Responda y escriba dentro del Readme con las siguientes preguntas:
1. En qué consiste el principio de responsabilidad única? Cuál es su propósito?
-Consiste en que cada componente está encargado (responsable) de solo una función y no de muchas cosas a la vez
-al usar este principio se aumenta la reutilización del código y se mejoran los tiempos de depuración (ya que es más fácil determinar el origen de un bug)

2. Qué características tiene, según su opinión, un “buen” código o código limpio
-No debe tener lineas innecesarias (que no contribuyan en nada al propósito del código)
-que cada bloque de código, no se pueda refactorizar a un bloqué más simple o reusable
-que el código sea modular, cada parte cumpliendo una función especifica y no multiple.
-que esté formateado (identación, espacios)
