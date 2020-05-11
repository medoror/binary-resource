# Github Binary Resource

Run binaries from resources injected into tasks

## Motivations
1. Executables needed to support tasks within concourse jobs are placed 
   in dockerfiles which can bloat image sizes
1. If the version of the executables needs to change a recompile
   of the docker image is required
1. Binaries needed for one off tasks sometimes don't justify
   space on a dockerfile
   
The github binary resource will allow users to inject binaries on a per
task basis allowing for use only when necessary.  

Need a new version of the binary? No need to re-compile you docker image
just increment the version defined in the binary resource or use the
`latest` tag to always stay up to date


### Example

```yaml
resource_types:
- name: github-binary-resource
  type: docker-image
  source:
    repository: medoror/github-binary-resource

resources:
- name: binary
  type: github-binary-resource
  source:
    repo: pivotal-cf/om
    tag: latest
```

## Source Configuration
  
- `repo` - Identifies the binary entered in the following format `<github-owner>/<github-repository>`

- `tag`  - Identifies the version of the binary to be downloaded
  
  
## Behaviour

### `check`: Check for new resource
If the `latest` tag is used, the check resource will query for the latest version of the given binary. If a particular
version tag is used, that version will always be returned

### `in`: Download given resource
Will pull download the given version of the binary, untar, and place it in the destination dir under the respository name 

### `out`: No Op


## Running the tests

Run the ruby tests locally

```
bundle exec rspec .
```

## Building Docker Image

```bash
docker build -t github-binary-resource .
```
The tests have also been embedded with the Dockerfile; ensuring that the testing environment is consistent across any docker enabled platform. When the docker image builds, the test are run inside the docker container, on failure they will stop the build.

## Limitations
Currently this resource will only download linux binaries

## License

MIT © Michael Edoror