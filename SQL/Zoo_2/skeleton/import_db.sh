#!/usr/bin/env sh

dropdb zoo2
createdb zoo2
psql zoo2 < data/create_tables.sql
