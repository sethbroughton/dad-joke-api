require 'json'
require 'uri'
require 'net/http'

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

    question = res.item['question']

    uri = URI('https://hooks.slack.com/services/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')
    res = Net::HTTP.post_form(uri, 'title' => 'foo', 'body' => 'bar', 'userID' => 1)
    puts res.body  if res.is_a?(Net::HTTPSuccess)

    # joke_manager = JokeManager.new()
    # p joke_manager.create_joke("foo", "bar")

    # { statusCode: 200, body: res.item["question"] }

    # { statusCode: 200, body: JSON.generate('Hello from m10n!!!') }
end
