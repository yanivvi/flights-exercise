{{ 
	config (
		materialized='table'
		) 
	}}

select
    "index",
    "ISO-3166alpha2",
    "ISO-3166alpha3",
    "ISO-3166numeric",
    "Country",
    "Capital",
    "Area in km²",
    "Population",
    "Continent"
from {{ source('flightsapi', 'mrr_countries') }}