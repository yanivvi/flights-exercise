{{ 
	config (
		materialized='table'
		) 
	}}
	
with 
ranked_rows as (
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
		"snapshot_timestamp",
		max(_id) over (partition by "CHOPER","CHFLTN") last_id,
		max(snapshot_timestamp) over (partition by "CHOPER","CHFLTN") last_timestamp  
	from {{ ref('log_flights') }}
	where "CHOPER" <> '' -- remove blank lines
	)
select 
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
from ranked_rows 
where _id = last_id	
and snapshot_timestamp = last_timestamp