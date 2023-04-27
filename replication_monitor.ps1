# Set the Attunity Replicate API endpoint and credentials
$endpoint = "http://<YOUR_SERVER_NAME>:<PORT>/attunityreplicate/api/v1"
$username = "<YOUR_USERNAME>"
$password = "<YOUR_PASSWORD>"

# Define the task name to monitor
$task_name = "My Replication Task"

# Get the task ID from the task name
$headers = @{ Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$username:$password")) }
$response = Invoke-RestMethod -Method Get -Uri "$endpoint/tasks" -Headers $headers
$task_id = $response.data | Where-Object { $_.task_name -eq $task_name } | Select-Object -ExpandProperty task_id

if (-not $task_id) {
    Write-Host "Error: Task '$task_name' not found."
    Exit
}

# Loop until the task has completed or an error has occurred
$status = $null
do {
    # Get the status of the task
    $response = Invoke-RestMethod -Method Get -Uri "$endpoint/tasks/$task_id/status" -Headers $headers
    $status = $response.data.status

    # Display the current status of the task
    Write-Host "Task '$task_name' status: $status"

    # Wait for a few seconds before checking the status again
    Start-Sleep -Seconds 5
} while ($status -ne "COMPLETED" -and $status -ne "ERROR")

if ($status -eq "COMPLETED") {
    Write-Host "Task '$task_name' completed successfully."
} else {
    Write-Host "Error: Task '$task_name' failed with status '$status'."
}
