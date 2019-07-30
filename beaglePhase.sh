#!/bin/bash

java --jar beagle.12Jul19.0df.jar \
	gt=<input-vcf> \
	out=<output prefix> \
	burnin=10 \
	iterations=15
