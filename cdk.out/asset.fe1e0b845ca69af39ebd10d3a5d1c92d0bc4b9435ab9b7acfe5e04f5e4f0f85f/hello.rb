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
            'id' => 'Random.new.rand(4).to_s', 
          }, 
          table_name: table_name
    }).to_s

    question = res.item['question'].to_s
    answer = res.item['answer'].to_s

    uri = URI('https://hooks.slack.com/services/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')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
    req.body = {
        "type": "modal",
        "title": {
            "type": "plain_text",
            "text": "My App",
            "emoji": true
        },
        "submit": {
            "type": "plain_text",
            "text": "Submit",
            "emoji": true
        },
        "close": {
            "type": "plain_text",
            "text": "Cancel",
            "emoji": true
        },
        "blocks": [
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": 'hello'
                },
                "accessory": {
                    "type": "overflow",
                    "options": [
                        {
                            "text": {
                                "type": "plain_text",
                                "text": "answer"
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
