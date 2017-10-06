
# Get Started

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
make newpost name=post_name
```

## Open your browser

```
http://localhost/
```

# Extras

## Add another theme

```
git submodule add git@github.com:account/hugo-theme_name-theme.git source/themes/theme_name
```

## Creating a custom post from Docker-compose

```
docker-compose exec hugo sh -c "hugo new posts/post_name.md"
```
