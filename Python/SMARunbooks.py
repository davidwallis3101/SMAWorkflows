import requests
import re
import time

# SMARunbooks.py
# Starts SMA runbook via REST from python DWallis http://blog.wallis2000.co.uk

# Web Service Details
port = '9090'
webservice = 'https://sma'
username = 'domain\\user'
password = 'passwordhere' # Obv.. this isnt secure!
runbookname = "Davidw"
ignoreSSL = True
pollIntervalSecs = 2
streamType = "Any"

# Append port to webservice url
webservice+= ":" + port

# Supress SSL Warning
if ignoreSSL == True:
    requests.packages.urllib3.disable_warnings() 

# Construct uri for finding runbook via name
rburi = webservice + "/00000000-0000-0000-0000-000000000000/Runbooks"
rburi+= "?$filter=RunbookName eq '" + runbookname +"'"

# Headers used for gettting the runbook
headers = {'accept': 'application/atom+xml,application/xml'}

# Get Runbook GUID
response = requests.get(rburi, headers=headers, verify=(not ignoreSSL), auth=('username, password))

if response.status_code != 200:
    raise ValueError('HTTP Error')

# Do regex match on one line, example from here http://stackoverflow.com/questions/23366848/getting-captured-group-in-one-line
runbookID = (lambda match: match.group(1) if match else "Runbook ID not found")(re.search('>([a-z0-9]{8}-([a-z0-9]{4}-){3}[a-z0-9]{12})</d:RunbookID>',response.text,re.IGNORECASE))
runbookName = (lambda match: match.group(1) if match else "Runbook name not found")(re.search('<d:RunbookName>(.*?)</d:RunbookName>',response.text,re.IGNORECASE))

print "Starting Runbook \"" + runbookName + "\" RunbookID: " + runbookID

# construct the uri for starting the runbook
startUri = webservice + "/00000000-0000-0000-0000-000000000000/Runbooks(guid'" + runbookID + "')/Start"

# Construct JSON for parameters
parameters = (
    '{"parameters":[\n'
    '{"__metadata":{"type":"Orchestrator.ResourceModel.NameValuePair"},"Name":"Message","Value":"\'This is a message\'"},\n'
    '{"__metadata":{"type":"Orchestrator.ResourceModel.NameValuePair"},"Name":"Number","Value":"\'012345\'"},\n'
    '{"__metadata":{"type":"Orchestrator.ResourceModel.NameValuePair"},"Name":"Originator","Value":"\'Me\'"}\n'
    ']}'
)

headers = {'Content-type': 'application/json;odata=verbose', 'Accept': 'application/atom+xml,application/xml'}
startresponse = requests.post(startUri, parameters, headers=headers, verify=(not ignoreSSL), auth=(username, password))

if startresponse.status_code != 200:
    raise ValueError('Unable to start runbook')

# Extract the GUID from the response so we can poll the status
runbookJobId = (lambda match: match.group(1) if match else "Runbook Job ID not found")(re.search('([a-z0-9]{8}-([a-z0-9]{4}-){3}[a-z0-9]{12})',startresponse.text,re.IGNORECASE))
print "Job started, Job ID: ", runbookJobId

# Construct the uri for getting the status
statusURI = webservice + "/00000000-0000-0000-0000-000000000000/Jobs(guid'" + runbookJobId + "')"

# Get the status and poll until its completed or failed.
statusResponse = requests.get(statusURI, headers=headers, verify=(not ignoreSSL), auth=(username, password))
jobStatus = (lambda match: match.group(1) if match else "Job status not found")(re.search('<d:JobStatus>(.*?)</d:JobStatus>',statusResponse.text,re.IGNORECASE))

while jobStatus != "Completed": #  or jobStatus != "Failed" or jobStatus != "Stopped":
    print "JobStatus: ", jobStatus
    time.sleep(pollIntervalSecs)
    statusResponse = requests.get(statusURI, headers=headers, verify=(not ignoreSSL), auth=(username, password))
    jobStatus = (lambda match: match.group(1) if match else "Job status not found")(re.search('<d:JobStatus>(.*?)</d:JobStatus>',statusResponse.text,re.IGNORECASE))
print "JobStatus: ", jobStatus

if jobStatus == "Completed":
    # Get Job output
    # Construct the uri for getting the status
    resultsURI = webservice + "/00000000-0000-0000-0000-000000000000/JobStreams/GetStreamItems?jobId='" + runbookJobId + "'&streamType='" + streamType + "'"

    # Get specified result stream text
    results = requests.get(resultsURI, headers=headers, verify=(not ignoreSSL), auth=(username, password))
    streamText = (lambda match: match.group(1) if match else "Stream text attribute not found")(re.search('<d:StreamText xml:space="preserve">(.*?)</d:StreamText>',results.text,re.IGNORECASE|re.DOTALL))
    
    print "Stream text"
    print streamText
