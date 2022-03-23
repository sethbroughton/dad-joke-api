require 'json'
require 'uri'
require 'net/http'
require 'aws-sdk'

def lambda_handler(event:, context:)

    region = 'us-east-1'
    table_name = ENV['TABLE_NAME']
    dynamodb_client = Aws::DynamoDB::Client.new(region: region)

    res = dynamodb_client.get_item({
        key: {
            'id' => Random.new.rand(4).to_s, 
          }, 
          table_name: table_name
    })

    question = res.item['question'].to_s
    answer = res.item['answer'].to_s

    uri = URI('https://hooks.slack.com/services/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')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
    req.body = {
        "blocks": [
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": question
                },
                "accessory": {
                    "type": "overflow",
                    "options": [
                        {
                            "text": {
                                "type": "plain_text",
                                "text": answer
                            }
                        }
                    ]
                }
            }
        ]
    }.to_json
    res = http.request(req)

    puts "response #{res.body}"

    { statusCode: 200, body: JSON.generate('Hello from m10n!!!') }
end
