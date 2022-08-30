# Billing And Recurring Payment System

Billing And Recurring Payment System is a test project in ruby on rails. It has the functionality for sign up and loginUsers are of two types;Admin and Buyer.Admin can invite user to make subscriptions of the plans they create.Buyers will be given an invoice containing their bill for the feature usage of subscribed plans and any overuse of features on a billing day.

## Versions

* Ruby version: ruby 2.7.0p0
* Rails version: Rails 5.2.8.1


## Dependencies

* Postgresql
* Devise
* pundit
* Cloundinary

### Database Creation
Postgress has been used in this Project, new database can be created using following commands.

```bash
rails db:drop
rails db:create
rails db:migrate
```

### Database Initialization
Database can be initialized by running.

```bash
rails db:seed
```

### Background Jobs
Billing invoice will automatically be sent at the end of the month, as I have setup the background job using sidekiq.

### Deployment Instructions

```bash
heroku login
heroku create #This will create new application.
heroku rename #If you want to rename your application.
git push heroku main
heroku run rails db:migrate
```
