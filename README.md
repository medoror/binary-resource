# github binary-resource

Use binaries on demand

## Motivations
1. Executibles needed in jobs are placed in dockerfiles which
   can bloat image sizes
1. If the version of the executible needs to change a recompile
   of the docker image is required
1. Binaries needed for a one off tasks sometimes don't justify
   space on a dockerfile
   

The binary resource will allow users to inject binaries on a per
task basis allowing for use only when necessary.  

Need a new version of the binary? No need to dockerfile recompiles
just incrment the version defined in the binary resourse or use the
`latest` tag to always stay up to date

**Show example usage in pipelines here**


**Show configurations here**