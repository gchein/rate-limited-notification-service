# Rate Limited Notification Service API

## Installation and Configuration

1. **Clone the Repository (below using SSH) and enter the local directory:**
   ```sh
   git clone git@github.com:gchein/rate-limited-notification-service.git
   cd rate-limited-notification-service
   ```

2. **Install dependencies:**
   ```sh
    bundle install
    ```

3. **Setup the Database:**
   ```sh
    bin/rails db:create
    bin/rails db:migrate
    bin/rails db:seed
    ```

The `db:seed` command will populate the database with 10 test users (initial IDs 1 to 10), but be aware that if you re-run the commands, new users will be generated, but the IDs will **not** restart. For restarting the IDs, the below command to drop the DB is necessary.

If you need to reset the database, run the command below, then the commands in this section 3 again
```
  bin/rails db:drop
```

4. **Start the server:**
   ```sh
    bin/rails server
    ```

## Interacting with the API

The API has a single endpoint for creating notifications:
```sh
  POST /notifications
  ```

You can interact with the application by sending HTTP JSON requests to this endpoint in any way you prefer (cURL, Postman etc.), while passing the necessary attributes:
 - notification_type
 - user_id
 - message

Here's an example using cURL (assuming the server is running on port 3000):

```sh
  curl -X POST http://localhost:3000/notifications \
  -H "Content-Type: application/json" \
  -d '{"notification_type":"Status Update", "user_id":"1", "message":"Print message if successful"}'
  ```

**Error Handling:**

If there is an error, the server will return a status of "Unprocessable Entity" (422). This could pose a potential security threat (eg. someone would be able to test if a user ID exists or not), but for this assignment only, I find that not to be a problem. Adjustments can be made further on to enhance security.


## Running the test suite

To run the test suite, use the following command:
  ```sh
bundle exec rspec
  ```

All the files related to the test suite are in the 'spec' folder, mainly the two below:
 - ***'spec/models/notification_spec.rb'***: This is the file that tests the Notification model's behaviours and validations. The enforcement of the limitations imposed by the ruleset is tested here.
 - ***'spec/requests/notifications_spec.rb'***: This is the file that tests the Notifications Controller, to ensure that the HTTP Requests are being handled properly.

## Remarks, Assumptions, and Future Development
 - **User Model**: A basic User model was created for testing purposes to ensure the code is functioning correctly.
- **Notification Model**: The attribute notification_type was used instead of type to avoid conflicts with Rails' reserved column names.
- **Email Sending**: As agreed by email, the email sending function is simulated by logging the notification message to the console.
- **Rule Management**: A YAML file ('config/rate_limits.yml') with safe loading and a deserialization check was used to define the ruleset for filtering notifications (see: 'config/initializers/rate_limits.rb'). If the rules need to be dynamic and frequently updated, it could make sense to implement a separate Rule model. This would allow authorized users to create, edit, and delete rules via endpoints in the API. However, this approach could have performance implications and would require careful consideration. Some notes on this decision are in the WORKFLOW.md file.
- **Performance Considerations**: For better performance, caching strategies could be implemented to reduce database hits, and job queueing could be introduced (for instance using Sidekiq or ActiveJob) for processing requests in a multi-threaded environment.
