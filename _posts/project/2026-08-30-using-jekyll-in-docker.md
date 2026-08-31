---
layout: post
author: Seth Troisi
category: project
title:  Using Jekyll (in Docker) to run a local copy of the project website
tags: projectdoc
excerpt: A description of how to use Jekyll to serve this website on http://localhost:4000
---

## Introduction

[Graham Higgins wrote a post in 2020](/project/2020/02/04/using-jekyll-to-serve-the-project-website-locally/) about running the site loccaly.

I haven't done that because I hate Ruby.

Here are my notes on how I got it running in docker.

### Run locally

```
# Commented out the install-if lines in the Gemfile
# Include both "tzinfo" and "tzinfo-data", remove "wdm"
sudo docker build -t prime-gaps .
sudo docker run --volume="$PWD:/srv/jekyll" -it prime-gaps bash
```

```
sudo docker run -p4000:4000 --volume="$PWD:/srv/jekyll" -it prime-gaps jekyll clean
sudo docker run -p4000:4000 --volume="$PWD:/srv/jekyll" -it prime-gaps jekyll build
sudo docker run -p4000:4000 --volume="$PWD:/srv/jekyll" -it prime-gaps jekyll serve --host 0.0.0.0 --incremental --livereload --trace
```

This seems to result in Jekyll running and serving on [http://localhost:4000](http://localhost:4000)
