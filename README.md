# README

With this application you can fetch information about movies stored in ["The Movie Database - registration required"](https://developer.themoviedb.org/reference/search-movie) searching by their titles. A subscription to "The Movie Database" limits how many requests the clients are allowed to send to it. To reduce the number of requests directly sent to the database this app stores the responsded information for a while and, when the request is the same, serves the requested information from it's store. Using this app please subscribe  to ["The Movie Database - registration required"](https://developer.themoviedb.org/reference/search-movie) and provide your `API Read Access Token`.

## Installation and local trial

* Clone this repo.
* Install required ruby version (3.2.5) and bundler.
* Run `bundle install` in the project directory.
* Token is encrypted. Please generate encryption keys and set in `config/credentails.yml.enc` as follows:
* run: `bin/rails db:encryption:init`, the generated keys are printed on console:
*     `active_record_encryption:`
          `primary_key: [GENERATED KEY]`
          `deterministic_key: [GENERATED KEY]`
          `key_derivation_salt: [GENERATED KEY]`
* copy the generated keys into `credentails.yml.enc` and save.
* You can edit `credentials.yml.enc` with `EDITOR=nano rails credentials:edit`
* If you can not open cerate a `master.key` and copy into `config/` directory.
* Run the rails server from the project directory: `bundle exec rails server`
* You can reach the app in a browser at `http://localhost:3000/`

## How to use it

First you can see a `Welcome!` and `Sign in` page. Providing your e-mail address and password you can enter the `searching` page. If you do not have account yet, you can register by following the link. Please provide your e-mail address, password, password confirmation and the `API Read Access Token`. The token is stored with encryption. After registration you are entered into the `searching` page.

In the `searching` page you can add keywords in the search box and then click the `Search` button. In the results, if any, you will receive information about movies whose titles match the search term. The movies are listed in cards. You can find the title, an overview and a poster image about each movie. You are also informed, that the request is provided by the store or the 3rd party API and about errors, if occurs one.

## Test

You can run tests with: `bundle exec rails test`

## Personal motivation

I decided using cache for solving this problem. Since Movie Database stores data, it is not neccessary to store data permanently in this project.

Rails.cache is a great tool for this purpose. It stores data you put into the cache. After expiration it frees store. If the store runs out of the space it frees space automatically.

## Further improvements

* The Movie Database API provides many other possibilities besides searching in titles. Generalize communication and then spezialize for each and every API endpoints expands our possibilities.
* There are many ways to improve eg.the UX. Among others the account stores only the most necessary data. It should be store more personal information and should provide some basic flows: like changing stored data: e-mail, password API token, handling forgotten password, storing preferences, etc.

# Background

## The TMDB API

### Basics

The TMDB API provides a list of methods for movie, tv, actor and image API. This application connets to the searching movie endpoint, below you can information about the endpoint.

### Main URL

All the methods can be connected via this main url:

https://api.themoviedb.org/3

### Search movie API

This application sends `get` request to the `/search/movie` endpoint for retreiving info about movies.

#### Available QUERY PARAMS

- **query** string - *required*
- **include_adult** boolean - *Defaults to false*
- **language** string - *Defaults to en-US*
- **primary_release_year** string
- **page** int32 - *Defaults to 1*
- **region** - string
- **year** - string

#### RESPONSE

- **CODE** - 200
- **BODY**
  - object
  - **page** integer - *Defaults to 0*
  - **results** array of objects
    - object
    - **adult** boolean - *Defaults to true*
    - **backdrop_path** string
    - **genre_ids** array of integers
    - **id** integer - *Defaults to 0*
    - **original_language** string
    - **original_title** string
    - **overview** string
    - **popularity** number - *Defaults to 0*
    - **poster_path** string
    - **release_date** string
    - **title** string
    - **video** boolean - *Defaults to true*
    - **vote_average** number - *Defaults to 0*
    - **vote_count** integer - *Defaults to 0*
  - **total_pages** integer - *Defaults to 0*
  - **total_results** integer - *Defaults to 0*

## This application

This application connets to the `/search/movie` endpoint, where you can search for movies by their original, translated and alternative titles.

### REQUEST

A general request, that is sended to TMDB API looks like this:

`GET https://api.themoviedb.org/3/search/movie?query=test&page=1`

#### QUERY PARAMS

The application uses only the `query` and the `page` params. Using the rest is a possibility for further improvement. Keywords from the app's search bar and the number from pagination are included in the `query` and `page` param, respectively.

#### HEADERS

In the request the `accept` and `Authorization` headers have to be set. The value of the `accept` headers is `application/json`. In the `Authorization` headers the token should be provided, that was given by user at the registration: `Authorization: Bearer [API Read Access Token]`.

### RESPONSE

The movie cards information, that are showed, are based on the response `results` array. A movie card corresponds to an object included in the array. The data, displayed on the card, come from the `title` and `overview` keys, and the image location is provided in the `poster_path` key. Then the image can be dowonloaded from the `https://image.tmdb.org/t/p/[poster_path]` url.

The pagination uses the `page` and `total_pages` keys.
