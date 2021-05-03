#!/usr/bin/env bash

ansible-lint --exclude=.github --exclude=collections -c .ansible-lint -v
