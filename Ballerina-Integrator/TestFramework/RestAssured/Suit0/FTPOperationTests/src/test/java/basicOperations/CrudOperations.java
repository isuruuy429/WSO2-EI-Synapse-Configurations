package basicOperations;

import org.testng.annotations.Test;
import org.testng.AssertJUnit;
import org.json.simple.JSONObject;
import org.testng.Assert;
import org.testng.annotations.Test;

import io.restassured.RestAssured;
import io.restassured.path.json.JsonPath;
import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;

public class CrudOperations {
	
	String url = "http://localhost:9090/company/";
	JsonPath jsonPathEvaluator;
	
	@Test(priority = 0)
	public void testPostAction()
	{
		RequestSpecification request = RestAssured.given();
		request.header("Content-Type", "application/json");
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("firstName", "John");
		jsonObject.put("lastName", "Doe");
		jsonObject.put("age", 21);
		jsonObject.put("gender", "M");
		
		request.body(jsonObject.toJSONString());
		Response response = request.post(url+"addJsonFile");
		
		jsonPathEvaluator = response.jsonPath();
		String message = jsonPathEvaluator.get("Message");
		
		AssertJUnit.assertEquals(message, "Employee records uploaded successfully.");
		AssertJUnit.assertEquals(response.getStatusCode(), 200);
	}
	
	@Test(priority = 1)
	public void testGetAction()
	{
		String fileName = "account.json";
		Response response = RestAssured.get(url+"readFile/"+fileName);
		String expected = "{\"firstName\":\"John\", \"lastName\":\"Doe\", \"gender\":\"M\", \"age\":21}";

		AssertJUnit.assertEquals(response.asString(), expected);
	}

}
