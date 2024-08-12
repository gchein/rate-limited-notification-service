# Rate-Limited Notification Service Workflow

## Initial Approach

- [x] **Define the Schema**

- [x] **Create the Models**

- [x] **Define the Routes and Corresponding Controller Actions**
  - Only route needed was the create for the API to function properly, as the validation of the rules was done entirely by the Notification Model

- [x] **Define how the Notification Service will be implemented (scopes / ActiveRecord Query with #count / other)**
  - Will first attempt to use scopes, as it seems at first to be the easiest and most straightforward way to build and test the ActiveRecord queries that will be used, as well as alowing for chaining of scope calls, which can make the code more readable
  - This approach of using scopes proved to be succesful and fairly simple to implement and test, as well as is easily readable and understandable
  - Other approaches may be more robust or have less of an impact on performance, but this seems like a reasonable first approach to solving the problem

- [x] **Define the rule-setting system that will be consumed by the Notification Service (YAML file / Rules Hash Constant / Rule Dynamic Model)**
  - On a scale of 'how dynamic and easy is the rule setting', the options would go 'Rule Dynamic Model' -> 'YAML file' -> 'Rules Hash Constant'
  - To create a Rule Model that would allow for, say, authorized users to send an HTTP request to one of the API's endpoints to create/delete/patch a rule to be applied would be very customizable and would be instantly taken into effect, however the final performance of the app could be severely hampered if not taken the necessary steps
  - To have a hash(=object/=dictionary) constant that defines the rules would be the fastest way to implement the ruleset, but it would be the most troublesome to adjust, as it would need for manually altering the hard coded value in the application, so it is not the best option either
  - That said, the halfway option seems to be to have some kind of source file with the ruleset, for instance a YAML file. With proper measures to mitigate security risks of loading an external file, this seems like an option that is customizable enough, without relevant performance risks.

- [x] **Create the Service Respecting the Rules**
  - Created the logic for respecting the ruleset inside the Notifications Controller
  - As a custom validation method, a new Notification can only be saved if it respects the limits layed out in the YAML file with the limits per type of notification, per 'time_window' eg.(minute, hour, day, month etc.)
  - This makes it possible for the '#create' method in the Notification Controller to respond with a JSON with the applicable error when trying to persist the Notitication sent through the POST request

- [x] **Refactor as Applicable and Retest Application Functionality**
  - Did a few refactorings, specified throughout the commits

- [ ] **Add to README**
  - [ ] Implicit assumptions and definitions.
  - [ ] Guide for running and testing the application.
  - [ ] Additional notes or instructions.
