# Set the Attunity Replicate API endpoint and credentials
$endpoint = "http://<YOUR_SERVER_NAME>:<PORT>/attunityreplicate/api/v1"
$username = "<YOUR_USERNAME>"
$password = "<YOUR_PASSWORD>"

# Define the endpoint connection properties
$endpoint_name = "My Kafka Target"
$endpoint_type = "Kafka"
$endpoint_brokers = "<YOUR_ENDPOINT_BROKERS>"
$endpoint_topic = "<YOUR_ENDPOINT_TOPIC>"
$endpoint_key_serializer = "org.apache.kafka.common.serialization.StringSerializer"
$endpoint_value_serializer = "org.apache.kafka.common.serialization.StringSerializer"

# Create the JSON payload for the endpoint connection creation request
$body = @{
    endpoint_name = $endpoint_name
    endpoint_type = $endpoint_type
    endpoint_brokers = $endpoint_brokers
    endpoint_topic = $endpoint_topic
    endpoint_key_serializer = $endpoint_key_serializer
    endpoint_value_serializer = $endpoint_value_serializer
} | ConvertTo-Json

# Send the endpoint connection creation request to Attunity Replicate API
$headers = @{ Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$username:$password")) }
$response = Invoke-RestMethod -Method Post -Uri "$endpoint/endpoints" -Headers $headers -ContentType "application/json" -Body $body

# Check the response status code to verify the endpoint connection creation request was successful
if ($response.success -eq $true) {
    Write-Host "Endpoint connection created successfully."
} else {
    Write-Host "Error creating endpoint connection: $($response.message)"
}
