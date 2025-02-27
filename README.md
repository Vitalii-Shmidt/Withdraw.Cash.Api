# Test task for dream job.

## Task:
Build a service for registering applications for cash withdrawals at a bank branch. The service must be prepared for launch in docker (via docker compose). The architecture of the service is as follows:
## WebApi, which implements the entry point (asp.net core) The task of the Api is to accept the request, log it and add data about the IP of the client who sent it. Send the received object for processing to the backend[remark: means other project in the same solution that consumes the message] using RabbitMq.
Add check - parameters: amount must be from 100 to 100000
UAH/USD
### Request to save the application:
```json
{
    client_id: “<identifier of a specific client>”,
    departemnt_address: “<address>”,
    amount: 1000.00,
    currency: “UAH (or other)”
}
```
### Request to obtain the status of the application №1:
```json
{
    request_id: <id of the application>
}
```
### Request to obtain the status of the application №2:
```json
{
    client_id: “<identifier of a specific client>”,
    department_address: “<address>”
}
```
## Backend request handler. Reads the request from Rabbit, logs and:
- saves it to the database (MsSql or PostgreSQL, the database selection must be specified in the configuration -
(+ the connection configuration must be in “secrets”[remark: means appsettings]).
- In response, the order id is returned, which corresponds to the id of the DB record. (The presence of a field in the DB that is responsible for the status of the request is ready for issuance or other is mandatory)

- for the record id or client_id + department_address, an array with the amount, currency and status of the request is returned. (There can be several requests. For example, with a regular currency)

Implement the work with the DB on a stored procedure and via Dapper. Add the script for creating tables in the DB and stored procedures as a txt file.