# Smart AC

## Deployment & Configuration
The environment variables 

API_ACCESS_KEY
ADMIN_USER
ADMIN_PASSWORD

have to be defined

## Test Data
You can generate a years worth of sensor data with `rake db:seed`

## Tests
`bin/rails test`

## Major To-Dos
Sidekiq isn't actually enabled yet. The sidekiq worker in the api controller needs to be converted 
to async.

## API access

### Structure
  * sensor_number - **(String - Unique per Device)** An identifier for each sensor. __Required__
  * recorded_at - **(Time)**  The time the reading was taken __Requred__
  * humidity - **(Integer)** % Humidity __Requred__
  * temperature - **(Decimal)** Temperature in C __Requred__
  * carbon_monoxide - **(Integer)** CO parts per million __Requred__
  * device - 
    * serial_number - **(String - Unique)** __Requred__
    * registration_date - **(Date)** The date the device is registered __Optional__
    * firmware_version - **(String)** Firmware version on device __Optional__

### TYPES
**Time** should be an iso8601 time, e.g 2020-04-01T12:47:02-04:00
**Integers** can be a decimal but they will get rounded
**Date** should be YYYY-MM-DD

### CURL EXAMPLE
DATA="{\"data\":{\"device\":{\"serial_number\":\"FAK-1122-334455\",\"firmware_version\":\"0.0.2\",\"registration_date\":\"2018-1-1\"},\"humidity\":\"98.9\",\"temperature\":20.1234,\"carbon_monoxide\":8,\"health_status\":\"gas_leak\",\"recorded_at\":\"2020-04-01T12:24:57-04:00\",\"sensor_number\":\"42\"}}"

TOKEN="ABCDEFGH"

curl -XPOST localhost:3000/api/data_reports --data $DATA -H "Content-Type: application/json" -H "Authorization: Token token=\"$TOKEN\""