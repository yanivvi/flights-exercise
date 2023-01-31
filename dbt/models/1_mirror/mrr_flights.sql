{{ 
	config (
		materialized='table'
		) 
	}}

select
    "_id",
    "CHOPER",
    "CHFLTN",
    "CHOPERD",
    "CHSTOL",
    "CHPTOL",
    "CHAORD",
    "CHLOC1",
    "CHLOC1D",
    "CHLOC1TH",
    "CHLOC1T",
    "CHLOC1CH",
    "CHLOCCT",
    "CHTERM",
    "CHCINT",
    "CHCKZN",
    "CHRMINE",
    "CHRMINH"
from {{ source('flightsapi', 'mrr_flights') }}