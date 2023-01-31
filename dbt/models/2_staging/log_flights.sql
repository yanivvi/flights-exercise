{{ 
	config (
		materialized='incremental'
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
	"CHRMINH",
	current_timestamp as snapshot_timestamp  
from {{ ref('mrr_flights') }}