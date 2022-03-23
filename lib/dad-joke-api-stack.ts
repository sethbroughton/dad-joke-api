import { Stack, StackProps, CfnOutput, Duration } from 'aws-cdk-lib';
import { Construct } from 'constructs';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import * as apigateway from 'aws-cdk-lib/aws-apigateway'
import * as dynamodb from 'aws-cdk-lib/aws-dynamodb'
import { Rule, Schedule } from 'aws-cdk-lib/aws-events'
import * as path from 'path'
import { LambdaFunction } from 'aws-cdk-lib/aws-events-targets';
import * as dotenv from "dotenv";
dotenv.config({ path: __dirname+'/.env' });

export class DadJokeApiStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    const table = new dynamodb.Table(this, 'table', {
      partitionKey: { name: 'id', type: dynamodb.AttributeType.STRING }
    })

    const fn = new lambda.Function(this, 'MyFunction', {
      runtime: lambda.Runtime.RUBY_2_7,
      handler: 'hello.lambda_handler',
      code: lambda.Code.fromAsset(path.join(__dirname, 'lambda-fns')),
      environment: {
        "TABLE_NAME": table.tableName,
        "SLACK_WEBHOOK": process.env.SLACK_WEBHOOK!
      }
    });

    const api = new apigateway.LambdaRestApi(this, 'api', {
      handler: fn
    })

    table.grantReadWriteData(fn);

    const rule = new Rule(this, 'ScheduleRule', {
      schedule: Schedule.rate(Duration.hours(1)),
     });  

    rule.addTarget(new LambdaFunction(fn))

    new CfnOutput(this, 'tableName', {
      value: table.tableName
    })

  }
}
