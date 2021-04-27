#!/usr/bin/env bash

ansible-lint --exclude=collections -c .ansible-lint -v
