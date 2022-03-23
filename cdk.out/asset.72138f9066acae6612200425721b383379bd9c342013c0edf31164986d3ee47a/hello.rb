require 'json'

def lambda_handler
    
    { statusCode: 200, body: JSON.generate('Hello m10n!!!') }
end
