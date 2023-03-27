# Set the Attunity Replicate API endpoint and credentials
$endpoint = "http://<YOUR_SERVER_NAME>:<PORT>/attunityreplicate/api/v1"
$username = "<YOUR_USERNAME>"
$password = "<YOUR_PASSWORD>"

# Define the endpoint connection properties
$endpoint_name = "My Oracle Endpoint"
$endpoint_type = "Oracle"
$endpoint_host = "<YOUR_ENDPOINT_HOST>"
$endpoint_port = "<YOUR_ENDPOINT_PORT>"
$endpoint_service_name = "<YOUR_ENDPOINT_SERVICE_NAME>"
$endpoint_username = "<YOUR_ENDPOINT_USERNAME>"
$endpoint_password = "<YOUR_ENDPOINT_PASSWORD>"

# Create the JSON payload for the endpoint connection creation request
$body = @{
    endpoint_name = $endpoint_name
    endpoint_type = $endpoint_type
    endpoint_host = $endpoint_host
    endpoint_port = $endpoint_port
    endpoint_service_name = $endpoint_service_name
    endpoint_username = $endpoint_username
    endpoint_password = $endpoint_password
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
