# Automate Rest API testing using Postman/ Newman

In this example we focus on automating the REST Apis testing using Postman and Newman. 

## Creating REST API using WSO2 Enterprise Integrator

1. Create two APIs. (please find the .car apps of the created APIs.)
- API for String Operations
- API for Arithmetic Operations

2. Launch Postman. 
3. Create new Workspace. 
4. Create new Collection. 

5. In that Collection, create two folders called String Operations and Arithmetic Operations. All the requests/ tests related to String operations API will be placed in String Operations folder and all the tests/requests related to Arithmetic Operations API will be resulted in Arithmetic Operations folder. 

6. Lets take the API StringOperations. In this API, we have three API resources which are /concat, /split, and /case. Let's take /concat resource. 

POST /stringOperations/concat HTTP/1.1
Host: localhost:8280
URL: http://localhost:8280/stringOperations/concat
Content-Type: application/json
cache-control: no-cache
Postman-Token: 8e753596-d64a-41fb-a711-c84730d3ea67
{
   "Employees":
   [
      {  
         "initials":"R.J.",
         "firstName":"Leo",
         "lastName":"Johnes",
         "gender":"M",
         "age":"29"
      },
      {  
         "initials":"I.M.",
         "firstName":"Isuru",
         "lastName":"Uyanage",
         "gender":"F",
         "age":"29"
      },
      {  
         "initials":"G.P.S.",
         "firstName":"Supun",
         "lastName":"De Silva",
         "gender":"M",
         "age":"31"
      }
   ]
}


Response: 
{
    "Employees": [
        {
            "name": "R.J.Johnes",
            "gender": "M"
        },
        {
            "name": "I.M.Uyanage",
            "gender": "F"
        },
        {
            "name": "G.P.S.De Silva",
            "gender": "M"
        }
    ]
}

From this API resouce we send a json payload of Employees which contains the details of Employee initials, first name, last name, gender and age. The API will output Employee name by concatenating initials and last name with Employee gender. (This logic is defined inside API Datamapper diagram)
(images/dm_concat.png)

We can write set of test cases for above test. 
* Verify if Employee name is returned as concatenating initials and last name.  
* Verify if gender of the Employee is returned in the response. 
* Verify if response contains a key as initials. 
* Verify if response contains a key as firstname.
* Verify if response contains a key as lastname.
* Verify if response contains a key as age.

We can write above test cases in the Request itself in the Tests tab. The language will be javascript. 

Please find the test methods below. 
```
//getting the response and convert it to json.
var jsonData = pm.response.json();

//Testcase: Verify if Employee name is returned as concatenating initials and last name.  
pm.test("EmployeeNameTest", function () {
    var employeeName1 = jsonData.Employees[0].name;
    var employeeName2 = jsonData.Employees[1].name;
    var employeeName3 = jsonData.Employees[2].name;
    
    pm.expect(employeeName1).to.eql("R.J.Johnes");
    pm.expect(employeeName2).to.eql("I.M.Uyanage");
    pm.expect(employeeName3).to.eql("G.P.S.De Silva");
});

//Testcase: Verify if gender of the Employee is returned in the response. 
pm.test("EmployeeGenderTest", function () {
    var employee1Gender = jsonData.Employees[0].gender;
    var employee2Gender = jsonData.Employees[1].gender;
    var employee3Gender = jsonData.Employees[2].gender;
    
    pm.expect(employee1Gender).to.eql("M");
    pm.expect(employee2Gender).to.eql("F");
    pm.expect(employee3Gender).to.eql("M");
});

//Testcase: Verify if response contains a key as initials. 
pm.test("ResponseContainsInitialsTest", function () {
    var isContainsInitials = !!(jsonData.Employees[0].initials);
    pm.expect(isContainsInitials).to.eql(false);
});

//Testcase: Verify if response contains a key as firstname. 
pm.test("ResponseContainsFirstNameTest", function () {
    var isContainsFirstName = !!(jsonData.Employees[0].firstName);
    pm.expect(isContainsFirstName).to.eql(false);
});

//Testcase: Verify if response contains a key as lastname. 
pm.test("ResponseContainsLastNameTest", function () {
    var isContainsLastName = !!(jsonData.Employees[0].lastName);
    pm.expect(isContainsLastName).to.eql(false);
});

//Testcase: Verify if response contains a key as age. 
pm.test("ResponseContainsAge", function () {
    var isContainsAge = !!(jsonData.Employees[0].age);
    pm.expect(isContainsAge).to.eql(false);
});
```

7. Likewise you can write tests to the other API resources as well. All these tests can run as a Collection. 
(images/testrun.png)

8. Further these tests can be exported. You can find the exported test script in Datamapper Tests.postman_collection.json file. 

9. Further, this can run in command line using Newman. It will give you a detailed report as below. 

```
Datamapper Tests

❏ String Operations
↳ stringConcatenateTest
  POST http://localhost:8280/stringOperations/concat [200 OK, 425B, 113ms]
  ✓  EmployeeNameTest
  ✓  EmployeeGenderTest
  ✓  ResponseContainsInitialsTest
  ✓  ResponseContainsFirstNameTest
  ✓  ResponseContainsLastNameTest
  ✓  ResponseContainsAge

↳ stringSplitTest
  POST http://localhost:8280/stringOperations/split [200 OK, 504B, 37ms]
  ✓  pharmacyReferenceTest
  ✓  channelReferenceTest
  ✓  patientNameTest
  ✓  patientAgeTest
  ✓  IsResponseContainsReferenceTest

↳ stringCaseTest
  POST http://localhost:8280/stringOperations/case [200 OK, 431B, 33ms]
  ✓  toUpperCaseTest
  ✓  toLowerCaseTest
  ✓  remainCaseTest

❏ Arithmetic Operations
↳ MultiplicationTest
  POST http://localhost:8280/ArithmeticOperations/multiply [200 OK, 313B, 22ms]
  ✓  MultiplicationTest

↳ AdditionTest
  POST http://localhost:8280/ArithmeticOperations/add [200 OK, 313B, 30ms]
  ✓  AdditionTest

┌─────────────────────────┬───────────────────┬───────────────────┐
│                         │          executed │            failed │
├─────────────────────────┼───────────────────┼───────────────────┤
│              iterations │                 1 │                 0 │
├─────────────────────────┼───────────────────┼───────────────────┤
│                requests │                 5 │                 0 │
├─────────────────────────┼───────────────────┼───────────────────┤
│            test-scripts │                 5 │                 0 │
├─────────────────────────┼───────────────────┼───────────────────┤
│      prerequest-scripts │                 0 │                 0 │
├─────────────────────────┼───────────────────┼───────────────────┤
│              assertions │                16 │                 0 │
├─────────────────────────┴───────────────────┴───────────────────┤
│ total run duration: 403ms                                       │
├─────────────────────────────────────────────────────────────────┤
│ total data received: 486B (approx)                              │
├─────────────────────────────────────────────────────────────────┤
│ average response time: 47ms [min: 22ms, max: 113ms, s.d.: 33ms] │
└─────────────────────────────────────────────────────────────────┘
```

Running the test cases in Newman
1. Installing Newman
```
npm install -g newman
```

2. Running the exported file
```
newman run Datamapper\ Tests.postman_collection.json
```

3. Running from the URL. 
```
newman run https://www.getpostman.com/collections/cada711ed935d4507f28
```