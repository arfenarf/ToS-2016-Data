---
title: "ReadMe"
author: "KGW"
date: "February 13, 2016"
output: html_document
---

Simple scripts for presenting TrainerRoad data accumulated during the
Tour of Sufferlandria.

Source files are being gathered by hand in light of baulky APIs on the TR end.

Key files:

* **tour-reporting.Rmd** is a knitr file that tidies the raw json files and presents them.  The tidying routine was originally built and tested in
* **TRAllReader** this file has fallen behind the tidying in tour-reporting
* **mapping.R** contains experiments for plotting on shapefiles of time zones.
* **trdownload.R** has simple API code for talking to TR but I can't get it working properly.  No matter what I send it, TR curtsies and sends back the last 10 rides.  Postman, however, can download, so I'm just using it instead by hand.

More to follow