#!/bin/bash
cp response/getThinnedEntities response/getThinnedEntities.prev
api/getThinnedEntities.sh -l 10 53.78 27.37 54.02 27.75
bin/checkl8.pl response/getThinnedEntities.prev response/getThinnedEntities
