# Rate-Limited Notification Service Workflow

## Initial Approach

- [x] **Define the Schema**

- [x] **Create the Models**

- [ ] **Define the Routes and Corresponding Controller Actions**

- [ ] **Define how the Notification Service will be implemented (scopes / ActiveRecord Query with #count / other)**
  - Will first attempt to use scopes, as it seems at first to be the easiest and most straightforward way to build and test the ActiveRecord queries that will be used, as well as aloowing for chaining of scope calls, which can make the code more readable

- [ ] **Implement the rule-setting system that will be consumed by the Notification Service (YAML file / Rules Hash Constant / Rule Dynamic Model)**

- [ ] **Create the Service Respecting the Rules**

- [ ] **Refactor as Applicable and Retest Application Functionality**

- [ ] **Add to README**
  - [ ] Implicit assumptions and definitions.
  - [ ] Guide for running and testing the application.
  - [ ] Additional notes or instructions.
