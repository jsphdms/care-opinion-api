# care-opinion-api
Download and visualise Care Opinion data

## Introduction
[Care Opinion](https://www.careopinion.org.uk/) was founded in 2005 and is an independent non-profit feedback platform for health services in the UK. They provide access to the raw data of published stories, responses, tags, healthservices and treatment functions through an API. This repo contains R scripts to interact with this API - to download and visualise the data.

## API Key
The Care Opinion API requires [authentication via an API key](https://www.careopinion.org.uk/info/api-v2-authentication). The download script in this repo won't work without it. Define a valid API key in your .Renviron file like this:

`co_api_key="lotsofrandomlettersandnumbers"`

## Example plot
Here is an example visualisation of Care Opinion data (produced using the scripts in this repo).

![An example plot of Care Opinion data](https://raw.githubusercontent.com/jsphdms/care-opinion-api/master/example_plot_Scotland.png)
