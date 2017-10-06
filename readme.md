
## Clone

```
git clone git@bitbucket.org:joejansanchez/mobile.frontendlabs.io.git
```

```
cd mobile.frontendlabs.io
```

## Update submodules (only the first time)

```
git submodule update --init --recursive
```

## Run

```
docker-compose up
```

## Create a new post

```
make newpost "post_name"
```

## Add another theme

```
git submodule add git@github.com:account/hugo-theme_name-theme.git source/themes/theme_name
```
