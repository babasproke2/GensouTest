# mcl_villages

## Parameter

All of the following functions take a table with the following keys.

### Mandatory

name

: The name to use for the object.

mts

: The path to the mts format schema file.

### Optional

yadjust

: Y axis adjustment when placing the schema. This can be positive to raise the
placement, or negative to lower it.

If your schema does not contain a ground layer then set this to 1.

## mcl_villages.register_lamp(table)

Register a structure to use as a lamp. These will be added to the table used when
adding lamps to paths during village creation.

## mcl_villages.register_bell(table)

Register a structure to use as a bell. These will be added to the table used when
adding the bell during village creation.

There is 1 bell per village.

## mcl_villages.register_well(table)

Register a structure to use as a well. These will be added to the table used when
adding the wells during village creation.

The number of wells is calculated randomly based on the number of beds in the
village. Every 10 beds add 1 to the maximum number.

e.g. 8 beds == 1 well, 15 beds == 1 or 2 wells, 22 beds == 1 to 3 wells, etc.

## mcl_villages.register_building(table)

Register a building used for jobs, houses, or other uses.

The schema is parsed to work out how many jobs and beds are in it.

If you are adding a job site for a custom profession then ensure you call
```mobs_mc.register_villager_profession``` before you register a building using it.

If a building doesn't have any job sites or beds then it may get added during
the house placement phase. This will simply add another building to
the village and will not affect the number of jobs or beds.

### Additional options

The ```mcl_villages.register_building``` call accepts the following optional
parameters in the table.

min_jobs

: A village will need at least this many jobs to have one of these buildings.

  This is used to restrict buildings to bigger villages.

max_jobs

: A village will need less that or equal to (<=) this many jobs to have one of
these buildings.

  This is used to restrict buildings to smaller villages.

num_others

: A village will need this many other job sites before you can have another of
these jobs sites.

  This is used to influence the ratio of buildings in a village.

## mobs_mc.register_villager_profession(title, table)

**TODO** this should be somewhere else.

This API call allows you to register professions for villagers.

It takes 2 arguments.

1. title - The title to use for the profession.

  This mus be unique; the profession will be rejected if this title is already
  used.

1. Record - a table containing the details of the profession, it contains the
   following fields.

	1. name: The name displayed for the profession in the UI.
	1. texture: The texture to use for the profession
	1. jobsite: the node or group name sued to flag blocks as job sites for this
       profession
	1. trades: a table containing trades with 1 entry for each trade level.

You can access the current profession and job site data in
```mobs_mc.professions``` and ```mobs_mc.jobsites```.
