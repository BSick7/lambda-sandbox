# Lambda Sandbox

This repo is intended to validate assumptions in AWS Lambda.

The lambda verifies that AWS runs the uploaded golang binary using the `main` func in the `main` package.
AWS runs a single, long-lived process within an execution context.
Every degree of concurrency will force an additional execution context.
Each individual lambda invocation will attempt to use a prebuilt execution context to run code.

From https://docs.aws.amazon.com/lambda/latest/dg/running-lambda-code.html:
> Any declarations in your Lambda function code (outside the handler code, see Programming Model) remains initialized, 
providing additional optimization when the function is invoked again. For example, 
if your Lambda function establishes a database connection, instead of reestablishing the connection, 
the original connection is used in subsequent invocations. 
We suggest adding logic in your code to check if a connection exists before creating one.
 
This has several unexpected side effects.
- Pointers created in `main` and injected into the handler are held on until a recycling event occurs
- Singletons/globals are held on until a recycling event occurs
- Any processes created (i.e. chrome) are held on until a recycling event occurs 

There are several recycling events, but here are the most common:
- Uploaded new binary
- Expired execution context
- Change Lambda description