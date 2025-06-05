
# Trepando Cerros

Proyecto Rails 8 de ejemplo con integración para la API de Strava.

## Requisitos previos

1. Instala Ruby 3.2.2 (por ejemplo con `rbenv install 3.2.2`).
2. Ejecuta `bundle install` para instalar las dependencias.

## Configuración

1. Copia `.env.example` a `.env` y coloca tu token de acceso:

```bash
cp .env.example .env
echo "STRAVA_ACCESS_TOKEN=tu-token" >> .env
```
La gema `dotenv-rails` cargará esta variable para permitir las llamadas a `StravaClient`.

## Uso

Ejecuta la aplicación con:

```bash
bundle exec rails server
```

Al abrir `http://localhost:3000` verás un panel con información básica del atleta en Strava. Solo necesitas subir un archivo GPX de tu ruta para que la aplicación calcule el tiempo estimado de carrera. Se analizan tus entrenamientos de los últimos seis meses en Strava y se obtienen ritmos promedio en subidas, bajadas y tramos planos. Estos ritmos se comparan con la pendiente de cada segmento de la ruta para calcular el tiempo total.

La interfaz usa Tailwind con un tema claro y tarjetas tipo *glass* para separar la información. Al subir tu GPX verás una barra de progreso animada y mensajes de cada etapa del análisis. El gráfico de elevación se presenta en una tarjeta aparte con animaciones suaves y no ocupa toda la pantalla. También se muestra un desglose de la distancia recorrida cada hora durante la carrera.

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
