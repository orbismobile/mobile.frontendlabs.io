
# Get Started

## First

Fork this repository.

## Clone

```
git clone git@github.com:your_github_username/mobile.frontendlabs.io.git
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

## Open your browser

```
http://localhost/
```

## Creating a new post

This command creates a markdown file on the following path: `source/content/posts/`. This only works when your container is up and running.

### Create a new post

```
make newpost name=post_name
```

### Change status

Open your .md file with an editor and change the value of `draft: true` to `draft: false`, and write some of markdown like this:

```
---
title: "Post_name"
date: 2017-10-06T22:26:57Z
draft: false
---

## Subtitle

paragraph paragraph paragraph paragraph.
```

Save your changes.

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
