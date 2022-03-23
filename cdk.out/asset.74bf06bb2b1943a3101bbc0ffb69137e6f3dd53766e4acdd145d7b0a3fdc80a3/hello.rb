require 'json'

def lambda_handler(event:, context:)

    region = 'us-east-1'
    table_name = ENV['TABLE_NAME']
    dynamodb_client = Aws::DynamoDB::Client.new(region: region)

    res = dynamodb_client.get_item({
        key: {
            'id' => Random.new.rand(4).to_s, 
          }, 
          table_name: table_name, 
    })

    { statusCode: 200, body: res.item["question"] }

    # { statusCode: 200, body: JSON.generate('Hello from m10n!!!') }
end
