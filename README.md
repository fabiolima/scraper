# Web scraper
> Extract product data from Zara and Hering.

## Why?
I made this project to practice ruby and scraping techniques.

## Dependencies
- [Ruby](https://www.ruby-lang.org/en/)
- [Bundler](https://bundler.io/) 

## Install
After cloning this repository, navigate to project folder and run:
```bash
bundle install
```
then spin up the web server
```bash
rails s
```
Default port for this project is `3002`. You can change at `config/puma.rb`

## Usage
```
POST /scrape

BODY
{
    "id": "",
    "url": "",
    "webhook": ""
}
```
Body parameters:
- **id**: the id of your external resource (Like `@task.id`, or `@product.id`).
- **url**: URL to be scrapped
- **webhook**: URL to notify when scrape finishes
