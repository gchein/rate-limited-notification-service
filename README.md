# Rate-Limited Notification Service Workflow

## Initial Approach

- [x] **Define the Schema**

- [x] **Create the Models**

- [ ] **Define the Routes and Corresponding Controller Actions**

- [ ] **Define how the Notification Service will be implemented (scopes / ActiveRecord Query with #count / other)**
  - Will first attempt to use scopes, as it seems at first to be the easiest and most straightforward way to build and test the ActiveRecord queries that will be used, as well as aloowing for chaining of scope calls, which can make the code more readable

- [x] **Define the rule-setting system that will be consumed by the Notification Service (YAML file / Rules Hash Constant / Rule Dynamic Model)**
  - On a scale of 'how dynamic and easy is the rule setting', the options would go 'Rule Dynamic Model' -> 'YAML file' -> 'Rules Hash Constant'
  - To create a Rule Model that would allow for, say, authorized users to send an HTTP request to one of the API's endpoints to create/delete/patch a rule to be applied would be very customizable and would be instantly taken into effect, however the final performance of the app could be severely hampered if not taken the necessary steps
  - To have a hash(=object/=dictionary) constant that defines the rules would be the fastest way to implement the ruleset, but it would be the most troublesome to adjust, as it would need for manually altering the hard coded value in the application, so it is not the best option either
  - That said, the halfway option seems to be to have some kind of source file with the ruleset, for instance a YAML file. With proper measures to mitigate security risks of loading an external file, this seems like an option that is customizable enough, without relevant performance risks.

- [ ] **Create the Service Respecting the Rules**

- [ ] **Refactor as Applicable and Retest Application Functionality**

- [ ] **Add to README**
  - [ ] Implicit assumptions and definitions.
  - [ ] Guide for running and testing the application.
  - [ ] Additional notes or instructions.
