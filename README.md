
# Trepando Cerros

Proyecto Rails 8 de ejemplo con integración para la API de Strava.

## Requisitos previos

1. Instala Ruby 3.2.2 (por ejemplo con `rbenv install 3.2.2`).
2. Ejecuta `bundle install` para instalar las dependencias, incluida la gema `strava-ruby-client`.

## Configuración

1. Exporta la llave de acceso necesaria:

```bash
export STRAVA_ACCESS_TOKEN="tu-token-de-strava"
```
Con ello puedes utilizar el servicio `StravaClient` dentro de la aplicación.

## Uso

Ejecuta la aplicación con:

```bash
bundle exec rails server
```

Al abrir `http://localhost:3000` verás un panel con información básica del atleta en Strava. Desde allí puedes subir un archivo GPX de tu ruta o ingresar manualmente la distancia y tu ritmo para obtener el tiempo estimado de carrera. Cuando subes un GPX, la aplicación analiza cada tramo del recorrido y ajusta el ritmo según el desnivel utilizando tus actividades recientes de Strava.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
