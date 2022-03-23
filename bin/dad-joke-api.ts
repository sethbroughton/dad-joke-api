#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from 'aws-cdk-lib';
import { DadJokeApiStack } from '../lib/dad-joke-api-stack';

const app = new cdk.App();
new DadJokeApiStack(app, 'DadJokeApiStack', {});