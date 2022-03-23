require 'aws-sdk-dynamodb'
require 'csv'

def add_item_to_table(dynamodb_client, table_item)
  dynamodb_client.put_item(table_item)
rescue StandardError => e
  puts "Error adding joke '#{table_item[:id][:joke]} "
end


def run_me
  region = 'us-east-1'
  table_name = 'DadJokeApiStack-table8235A42E-MXGIAWYP15BQ'
  dynamodb_client = Aws::DynamoDB::Client.new(region: region)

  CSV.foreach('jokes.csv') do |row|
    table_item = {
      table_name: table_name,
      item: {
        id: row[0],
        question: row[1],
        answer: row[2]
      }
    }
    add_item_to_table(dynamodb_client, table_item)
  end

end

run_me if $PROGRAM_NAME == __FILE__
