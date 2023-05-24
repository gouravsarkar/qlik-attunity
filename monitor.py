import requests
import time

# Set the Attunity Enterprise Manager API endpoint and credentials
endpoint = "http://<YOUR_SERVER_NAME>:<PORT>/attunity/api/replication"
username = "<YOUR_USERNAME>"
password = "<YOUR_PASSWORD>"

# Define the task name to monitor
task_name = "My Replication Task"

# Get the task ID from the task name
headers = {"Content-Type": "application/json"}
auth = (username, password)
response = requests.get(f"{endpoint}/getTaskList", headers=headers, auth=auth)
task_id = None
if response.status_code == 200:
    task_list = response.json().get("TaskList", [])
    for task in task_list:
        if task.get("TaskName") == task_name:
            task_id = task.get("TaskId")
            break

if task_id is None:
    print(f"Error: Task '{task_name}' not found.")
    exit()

# Loop until the task has completed or an error has occurred
status = None
while status not in ["COMPLETED", "ERROR"]:
    # Get the status of the task
    response = requests.get(f"{endpoint}/getStatus/{task_id}", headers=headers, auth=auth)
    if response.status_code == 200:
        status = response.json().get("Status", "UNKNOWN")
        print(f"Task '{task_name}' status: {status}")
    else:
        print(f"Error getting task status: {response.status_code} - {response.text}")

    # Wait for a few seconds before checking the status again
    time.sleep(5)

if status == "COMPLETED":
    print(f"Task '{task_name}' completed successfully.")
else:
    print(f"Error: Task '{task_name}' failed with status '{status}'.")
